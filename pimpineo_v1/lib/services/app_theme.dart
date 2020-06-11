
import 'package:flutter/material.dart';

class AppTheme{


  //this is to provide the mail them of the whole application
  static final ThemeData theme = ThemeData(
    primaryColor: Colors.blue[800],
    accentColor: Colors.lightBlue[100],
    scaffoldBackgroundColor: Colors.white,
    textTheme: textTheme,
  );


  static final TextTheme textTheme = TextTheme(
    title: titleStyle,
    subtitle: subtitleStyle,
    button: buttonStyle,
    headline: headlineStyle,
    display1: display1Style,
  );


  

  static final TextStyle titleStyle = TextStyle();

  static final TextStyle subtitleStyle = TextStyle();

  static final TextStyle buttonStyle = TextStyle();



  static final TextStyle headlineStyle = TextStyle(
    color: Colors.blue[800],
    fontFamily: 'Pacifico',
    fontSize: 40.0,
  );

  static final TextStyle display1Style = TextStyle(
    fontFamily: 'Poppins', 
    fontSize: 18.0
  );

//thiis the size of all letters in the form fields
  static final TextStyle formLetterSize12 = TextStyle(
    fontSize: 12.0
  );

  static final TextStyle formLetterSize14 = TextStyle(
    fontSize: 14.0
  );

  static final TextStyle formLetterSize16 = TextStyle(
    fontSize: 16.0
  );

  static final TextStyle formLetterSize20 = TextStyle(
    fontSize: 20.0
  );


 

}