import 'package:flutter/cupertino.dart';


class SizeConfig{

  static double heightMultiplier;
  static double textMultiplier;
  static double imageSizeMultiplier;

  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;

  static double screenWidth;
  static double screenHeight;

  void init(BoxConstraints constraints){
    screenHeight = constraints.maxHeight;
    screenWidth = constraints.maxWidth;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    heightMultiplier = blockSizeVertical;
    textMultiplier = blockSizeVertical;
    imageSizeMultiplier = blockSizeHorizontal;
 
    print(blockSizeHorizontal);
    print(blockSizeVertical);
  }

}