import 'package:flutter/material.dart';
import 'package:tp/ui/screens/favorites.dart';
import 'package:tp/ui/screens/home.dart';
import 'package:tp/ui/screens/recipe_detail.dart';
import 'package:tp/ui/screens/recipe_list.dart';

import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe paradise',
      theme: appTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final Uri uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'recipes') {
          final id = uri.pathSegments[1];
          final isCategory = settings.arguments as bool;
          return MaterialPageRoute(
            builder: (context) => RecipeList(id: id, isCategory: isCategory),
          );
        } else if (uri.pathSegments.length == 3 &&
            uri.pathSegments.first == 'recipe') {
          final idMeal = uri.pathSegments[1];
          final categoryId = uri.pathSegments[2];
          return MaterialPageRoute(
            builder: (context) =>
                RecipeDetail(idMeal: idMeal, categoryId: categoryId),
          );
        } else if (uri.pathSegments.length == 1 &&
            uri.pathSegments.first == 'favorites') {
          return MaterialPageRoute(
            builder: (context) => Favorites(),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Home(),
          );
        }
      },
    );
  }
}
