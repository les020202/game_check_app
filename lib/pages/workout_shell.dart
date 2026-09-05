import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkoutShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const WorkoutShell({super.key,required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme=Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.onPrimary,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: colorScheme.onPrimary,
        ),
      ),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 50,
          selectedIndex: navigationShell.currentIndex,
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: (index){
            navigationShell.goBranch(
              index,
              initialLocation: index==navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }
}