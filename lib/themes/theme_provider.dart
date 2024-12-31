import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking/themes/dark_mode.dart';
import 'package:parking/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData value) {
    _themeData = value;
    notifyListeners();
  }

  bool get isDarkMode => _themeData ==darkMode;

  void toggleTheme(){
     if(_themeData ==lightMode){
       themeData =darkMode;
     }else{
       themeData = lightMode;
     }
  }
}