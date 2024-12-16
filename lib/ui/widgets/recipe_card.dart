import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import 'package:go_router/go_router.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          recipe.strMealThumb,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(recipe.strMeal),
        onTap: () {
          context.go('/recipe/${recipe.idMeal}');
        },
      ),
    );
  }
}