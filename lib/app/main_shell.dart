import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/app/bottom_nav.dart';
import 'package:peopleslab/features/home/presentation/home_page.dart';
import 'package:peopleslab/features/search/presentation/search_page.dart';
import 'package:peopleslab/features/favorites/presentation/favorites_page.dart';
import 'package:peopleslab/features/profile/presentation/profile_page.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          HomePage(),
          SearchPage(),
          FavoritesPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) =>
            ref.read(bottomNavIndexProvider.notifier).state = i,
        // Height/indicator/colors are themed in AppTheme
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Головна',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Пошук',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Обране',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}
