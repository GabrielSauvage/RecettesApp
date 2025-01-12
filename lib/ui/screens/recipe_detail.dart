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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Detail'),
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
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
                _buildImageWithGradient(recipe.strMealThumb),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    recipe.strMeal,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Category: ${recipe.strCategory}\nArea: ${recipe.strArea}',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                _buildExpansionTile(
                  'Ingredients',
                  _buildIngredientsList(recipe),
                ),
                _buildExpansionTile(
                  'Instructions',
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      recipe.strInstructions,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: -1),
    );
  }

  Widget _buildImageWithGradient(String imageUrl) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: NetworkImageWithErrorHandling(url: imageUrl),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionTile(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [content],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsList(Recipe recipe) {
    return Column(
      children: recipe.ingredients.map((ingredient) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: NetworkImageWithErrorHandling(
                  url:
                      'https://www.themealdb.com/images/ingredients/${ingredient.split(' ')[0]}.png',
                ),
              ),
            ),
            title: Text(
              ingredient,
              style: const TextStyle(fontSize: 16),
            ),
          ),
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
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'lib/assets/no_image.png',
          fit: BoxFit.cover,
        );
      },
    );
  }
}
