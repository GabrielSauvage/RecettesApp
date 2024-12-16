import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_nav_bar.dart';
import 'recipe_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paradis des recettes'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/recipes/indian');
          },
          child: const Text('Voir les recettes indiennes'),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }
}