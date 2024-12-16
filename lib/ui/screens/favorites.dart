import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recettes favorites'),
      ),
      body: const Center(
        child: Text('Liste des recettes favorites'),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}