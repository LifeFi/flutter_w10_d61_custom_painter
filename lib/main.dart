import 'package:flutter/material.dart';
import 'package:flutter_w10_d61_custom_painter/home_screen_custom_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your app  lication.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0XFFFE6E73),
      ),
      home: const HomeScreenCustomPainter(),
    );
  }
}
