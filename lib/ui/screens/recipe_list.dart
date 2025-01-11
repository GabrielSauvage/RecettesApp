import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/recipe_cubit.dart';
import '../../models/recipe.dart';
import '../../repositories/recipe_repository.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/recipe_card.dart';

class RecipeList extends StatelessWidget {
  final String id;
  final bool isCategory;

  const RecipeList({super.key, required this.id, required this.isCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeCubit(
        recipeRepository: RecipeRepository(),
      )..fetchRecipes(isCategory ? 'category' : 'country', id),
      child: RecipeListView(id: id, isCategory: isCategory),
    );
  }
}

class RecipeListView extends StatefulWidget {
  final String id;
  final bool isCategory;

  const RecipeListView({super.key, required this.id, required this.isCategory});

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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.id} recipes'),
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterRecipes,
            ),
          ),
          Expanded(
            child: BlocBuilder<RecipeCubit, List<Recipe>?>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, recipes) {
                if (recipes == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (recipes.isEmpty) {
                  return const Center(child: Text('No recipes found.'));
                }

                final filteredRecipes = recipes
                    .where((recipe) => recipe.strMeal
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();

                return ListView.builder(
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(
                        recipe: filteredRecipes[index], categoryId: widget.id);
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
