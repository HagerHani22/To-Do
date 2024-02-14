import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData darkTheme=ThemeData(
    scaffoldBackgroundColor: HexColor('#121212'),
    appBarTheme: AppBarTheme(
      systemOverlayStyle:SystemUiOverlayStyle(
        statusBarColor: HexColor('#121212'),
        statusBarIconBrightness: Brightness.light,
      ) ,
      backgroundColor: HexColor('#121212'),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 26),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: HexColor('#ba4c31'),
      backgroundColor: HexColor('#121212'),
      unselectedItemColor: Colors.grey,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: HexColor('#ba4c31'),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.white),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.grey,
    )
);
ThemeData lightTheme=ThemeData(
  // primarySwatch:HexColor('#ba4c31') ,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    systemOverlayStyle:SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ) ,
    backgroundColor: HexColor('#ba4c31'),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 26),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: HexColor('#ba4c31'),
    backgroundColor: Colors.white,

  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: HexColor('#ba4c31'),
  ),
);