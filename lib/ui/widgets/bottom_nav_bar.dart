import 'package:flutter/material.dart';
import '../screens/favorites.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  const BottomNavBar({super.key, required this.selectedIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {
    if (index == 0) {
      context.go('/', extra: {'reverse' : true});
    } else if (index == 1) {
      context.go('/favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = widget.selectedIndex >= 0 && widget.selectedIndex < 2 ? widget.selectedIndex : -1;

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favoris',
        ),
      ],
      currentIndex: currentIndex == -1 ? 0 : currentIndex,
      onTap: _onItemTapped,
      selectedItemColor: currentIndex == -1 ? Colors.grey : Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: currentIndex != -1,
      showUnselectedLabels: true,
    );
  }
}