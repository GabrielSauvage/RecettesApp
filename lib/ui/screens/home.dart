import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/country.dart';
import '../../utils/api_client.dart';
import '../widgets/category_card.dart';
import 'package:go_router/go_router.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_card.dart';
import '../widgets/country_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Category>> futureCategories;
  late Future<List<Country>> futureCountries;
  final ApiClient apiClient = ApiClient();
  bool showCategories = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureCategories = apiClient.fetchCategories();
    futureCountries = apiClient.fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes paradise'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCategories = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showCategories
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary,
                  ),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      color: showCategories
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCategories = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !showCategories
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary,
                  ),
                  child: Text(
                    'Countries',
                    style: TextStyle(
                      color: !showCategories
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: showCategories ? _buildCategories() : _buildCountries(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildCategories() {
    return FutureBuilder<List<Category>>(
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
              final category = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  context.go('/recipes/${category.strCategory}');
                },
                child: CategoryCard(category: category),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildCountries() {
    return FutureBuilder<List<Country>>(
      future: futureCountries,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No countries found'));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return CountryCard(country: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}