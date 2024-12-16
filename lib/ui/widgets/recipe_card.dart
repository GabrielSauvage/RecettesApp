import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/recipe.dart';
import 'package:go_router/go_router.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final String categoryId;

  const RecipeCard({super.key, required this.recipe, required this.categoryId});

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.recipe.idMeal) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool(widget.recipe.idMeal, isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          widget.recipe.strMealThumb,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(widget.recipe.strMeal),
        trailing: IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: _toggleFavorite,
        ),
        onTap: () {
          context.go('/recipe/${widget.recipe.idMeal}/${widget.categoryId}');
        },
      ),
    );
  }
}