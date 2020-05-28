import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pimpineo_v1/view/launch_page.dart';
import 'package:pimpineo_v1/view/login.dart';
import 'package:pimpineo_v1/view/us/comprar_credito.dart';
import 'package:pimpineo_v1/view/no_connection.dart';
import 'package:pimpineo_v1/view/us/profile_page.dart';
import 'package:pimpineo_v1/view/us/registrarse_us.dart';
import 'package:pimpineo_v1/view/us/transacciones.dart';
import 'package:pimpineo_v1/view/us/us_lobby.dart';
import 'package:pimpineo_v1/widgets/credit_card.dart';

class Router {

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case ComprarCreditoUI.route:
        return MaterialPageRoute(builder: (_) => ComprarCreditoUI());
      case LogIn.route:
        return MaterialPageRoute(builder: (_) => LogIn());
      case LobbyUS.route:
        return MaterialPageRoute(builder: (_) => LobbyUS());
      case RegistrarseUS.route:
        return MaterialPageRoute(builder: (_) => RegistrarseUS());
      case ProfilePage.route:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case CreditCardPurchaseUI.route:
        return MaterialPageRoute(builder: (_) => CreditCardPurchaseUI());
      case LaunchPage.route:
        return MaterialPageRoute(builder: (_) => LaunchPage());
      case TransaccionesUI.route:
        return MaterialPageRoute(builder: (_) => TransaccionesUI());
      case NoConnection.route:
        return MaterialPageRoute(builder: (_) => NoConnection());
    }
    return MaterialPageRoute(builder: (_) => Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('No routes defined for ${settings.name}.',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Sen',
            fontSize: 18
          ),
        ),
      )
    ));
  }
 

//to create the route transition smoother
  static Route<dynamic> createRoute(Widget destination) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 100),
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0 , 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
   );
  }


}