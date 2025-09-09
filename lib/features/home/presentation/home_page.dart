import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/app/bottom_nav.dart';
import 'package:peopleslab/common/widgets/search_field.dart';
import 'widgets/project_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories = const [
      'Immunity',
      'Energy',
      'Detox',
      'Longevity',
      'Sleep',
      'Focus',
    ];
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSearchField(
                      hintText: 'Search projects or supplements',
                      onChanged: (_) {},
                      onTap: () {
                        ref.read(bottomNavIndexProvider.notifier).state = 1;
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final c in categories)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(c),
                                onSelected: (_) {},
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            SliverList.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                final cat = categories[index % categories.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ProjectCard(
                    title: 'Research on $cat supplements',
                    description:
                        'Help fund independent research for $cat boosters.',
                    raised: 2500 + index * 300,
                    goal: 5000,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
