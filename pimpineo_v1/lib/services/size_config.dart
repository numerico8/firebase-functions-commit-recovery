import 'package:flutter/cupertino.dart';


class SizeConfig{

  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;

  static double screenWidth;
  static double screenHeight;

  void init(BoxConstraints constraints){
    screenHeight = constraints.maxHeight;
    screenWidth = constraints.maxWidth;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
 
  }


  static double resizeHeight(double actualHeight){
    return actualHeight/6.83 * blockSizeVertical;
  }

  static double resizeWidth(double actualWidth){
    return actualWidth/4.11 * blockSizeHorizontal;
  }


}