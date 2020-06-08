
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
  );


  static final TextStyle titleStyle = TextStyle();

  static final TextStyle subtitleStyle = TextStyle();

  static final TextStyle buttonStyle = TextStyle();

  static final TextStyle headlineStyle = TextStyle();




}