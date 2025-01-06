import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/recipe_cubit.dart';
import '../../repositories/recipe_repository.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/recipe_card.dart';
import '../../models/recipe.dart';

class RecipeList extends StatelessWidget {
  final String categoryId;

  const RecipeList({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeCubit(
        recipeRepository: RecipeRepository(),
      )..fetchRecipesByCategory(categoryId),
      child: RecipeListView(categoryId: categoryId),
    );
  }
}

class RecipeListView extends StatefulWidget {
  final String categoryId;

  const RecipeListView({super.key, required this.categoryId});

  @override
  _RecipeListViewState createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  String _searchQuery = '';

  void _filterRecipes(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryId} recipes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: ColorScheme.fromSeed(seedColor: const Color(0xFFDDBFA9)).primary,
          onPressed: () {
            context.go('/', extra: {'reverse': true});
          },
        ),
      ),
      body: Column(
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
            child: BlocBuilder<RecipeCubit, List<Recipe>>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, recipes) {
                if (recipes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredRecipes = recipes.where((recipe) => recipe.strMeal.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                return ListView.builder(
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(recipe: filteredRecipes[index], categoryId: widget.categoryId);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: -1),
    );
  }
}