import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pimpineo_v1/services/formatter.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/model/contactos_model.dart';
import 'package:pimpineo_v1/services/validator.dart';
import 'package:pimpineo_v1/view/base_view.dart';
import 'package:pimpineo_v1/viewmodels/contacts_viewmodel.dart';
import 'package:pimpineo_v1/widgets/checkout_dialogs.dart';
import 'package:provider/provider.dart';


class MainCarouselContactos extends StatefulWidget {
  @override
  _MainCarouselContactosState createState() => _MainCarouselContactosState();
}


class _MainCarouselContactosState extends State<MainCarouselContactos> {


// add contact variables
  String telefono;
  String nombre;
  String direccion;
  String municipio;
  String provincia;
  GlobalKey<FormState> _newContactFormKey = GlobalKey<FormState>();
  final UserValidator _validator = locator<UserValidator>();


  //variable utilizadas para la barra con los botones de los paises e inizializacion de estos
  String selectedCountry = 'CU';
  String controllerInitialValue = '+53-5-';
  TextEditingController _phoneFieldController;

  void _textEditingControllerListener(){
    _phoneFieldController.text = controllerInitialValue;
    _phoneFieldController.selection = TextSelection.collapsed(offset: _phoneFieldController.text.length);
  }
    
 
  @override
  void initState() {
    super.initState();
    if(_phoneFieldController == null){
      _phoneFieldController = new TextEditingController(text: controllerInitialValue);
    }
    else{
      _phoneFieldController.addListener(this._textEditingControllerListener);
    }
  }
  

