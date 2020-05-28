
import 'package:flutter/cupertino.dart';
import 'package:pimpineo_v1/services/viewstate.dart';


class BaseModel extends ChangeNotifier{

   ViewState _state = ViewState.Idel;
  
  ViewState get state => _state;

  void setState(ViewState viewState){
    this._state = viewState;
    notifyListeners();
  }


}