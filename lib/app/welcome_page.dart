import 'package:flutter/material.dart';
import 'package:peopleslab/core/router/app_router.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PeoplesLab',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Вітаємо! Розпочнімо знайомство.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.welcome),
                child: const Text('Onboard'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signIn),
                child: const Text('Already have an account? Sign in'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
