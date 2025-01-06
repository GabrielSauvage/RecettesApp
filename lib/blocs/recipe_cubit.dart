import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';
import '../repositories/recipe_repository.dart';

class RecipeCubit extends Cubit<List<Recipe>?> {
  final RecipeRepository recipeRepository;

  RecipeCubit({required this.recipeRepository}) : super(null);

  Future<void> fetchRecipes(String type, String id) async {
    try {
      if (type == 'category') {
        await fetchRecipesByCategory(id);
      } else if (type == 'country') {
        await fetchRecipesByCountry(id);
      } else {
        throw Exception('Invalid type');
      }
    } catch (e) {
      emit([]);
    }
  }

  Future<void> fetchRecipesByCategory(String category) async {
    try {
      final recipes = await recipeRepository.fetchRecipesByCategory(category);
      emit(recipes);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> fetchRecipesByCountry(String country) async {
    try {
      final recipes = await recipeRepository.fetchRecipesByCountry(country);
      emit(recipes);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> fetchFavoriteRecipes() async {
    try {
      final recipes = await recipeRepository.fetchFavoriteRecipes();
      emit(recipes);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> getMealDetails(String idMeal) async {
    try {
      final recipe = await recipeRepository.getMealDetails(idMeal);
      emit([recipe]);
    } catch (e) {
      emit([]);
    }
  }

  Future<void> removeFavoriteRecipe(String idMeal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(idMeal);
      final updatedRecipes = state?.where((recipe) => recipe.idMeal != idMeal).toList();
      emit(updatedRecipes);
    } catch (e) {
    }
  }

}