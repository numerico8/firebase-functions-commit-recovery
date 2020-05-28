import 'package:flutter/cupertino.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/model/contactos_model.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/firestore_service.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';
import 'package:pimpineo_v1/services/enviar_recarga.dart';
import 'package:provider/provider.dart';

// aqui se llama al backend para:
// agregar contacto, comunication con la API de las recargas

class ContactsViewModel extends BaseModel {
  
  User user = User();
  FirestoreService _firestoreService = locator<FirestoreService>();
  List<dynamic> pricesList = new List<dynamic>();


  Future<void> getListas(BuildContext context) async {
    this.user = Provider.of<User>(context);
    Provider.of<ListaContactosModel>(context).listaDeContactos(user.contactos);
    pricesList = await _firestoreService.getRecargasPrices();
  }



// function that calculates the total to pay
  double calcularTotalAPagar(List<dynamic> listaRecargar) {
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



  void borrarContacto(String telefono, BuildContext context) {
    //remove the contact from the model that is providing the information

    //**I have listen to false since it looks like is trying to listen a provider outside of the widget tree and this is not the desired behavior
    //**therefore from here we only write in the provider

    Map<String, dynamic> newList =
        Provider.of<ListaContactosModel>(context, listen: false)
            .borrarContacto(telefono);
    Provider.of<User>(context, listen: false).updateContactList(newList);

    //request to remove the contact from current user in the database by calling the function to the firestore sevice file
    _firestoreService
        .updateContactInUserList(Provider.of<User>(context, listen: false));

    //TODO we need to create a logic in order to catch errors if there was any issue removing contacts in database or application
  }



  String crearContacto(String nombre, String telefono, String direccion,
      String municipio, String provincia, BuildContext context) {
    // crear un mapa como el nuevo contacto y adicionarlo en la lista
    Map<String, dynamic> updatedList =
        Provider.of<ListaContactosModel>(context, listen: false)
            .crearContacto(nombre, telefono, direccion, municipio, provincia);
    if (updatedList != null) {
      //update la lista de contactos con el nuevo contacto agregado con una funcion en el backend
      Provider.of<User>(context, listen: false).updateContactList(updatedList);
      _firestoreService
          .updateContactInUserList(Provider.of<User>(context, listen: false));
      //TODO we need to create a logic in order to catch errors if there was any issue removing contacts in database or application
      return 'Completado';
    } else {
      return 'Ya existe un contacto con este telefono.';
    }
  }



//coonfirmar compra en la lista de recargas en el dialogo
  dynamic confirmarCompra(bool selectedCredito, bool selectedTarjeta, double totalAPagar, BuildContext context, List<dynamic> listadoARecargar) async {
    
    User activeUser = Provider.of<User>(context, listen: false);
    //pay with credit card only
    if ((selectedTarjeta == true) && (selectedCredito == false)) {
      //pay with credit card only
      return 1;
    }
   //use credit only and validate if is needed to buy credit
    else if ((selectedTarjeta == false) && (selectedCredito == true)) {
      if (activeUser.credito > 0) { // evaluating user credit amount to know if they are requesting to buy credit or use the credit in the purchase
        if(activeUser.credito >= totalAPagar){
          //apply only credit to the purchase

          //desde aqui se esta enviando la recarga
          CallEnviarRecarga recarga = new CallEnviarRecarga();
          List<dynamic> detallesDeLaRecargaEjecutada = await recarga('Recarga usando solo Credito', activeUser.credito, listadoARecargar);
          
          double newCredit = activeUser.credito - detallesDeLaRecargaEjecutada[2];
          var result = activeUser.updateCredit(newCredit);

          Helpers.crearRecordParaRecargaConSoloCredito(detallesDeLaRecargaEjecutada[0], detallesDeLaRecargaEjecutada[2], context);

          print(result);      
          return result;
        }
        else{
          //not enought credit have to select both payment methods
          return 3;
        }
      } 
      else {
        //navigate to the page to buy credit
        return 4;
      }
    } 
    //use credit and card
    else if ((selectedTarjeta == true) && (selectedCredito == true)) {
      return 1;
    }

    return null;
    
  }

 
}
