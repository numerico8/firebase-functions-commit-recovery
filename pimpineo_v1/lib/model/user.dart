


import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  
  User({this.uid, this.nombre, this.telefono, this.correo, this.pais, this.credito,this.contactos,this.payments,this.transacciones, this.termsAndCond});

  String uid;
  String pais;
  String nombre;
  String telefono;
  String correo;
  Map<String,dynamic> contactos;
  Map<String,dynamic> payments;
  List<dynamic> transacciones = [];
  var credito;
  String termsAndCond;
  
  
  //initializing the user with some data
  User.initial() : uid = '',pais = '',nombre = '', telefono = '', correo = '', credito = 0;


  //creating an user directly from the data coming from the Firestore Json file
  User.fromData(Map<String,dynamic> data)
  : uid = data['uid'], 
    pais = data['pais'], 
    nombre = data['nombre'], 
    telefono = data['telefono'], 
    correo = data['correo'], 
    credito = data['credito'],
    payments = data['payments'],
    contactos = data['contactos'],
    termsAndCond = data['accepted_termsAndCond'],
    transacciones = data['transaction_records'];



  //converting the data to a json file
  Map<String,dynamic> toJson(){
    return {
      'uid' : uid,
      'pais' : pais,
      'nombre' : nombre,
      'telefono' : telefono,
      'correo' : correo,
      'credito' : credito,
      'contactos' : contactos,
      'payments' : payments,
      'transaction_records' : transacciones,
      'termsAndCond' : termsAndCond
    };
  }

  //set new contact list 
  void updateContactList(Map<String,dynamic> newList){
    this.contactos = newList;
  }




  //CARDS----get the list of the cards that we have registered for the customer at that moment
  List<Widget> getCardInFileList(){

    List<dynamic> paymentMethods;
    paymentMethods = payments['payment_methods'];
    List<Widget> result = [Text('Nueva', style: TextStyle(fontFamily: 'Monserrat'),)];
    
    if(paymentMethods.isNotEmpty){
      paymentMethods.forEach((card) {
        result.add(Text(card['card']['brand'] + '-xxxx-' + card['card']['last4'].toString(),style: TextStyle(fontFamily: 'Monserrat',),));
      });
      return result;
    }
    else{
      return result;
    }
  } 
  
  //CARDS----get the card to be used to charge from the list
  Map<String, dynamic> getCardFromIndex(int index){
    List<dynamic> result;
    result = payments['payment_methods'];
    return result[index-1]; //get card index -1 since the index of the cupertino picker will be always 1 more because of 'Nueva' option
  }

  //CARDS--- remove locally a card from the list and return the ID of the payment method that was removed
  String deletePaymentMethod(int index){
    List<dynamic> paymentMethods = payments['payment_methods'];
    String pmID = paymentMethods.removeAt(index)['id'];
    payments['payment_methods'] = paymentMethods;
    return pmID;
  }
  

  //update variable functions as needed
  dynamic updateCredit(double newCredit) {
    double.parse(newCredit.toStringAsFixed(2));
    this.credito = newCredit;
    return this.credito;
  }

  updateName(String newName){
    this.nombre = newName;
  }

  updateTelefono(String newTelefono){
    this.telefono = newTelefono;
  }

  updateEmail(String newCorreo){
    this.correo = newCorreo;
  }

  setTransacciones(List<dynamic> transacciones){
    //devuelve la lista en reversa para ver el ultimo record de primero
    if(transacciones != null){this.transacciones = transacciones;}
  }

  setPaymentMethods(Map<String, dynamic> payments){
    this.payments['payment_methods'] = payments['payment_methods'];
  }

}