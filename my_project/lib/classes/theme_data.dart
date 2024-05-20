import 'package:flutter/material.dart';

class MyThemeData{
  bool darkMode;


  Color? getBeckGroundColor(bool main){
    if(darkMode){
      return main?Colors.black:Colors.grey[900];
    }
    return main?Colors.white:Colors.grey[300];
  }

  Color getTextColor(){
    return darkMode?Colors.white:Colors.black;
  }

  MyThemeData({
    required this.darkMode
  });
}
