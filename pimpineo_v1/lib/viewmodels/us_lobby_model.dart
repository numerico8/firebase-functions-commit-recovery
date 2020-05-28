
import 'package:flutter/cupertino.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/authentication.dart';
import 'package:pimpineo_v1/services/viewstate.dart';
import 'package:provider/provider.dart';
import 'base_model.dart';

 

class USLobbyModel extends BaseModel{

  AuthenticationService _auth = locator<AuthenticationService>();


  //datos del ususario como tal
  User user = User();
  
  User getUser(BuildContext context){
    setState(ViewState.Busy);
    user = Provider.of<User>(context);
    setState(ViewState.Idel);
    return user;
  }


  void logout() {
    _auth.signOut();
  }
  
  

}