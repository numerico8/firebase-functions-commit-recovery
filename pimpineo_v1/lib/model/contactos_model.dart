

import 'package:flutter/cupertino.dart';
import 'package:pimpineo_v1/model/user.dart';


class ListaContactosModel extends ChangeNotifier {

 String uid;

 //mapa con los contactos y las llaves son los telefonos reproducido como en la base de datos
 Map<String,dynamic> contactos = {};


 //listas que van a mostrar la lista actualizada
 List<String> nombres = List<String>();
 List<String> telefonos = List<String>();
 List<String> nombredisplay = List<String>();
 List<String> telefonosBAK = List<String>();

//constructor
 ListaContactosModel();
//constructor
 ListaContactosModel.fromUser(User user){
   contactos = user.contactos;
 }


//toma la lista de contactos
 void listaDeContactos(Map<String,dynamic> contactos) {
   this.contactos = contactos;
   //make sure that contact list has value
   if(this.contactos != null){
     this.contactos.forEach((key,value){
       value['isSelected'] = false;
       value['selectedAmount'] = '20'; //meaning that the value by default is 20 dollars
     });
   }   
   this.telefonos = getContactosTelefono();
   this.nombres = getContactosNombre();
   this.nombredisplay = this.nombres;
   this.telefonosBAK = this.telefonos;
 }


  
 // borra un contacto de la lista de contactos y actualiza el provider
  Map<String,dynamic> borrarContacto(String telefono){
    int index = this.telefonos.indexOf(telefono);
    this.telefonos.removeAt(index);
    this.nombres.removeAt(index);
    this.nombredisplay = this.nombres;
    this.contactos.remove(telefono);
    notifyListeners();
    return contactos;  
  }



 //crear un nuevo contacto en la lista de contactos y actualiza el provider
  Map<String, dynamic> crearContacto( String nombre, String telefono, String direccion, String municipio, String provincia){
     
    //esto es para chequear que no exista una llave con este telefono
    bool key = contactos.containsKey(telefono);

    //chequear que la lista NO contenga esta llave
    if(key == false){
      Map<String,dynamic> contactoNuevo = {
      'nombre' : nombre,
      'telefono' : telefono,
      'direccion' : direccion,
      'municipio' : municipio,
      'provincia' : provincia,
      'isSelected' : false,
      'selectedAmount' : '20'
      };
      this.contactos[telefono] = contactoNuevo;
      //refresh the list for the provider with the new contact included
      this.telefonos = getContactosTelefono();
      this.nombres = getContactosNombre();
      this.nombredisplay = this.nombres;
      notifyListeners();
      return contactos;
    } else {
      return null;
    }

  }




 
//auxiliar methods that does not communicate with providers

  //gets an specific contact from the main map
  Map<String,dynamic> getSpecificContact(String telefono){
   Map<String,Map<String,dynamic>> _list = this.contactos;
   return _list[telefono];
 }


  //toma los contactos como una lista
  List<Map<String,dynamic>> getContactosAsList(){
   Map _list = this.contactos;
   if(_list.isNotEmpty){
     List<Map<String,dynamic>> result;
     _list.forEach((key,value){
       result.add(value);
     }); 
     return result;      
   } 
   else{
     return List<Map<String,dynamic>>();
   }
  }


  //coger la  lista de los nombres
  List<String> getContactosNombre(){
   Map<String,dynamic> _map = this.contactos;
   if(_map.isNotEmpty){
     List<Map<String,dynamic>> result = List<Map<String,dynamic>>();
     _map.forEach((key,value){
       result.add(value);
     }); 

     //ordenar la lista alfabeticamente
     result.sort((a,b){
        String nombrea = a['nombre'].toUpperCase();
        String nombreb = b['nombre'].toUpperCase();
        var r = nombrea.compareTo(nombreb); 
        if(r != 0){return r;}
        return a['telefono'].compareTo(b['telefono']);
     });
    
     List<String> nombre = List<String>();
     result.forEach((value){
       nombre.add(value['nombre']);
     });
     return nombre;      
   } 
   else{
     return List<String>();
   }
  }

  //coger la  lista de los telefonos
  List<String> getContactosTelefono(){
   Map<String,dynamic> _list = this.contactos;
   if(_list.isNotEmpty){
     List<Map<String,dynamic>> result = List<Map<String,dynamic>>();
     _list.forEach((key,value){
       result.add(value);
     });
     
     //ordenar la lista alfabeticamente
     result.sort((a,b){
        String nombrea = a['nombre'].toUpperCase();
        String nombreb = b['nombre'].toUpperCase();
        var r = nombrea.compareTo(nombreb); 
        if(r != 0){return r;}
        return a['telefono'].compareTo(b['telefono']);
     });
     
     List<String> telefono = List<String>(); 
     result.forEach((value){
       telefono.add(value['telefono']);
     });
     return telefono;      
   } 
   else{
     return List<String>();
   }
  }
  
   
   
  
  
}