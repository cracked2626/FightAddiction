import 'package:flutter/material.dart';

ThemeData buildThemeData(BuildContext context) {
  return ThemeData(
    // textTheme: GoogleFonts.poppinsTextTheme(
    //   Theme.of(context).textTheme,
    // ),
    fontFamily: 'Satoshi',

    scaffoldBackgroundColor: scaffold,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        primary: Colors.deepPurple,
        onPrimary: lightPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),

    buttonTheme: ButtonThemeData(
      buttonColor: lightPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.blueGrey[50],
      labelStyle: TextStyle(
        fontSize: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey[50]!),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey[50]!),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}

const Color scaffold = Color(0xFFf5f5f5);

const Color facebookBlue = Color(0xFF1777F2);
const Color lightPurple = Color(0xffcfd9f1);
const Color lightBlue = Color(0xffccf8f8);
const Color lightGreen = Color(0xffe5f9f1);
const Color blue = Color(0xff08443C);
Color appGreyblue = Color(0xff08443C).withOpacity(0.5);
const Color white = Colors.white;
const Color lightWhite = Color(0xfff7f7f7);
const Color black = Colors.black;
const Color darkBlue = Color(0xff424f7b);
const Color lightBluish = Color(0xffaeb2cc);

const LinearGradient createRoomGradient = LinearGradient(
  colors: [Color(0xFF496AE1), Color(0xFFCE48B1)],
);

const Color online = Color(0xFF4BCB1F);

const LinearGradient storyGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Colors.transparent, Colors.black26],
);
List<BoxShadow> shadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.23),
    spreadRadius: 1.5,
    blurRadius: 5,
    offset: const Offset(0, 2), // changes position of shadow
  ),
];
BoxDecoration kFieldDecoration = BoxDecoration(
  color: appGreyblue,
  borderRadius: BorderRadius.circular(
    10.0,
  ),
);
