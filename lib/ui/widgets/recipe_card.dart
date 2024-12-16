import 'package:flutter/material.dart';
import '../../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          recipe.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(recipe.title),
        onTap: () {
          // Action to perform when a recipe is tapped
        },
      ),
    );
  }
}