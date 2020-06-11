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
import 'package:pimpineo_v1/services/size_config.dart';



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
                size:  SizeConfig.resizeHeight(30),
              ),
                SizedBox(width: SizeConfig.resizeWidth(15), ),
                Text(            //mis contactos
                'Mis Contactos',
                style: TextStyle(
                    color: Colors.blue[800],
                    fontSize:  SizeConfig.resizeHeight(28),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700),
              ),
            ]),
            SizedBox(height:  SizeConfig.resizeHeight(20),),
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
                height:  SizeConfig.resizeHeight(400),
                width:  SizeConfig.resizeWidth(360),
                child:ListView.separated(     //Lista
                      separatorBuilder: (context, index) {     //separator container      
                        return Center(
                          child: Container(
                            color: Colors.grey[400],
                            height: 1.0,
                            width:  SizeConfig.resizeWidth(330),
                          ),
                        );
                      },
                      itemCount: lists.nombredisplay.length + 1,              //detail,
                      itemBuilder: (context, index) {
                        return index == 0 ? _searchBar(lists) :  _listItem(lists,index-1,model);
                      }),),
            Padding(       //add button
              padding: EdgeInsets.symmetric(horizontal:  SizeConfig.resizeWidth(25)),
              child: RaisedButton(         // accion de crear el nuevo contacto      
                  elevation: 2,
                  onPressed: () {  // accion de crear el nuevo contacto 
                    showModalBottomSheet( 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))
                      ),
                      isScrollControlled: true,
                      context: context, 
                      builder: (context){
                        return StatefulBuilder(
                          builder: (context,setState) => Form(
                            key: _newContactFormKey,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
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
                                      //validator: _validator.direccion,
                                      style: TextStyle(
                                        fontFamily: 'Poppins'
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Direccion (no requerido)',
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
                                      //validator: _validator.municipio,
                                      style: TextStyle(
                                        fontFamily: 'Poppins'
                                      ),
                                      decoration: InputDecoration(
                                        hintText: selectedCountry == 'CU'
                                        ?'Municipio (no requerido)'
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
                                      //validator: _validator.provincia,
                                      style: TextStyle(
                                        fontFamily: 'Poppins'
                                      ),
                                      decoration: InputDecoration(
                                        hintText: selectedCountry == 'CU' 
                                        ?'Provincia (no requerido)'
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
                                          onPressed: () async {
                                            if(_newContactFormKey.currentState.validate()){
                                              String result = await model.crearContacto(nombre,  telefono,  direccion,  municipio, provincia, context);
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
                          ),
                        );
                      }
                    );                       
                    },
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row( //boton de crear contacto
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.group_add,
                        color:Colors.white,
                        size: SizeConfig.resizeHeight(28),
                      ),
                      SizedBox(width: SizeConfig.resizeWidth(10)),
                      Text(
                        'Crear Contacto',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sen',
                            fontSize: SizeConfig.resizeHeight(20),
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
          padding: EdgeInsets.only(left: SizeConfig.resizeWidth(15)),
          child: Icon(Icons.search,size: SizeConfig.resizeHeight(20),),
        ),
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.resizeWidth(15)),
          child: SizedBox(
            width: 200,
            child: TextField(//buscar textfield
              keyboardType: TextInputType.text,
              onChanged: (text){
                
                text = text.toLowerCase();
                List<String> newNombres = new List<String>();
                List<String> newTelefonos = new List<String>();

                setState((){
                  
                  if(text != ''){

                    lists.contactos.values.where((value){
                      var result = value['nombre'].toString().toLowerCase().contains(text);
                      if(result){
                        newNombres.add(value['nombre']);
                        newTelefonos.add(value['telefono']);
                      }
                      return result;
                    }).toList();

                    lists.nombredisplay = newNombres;
                    lists.telefonos = newTelefonos;

                  } else {
                    lists.nombredisplay = lists.nombres;
                    lists.telefonos = lists.telefonosBAK;
                  }
                });
                    
              },
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ) ,
                hintText: 'Buscar Contacto...',
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
           dense: true,
           onTap: (){ //tap listview action
             setState(() {
               lists.contactos[tel]['isSelected'] = !lists.contactos[tel]['isSelected'];
             });
           },
           contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.resizeWidth(20)),
           title: Text( //nombre
             lists.nombredisplay[index], 
             style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: SizeConfig.resizeHeight(16),
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]),
           ),
          subtitle: Text( // telefono
            lists.telefonos[index],
            style: TextStyle(fontFamily: 'Roboto', fontSize: SizeConfig.resizeHeight(14), color: Colors.grey[900]),
          ),
          trailing: GestureDetector( // tap delete icon action 
            onTap: (){ // tap delete icon alert dialog
              if(lists.contactos[tel]['isSelected'] == true){
                showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: AlertDialog(
                      contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.resizeWidth(20), vertical: SizeConfig.resizeHeight(20)),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                      content: FittedBox(
                        child: Container(
                          width: SizeConfig.resizeWidth(300),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container( //boton de cerrar
                                margin: EdgeInsets.only(left:SizeConfig.resizeWidth(250)),
                                child: GestureDetector(
                                  child: Icon(Icons.close),
                                  onTap: (){Navigator.pop(context);},
                                )
                              ),
                              SizedBox(height: SizeConfig.resizeHeight(15),),   
                              Text( //palabreo del dialogo para borrar
                                'Seguro desea borrar a ${lists.nombredisplay[index].split(' ')[0].toUpperCase()} de su lista de contactos?',
                                style:TextStyle(fontFamily: 'Poppins'),
                              ),
                              SizedBox(height: SizeConfig.resizeHeight(4),),
                              Text(
                                'Mantenga el boton presionado.',
                                style:TextStyle(fontFamily: 'Poppins'),
                              ),
                              SizedBox(height: SizeConfig.resizeHeight(25),),
                              Center( // boton de borrar
                                child: Container(
                                  width: SizeConfig.resizeWidth(150),
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
                size: SizeConfig.resizeHeight(30),
              ),
            ),
          ),
        );
  }


}