  @override
  Widget build(BuildContext context) {//instancias de prueba para el desarrollo el UI        
  return BaseView<ContactsViewModel>(
      onModelReady: (model) => model.getListas(context),
      builder: (context, model, child) {
        return Consumer<ListaContactosModel>(
          builder: (context,lists,child) {
          return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: <Widget>[ // mis contactos con el icono
                Icon( // icon before Mis contactos
                FontAwesomeIcons.addressBook,
                color: Theme.of(context).primaryColor,
                size: 30.0,
              ),
                SizedBox(width: 15.0, ),
                Text(            //mis contactos
                'Mis Contactos',
                style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 28.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700),
              ),
            ]),
            SizedBox(height: 20.0,),
            Container(      //Listview container
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[400],
                          offset: Offset(0.0, 6.0),
                          blurRadius: 5.0),
                      BoxShadow(
                          color: Colors.grey[400],
                          offset: Offset(0.0, -6.0),
                          blurRadius: 5.0)
                    ]),
                height: 400.0,
                width: 360.0,
                child:ListView.separated(     //Lista
                      separatorBuilder: (context, index) {     //separator container      
                        return Center(
                          child: Container(
                            color: Colors.lightBlue[200],
                            height: 2.0,
                            width: 330.0,
                          ),
                        );
                      },
                      itemCount: lists.nombredisplay.length + 1,              //detail,
                      itemBuilder: (context, index) {
                        return index == 0 ? _searchBar(lists) :  _listItem(lists,index-1,model);
                      }),),
            Padding(       //add button
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: RaisedButton(         // accion de crear el nuevo contacto      
                  elevation: 2,
                  onPressed: () {  // accion de crear el nuevo contacto 
                    showModalBottomSheet( 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))
                      ),
                      isScrollControlled: true,
                      context: context, 
                      builder: (context){
                        return StatefulBuilder(
                          builder: (context,setState) => Container(
                            padding: EdgeInsets.symmetric(horizontal:25.0,vertical: 25.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) ,topRight: Radius.circular(15.0))
                            ),
                            child: Form(
                              key: _newContactFormKey,
                              child: Column( 
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text( //crear contacto label
                                    'Crear Contacto',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontFamily: 'Poppins',
                                      fontSize: 22.0
                                    ),
                                  ),
                                  TextFormField( //nombre
                                    onChanged: (value){
                                      this.nombre = value;
                                    },
                                    validator: _validator.validateNombreContacto,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontFamily: 'Poppins'
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Nombre',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins'
                                      )
                                    ),
                                  ),
                                  Row( //phone number
                                    children: <Widget>[
                                      Expanded( //telefono field
                                        flex: 4,
                                        child: TextFormField( // telefono
                                          controller: _phoneFieldController,
                                          style: TextStyle(fontFamily: 'Poppins'),
                                          inputFormatters:  selectedCountry == 'CU'
                                          ?[
                                            TextFormatter(
                                              separator: '-',
                                              mask: 'xxx-x-xxx-xxxx',
                                            )
                                          ]
                                          :[
                                            TextFormatter(
                                              separator: '-',
                                              mask: 'xx-xxx-xxx-xxxx',
                                            )
                                          ],
                                          onChanged: (value){
                                            this.telefono = value.replaceAll('-', '');
                                          },
                                          validator: _validator.validatePhone,
                                          keyboardType: TextInputType.phone,),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded( //select pais button
                                        flex: 2,
                                        child: Padding( //botones para elegir el pais
                                          padding: const EdgeInsets.only(top:8.0),
                                          child: SizedBox(
                                            height: 50,
                                            width: 120,
                                            child: ButtonBar(
                                              buttonPadding: EdgeInsets.all(1),
                                              children: <Widget>[
                                                Container( //CUBA BOTON
                                                  width: 50,
                                                  child: RaisedButton(
                                                    splashColor: Colors.transparent,
                                                    elevation: selectedCountry == 'CU' ?1 :0,
                                                    color: selectedCountry == 'CU'  ?Colors.green :Colors.grey[300],
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),topLeft: Radius.circular(8)),
                                                    ),
                                                    onPressed: (){
                                                      setState(() {
                                                        selectedCountry = 'CU';
                                                        controllerInitialValue = '+53-5-';
                                                        _textEditingControllerListener();
                                                         });
                                                    }, 
                                                    child: Text(
                                                      'CU',
                                                      style: TextStyle(
                                                        color:selectedCountry == 'CU'?Colors.white:Colors.grey[400],
                                                        fontSize: 18,
                                                        fontFamily: 'Poppins'
                                                    ),)
                                                )),                                          
                                                Container( //US BOTON
                                                  width: 50,
                                                  child: RaisedButton(
                                                    splashColor: Colors.transparent,
                                                    elevation:  selectedCountry == 'US' ?1 :0,
                                                    color: selectedCountry == 'US'  ?Colors.green :Colors.grey[300],
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(8) ,topRight: Radius.circular(8)),
                                                    ),
                                                    onPressed: (){
                                                      setState(() {
                                                        selectedCountry = 'US';
                                                        controllerInitialValue = '+1-';
                                                        _textEditingControllerListener(); 
                                                      });
                                                    }, 
                                                    child: Text('US',
                                                    style: TextStyle(
                                                      color:selectedCountry == 'US'?Colors.white:Colors.grey[400],
                                                      fontSize: 18,
                                                      fontFamily: 'Poppins'
                                                    ),)
                                                )),
                                                ]
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  TextFormField( //direccion
                                    onChanged: (value){
                                      this.direccion = value;
                                    },
                                    keyboardType: TextInputType.text,
                                    validator: _validator.direccion,
                                    style: TextStyle(
                                      fontFamily: 'Poppins'
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Direccion',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins'
                                      )
                                    ),
                                  ),
                                  TextFormField(  //municipio
                                    onChanged: (value){
                                      this.municipio = value;
                                    },
                                    keyboardType: TextInputType.text,
                                    validator: _validator.municipio,
                                    style: TextStyle(
                                      fontFamily: 'Poppins'
                                    ),
                                    decoration: InputDecoration(
                                      hintText: selectedCountry == 'CU'
                                      ?'Municipio'
                                      :'Ciudad',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins'
                                      )
                                    ),
                                  ),
                                  TextFormField( // provincia
                                    onChanged: (value){
                                      this.provincia = value;
                                    },
                                    keyboardType: TextInputType.text,
                                    validator: _validator.provincia,
                                    style: TextStyle(
                                      fontFamily: 'Poppins'
                                    ),
                                    decoration: InputDecoration(
                                      hintText: selectedCountry == 'CU' 
                                      ?'Provincia'
                                      :'Estado, ZIP',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins'
                                      )
                                    ),
                                  ),
                                  SizedBox(height:15.0),
                                  Padding(  //boton salvar
                                    padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
                                    child: Container(
                                      height: 35.0,
                                      width: 150.0,
                                      child: FlatButton( //boton salvar
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0)
                                        ),
                                        onPressed: (){
                                          if(_newContactFormKey.currentState.validate()){
                                            String result = model.crearContacto(nombre,  telefono,  direccion,  municipio, provincia, context);
                                            if(result.contains('existe')){ //significa que el contacto ya existe
                                              showDialog( //contacto con ese numero ya existe
                                              context: context,
                                              builder: (context){
                                                return CustomAlertDialogs(
                                                  selection: 13,
                                                  text: result,
                                                );
                                              });
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          } else { //error creando el contacto
                                            showDialog( // usuario mando la forma con errores y no valido bien
                                              context: context,
                                              builder: (context){
                                                return CustomAlertDialogs(
                                                  selection: 13,
                                                  text: 'Por favor corrija los errores mostrados.',
                                                );
                                              });
                                          }
                                          _textEditingControllerListener(); //called the listener so it reloads back the CU data ('+53-5-)
                                        },
                                         child: Icon(Icons.save_alt, color: Colors.white,)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),                
                          ),
                        );
                      }
                    );                       
                    },
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row( //boton de crear contacto
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.group_add,
                        color: Theme.of(context).primaryColor,
                        size: 28.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Crear Contacto',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'Sen',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
            )
          ],
         );
        });
      } ,
      );
  }


   
   // this is the search bar algorithm
  _searchBar(ListaContactosModel lists){   //este es el algoritmo para la busqueda dentro de las listas
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Icon(Icons.search,size: 20.0,),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: SizedBox(
            width: 200,
            child: TextField(//buscar textfield
              keyboardType: TextInputType.text,
              onChanged: (text){
                text = text.toLowerCase();
                setState(() {
                  lists.nombredisplay = lists.nombres.where((nombre){
                    nombre = nombre.toLowerCase();
                    var result = nombre.contains(text);
                    return result;
                  }).toList();
                });
              },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ) ,
                hintText: '...Buscar Contacto',
                hintStyle: TextStyle(
                  fontFamily: 'Sen',
                )
              ),
            ),
          ),
        ),
      ],
    );
  }


   //actual list of contacts in the list
  _listItem(ListaContactosModel lists,index, ContactsViewModel model) {     //partes de las listas
     //this is in order to get the correct value to show in the list
    String tel;
    lists.contactos.forEach((key,value){
      if(value['nombre'] == lists.nombredisplay[index]){
        tel = value['telefono'];
      }
    });

    return ListTile(        //aqui estan los iconos de la lista de contactos UI    
           onTap: (){ //tap listview action
             setState(() {
               lists.contactos[tel]['isSelected'] = !lists.contactos[tel]['isSelected'];
             });
           },
           contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
           title: Text( //nombre
             lists.nombredisplay[index], 
             style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]),
           ),
          subtitle: Text( // telefono
            lists.telefonos[index],
            style: TextStyle(fontFamily: 'Sen', fontSize: 18.0),
          ),
          trailing: GestureDetector( // tap delete icon action 
            onTap: (){ // tap delete icon alert dialog
              if(lists.contactos[tel]['isSelected'] == true){
                showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: AlertDialog(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      content: Container(
                        width: 300.0,
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container( //boton de cerrar
                              margin: EdgeInsets.only(left:225),
                              child: GestureDetector(
                                child: Icon(Icons.close),
                                onTap: (){Navigator.pop(context);},
                              )
                            ),
                            SizedBox(height: 15.0,),   
                            Text( //palabreo del dialogo para borrar
                              'Seguro desea borrar a ${lists.nombredisplay[index].split(' ')[0].toUpperCase()} de su lista de contactos?',
                              style:TextStyle(fontFamily: 'Poppins'),
                            ),
                            SizedBox(height: 4.0,),
                            Text(
                              'Mantenga el boton presionado.',
                              style:TextStyle(fontFamily: 'Poppins'),
                            ),
                            SizedBox(height: 25.0,),
                            Center( // boton de borrar
                              child: Container(
                                width: 150,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  color: Colors.red[400],
                                  onLongPress: (){ //accion del boton borrar
                                    
                                    model.borrarContacto(tel, context);
                                    Navigator.pop(context);
                                  },
                                  onPressed: null,
                                  child: Icon(Icons.delete_forever, color: Colors.white,))
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }   
              );
              }
              },
            child: Container( //delete icon
              child: Icon(
                Icons.delete_outline,
                color: lists.contactos[tel]['isSelected'] == true 
                ?Colors.red[400]
                :Colors.grey[300],
                size: 30.0,
              ),
            ),
          ),
        );
  }


}
