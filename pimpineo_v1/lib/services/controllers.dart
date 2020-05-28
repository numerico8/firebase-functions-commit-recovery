import 'dart:async';
import 'package:pimpineo_v1/model/user.dart';


class Controllers {

  Controllers();
  
  static StreamController<User> userStreamController = StreamController<User>();
  
  static void closeController(){
    userStreamController.sink.close();
    userStreamController.close();
  }
    

}

