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
      child: FavoritesView(),
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

  void _filterRecipes(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _removeRecipe(int index, Recipe recipe) {
    context.read<RecipeCubit>().removeFavoriteRecipe(recipe.idMeal);
    _listKey.currentState?.removeItem(
      index,
          (context, animation) => _buildRemovedItem(context, recipe, animation),
      duration: const Duration(milliseconds: 300),
    );
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

                  final filteredRecipes = recipes.where((recipe) => recipe.strMeal.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: filteredRecipes.length,
                    itemBuilder: (context, index, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: RecipeCard(
                          recipe: filteredRecipes[index],
                          categoryId: filteredRecipes[index].strCategory,
                          fromFavorites: true,
                          onFavoriteToggle: () {
                            _removeRecipe(index, filteredRecipes[index]);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }
}