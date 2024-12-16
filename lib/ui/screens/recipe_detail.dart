import 'package:flutter/material.dart';
import 'package:tp/utils/api_client.dart';

import '../../models/recipe.dart';

class RecipeDetail extends StatelessWidget {
  final String idMeal;

  const RecipeDetail({required this.idMeal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de la recette"),
      ),
      body: FutureBuilder<Recipe>(
        future: ApiClient.getMealDetails(idMeal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Aucune donnée disponible"));
          } else {
            final meal = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(meal.strMealThumb),
                  const SizedBox(height: 16.0),
                  Text(
                    meal.strMeal,
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  Text("Catégorie : ${meal.strCategory}"),
                  Text("Cuisine : ${meal.strArea}"),
                  const SizedBox(height: 16.0),
                  Text(
                    "Ingrédients :",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  ...meal.ingredients.map((ingredient) => Text("- $ingredient")),
                  const SizedBox(height: 16.0),
                  Text(
                    "Instructions :",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(meal.strInstructions),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
