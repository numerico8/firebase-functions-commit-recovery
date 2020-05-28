
import 'package:pimpineo_v1/viewmodels/base_model.dart';



///** THIS IS NOT BEING USED ANYMORE */ 

class ComprarCreditoModel extends BaseModel{

//   Map<String,dynamic> paymentMethod = Map<String,dynamic>();
//   FirestoreService _firestoreService = locator<FirestoreService>();
  

//   //comprar credito usando una nueva tarjeta de credito 
//   void comprarCreditoNewCard(BuildContext  context, bool saveCard, double totalAPagar, String cardnombre ,String cardnumero, String cardfecha, String cardcvv, String cardzip) async {
    
//     User user = Provider.of<User>(context,listen: false);
//     String mes = cardfecha.replaceAll('/', '').substring(0,2);
//     String ano = cardfecha.replaceAll('/', '').substring(2);
    

//     // creating the payment methdd as a map
//     paymentMethod = {
//       'uid' : user.uid, 
//       'credito' : user.credito, //at this point the credit is updated
//       'stripe_id' : user.payments['stripe_id'],  //este id se crea en el registro inicial del usuario
//       'savecard' : saveCard,
//       'amount' : totalAPagar,
//       'cardnombre': cardnombre,
//       'number' : cardnumero,
//       'exp_month' : mes,
//       'exp_year' : ano,
//       'cvc' : cardcvv,
//       'cardzip' : cardzip
//     };

//     bool result = await _firestoreService.makePaymentCard(paymentMethod); //this is the fuction where i am sending to validate to Stripe to check if the card is valid
    

//    }


//    //this is the function to buy credit using a card that is already saved
//    Future<bool> comprarCreditoSavedCard(BuildContext  context, int cardIndex, double totalAPagar) async {

//      Map<String,dynamic> card;
//      User user = Provider.of<User>(context,listen: false);
//      card = user.getCardFromIndex(cardIndex);
     

//      paymentMethod = {
//       'uid' : user.uid, 
//       'credito' : user.credito,
//       'transaction_records' : user.transacciones,
//       'stripe_id' : user.payments['stripe_id'],  //este id se crea en el registro inicial del usuario
//       'savecard' : false, //this is false since the card that we are sending here is already saved
//       'amount' : totalAPagar,
//       'cardnombre': card['name'],
//       'number' : card['number'],
//       'exp_month' : card['exp_month'],
//       'exp_year' : card['exp_year'],
//       'cvc' : card['cvc'],
//       'cardzip' : card['cardzip'],
//     };
  

//      var result = await _firestoreService.makePaymentCard(paymentMethod);

//      return result;

//    }
  
   
//    Future<List<dynamic>> enviarRecarga( String type, var credito, List<Map<String,dynamic>> contactosARecargar) async {
     
//      Map<String, dynamic> data = new Map<String,dynamic>();
//      List<Map<String,dynamic>> contactosARecargarModificada = new List<Map<String,dynamic>>();
//      List<String> contactosNoRecargados = new List<String>();
//      List<dynamic> result = new List<dynamic>();
//      double newTotalAPagar;

//      // creando el paquete a enviar para recargar
//      contactosARecargar.forEach((contacto) async {
//        data['telefono'] = contacto['telefono'];
//        data['cantidad'] = contacto['selectedAmount'];
//        data['credito'] = credito;
//        data['type'] = type;

//        String resultDeEnvio = await _firestoreService.enviarRecarga(data);
//        contacto['resultadoDeUltimaRecarga'] = resultDeEnvio;

//        if(resultDeEnvio.contains('error')){
//          contactosNoRecargados.add(contacto['nombre']);
//        }
//        else{
//          contactosARecargarModificada.add(contacto);
//        }
//      });

//      newTotalAPagar = this.calcularTotalAPagar(contactosARecargarModificada);
//      result.add(contactosARecargarModificada);
//      result.add(contactosNoRecargados);
//      result.add(newTotalAPagar);
     
//      return result;
//    }


//   // para devolver las tarjetas salvadas al cupertino picker
//    List<Widget> getCardsInFileList(BuildContext context){
//      List<Widget> result;
//      result = Provider.of<User>(context).getCardInFileList();
//      return result;
//    }


//   //it is just to test the DT One API
//    quicktest(BuildContext context){
//      User user = Provider.of<User>(context,listen: false);
//    }



// // function that calculates the total to pay
//   double calcularTotalAPagar(List<dynamic> listaRecargar) {
//     var totalAPagarNoTax = 0.0;
//     double tax = 0.07;
//     double fee;
//     listaRecargar.forEach((value) {
//       String amount = value['selectedAmount'];
//       String cleanAmount = amount.substring(0, 2);
//       double number = double.parse(cleanAmount);
//       totalAPagarNoTax += number;
//     });
//     fee = totalAPagarNoTax / 20;
//     double totalAPagarWithFee = totalAPagarNoTax + fee;
//     double taxationValue = totalAPagarWithFee * tax;
//     double totalAPagar = totalAPagarWithFee + taxationValue;
//     return totalAPagar;
//   }


}