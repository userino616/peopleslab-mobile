import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/app/bottom_nav.dart';
import 'package:peopleslab/features/home/presentation/home_page.dart';
import 'package:peopleslab/features/search/presentation/search_page.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/theme/theme_provider.dart';
import 'package:peopleslab/common/widgets/app_button.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';

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
          _FavoritesPage(),
          _ProfilePage(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(15, 23, 42, 0.08),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: NavigationBarTheme(
                  data: NavigationBarThemeData(
                    backgroundColor: Colors.transparent,
                    indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                    indicatorShape: const StadiumBorder(),
                    labelTextStyle: WidgetStatePropertyAll(
                      Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  child: NavigationBar(
                    height: 56,
                    selectedIndex: index,
                    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                    onDestinationSelected: (i) =>
                        ref.read(bottomNavIndexProvider.notifier).state = i,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfilePage extends ConsumerWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final user = auth.user;
    final theme = Theme.of(context);
    final mode = ref.watch(themeModeProvider);

    final s = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (user != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Text(
                    (user.email.isNotEmpty ? user.email[0] : '?').toUpperCase(),
                  ),
                ),
                title: Text(user.email),
                subtitle: Text('ID: ${user.id}'),
              )
            else
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text('Користувач'),
                subtitle: Text('Не знайдено даних користувача'),
              ),
            const SizedBox(height: 24),
            Text('Тема', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('Авто'),
                  icon: Icon(Icons.brightness_auto_rounded),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Світла'),
                  icon: Icon(Icons.light_mode_rounded),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Темна'),
                  icon: Icon(Icons.dark_mode_rounded),
                ),
              ],
              selected: {mode},
              onSelectionChanged: (s) {
                if (s.isNotEmpty) {
                  ref.read(themeModeProvider.notifier).state = s.first;
                }
              },
            ),
            const SizedBox(height: 32),
            Text('Гаманець', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_balance_wallet_rounded),
              title: const Text('Статистика по гаманцю'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(AppRoutes.wallet),
            ),
            const SizedBox(height: 24),
            AppButton.tonal(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signOut();
              },
              label: s.action_sign_out,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesPage extends StatelessWidget {
  const _FavoritesPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Поки що порожньо',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
