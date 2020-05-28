
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pimpineo_v1/model/contactos_model.dart';
import 'package:pimpineo_v1/view/base_view.dart';
import 'package:pimpineo_v1/view/us/comprar_credito.dart';
import 'package:pimpineo_v1/viewmodels/contacts_viewmodel.dart';
import 'package:pimpineo_v1/widgets/checkout_dialogs.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:provider/provider.dart';


class MainCarouselRecargar extends StatefulWidget {
  @override
  _MainCarouselRecargarState createState() => _MainCarouselRecargarState();
}

class _MainCarouselRecargarState extends State<MainCarouselRecargar> {

    @override
  void initState() {
    super.initState();
  } 


  List<String> _prices = new List<String>(); 
 

  //lista de los contactos que hay que recargar
  List<Map<String,dynamic>> listaRecargar = new List<Map<String,dynamic>>();
  
  
  @override
  Widget build(BuildContext context) {
    return BaseView<ContactsViewModel>(
      onModelReady: (model) async {
        await model.getListas(context);
        _prices = List<String>.from(model.pricesList);//convierte la lista dinamica que retorna la base de datos en una lista de String  
      },
      builder: (context, model, child) {
        return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Icon(FontAwesomeIcons.plug, color: Theme.of(context).primaryColor, size: 30.0,),
            SizedBox(width:15.0,),
            Text( //Recargar
              'Recargar',
              style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 28.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700),
            ),
            ]),
          SizedBox(height: 20.0,),
          Container(  //Listview container
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
            ]
            ),
            height: 400.0,
            width: 360.0,
            child: Consumer<ListaContactosModel>(
              builder: (context, lists, child) {
                return ListView.separated(//Lista 
                separatorBuilder: (context, index){ //separator container
                  return Center(
                    child: Container(
                      color: Colors.green,
                      height: 2.0,
                      width: 330.0,
                    ),
                  );             
                },
                itemCount: lists.nombredisplay.length + 1,
                itemBuilder: (BuildContext context, index) {
                      return index == 0 ? _searchBar(lists) :  _listItem(index-1, lists);
                }
              );
              }, 
            )
            ),
          Padding(   //Raised button to Enviar Recarga
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: RaisedButton( 
              child: Center(
                child: Text( //Enviar Recarga texto
                  'Enviar Recarga', 
                  style: TextStyle(color: Colors.white, fontSize:20, fontFamily: 'Sen',fontWeight:FontWeight.w600),
                ),
              ),
              splashColor: Colors.green[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
              ),
              color: Colors.green,
              onPressed: (){   //algorithm
                
                //clear el arreglo de los que tienen cargos
                listaRecargar.clear();

                // crear  la lista con los datos de los contactos a recargar
                Provider.of<ListaContactosModel>(context, listen: false).contactos.forEach((key,value){
                  if(value['isSelected'] == true){
                    listaRecargar.add(value);
                  }
                });

                if(listaRecargar.isNotEmpty){
                //dialogo donde se hace todo le proceso de la compra de credito               
                showDialog(
                  context: context,
                  builder: (context) {

                  // calculo del pago de cuanto es que tienen que pagar contando taxes and fees
                    double totalAPagar = model.calcularTotalAPagar(listaRecargar);
                  //aqui tenemos las distintas opciones de pago
                    bool _selectedCredito = false;
                    bool _selectedTarjeta = false;
                  // cambia el estado del dialogo
                    bool busy = false;

                  // dialogo de alerta que hace la inteligencia antes de llegar a la vista de la tarjeta de credito
                    return StatefulBuilder(
                      builder: (context, setState){
                        return AlertDialog(                              
                          contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, top: busy == false ? 25.0 : 0, bottom: busy == false ? 0 : 45),
                          elevation: 6.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          content: busy == false 
                          ?Container(
                            height: 350,
                            width: 330,
                            child: Column(
                              children: <Widget>[
                              Container( // contenido general del dialogo
                                padding: EdgeInsets.all(10.0),
                                height: 280.0,
                                width: 330.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(1, 2),
                                      color: Colors.grey[500],
                                      blurRadius: 4.0
                                    ),
                                    BoxShadow(
                                      offset: Offset(2, 4),
                                      color: Colors.grey[500],
                                      blurRadius: 4.0
                                    ),
                                  ],
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey[400]
                                  )
                                ),
                                child: Column( // texto y metodos de pago 
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container( // total a pagar
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[800],
                                        borderRadius: BorderRadius.circular(5),
                                        ),
                                      child: Center( //TOTAL A PAGAR
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'TOTAL:',
                                            style: TextStyle(
                                              color:  Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              fontFamily: 'Poppins'),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '  \$' + totalAPagar.toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 32
                                                )
                                              )
                                            ]
                                          )
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Center( //credito disponible numero
                                      child: Text( 
                                        '\$' + double.parse(model.user.credito.toString()).toStringAsFixed(2),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28.0,
                                          fontFamily: 'Sen'
                                        ),                            
                                      ),
                                    ),
                                    SizedBox(height:5.0),
                                    Center( //credito disponible texto
                                      child: Text(//credito disponible had another read to the database
                                              'Credito Disponible',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Sen',
                                                color: Colors.grey
                                              ),
                                      ),
                                    ),
                                    SizedBox(height:10.0),
                                    Container( // metodo de pago
                                      child: (model.user.credito == 0 || model.user.credito > totalAPagar)
                                      ?Column( //if client doesnt have credit enought
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container( //credito tile
                                            decoration: BoxDecoration(
                                              color: _selectedCredito == false
                                              ?Colors.white
                                              :Colors.green,
                                              borderRadius: BorderRadius.circular(25)
                                            ),
                                            child: ListTile( //Tile Comprar Credito
                                              //dense: true,
                                              onTap: (){
                                                  setState(() {
                                                    _selectedTarjeta = false;
                                                    _selectedCredito = !_selectedCredito;
                                                  });
                                              },
                                              leading: _selectedCredito == false 
                                              ?Icon(Icons.radio_button_unchecked, color: Colors.green,)
                                              :Icon(Icons.radio_button_checked,color: Colors.white,),
                                              title:Text( 
                                                model.user.credito > totalAPagar 
                                                ?'CREDITO'
                                                :'COMPRAR CREDITO',
                                                style: TextStyle(
                                                  color: _selectedCredito == false
                                                  ?Colors.green
                                                  :Colors.white,
                                                  fontSize: 18.0,
                                                  fontFamily: 'Poppins'),
                                            ))
                                          ),
                                          SizedBox(height: 10,),
                                          Container( //tarjeta tile
                                            decoration: BoxDecoration(
                                              color: _selectedTarjeta == false
                                              ?Colors.white
                                              :Colors.green,
                                              borderRadius: BorderRadius.circular(25)
                                            ),
                                            child: ListTile( // Tile Tarjeta
                                              dense: true,
                                              onTap: (){
                                                  setState(() {
                                                    _selectedCredito = false;
                                                    _selectedTarjeta = !_selectedTarjeta;
                                                  });
                                              },
                                              leading: _selectedTarjeta == false 
                                              ?Icon(Icons.radio_button_unchecked,color: Colors.green,)
                                              :Icon(Icons.radio_button_checked,color: Colors.white,),
                                              title: Text(
                                                'TARJETA',
                                                style: TextStyle(
                                                  color: _selectedTarjeta == false
                                                  ?Colors.green
                                                  :Colors.white,
                                                  fontSize: 18.0,
                                                  fontFamily: 'Poppins'),
                                            )),
                                          ),
                                        ],
                                      )
                                      :Column( //if client has credit
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: _selectedCredito == false
                                              ?Colors.white
                                              :Colors.green,
                                              borderRadius: BorderRadius.circular(25)
                                            ),
                                            child: ListTile( //Tile usar Credito
                                              dense: true,
                                              onTap: (){
                                                  setState(() {
                                                   if((model.user.credito > totalAPagar) && (_selectedTarjeta == true)){
                                                      _selectedCredito = false;
                                                    }
                                                    else{
                                                      _selectedCredito = !_selectedCredito;
                                                    }
                                                  });
                                              },
                                              leading: _selectedCredito == false 
                                              ?Icon(Icons.check_box_outline_blank,color: Colors.green,)
                                              :Icon(Icons.check_box,color: Colors.white,),
                                              title:Text('USAR CREDITO',style: TextStyle(
                                                color: _selectedCredito == false
                                                ?Colors.green
                                                :Colors.white,
                                                fontSize: 18.0, 
                                                fontFamily: 'Poppins'),)
                                              ),
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: _selectedTarjeta == false
                                              ?Colors.white
                                              :Colors.green,
                                              borderRadius: BorderRadius.circular(25)
                                            ),
                                            child: ListTile( // Tile Tarjeta
                                              dense: true,
                                              onTap: (){
                                                  setState(() {
                                                    if((model.user.credito > totalAPagar) && (_selectedCredito == true)){
                                                      _selectedTarjeta = false;
                                                    }
                                                    else{
                                                      _selectedTarjeta = !_selectedTarjeta;
                                                    }
                                                    
                                                  });
                                              },
                                              leading: _selectedTarjeta == false 
                                              ?Icon(Icons.check_box_outline_blank,color: Colors.green,)
                                              :Icon(Icons.check_box ,color: Colors.white,),
                                              title: Text('TARJETA',style:
                                               TextStyle(
                                                 color: _selectedTarjeta == false
                                                ?Colors.green
                                                :Colors.white,
                                                 fontSize: 18.0, 
                                                 fontFamily: 'Poppins'),
                                              )),
                                          ),
                                        ],
                                      )
                                      ),
                                   ],
                                )
                              ),
                              SizedBox(height:10),
                              Row(  //linea de botones confimar y cancelar
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton( //cancelar
                                    elevation: 6,
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    color: Colors.red[100],
                                    onPressed: (){
                                      listaRecargar.clear();
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.close, size: 24,color:Colors.red[900])//Text('Cancelar',style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: 'Poppins'),)
                                  ),
                                  RaisedButton( //confirmar
                                    child: Icon(Icons.forward, size: 30,color: Colors.green[900],), //Text('Confirmar',style: TextStyle(fontSize: 18,color: Colors.white, fontFamily: 'Poppins'),)
                                    elevation: 6,
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    color: Colors.green[100],
                                    onPressed: () async {      //confirmar action
                                      //set to busy the UI to inform the clien thath we are working on the backend
                                      setState(() {
                                        busy = true;
                                      });
                                      
                                      //return the option to checkout that the customer selected
                                      var result = await model.confirmarCompra(_selectedCredito, _selectedTarjeta, totalAPagar, context, listaRecargar);

                                      /*
                                      1- solamente tarjeta de credito
                                      3- no tiene suficiente credito tiene que soleccionar ambos pagos
                                      4- elige comprar mas credito
                                      otras- si e numero es doble esta mandando el nuevo credito luego de actualizado en el modelo
                                      */
                                      print(result.toString() + ' Dialogo de las Recargas');

                                      if((result == 1)||(result == 3)){ //te lleva a la ventana de pago con tarjeta de credito
                                        setState(() {
                                          busy = false;
                                        });
                                        showDialog(
                                        context: context,
                                        builder: (context){
                                          return CustomAlertDialogs(
                                            selection: result,
                                            totalAPagar: totalAPagar,
                                            contactosARecargar: listaRecargar, //envio la lista de los contactos a recargar
                                          );
                                        });                                        
                                      } 
                                      else if (result == 4){//te envia a comprar credito
                                        setState((){
                                          busy = false;
                                        });
                                        Navigator.pushNamed(context, ComprarCreditoUI.route);
                                      }
                                      else if(result is double){ //pagar recarga con credito solamente
                                        setState((){
                                          busy = false;
                                        });
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context){
                                            return CustomAlertDialogs(
                                              selection: 11,
                                          );
                                        });
                                      }                                        
                                    },
                                  ),
                                ],
                              )
                            ],
                            ),
                          )
                          :Container(
                            height: 330,
                            width: 300,
                            child: Helpers.customProgressIndicator())
                        );
                      },
                    );
                  }   
                );

                }
              },
              
            ),
          )
        ],
      );
     }
    );
  }

  
  
  _searchBar(ListaContactosModel lists){
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
            child: TextField(
              keyboardType: TextInputType.text,
              onChanged: (text){
                text = text.toLowerCase();
                setState(() {
                  lists.nombredisplay  =  lists.nombres.where((nombre){
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


  
  _listItem( index , ListaContactosModel lists) {

    //this is in order to get the correct value to show in the list
    String tel;
    lists.contactos.forEach((key,value){
      if(value['nombre'] == lists.nombredisplay[index]){
        tel = value['telefono'];
      }
    });
    return ListTile(      //partes de las listas
      onTap: (){
          setState(() {
            lists.contactos[tel]['isSelected'] = !lists.contactos[tel]['isSelected'];
          });
        },
      leading: IconButton(
        icon: lists.contactos[tel]['isSelected'] == false ? Icon(Icons.check_box_outline_blank, color: Colors.grey[200],) : Icon(Icons.check,color: Colors.green,size: 30,), 
        onPressed: (){
          setState(() {
            lists.contactos[tel]['isSelected'] = !lists.contactos[tel]['isSelected'];
          });
        }
        ),
      trailing: lists.contactos[tel]['isSelected'] == false 
      ?Icon( FontAwesomeIcons.plug, color:Colors.green[100], size: 25.0,)
      :escogerPrecio(context,lists,tel) ,
      contentPadding: EdgeInsets.only(left: 5.0, right: 20.0),
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
    );
  }

    
  // esta es la creacion del trailing field en el listile
  Widget escogerPrecio(BuildContext context, ListaContactosModel lists, String tel){
    //Lista con los precios de recargas para cada uno de los contactos a recargar
    
    return DropdownButton<String>(
      underline: Container(
        height: 2.0,
        decoration: BoxDecoration(
          color: Colors.transparent
        )
      ),
      isDense: false,
      iconSize: 22,
      value: lists.contactos[tel]['selectedAmount'],
      items: _prices.map((value) => DropdownMenuItem(
          child: Text(value,style: TextStyle(fontSize: 18, fontFamily: 'Sen'),),
          value: value,
      )).toList(),
      onChanged: (selected){
        setState(() {
          lists.contactos[tel]['selectedAmount'] = selected;
        });
      });
  }
  

}
