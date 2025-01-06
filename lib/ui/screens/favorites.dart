import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/recipe_cubit.dart';
import '../../repositories/recipe_repository.dart';
import '../widgets/recipe_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../models/recipe.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeCubit(
        recipeRepository: RecipeRepository(),
      )..fetchFavoriteRecipes(),
      child: const FavoritesView(),
    );
  }
}

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  String _searchQuery = '';
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Recipe> _currentFavorites = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipes = context.read<RecipeCubit>().state ?? [];
      setState(() {
        _currentFavorites = List.from(recipes);
      });
    });
  }

  void _filterRecipes(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _removeRecipe(int index, Recipe recipe) {
    context.read<RecipeCubit>().removeFavoriteRecipe(recipe.idMeal);

    // Remove from the AnimatedList with animation
    if (index >= 0 && index < _currentFavorites.length) {
      _listKey.currentState?.removeItem(
        index,
            (context, animation) => _buildRemovedItem(context, recipe, animation),
        duration: const Duration(milliseconds: 500),
      );

      setState(() {
        _currentFavorites.removeAt(index);
      });
    }
  }

  Widget _buildRemovedItem(BuildContext context, Recipe recipe, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: RecipeCard(
          recipe: recipe,
          categoryId: recipe.strCategory,
          fromFavorites: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: _filterRecipes,
              ),
            ),
            // Recipe list
            Expanded(
              child: BlocBuilder<RecipeCubit, List<Recipe>?>(builder: (context, recipes) {
                if (recipes == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Synchronise la liste locale avec l'état du Cubit
                _currentFavorites = List.from(recipes);

                // Filtrage des recettes
                final filteredRecipes = _searchQuery.isEmpty
                    ? _currentFavorites
                    : _currentFavorites.where((recipe) {
                  return recipe.strMeal.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                if (filteredRecipes.isEmpty) {
                  return const Center(
                    child: Text('No recipes found.'),
                  );
                }

                return AnimatedList(
                  key: _listKey,
                  initialItemCount: filteredRecipes.length,
                  itemBuilder: (context, index, animation) {
                    // Protection contre les accès invalides à l'index
                    if (index >= filteredRecipes.length) {
                      return const SizedBox.shrink(); // Éviter un accès en dehors des limites
                    }
                    final recipe = filteredRecipes[index];
                    return SizeTransition(
                      sizeFactor: animation,
                      child: RecipeCard(
                        recipe: recipe,
                        categoryId: recipe.strCategory,
                        fromFavorites: true,
                        onFavoriteToggle: () {
                          final originalIndex = _currentFavorites.indexWhere((r) => r.idMeal == recipe.idMeal);
                          if (originalIndex != -1) {
                            _removeRecipe(originalIndex, recipe);
                          } else {
                            setState(() {
                              _currentFavorites = _currentFavorites.where((r) => r.idMeal != recipe.idMeal).toList();
                            });
                          }
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}
