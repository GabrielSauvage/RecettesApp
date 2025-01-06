import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryRepository {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('${_baseUrl}categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final categories = data['categories'] as List<dynamic>;

      return categories.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception("Erreur lors du chargement des catégories");
    }
  }
}