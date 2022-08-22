
import 'package:flutter/material.dart';
import 'package:gemini_social_app/shared/colors.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'Myfont',
    floatingActionButtonTheme:FloatingActionButtonThemeData(
        backgroundColor: buttonsColor
    ),
    scaffoldBackgroundColor: Colors.black87,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: buttonsColor),
      titleTextStyle: TextStyle(
          fontFamily: 'Myfont',
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold
      ),
      backgroundColor: Colors.black87,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: buttonsColor,
        elevation: 20,
        backgroundColor: Colors.black
    ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: 17,
        height: 1.3,
        fontWeight: FontWeight.w800,
        color: Colors.white
    ),

  ),
) ;
ThemeData lightTheme = ThemeData(
    fontFamily: 'Myfont',
    floatingActionButtonTheme:FloatingActionButtonThemeData(
        backgroundColor: buttonsColor
    ),
    scaffoldBackgroundColor: backGround,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: buttonsColor),
      titleTextStyle: TextStyle(
        fontFamily: 'Myfont',
          color: textColor,
          fontSize: 25,
          fontWeight: FontWeight.bold
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: buttonsColor,
        elevation: 20
    ),
    textTheme: TextTheme(
        bodyText1: TextStyle(
            fontSize: 17,
            height: 1.3,
            fontWeight: FontWeight.w800,
            color: Colors.black87
        ),

    ),
  inputDecorationTheme: InputDecorationTheme(
    prefixIconColor: buttonsColor,
    suffixIconColor: buttonsColor,
    focusColor: buttonsColor,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: buttonsColor)),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
  )

) ;