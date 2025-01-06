import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/category_cubit.dart';
import '../../blocs/country_cubit.dart';
import '../../models/category.dart';
import '../../models/country.dart';
import '../../repositories/category_repository.dart';
import '../../repositories/country_repository.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/category_card.dart';
import '../widgets/country_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryCubit(
            categoryRepository: CategoryRepository(),
          )..fetchCategories(),
        ),
        BlocProvider(
          create: (context) => CountryCubit(
            countryRepository: CountryRepository(),
          )..fetchCountries(),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool showCategories = true;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes paradise'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
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
    return BlocBuilder<CategoryCubit, List<Category>?>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, categories) {
        if (categories == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (categories.isEmpty) {
          return const Center(child: Text('No recipes found.'));
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/recipes/${category.strCategory}',
                  arguments: true,
                );
              },
              child: CategoryCard(category: category),
            );
          },
        );
      },
    );
  }

  Widget _buildCountries() {
    return BlocBuilder<CountryCubit, List<Country>?>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, countries) {
        if (countries == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (countries.isEmpty) {
          return const Center(child: Text('No recipes found.'));
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
          ),
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final country = countries[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/recipes/${country.strArea}',
                  arguments: false,
                );
              },
              child: CountryCard(country: country),
            );
          },
        );
      },
    );
  }
}
