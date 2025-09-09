import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/theme/theme_provider.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';
import 'package:peopleslab/common/widgets/app_button.dart';

/// Basic profile screen with theme switching and sign out.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

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
                title: Text('User'),
                subtitle: Text('No user data'),
              ),
            const SizedBox(height: 24),
            Text('Theme', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('Auto'),
                  icon: Icon(Icons.brightness_auto_rounded),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode_rounded),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
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

