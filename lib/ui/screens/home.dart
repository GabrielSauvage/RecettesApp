import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../utils/api_client.dart';
import '../widgets/category_card.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Category>> futureCategories;
  final ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    futureCategories = apiClient.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paradis des recettes'),
      ),
      body: FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CategoryCard(category: snapshot.data![index]);
              },
            );
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }
}