import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tp/ui/screens/recipe_detail.dart';
import 'package:tp/ui/screens/recipe_list_by_country.dart';
import 'ui/screens/home.dart';
import 'ui/screens/recipe_list_by_category.dart';
import 'ui/screens/favorites.dart';

class SlidingPageRoute extends PageRouteBuilder {
  final Widget page;
  final bool reverse;
  SlidingPageRoute({required this.page, this.reverse = false})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = reverse ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

GoRouter createRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Home(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final reverse = state.extra != null && (state.extra as Map<String, dynamic>)['reverse'] == true;
            return _buildSlideTransition(
              context: context,
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              reverse: reverse,
            );
          },
        ),
      ),
      GoRoute(
        path: '/recipes/:categoryId',
        pageBuilder: (context, state) {
          final categoryId = state.params['categoryId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RecipeListByCategory(categoryId: categoryId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return _buildSlideTransition(
                context: context,
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/recipes/country/:country',
        pageBuilder: (context, state) {
          final country = state.params['country']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RecipeListByCountry(country: country),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final reverse = state.extra != null && (state.extra as Map<String, dynamic>)['reverse'] == true;
              return _buildSlideTransition(
                context: context,
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                reverse: reverse,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/recipe/:idMeal/:categoryId',
        pageBuilder: (context, state) {
          final idMeal = state.params['idMeal']!;
          final categoryId = state.params['categoryId']!;
          final extra = state.extra as Map<String, dynamic>?;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RecipeDetail(idMeal: idMeal, categoryId: categoryId, extra: extra),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final reverse = state.extra != null && (state.extra as Map<String, dynamic>)['reverse'] == true;
              return _buildSlideTransition(
                context: context,
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                reverse: reverse,
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/favorites',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Favorites(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final reverse = state.extra != null && (state.extra as Map<String, dynamic>)['reverse'] == true;
            return _buildSlideTransition(
              context: context,
              child: child,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              reverse: reverse,
            );
          },
        ),
      ),
    ],
  );
}

Widget _buildSlideTransition({
  required BuildContext context,
  required Widget child,
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  bool reverse = false,
}) {
  final begin = reverse ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(position: offsetAnimation, child: child);
}