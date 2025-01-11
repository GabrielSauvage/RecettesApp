import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryRepository {
  static const String _baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  Future<List<Country>> fetchCountries() async {
    final response = await http.get(Uri.parse('${_baseUrl}list.php?a=list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final countries = data['meals'] as List<dynamic>;

      return countries.map((country) => Country.fromJson(country)).toList();
    } else {
      throw Exception("Error loading countries");
    }
  }
}