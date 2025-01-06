import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/recipe_cubit.dart';
import '../../models/recipe.dart';
import '../../repositories/recipe_repository.dart';
import '../widgets/bottom_nav_bar.dart';

class RecipeDetail extends StatelessWidget {
  final String idMeal;
  final String categoryId;
  final Map<String, dynamic>? extra;

  const RecipeDetail(
      {super.key, required this.idMeal, required this.categoryId, this.extra});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeCubit(
        recipeRepository: RecipeRepository(),
      )..getMealDetails(idMeal),
      child: RecipeDetailView(
          idMeal: idMeal, categoryId: categoryId, extra: extra),
    );
  }
}

class RecipeDetailView extends StatefulWidget {
  final String idMeal;
  final String categoryId;
  final Map<String, dynamic>? extra;

  const RecipeDetailView(
      {super.key, required this.idMeal, required this.categoryId, this.extra});

  @override
  _RecipeDetailViewState createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
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
    final fromFavorites = widget.extra?['fromFavorites'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color:
              ColorScheme.fromSeed(seedColor: const Color(0xFFDDBFA9)).primary,
          onPressed: () {
            if (fromFavorites) {
              Navigator.pushNamed(context, '/favorites');
            } else {
              Navigator.pushNamed(context, '/recipes/${widget.categoryId}');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: BlocBuilder<RecipeCubit, List<Recipe>?>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, recipes) {
          if (recipes == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (recipes.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }

          final recipe = recipes.first;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NetworkImageWithErrorHandling(url: recipe.strMealThumb),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    recipe.strMeal,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
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
                _buildExpansionTile(
                    'Ingredients', _buildIngredientsList(recipe)),
                _buildExpansionTile(
                    'Instructions', Text(recipe.strInstructions)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: -1),
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
            url:
                'https://www.themealdb.com/images/ingredients/${ingredient.split(' ')[0]}.png',
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
        return Image.asset(
          'lib/assets/no_image.png',
          width: 60,
          height: 60,
        );
      },
    );
  }
}
