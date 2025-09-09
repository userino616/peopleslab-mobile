import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/common/widgets/search_field.dart';
import 'package:peopleslab/app/bottom_nav.dart';
import 'package:peopleslab/core/l10n/l10n_x.dart';
import 'widgets/campaign_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final categories = [
      l10n.categoryImmunity,
      l10n.categoryEnergy,
      l10n.categorySleep,
      l10n.categoryGutHealth,
    ];
    final campaigns = [
      (
        title: 'Vitamin D and Immune Response',
        description:
            'Help fund a trial studying high-dose vitamin D for immune health.',
        raised: 7200.0,
        goal: 10000.0,
      ),
      (
        title: 'Rhodiola and Endurance',
        description:
            'Support research on Rhodiola rosea for energy and stress.',
        raised: 4300.0,
        goal: 7500.0,
      ),
      (
        title: 'Magnesium for Better Sleep',
        description:
            'Backing a study on magnesium glycinate and sleep quality.',
        raised: 2100.0,
        goal: 5000.0,
      ),
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
                      hintText: l10n.searchProjectsHint,
                      onChanged: (_) {},
                      onTap: () {
                        // Open Search tab when tapping the search field
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
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final c = campaigns[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: CampaignCard(
                    title: c.title,
                    description: c.description,
                    raised: c.raised,
                    goal: c.goal,
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
