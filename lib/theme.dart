import 'package:flutter/material.dart';

ThemeData appThemeData(BuildContext context) {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: inputDecorationTheme(),
    elevatedButtonTheme: elevatedButtonTheme(),
  );
}

const OutlineInputBorder defaultOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.all(
    Radius.circular(12),
  ),
);

InputDecorationTheme inputDecorationTheme() {
  return const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF8F8F9),
    hintStyle: TextStyle(
      color: Color(0xFFB8B5C3),
    ),
    border: defaultOutlineInputBorder,
    enabledBorder: defaultOutlineInputBorder,
    focusedBorder: defaultOutlineInputBorder,
  );
}

ElevatedButtonThemeData elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // backgroundColor: const Color(0xFF33cc66),
      primary: const Color(0xFF33cc66), //Flutter version
      minimumSize: const Size(double.infinity, 56),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    ),
  );
}
