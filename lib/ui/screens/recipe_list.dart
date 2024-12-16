import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class RecipeList extends StatelessWidget {
  final String categoryId;

  const RecipeList({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recettes de $categoryId'),
      ),
      body: Center(
        child: Text('Liste des recettes pour la catégorie $categoryId'),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}