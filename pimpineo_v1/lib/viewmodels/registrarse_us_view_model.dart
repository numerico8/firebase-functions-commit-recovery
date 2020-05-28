import 'dart:async';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/services/authentication.dart';
import 'package:pimpineo_v1/services/viewstate.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';


class RegistrarseViewModel extends BaseModel {

  //Authentication service to register the user 
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  
  //register button logic  
  Future<String> registerUserButton( 
    String correo,
    String contrasena,
    String nombre,
    String pais,
    String telefono,
    var credito
  ) async { 
    setState(ViewState.Busy);               
    var _result = await _authenticationService  //we dont need to craete the contacts for the user model from here since we can do it just before calling the back end
    .registerUser(correo: correo, contrasena: contrasena, nombre: nombre, pais: pais, telefono: telefono, credito: 0);  
    setState(ViewState.Idel);
    return _result;
  }



  Future<String> registrarseConGoogle() async {
    setState(ViewState.Busy);
    String _result;
    _result = await _authenticationService.signInGoogle();
    setState(ViewState.Idel);
    return _result;    
  }

           
}
  



