
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pimpineo_v1/services/authentication.dart';
import 'package:pimpineo_v1/services/connectivity_service.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/view/login.dart';
import 'package:pimpineo_v1/view/no_connection.dart';
import 'package:pimpineo_v1/view/us/us_lobby.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';


class LaunchPageViewModel extends BaseModel{


  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  
    

  Future handleInitialLogic(BuildContext context) async {

    //Check if there is Network connection 
    var isConnected = await this.isConnected(); //to intenet

    if(isConnected){

      var hasLoggedUser = await _authenticationService.isUserLoggedIn();

      // add a duration to the main screen
      Timer(Duration(seconds:1), (){
        if(hasLoggedUser){
          Navigator.pushNamedAndRemoveUntil(context, LobbyUS.route ,  (Route<dynamic> route) => false);
        }
        else{
          Navigator.pushNamedAndRemoveUntil(context, LogIn.route ,  (Route<dynamic> route) => false);
        }
      });
    }
    else{
      Navigator.pushNamedAndRemoveUntil(context, NoConnection.route ,  (Route<dynamic> route) => false);
    }
    
  }


  Future<bool> isConnected(){
    return ConnectivityService.isConnected();
  }

  


}