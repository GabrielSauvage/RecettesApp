import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/recipe.dart';
import '../../utils/api_client.dart';

class RecipeDetail extends StatefulWidget {
  final String idMeal;

  const RecipeDetail({super.key, required this.idMeal});

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  late Future<Recipe> futureRecipe;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    futureRecipe = ApiClient.getMealDetails(widget.idMeal);
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.idMeal) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool(widget.idMeal, isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Detail'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: FutureBuilder<Recipe>(
        future: futureRecipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Recipe not found'));
          } else {
            final recipe = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NetworkImageWithErrorHandling(url: recipe.strMealThumb),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      recipe.strMeal,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Category: ${recipe.strCategory}\nArea: ${recipe.strArea}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _buildExpansionTile('Ingredients', _buildIngredientsList(recipe)),
                  _buildExpansionTile('Instructions', Text(recipe.strInstructions)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildExpansionTile(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(title, textAlign: TextAlign.center),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide.none,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide.none,
        ),
        children: [content],
      ),
    );
  }

  Widget _buildIngredientsList(Recipe recipe) {
    return Column(
      children: recipe.ingredients.map((ingredient) {
        return ListTile(
          leading: NetworkImageWithErrorHandling(
            url: 'https://www.themealdb.com/images/ingredients/${ingredient.split(' ')[0]}.png',
          ),
          title: Text(ingredient),
        );
      }).toList(),
    );
  }
}

class NetworkImageWithErrorHandling extends StatelessWidget {
  final String url;

  const NetworkImageWithErrorHandling({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('lib/assets/no_image.png',
          width: 60,
          height: 60,
        );
      },
    );
  }
}