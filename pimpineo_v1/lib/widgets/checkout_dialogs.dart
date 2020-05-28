import 'package:flutter/material.dart';
import 'package:pimpineo_v1/view/login.dart';
import 'package:pimpineo_v1/view/us/comprar_credito.dart';
import 'package:pimpineo_v1/view/us/us_lobby.dart';
import 'package:pimpineo_v1/widgets/credit_card.dart';
import 'package:pimpineo_v1/services/helpers.dart';

class CustomAlertDialogs extends StatefulWidget {
  final int selection;
  final double totalAPagar;
  final String text;
  final List<Map<String,dynamic>> contactosARecargar;

  const CustomAlertDialogs({Key key, this.selection, this.totalAPagar, this.text,this.contactosARecargar}) : super(key: key);
  
  
  @override
  _CustomAlertDialogsState createState() => _CustomAlertDialogsState();
}

class _CustomAlertDialogsState extends State<CustomAlertDialogs> {

  int _selection;
  
  @override
  void initState() {
    super.initState();
    _selection = widget.selection;
  }

  @override
  Widget build(BuildContext context) {
    switch (_selection) {
      case 3: //Alerta de cuando no es suficinete credito
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 25, right: 15, left: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 280,
            height: 180,
            child: Column(
              children: <Widget>[
                Text(
                    'Credito no suficiente. \nSus variantes son: \n-Elegir las dos opciones de pago. \n-Comprar mas credito.',
                    style: TextStyle(fontFamily: 'Poppins'),),
                Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(   //cancelar
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.keyboard_backspace,color: Colors.white, size: 24,)//Text(
                        //   'Atras',
                        //   style: TextStyle(
                        //       fontSize: 16,
                        //       color: Colors.white,
                        //       fontFamily: 'Poppins'),
                        // )
                    ),
                    FlatButton(  //comprar
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.green,
                        onPressed: () {
                          Navigator.popAndPushNamed(
                              context, ComprarCreditoUI.route);
                        },
                        child: Icon(Icons.shopping_cart, color: Colors.white,)
                     ),
                    ],
                ),
              ),
              ],
            ),
          ),
        );
        break;
      case 1: //para mandar al UI de comprar con tarjeta de credito
        return CreditCardPurchaseUI(
          totalApagar: widget.totalAPagar,
          contactosARecargar: widget.contactosARecargar,
        );
        break;
      case 10: //Alert when the credit that is going to be applied is forced to leave a difference of a minAmount to charge the credit cards
       return AlertDialog(
          contentPadding: EdgeInsets.only(top:20,right: 15,left: 25),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            height: 230,
            child: Column(
              children: <Widget>[
                Text(
                    'El cobro minimo para tarjetas de credito es \$ ${Helpers.minAmount}. Su credito sera aplicado parcialmente.'
                    +'\nPagar con credito: \$${(widget.totalAPagar - Helpers.minAmount).toStringAsFixed(2)}\nPagar con tarjeta: \$ ${Helpers.minAmount}\nTotal: \$${widget.totalAPagar.toStringAsFixed(2)}.',
                    style: TextStyle(fontFamily: 'Poppins'),),
                SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(   //thumb up
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.green,
                        onPressed: () {
                          Navigator.pop(context);
                          Helpers.clienteAgreed = true;
                        },
                        child: Icon(Icons.thumb_up, color: Colors.white)
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
       break;
      case 11: // Comprar con credito solamente y te envia al lobby US
       return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Text(
              'Su credito ha sido aplicado a la compra, muchas gracias!!',
              style: TextStyle(fontFamily: 'Poppins'),),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90.0),
                    child: FlatButton(   //thumb up
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.green,
                        onPressed: () {
                          Helpers.lastroute = 'recargas';
                          Navigator.pushNamedAndRemoveUntil(context, LobbyUS.route, (Route<dynamic> route) => false);
                        },
                        child: Icon(Icons.thumb_up, color: Colors.white)
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
       break;
      case 12: // este es un comodin que va a mostrar lo que se le envie en el texto ademas del boton de thumbs up y te direcciona al log in
       return AlertDialog(
          contentPadding: EdgeInsets.only(bottom: 10,left: 20,right: 20, top: 20,),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(widget.text,style: TextStyle(fontFamily: 'Poppins'),),
                SizedBox(height: 40,),
                Center(
                  child: FlatButton(   //thumb up
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pushNamed(context, LogIn.route);
                      },
                      child: Icon(Icons.thumb_up, color: Colors.white)
                  ),
                ),
             ],
            ),
          ),
        );
       break;
      case 13: // otro dialogo de comodin y Navigator.pop
      return AlertDialog(
          contentPadding: EdgeInsets.only(top:20,right:20,left:20,bottom: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(widget.text,style: TextStyle(fontFamily: 'Poppins'),),
                SizedBox(height: 30,),
                Center(
                  child: FlatButton(   //thumb up
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.thumb_up, color: Colors.white)
                  ),
                ),
             ],
            ),
          ),
        );
      break;
      default:
    }
    return Container();
  }
}











// AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           content: Text(widget.text, style: TextStyle(fontFamily: 'Poppins'),),
//           actions: <Widget>[
//             Padding(//thumb up
//               padding: const EdgeInsets.only(right: 30.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   FlatButton(   //thumb up
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5.0)),
//                       color: Colors.green,
//                       onPressed: () {
//                         Navigator.pushNamed(context, LogIn.route);
//                       },
//                       child: Icon(Icons.thumb_up, color: Colors.white)
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );