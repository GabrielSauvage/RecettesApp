import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/recipe.dart';
import '../../utils/api_client.dart';
import '../widgets/recipe_card.dart';
import '../widgets/bottom_nav_bar.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Recipe> _favoriteRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final List<Recipe> favoriteRecipes = [];

    for (String key in keys) {
      if (prefs.getBool(key) == true) {
        // Assuming you have a method to get recipe details by ID
        final recipe = await ApiClient.getMealDetails(key);
        favoriteRecipes.add(recipe);
      }
    }

    setState(() {
      _favoriteRecipes = favoriteRecipes;
      _filteredRecipes = _favoriteRecipes;
      _isLoading = false;
    });
  }

  void _filterRecipes(String query) {
    setState(() {
      _searchQuery = query;
      _filteredRecipes = _favoriteRecipes.where((recipe) => recipe.strMeal.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterRecipes,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRecipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(recipe: _filteredRecipes[index], categoryId: _filteredRecipes[index].strCategory);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}