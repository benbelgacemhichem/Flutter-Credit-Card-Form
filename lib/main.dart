import 'package:add_card/constains.dart';
import 'package:add_card/screens/new_card/add_new_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF8F8F9),
          hintStyle: TextStyle(
            color: Color(0xFFB8B5C3),
          ),
          border: defaultOutlineInputBorder,
          enabledBorder: defaultOutlineInputBorder,
          focusedBorder: defaultOutlineInputBorder,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
            minimumSize: const Size(double.infinity, 56),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            primary: Colors.black,
            minimumSize: const Size(double.infinity, 56),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
      home: const AddNewCardScreen(),
    );
  }
}

const OutlineInputBorder defaultOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.all(Radius.circular(12)),
);
