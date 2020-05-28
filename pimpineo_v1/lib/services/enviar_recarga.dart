

// callable class since this is a functions used from different points in the application
import 'package:pimpineo_v1/services/firestore_service.dart';
import 'package:pimpineo_v1/services/locator.dart';

class CallEnviarRecarga{

  FirestoreService _firestoreService = locator<FirestoreService>();

  Future<List<dynamic>> call( String type, var credito, List<Map<String,dynamic>> contactosARecargar) async {
     
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

       print(resultDeEnvio);

       if(!resultDeEnvio.contains('successful')){
         print('No recargado'); //to Delete
         contactosNoRecargados.add(contacto['nombre']);
       }
       else{
         print(contacto); //to Delete
         contactosRecargados.add(contacto);
       }

     });
     
       newTotalAPagar = await CallEnviarRecarga.calcularTotalAPagar(contactosRecargados);
       print(newTotalAPagar);
       print(contactosRecargados);
       result.add(contactosRecargados); //0
       result.add(contactosNoRecargados);    //1
       result.add(newTotalAPagar);    //2

     return result;

   }


   // function that calculates the total to pay
  static Future<double> calcularTotalAPagar(List<dynamic> listaRecargar) async {
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

}