import 'dart:async';
import 'package:pimpineo_v1/services/authentication.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:pimpineo_v1/services/viewstate.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

//** aqui hay una lectura del usuario que esta entrando

class LogInModel extends BaseModel {

  AuthenticationService _authenticationService = locator<AuthenticationService>();
  
  Future<String> login(String email, String contrasena) async {
    setState(ViewState.Busy);
    String result;
    var user;
    user = await _authenticationService.signIn(email,contrasena);
    if((!(user is String)) && (user != null)){
      result = user.pais;
    } 
    else{
      result = 'Ocurrio un error.\n-Usuario o contrasena incorrecta.\n-El usuario no esta registrado en Pimpineo. Para continuar presione Registrarse.';
    }
    setState(ViewState.Idel);
    return result;
  }

  //Shared Preferences related functions
  saveUserEmail(String email) async {
    Helpers.preferences = await SharedPreferences.getInstance();  
    // save email
    await Helpers.preferences.setString('email', email);
  }

  
  Future<String> getSavedUserEmail() async {
    Helpers.preferences = await SharedPreferences.getInstance();
    String emailSaved = Helpers.preferences.getString('email');
    if(emailSaved != null){
      return emailSaved;
    }  
    return ''; 
  }


  //function de olvido la contrasena para mandar el email    
  Future<String> olvidoContrasena(String email) async {
    bool result = await _authenticationService.olvidoContrasena(email);
    if(result){
      return 'Mensaje enviado al correo: $email.';
    }
    else{
      return 'Correo:$email \nNo esta registrado en nuestra aplicacion, por favor provea un correo registrado en Pimpineo.';
    }
  }

}