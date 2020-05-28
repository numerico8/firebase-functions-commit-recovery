import 'package:flutter/cupertino.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';
import 'package:provider/provider.dart';




class TransaccionesViewModel extends BaseModel{

  List<dynamic> transacciones;

  getTransacciones(BuildContext context){
    this.transacciones = Provider.of<User>(context,listen: false).transacciones.reversed.toList();
  }

  

}