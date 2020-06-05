import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pimpineo_v1/services/controllers.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthenticationService {


  ///authentication instance
  final _auth = FirebaseAuth.instance;

  ///aqui se escribe en la base de datos el ususario que esta registrandose o entrando
  final FirestoreService _firestoreService = locator<FirestoreService>();

  ///sign in with google instance
  final GoogleSignIn _googleSignIn = new GoogleSignIn();


  ///sign in method with email and password
  Future signIn(String email, String contrasena) async {
    try{
      AuthResult _result = await _auth.signInWithEmailAndPassword(email: email, password: contrasena);
      if(_result.user != null){
        FirebaseUser user = _result.user;
        String uid = user.uid;                             // test uid: 'wRT2GrdR03bJkeglJHcITPTINFE2'
        var _user = await _firestoreService.fetchUserFromDatabase(uid); 

        //toma el anuncio inicial
        Helpers.initialPicture  = await _firestoreService.getInitialPicture();
        //para tomar el precio de las recargas
        Helpers.recargasPrices = await _firestoreService.getRecargasPrices();

        Controllers.userStreamController.sink.add(_user);
        return _user;
      }
      else{
        return 'Usuario no registrado'; //retorna un string y asi sabemos que no esta registrado el ususario
      }
    }catch(e){
      return e.message;    
    }
  }
  


  ///register with email and password that are already validated
  Future<String> registerUser({
    @required String correo,
    @required String contrasena,
    @required String nombre,
    @required String pais,
    @required String telefono,
    @required var credito,
    @required Map<String,dynamic> contactos
  }) async {

    String result;
    bool error = false;
    bool agreeTermsAndCond = Helpers.agreeTermsAndCond;

    var _result = await _auth.createUserWithEmailAndPassword(email: correo, password: contrasena).catchError((e){
      print(e);
      error = true;
    });
    if(error){return 'Ocurrio un error creando el usuario. Es comun que el error se deba a que el usuario ya existe.';}
    
    FirebaseUser fbuser = _result.user;

    try {
      //*********creation of the payments object
      Map<String,dynamic> payments = {
        'stripe_id' : '',
        'payment_methods' : [],
        'payment_in_process' : {}
      };


      User _user = User(  //we cannot use tojson method since we have more than one type needed to create the user **uid
          uid: fbuser.uid,
          correo: correo,
          nombre: nombre,
          pais: pais,
          telefono: telefono, 
          credito: credito, 
          contactos: contactos,
          payments: payments,
          termsAndCond: agreeTermsAndCond.toString()
      );
      
      result = await _firestoreService.createFirestoreUserBE(_user); //devuelve el stripe id creado con la funcion en el cloud
      
      if(!result.contains('error')){
        
        //para el anuncio inicial
        Helpers.initialPicture  = await _firestoreService.getInitialPicture();
        //para tomar el precio de las recargas
        Helpers.recargasPrices = await _firestoreService.getRecargasPrices();

        Controllers.userStreamController.sink.add(_user);
        _user.payments['stripe_id'] = result; //pone el resultado del id de stripe en la data del cliente
        return 'Exitosamente registrado.';
      }else{
        _result.user.delete();
        return 'Error creando el usuario.';
      }      
    } catch (e) {
      _result.user.delete();
      return 'Hubo un problema creando el usuario.';          
    }
  }
  


  ///check if there is an user logged in at this time
   Future<bool> isUserLoggedIn() async{
     var user = await _auth.currentUser();
     //si hay un usuarion loggeado entonces entra a la pagina directamente
     if(user != null){
       String uid = user.uid;                            
       var _user = await _firestoreService.fetchUserFromDatabase(uid); 
       //para el anuncio inicial
       Helpers.initialPicture  = await _firestoreService.getInitialPicture();
       //para tomar el precio de las recargas
       Helpers.recargasPrices = await _firestoreService.getRecargasPrices();

       Controllers.userStreamController.sink.add(_user);
     }
     return user != null; //check if user is not equal to null as the return value
   } 
   

  ///sign out
  void signOut() async {   //closing stream controller just in case
    await _auth.signOut();
  }


  ///googleAccount.email, googleAccount.email.split('@')[0] + '1234' , googleAccount.displayName , 'us' , '', 0
  Future<String> signInGoogle(Map<String,dynamic> contactos) async {
    String result;
    GoogleSignInAccount account = await _googleSignIn.signIn();
    if(account != null){
      result = await registerUser(correo: account.email, contrasena: account.email.split('@')[0] + '1234', nombre: account.displayName, pais: 'us', telefono: '', credito: 0,contactos: contactos);
      if(result.contains('registrado')){
        await _auth.sendPasswordResetEmail(email: account.email);
        //guardar el usuario en los sharedpreferences
        Helpers.preferences = await SharedPreferences.getInstance();
        Helpers.preferences.setString('email', account.email);
      }
      return result;
    }
    else{
      return 'aborto operacion';
    }
  }

  
  ///este es para el proceso del olvido de la contrasena
  Future<bool> olvidoContrasena(String email) async {
    bool result = true;
    await _auth.sendPasswordResetEmail(email: email).catchError((error){
      result = false;
      return result;
    });
    return result;
  }

  
}