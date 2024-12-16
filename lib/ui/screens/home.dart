import 'package:flutter/material.dart';
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecipeList(categoryId: 'indian'),
              ),
            );
          },
          child: const Text('Voir les recettes indiennes'),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}