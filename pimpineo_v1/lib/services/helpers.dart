
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Helpers{

  static SharedPreferences preferences;

  static Future<bool> showSnackBar(ScaffoldFeatureController<SnackBar, SnackBarClosedReason> inst, bool completed) async{
    Future.value(inst);
    return completed = true;
  }

  static String lastroute = '';

  static bool clienteAgreed = false;

  static bool fromComprarPage = false;

  static double minAmount = 12.00;

  static double maxAmountPerCardPerDay = 120.00;

  static Widget customProgressIndicator(){
    return Column( //custom progress indicator
                    children: <Widget>[
                      Padding( //custom progress indicator
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Center(child: Stack(
                          children: <Widget>[
                            Center(
                              child: CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.blue[800],
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Pacifico',
                                    fontSize: 38
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5,
                                    valueColor: AlwaysStoppedAnimation(Colors.blue[800]),
                                    backgroundColor: Colors.white,
                            ),
                                ),
                              ),)
                          ],
                        ),),
                      ),
                      SizedBox(height: 15.0),
                      Text('Procesando...', style: TextStyle( //Procesando
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        color: Colors.blue[800]
                      ),)
                    ],
                  );
  }

  /// Crear un nuevo record cuando se compra una recarga usando solamente el credito */
  static Future<void> crearRecordParaRecargaConSoloCredito(List<Map<String,dynamic>> contactosRecargados, double cantidad, BuildContext context) async {
    
    User user = Provider.of<User>(context, listen: false);
    Map<String, dynamic> newRecord = new Map<String, dynamic>();
    String telefonosRecargadosString = '';

    contactosRecargados.forEach((contacto){
      telefonosRecargadosString = telefonosRecargadosString + contacto['telefono'].toString() + ', ';
    });
        

    newRecord = {
      'credito' : user.credito,
      'cantidad' : double.parse(cantidad.toStringAsFixed(2)),
      'telefonosRecargados' : contactosRecargados,
      'telefonosRecargadosString' : telefonosRecargadosString,
      'type' : 'Recarga usando solo Credito',
      'timestamp' : DateTime.now().millisecondsSinceEpoch
    };

    user.transacciones.add(newRecord);

    await Firestore.instance.collection('users').document(user.uid).setData({
      'transaction_records' : user.transacciones,
      'credito' : user.credito,
    },merge: true);


  }


}

