import 'package:flutter/material.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/firestore_service.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';
import 'package:provider/provider.dart';
 

 
class TarjetaCreditoModel extends BaseModel {
    
  Map<String,dynamic> paymentMethod = Map<String,dynamic>();
  FirestoreService _firestoreService = locator<FirestoreService>();


  //comprar credito usando una nueva tarjeta de credito 
  Future<bool> makePaymentNewCard(BuildContext  context, bool saveCard, double totalAPagar, String cardnombre ,String cardnumero, String cardfecha, String cardcvv, String cardzip, String type, bool capture) async {
    
    User user = Provider.of<User>(context,listen: false);
    String mes = cardfecha.replaceAll('/', '').substring(0,2);
    String ano = cardfecha.replaceAll('/', '').substring(2);
    double amountCorrected = double.parse(totalAPagar.toStringAsFixed(2));
    

    // creating the payment methdd as a map
    paymentMethod = {
      'listadoDeTransacciones' : user.transacciones,
      'isSavedCard' : false, 
      'uid' : user.uid, 
      'credito' : user.credito, //at this point the credit is updated
      'stripe_id' : user.payments['stripe_id'],  //este id se crea en el registro inicial del usuario
      'savecard' : saveCard,
      'amount' : amountCorrected * 100, //stripe 
      'cardnombre': cardnombre,
      'number' : cardnumero,
      'exp_month' : mes,
      'exp_year' : ano,
      'cvc' : cardcvv,
      'cardzip' : cardzip,
      'type' : type,
      'capture' : capture,
    };

    bool result = await _firestoreService.makePaymentCard(paymentMethod); //this is the fuction where i am sending to validate to Stripe to check if the card is valid
    
    return result;

   }


   //this is the function to buy credit using a card that is already saved
   Future<bool> makePaymentSavedCard(BuildContext  context, int cardIndex, double totalAPagar, String type, bool capture) async {

     Map<String,dynamic> card;
     User user = Provider.of<User>(context,listen: false);
     card = user.getCardFromIndex(cardIndex);
     double amountCorrected = double.parse(totalAPagar.toStringAsFixed(2));

     paymentMethod = {
      'listadoDeTransacciones' : user.transacciones,
      'isSavedCard' : true, 
      'uid' : user.uid, 
      'credito' : user.credito,
      'transaction_records' : user.transacciones,
      'stripe_id' : user.payments['stripe_id'],  //este id se crea en el registro inicial del usuario
      'savecard' : false, //this is false since the card that we are sending here is already saved
      'amount' : amountCorrected * 100,
      'paymentID' : card['id'],
      'exp_month' : card['card']['exp_month'],
      'exp_year' : card['card']['exp_year'],
      'type' : type,
      'capture' : capture
    };

  
     bool result = await _firestoreService.makePaymentCard(paymentMethod);
     print(result.toString() + ' TarjetaCreditoModel');
     return result;

   }
  

   //function para processar el pago
   Future<dynamic> processPayment(String type, double newAmount, String uid, List<Map<String,dynamic>> telefonosRecargados) async {

      double amountCorrected = double.parse(newAmount.toStringAsFixed(2)); 

      Map<String, dynamic> data = {
       'type' : type,
       'amount' : amountCorrected * 100,
       'uid' : uid,
       'telefonosRecargados' : telefonosRecargados, //lista entera de los telefonos que fueron recargados sin problema
     };

     var result = await _firestoreService.processPaymentCard(data);

     return result;     
   }


   //Enviar recarga
   Future<List<dynamic>> enviarRecarga( String type, var credito, List<dynamic> contactosARecargar) async {
     
     Map<String, dynamic> data = new Map<String,dynamic>();
     List<Map<String,dynamic>> contactosRecargados = new List<Map<String,dynamic>>();
     List<String> contactosNoRecargados = new List<String>();
     List<dynamic> result = new List<dynamic>();
     double newTotalAPagar;

     print(contactosARecargar);

     await Future.forEach(contactosARecargar, (contacto) async {

       data['telefono'] = contacto['telefono'];
       data['selectedAmount'] = contacto['selectedAmount'];
       data['credito'] = credito;

       String resultDeEnvio = await _firestoreService.enviarRecarga(data);
       contacto['resultadoDeUltimaRecarga'] = resultDeEnvio;

       print(resultDeEnvio.toString() + ' Resultado de EnviarRecarga Function en el ViewModel Del CreditCard');

       if(!resultDeEnvio.contains('successful')){
         print('No recargado Credit Card ViewModel'); //to Delete
         contactosNoRecargados.add(contacto['nombre']);
       }
       else{
         print(contacto); //to Delete
         contactosRecargados.add(contacto);
       }

     });
     
       newTotalAPagar = await this.calcularTotalAPagar(contactosRecargados);
       print(newTotalAPagar); //to Delete
       print(contactosRecargados); //to Delete
       result.add(contactosRecargados); //0
       result.add(contactosNoRecargados);    //1
       result.add(newTotalAPagar);    //2

     return result;

   }


  // para devolver las tarjetas salvadas al cupertino picker
   List<Widget> getCardsInFileList(BuildContext context){
     List<Widget> result;
     result = Provider.of<User>(context).getCardInFileList();
     return result;
   }


// function that calculates the total to pay
  Future<double> calcularTotalAPagar(List<dynamic> listaRecargar) async {
    var totalAPagarNoTax = 0.0;
    double tax = 0.07;
    double fee;
    listaRecargar.forEach((value) {
      String amount = value['selectedAmount'];
      String cleanAmount = amount.substring(0, 2);
      double number = double.parse(cleanAmount);
      totalAPagarNoTax += number;
    });
    fee = totalAPagarNoTax / 20;
    double totalAPagarWithFee = totalAPagarNoTax + fee;
    double taxationValue = totalAPagarWithFee * tax;
    double totalAPagar = totalAPagarWithFee + taxationValue;
    return totalAPagar;
  }



  //function para actualizar el listado de transacciones
  updateListadoTransacciones(User user){
    _firestoreService.updateListadoTransacciones(user);
  }


  //return the asset of the credit card
  String getCardImage(int index){
    switch (index) {
      case 3:
        return 'images/amex.png'; //American Express
        break;
      case 4:
        return 'images/visa.png'; //Visa
        break;
      case 5:
        return 'images/mastercard.png'; //MasterCard
        break;
      case 6:
        return 'images/discover.png'; // Discover
        break;
      default: return '';
    }
  }
  
  
  

}
