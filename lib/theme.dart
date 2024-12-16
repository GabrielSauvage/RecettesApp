import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFDDBFA9)),
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFDDBFA9),
    titleTextStyle: TextStyle(
      color: ColorScheme.fromSeed(seedColor: const Color(0xFFDDBFA9)).primary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
);