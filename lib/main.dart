import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = createRouter();

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Paradis des recettes',
      theme: appTheme,
    );
  }
}