import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pimpineo_v1/model/contactos_model.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:provider/provider.dart';


class PermissionService {

  ListaContactosModel listaModel = new ListaContactosModel();


///Pide el permiso para coger los contactos y con esa informacion crear una lista */
  Future<Map<String,dynamic>> requestContactsPermission(BuildContext context,bool currentStatus) async {

    Map<String, dynamic> newList = new Map<String,dynamic>();

    if(!currentStatus){
      PermissionStatus status = await Permission.contacts.request();
      if(status.isGranted){
        currentStatus = true;
      }
    }

    print(currentStatus);

    if(currentStatus){
      Iterable<Contact> contacts = await ContactsService.getContacts();
      contacts.forEach((contact){
        print(contact.phones.elementAt(0).value);
        listaModel.crearContacto(contact.displayName, contact.phones.elementAt(0).value ,'', '', '');
      });
      newList = listaModel.contactos;
      await this.updateListaDeContacto(newList, context);
      return newList;
    }
    else{
      newList = {};
      return newList;
    }
  }


///Esta es la function para crear los contactos tanto en la base de datos como local 
  updateListaDeContacto(Map<String,dynamic> updatedList, BuildContext context) async {
    if (updatedList != null) {
      print(updatedList);
      //update la lista de contactos con el nuevo contacto agregado con una funcion en el backend
      Provider.of<User>(context, listen: false).updateContactList(updatedList);  //local update
      }
  }

  
///Toma el estado de los permisos en el telefono */
  Future<bool> getPermissionContactStatus() async {
    PermissionStatus result = await Permission.contacts.status;
    if(result.isGranted){return true;}
    else{return false;}
  }



}