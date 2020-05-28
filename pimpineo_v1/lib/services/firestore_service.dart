import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:pimpineo_v1/model/user.dart';



class FirestoreService {
 
  Firestore _firestore = new Firestore();

  //**** read the database and get the user completed
  Future fetchUserFromDatabase(String uid) async { 
    DocumentSnapshot doc = await _firestore.collection('users').document(uid).get(); 
    if(doc != null){
      var user = User.fromData(doc.data); //constructed User
      return user;
    }else{
      return 'Este usuario no existe.';
    }
  }
  
 
  //**** call the cloud function in the backend to create a new user when registered
  Future<String> createFirestoreUserBE(User user) async {
    try {
      Map<String,dynamic> usermap = user.toJson(); 
      var result = CloudFunctions.instance.getHttpsCallable(functionName: 'createFirestoreUser');
      var result1 = await result.call(usermap).catchError((e){
        return 'error in the Firebase Function.';
      });
      return result1.data;      
    } catch (e) {
      return 'error creating the User.';
    }
  }


  //**** function that request to delete contact from firestore to the backend
  Future updateContactInUserList(User user) async{
    try {
      var function = CloudFunctions.instance.getHttpsCallable(functionName: 'updateContactList');
      var result =  await function.call(user.toJson()).catchError((e){
        return 'error when calling http';
      }); 
      return result.data;  
    } catch (e) {
      return 'error running firestore service';
    }
  }


  //**** function with STRIPE API steps: validate the card, make the payment, save the card and save the record
  Future<bool> makePaymentCard(Map<String, dynamic> paymentMethod) async{
    try {
      var function = CloudFunctions.instance.getHttpsCallable(functionName: 'makePaymentCard');
      var result = await function.call(paymentMethod).catchError((e){
        return false;
      });
      print(result.data.toString() + 'makepayment');
      return result.data;
    } catch (e) {
      return false;
    }
    
  }


  /// ** function to process the payment of the credit card  */
  Future<dynamic> processPaymentCard(Map<String,dynamic> data) async {
    try {
      var function = CloudFunctions.instance.getHttpsCallable(functionName: 'processPaymentCard');
      var result = await function.call(data).catchError((e){
        return false;
      });

      var finalResult = result.data;
      finalResult ??= '';

      print(result.data + ' processpayment');
      
      if(finalResult.toString().contains('successfully')){
        return true;
      }
      else{
        return false;
      }

    } catch (e) {
      return false;
    }
  }


  //****function to request the topup to DT One API
  Future<String> enviarRecarga(Map<String,dynamic> data) async {
    try {
      var function = CloudFunctions.instance.getHttpsCallable(functionName: 'enviarRecarga');
      var result = await function.call(data).catchError((e)=>'Cloud function error');
      
      var finalResult = result.data;
      finalResult ??= '';

      print(result.data + ' Firestore Service Envio de Recarga Respuesta del Cloud Function');

      if(finalResult == 'Transaction successful'){
        print('Firestore Service Envio de Recarga Successfull'); //************ to delete  ** */
        return 'successful';
      }
      else{
        print('Firestore Service Envio de Recarga Failed'); //to delete
        return result.data;
      }
      
    } catch (e) {
      print('Firestore Service Envio de Recarga Error'); //**************to delete ** */
      return 'error';
    }
  }


  //update the name of the user in firestore
  Future<String> updateUserNombre(String newNombre, String uid) async {
    try {
      await _firestore.collection('users').document(uid).updateData({
        'nombre' : newNombre
      });
      return 'Success';
    } catch (e) {
      return 'Error';
    }
  }


  //actualiza el listado de las tranacciones cogiendo un snapshot del documento y pasando el record de transacciones al usuarion local
  updateListadoTransacciones(User user) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').document(user.uid).get(); 
    print(userDoc.data);
    user.setTransacciones(userDoc.data['transaction_records']);    
    user.setPaymentMethods(userDoc.data['payments']);
  }


  //coge el listado de precios
  Future<List<dynamic>> getRecargasPrices() async {
    List<dynamic> pricesList = new List<dynamic>();
    DocumentSnapshot doc = await _firestore.collection('prices').document('FGZ97LRV8vhmpmo1oTQd').get();
    pricesList = doc.data['recargas_price'];
    return pricesList;
  }


  //elimina una tarjeta de credito salvada en los records en stripe y en la nube nuestra
  Future<bool> deletePaymentMethod(User user, int index, String pmID) async {
    Map<String,dynamic> data = new Map<String,dynamic>();
    data = {
      'uid' : user.uid,
      'stripe_id' : user.payments['stripe_id'],
      'index' : index,
      'pmID' : pmID
    };

    var function = CloudFunctions.instance.getHttpsCallable(functionName: 'deletePaymentMethod');
    var result = await function.call(data).catchError((e){
      print('Cloud function error');
      return false;
    });
    print(result.data.toString() + ' FirestoreService');
    return result.data;    
  }


}
  
