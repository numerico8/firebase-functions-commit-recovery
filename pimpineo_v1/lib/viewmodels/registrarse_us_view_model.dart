import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/services/authentication.dart';
import 'package:pimpineo_v1/services/permissions_service.dart';
import 'package:pimpineo_v1/services/viewstate.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';


class RegistrarseViewModel extends BaseModel {

  //Authentication service to register the user 
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  
  //register button logic  
  Future<String> registerUserButton(
    BuildContext context, 
    String correo,
    String contrasena,
    String nombre,
    String pais,
    String telefono,
    var credito
  ) async { 
    setState(ViewState.Busy);  

    //get contacts
    bool permStatus = await PermissionService().getPermissionContactStatus();
    Map<String,dynamic> contactos = await PermissionService().requestContactsPermission(context,permStatus);

    var _result = await _authenticationService  //we dont need to craete the contacts for the user model from here since we can do it just before calling the back end
    .registerUser(correo: correo, contrasena: contrasena, nombre: nombre, pais: pais, telefono: telefono, credito: 0,contactos: contactos);

    setState(ViewState.Idel);
    return _result;
  }


  ///registrarse con Google
  Future<String> registrarseConGoogle(BuildContext context) async {
    //coger la lista de contactos aqui tambien
    setState(ViewState.Busy);

    //get contacts
    bool permStatus = await PermissionService().getPermissionContactStatus();
    Map<String,dynamic> contactos = await PermissionService().requestContactsPermission(context,permStatus);

    String _result;
    _result = await _authenticationService.signInGoogle(contactos);
    setState(ViewState.Idel);
    return _result;    
  }



           
}
  



