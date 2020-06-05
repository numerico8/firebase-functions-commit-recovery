import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pimpineo_v1/model/user.dart';
import 'package:pimpineo_v1/services/helpers.dart';
import 'package:pimpineo_v1/services/router.dart';
import 'package:pimpineo_v1/view/us/comprar_credito.dart';
import 'package:pimpineo_v1/view/us/transacciones.dart';
import 'package:pimpineo_v1/viewmodels/main_carousel_home_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/provider_architecture.dart';


class MainCarouselHome extends StatefulWidget {
  @override
  _MainCarouselHomeState createState() => _MainCarouselHomeState();
}



class _MainCarouselHomeState extends State<MainCarouselHome> {

  @override
  void initState() {
    super.initState();
    initialPicture = Helpers.initialPicture;
  }

//initial picture from the database
  Map<String,dynamic> initialPicture = new Map<String,dynamic>();

//checks if there are new transactions
  bool newTransactions = false;
  List<dynamic> transacciones = [];

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    var _credito = user.credito; 
    transacciones = user.transacciones;
    double creditoAMostrar = double.parse(_credito.toString());

    return ViewModelProvider<MainCarouselHomeVM>.withConsumer(
          viewModel: MainCarouselHomeVM(),
          onModelReady: (model) async {},
          builder:(context, model, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row( //home row
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: <Widget>[
                    Icon(FontAwesomeIcons.home, color: Theme.of(context).primaryColor, size: 30.0,),
                    SizedBox(width:15.0,),
                    Text( //Inicio
                      'Inicio',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 28.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700),
                    ),
                  ]),
                ),
                SizedBox(height: 15.0,),
                Container(     //container with the credit values
                  color: Theme.of(context).scaffoldBackgroundColor,  //container color
                  height: initialPicture['hay_recarga'] ? 590 : 300,
                  width: 360.0,
                  child: Column(
                    children: <Widget>[
                      Padding( //container del credito
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container( //money sign had one read to the database
                              child: _credito == 0 ? Icon(Icons.money_off,size: 45.0,) : Icon(Icons.attach_money,size: 45.0,)
                            ),
                            SizedBox(width: 5.0,),
                            Text( //credito
                                  creditoAMostrar.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 40.0,
                                    fontFamily: 'Sen',
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                            SizedBox(width: 10.0,),
                        ],),
                      ),              
                      SizedBox(height:10.0),
                      Text(//credito disponible wording read the database
                              'Credito Disponible',
                              style: TextStyle(
                                fontFamily: 'Sen',
                                color: Colors.grey
                              ),
                            ),
                      SizedBox(height:40.0),
                      Padding( //boton comprar credito
                        padding: EdgeInsets.symmetric(horizontal: 80.0),
                        child: FlatButton( //credito button
                          onPressed: (){
                            Navigator.of(context).push(Router.createRoute(ComprarCreditoUI()));
                          },
                          autofocus: true,
                          color: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.add_shopping_cart,color: Colors.black87,),
                                SizedBox(width: 10.0),
                                Text(
                                  'Credito',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Sen',
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ],
                            ),
                          )
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding( //chequear nuevas transacciones
                       padding: EdgeInsets.symmetric(horizontal: 50.0,),
                       child: FlatButton( //transacciones
                         onPressed: () async {
                          if(transacciones != null){
                            Navigator.of(context).push(Router.createRoute(TransaccionesUI()));
                          } 
                         },
                         autofocus: true,
                         color: Colors.green,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30.0)
                         ),
                         child: Padding(
                           padding: EdgeInsets.all(8.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: <Widget>[
                               newTransactions == false
                               ?Container()
                               :Padding( //alerta que hay nuevas transascciones
                                 padding: const EdgeInsets.only(right:10.0),
                                 child: Container(
                                   child: CircleAvatar(
                                     child: Text('2',style: TextStyle(color: Colors.white, fontSize: 12),),
                                     radius: 8,
                                     backgroundColor: Colors.red,
                                   ),
                                 ),
                               ),
                               Icon(Icons.message,color: Colors.white,),
                               SizedBox(width: 10.0),
                               Text( //transacciones text
                                 'Transacciones',
                                 style: TextStyle(
                                   color: Colors.grey[100],
                                   fontFamily: 'Sen',
                                   fontSize: 22.0,
                                   fontWeight: FontWeight.w600
                                 ),
                               )
                             ],
                           ),
                         )
                       ),
                         ),
                      SizedBox(height: 10.0),
                      initialPicture['hay_recarga']
                      ?Container(
                        height: 340,
                        width: 400,                   
                        child: Image.network(
                          initialPicture['url'],
                          fit: BoxFit.fill                        
                        ),
                      )
                      :Container()
                    ],
                  )
                ),
              ],
            ),
    );
      }

}
