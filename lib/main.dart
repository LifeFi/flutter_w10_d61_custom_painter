import 'package:flutter/material.dart';
import 'package:flutter_w10_d61_custom_painter/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: const Color(0xFFe64d3d),
          ),
          textTheme: const TextTheme(
              displayLarge: TextStyle(
            color: Colors.white,
          ))),
      home: const HomeScreen(),
    );
  }
}
