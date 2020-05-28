import 'package:flutter/material.dart';



class AnimationService {

   // animation from left to right  
  Route createRoute(var widget) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 100),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        var begin = Offset(-1.0, 0.0); //left to right on the x axis y axis=0
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(
          begin: begin, end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
    );
  }

}