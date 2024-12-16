import 'package:flutter/material.dart';
import './ui/screens/home.dart';
import './theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paradis des recettes',
      theme: appTheme,
      home: Home(),
    );
  }
}