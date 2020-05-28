import 'package:flutter/material.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/firestore_service.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/services/validator.dart';
import 'package:pimpineo_v1/widgets/checkout_dialogs.dart';
import 'package:provider/provider.dart';

//en este widget se llama el backend para cambia la informacion del ususario

class ProfilePage extends StatefulWidget {
  static const String route = '/profile';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {

  bool editionToggle = true;
  String newName;
  UserValidator validator = new UserValidator();
  String newCorreo;
  FirestoreService firestoreService = locator<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) =>
        SafeArea(
         child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(//Mi Perfil
                'Datos Personales',
                style: TextStyle(
                  color: Colors.blue[800],
                  fontFamily: 'Poppins',
                  fontSize: 22.0
                )
             ),
            leading: IconButton( // boton de atras
                icon: Padding(
                  padding: EdgeInsets.only(left:5.0),
                  child: Icon(Icons.arrow_back_ios, size: 30.0, color: Colors.blue[800],),
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            actions: <Widget>[ //edit button
                Padding( //boton de editar
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.edit ,color: Colors.blue[800],size: 30.0,), 
                    onPressed: (){
                      setState(() {
                        editionToggle = !editionToggle;
                      });
                    } 
              ),
                )],  
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                
                Container( //Nombre text
                  alignment: Alignment.centerLeft,
                  color: Colors.grey[200],
                  height: 50.0, 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Nombre: ',
                      style: TextStyle(
                        fontFamily: 'Monserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0
                      )
                    ),
                  ),
                ),
                Container( //Nombre
                  color: Colors.white,
                  height: 50.0, 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            onChanged: (val){
                              newName = val;
                            },
                            validator: validator.validateName,
                            readOnly: editionToggle,
                            style: TextStyle(
                              fontFamily: 'Monserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0
                            ),
                            initialValue: user.nombre,
                            decoration: InputDecoration(
                              enabledBorder: editionToggle == true 
                              ? UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)) 
                              : UnderlineInputBorder(borderSide: BorderSide(color: Colors.green, width: 3.0)),
                              focusedBorder:editionToggle == true 
                              ? UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)) 
                              : UnderlineInputBorder(borderSide: BorderSide(color: Colors.green, width: 3.0)), 
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                

                Container( //Telefono text
                  alignment: Alignment.centerLeft,
                  color: Colors.grey[200],
                  height: 50.0, 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Telefono: ',
                      style: TextStyle(
                        fontFamily: 'Monserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0
                      )
                    ),
                  ),
                ),
                Container( //Telefono
                  color: Colors.white,
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            style: TextStyle(
                              fontFamily: 'Monserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0
                            ),
                            initialValue: user.telefono,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 3.0)) 
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
                
                Container( // correo text
                  alignment: Alignment.centerLeft,
                  color: Colors.grey[200],
                  height: 50.0, 
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Correo Electronico: ',
                      style: TextStyle(
                        fontFamily: 'Monserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0
                      )
                    ),
                  ),
                ),
                Container( // correo
                  color: Colors.white,
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            readOnly: true,  //this is the one to modify for the users logging in from the phone
                            style: TextStyle(
                              fontFamily: 'Monserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0
                            ),
                            initialValue: user.correo,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 15.0,),
                Padding( //divider at the end 1
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Divider(color: Colors.grey[200],thickness: 4.0,),
                ),
                SizedBox(height: 15.0,),

                //botones al final de la forma del perfil
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[

                    Container( // boton cancelar
                      height: 40.0,
                      width: 170.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: FlatButton( //boton cancelar
                        color: Colors.red[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                         child: Icon(Icons.cancel, color: Colors.red[900],)
                      ),
                    ),
                  
                    Container( //boton salvar 
                      height: 40.0,
                      width: 170.0,
                      child: FlatButton( //boton salvar
                        color: Colors.green[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        onPressed: () async {
                          //boton salvar escribe en la base de datos
                          if(newName != null){
                            String result = await firestoreService.updateUserNombre(newName, user.uid);
                            if(result != 'Error'){
                              user.updateName(newName);
                            }
                            else{
                              showDialog(
                                context: context, 
                                builder:(context){
                                return CustomAlertDialogs(
                                  selection: 13,
                                  text: 'Ha ocurrido un error salvando los cambios. Intentelo nuevamente. Gracias!',
                                );
                              });
                            }
                          }
                        },
                         child: Icon(Icons.save_alt, color: Colors.green[900],)
                      ),
                    ),

                    ],
                ), 
                SizedBox(height: 15.0,),
                Padding( //divider at the end 2
                  padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Divider(color: Colors.grey[200],thickness: 4.0,),
                ),
                

              ],
            ),
          ),
        )
      ),
    );
  }



}