import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/recipe_card.dart';
import '../../models/recipe.dart';

class RecipeList extends StatefulWidget {
  final String categoryId;

  const RecipeList({super.key, required this.categoryId});

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.categoryId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['meals'];
      setState(() {
        _recipes = data.map((item) => Recipe.fromJson(item)).toList();
        _filteredRecipes = _recipes;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  void _filterRecipes(String query) {
    setState(() {
      _searchQuery = query;
      _filteredRecipes = _recipes.where((recipe) => recipe.strMeal.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recettes de ${widget.categoryId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/', extra: {'reverse': true});
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterRecipes,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRecipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(recipe: _filteredRecipes[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
    );
  }
}