import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/app/bottom_nav.dart';
import 'package:peopleslab/common/widgets/search_field.dart';
import 'package:peopleslab/common/widgets/project_preview_card.dart';
import 'package:peopleslab/common/widgets/app_filter_chip.dart';
import 'package:peopleslab/common/widgets/risk_tag.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/features/donation/presentation/donation_args.dart';
import 'package:peopleslab/features/study/presentation/study_args.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories = const ['Трендові', 'Низький ризик', 'RCT', 'Нові'];
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Removed large header; keep clean content block
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSearchField(
                      hintText: 'Пошук досліджень або БАДів',
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
                              child: AppFilterChip(
                                label: c,
                                selected: c == 'Трендові',
                                onPressed: () {},
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
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ProjectPreviewCard(
                    data: ProjectCardData(
                      title: index.isEven
                          ? 'Омега‑3 (EPA/DHA)'
                          : 'Магній (гліцинат)',
                      subtitle: 'Коротка ціль дослідження та дизайн',
                      collected: 30000 + index * 5000,
                      target: 80000,
                      status: '🧪 Набір',
                      design: index.isEven ? 'RCT' : 'Observational',
                      term: '${2 + index} міс',
                      risk: index % 3 == 0
                          ? RiskLevel.low
                          : index % 3 == 1
                              ? RiskLevel.mid
                              : RiskLevel.high,
                      ethicalBoard: index.isEven,
                    ),
                    onTap: () {
                      context.push(
                        AppRoutes.study,
                        extra: StudyArgs(
                          id: 'h$index',
                          title: index.isEven
                              ? 'Омега‑3 (EPA/DHA)'
                              : 'Магній (гліцинат)',
                          goal: 'Коротка ціль дослідження та дизайн',
                          collected: 30000 + index * 5000,
                          target: 80000,
                          ethicalBoard: index.isEven,
                          endsAt: DateTime.now().add(Duration(days: 20 - index * 2)),
                        ),
                      );
                    },
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
