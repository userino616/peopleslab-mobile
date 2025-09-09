import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'package:peopleslab/common/widgets/app_button.dart';

/// Simple onboarding flow with three informative pages.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static final _pages = [
    (
      icon: Icons.eco_rounded,
      title: 'Earn for good deeds',
      desc: 'Collect points and level up your neighbourliness.',
    ),
    (
      icon: Icons.receipt_long_rounded,
      title: 'Go paperless',
      desc: 'Store all your receipts in one tidy place.',
    ),
    (
      icon: Icons.handshake_rounded,
      title: 'Support local projects',
      desc: 'Spend earned points to make an impact.',
    ),
  ];

  void _next() {
    if (_index == _pages.length - 1) {
      context.push(AppRoutes.signUp);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final page = _pages[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page.icon, size: 120, color: colorScheme.primary),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.desc,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _pages.length; i++)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _index == i
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              AppButton.primary(
                onPressed: _next,
                label:
                    _index == _pages.length - 1 ? s.signup_create_account : s.onboarding_cta,
              ),
              const SizedBox(height: 8),
              AppButton.text(
                onPressed: () => context.push(AppRoutes.signIn),
                label: s.cta_already_have_account,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

