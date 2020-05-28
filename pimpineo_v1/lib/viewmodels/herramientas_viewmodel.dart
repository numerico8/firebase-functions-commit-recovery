
import 'package:flutter/cupertino.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/firestore_service.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pimpineo_v1/services/helpers.dart';



class HerramientasVM extends BaseModel{

  List<Widget> paymentMethods = new List<Widget>();
  SharedPreferences preferences;
  FirestoreService _firestoreService = locator<FirestoreService>();
  String savedEmail = '';


  //retorna la lista de los metodos de pago
  getPaymentMethodsList(User user){
    paymentMethods = user.getCardInFileList();
    paymentMethods.removeAt(0);
  }

  //get the email that is saved in the preferences
  getSavedLogInEmail() async {
    Helpers.preferences = await SharedPreferences.getInstance();
    String result;
    result = Helpers.preferences.getString('email');
    if(result == null){
      savedEmail = '';
    }else{
      savedEmail = result;
    }
  }

  //deletes the saved user email from the log in
  Future<bool> deleteSavedLogInEmail() async {
    bool result;
    Helpers.preferences = await SharedPreferences.getInstance();
    result = await Helpers.preferences. remove('email');
    if(result){savedEmail = '';}
    return result;
  }

  //borra el metodo de pago de la applicacion, base de datos y stripe
  Future<bool> deletePaymentMethod(User user, int index) async {
    bool result;
    String pmID = user.deletePaymentMethod(index);
    await _firestoreService.deletePaymentMethod(user,index,pmID).then((val){
      result = val;
    });
    return result;
  }

}