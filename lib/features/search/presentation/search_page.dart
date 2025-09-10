import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/common/widgets/search_field.dart';
import 'package:peopleslab/app/bottom_nav.dart';
import 'package:peopleslab/common/widgets/app_filter_chip.dart';
import 'package:peopleslab/common/widgets/project_preview_card.dart';
import 'package:peopleslab/common/widgets/project_card_skeleton.dart';
import 'package:peopleslab/common/widgets/risk_tag.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/features/donation/presentation/donation_args.dart';
import 'package:peopleslab/features/study/presentation/study_args.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String query = '';
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  // Filters
  bool fTrending = true;
  bool fLowRisk = false;
  bool fRCT = false;
  bool fRecruiting = true;
  bool fNew = true;

  // Data & loading state
  final List<ProjectCardData> _items = [];
  bool _loadingInitial = true;
  bool _loadingMore = false;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabIndex = ref.watch(bottomNavIndexProvider);
    if (tabIndex == 1 && !_focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
    _setupScrollListener();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Removed large header; keep clean content block
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSearchField(
                      hintText: 'Пошук досліджень або БАДів',
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: (v) => setState(() => query = v),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          AppFilterChip(
                            label: 'Трендові',
                            selected: fTrending,
                            onPressed: () => setState(() => fTrending = !fTrending),
                          ),
                          const SizedBox(width: 8),
                          AppFilterChip(
                            label: 'Низький ризик',
                            selected: fLowRisk,
                            icon: Icons.shield_outlined,
                            onPressed: () => setState(() => fLowRisk = !fLowRisk),
                          ),
                          const SizedBox(width: 8),
                          AppFilterChip(
                            label: 'RCT',
                            selected: fRCT,
                            onPressed: () => setState(() => fRCT = !fRCT),
                          ),
                          const SizedBox(width: 8),
                          AppFilterChip(
                            label: 'Набір учасників',
                            selected: fRecruiting,
                            onPressed: () => setState(() => fRecruiting = !fRecruiting),
                          ),
                          const SizedBox(width: 8),
                          AppFilterChip(
                            label: 'Нові',
                            selected: fNew,
                            onPressed: () => setState(() => fNew = !fNew),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_loadingInitial)
              SliverList.separated(
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ProjectCardSkeleton(),
                ),
              )
            else
              SliverList.separated(
                itemCount: _items.length + (_loadingMore ? 3 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index >= _items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ProjectCardSkeleton(),
                    );
                  }
                  final d = _items[index];
                  final match = query.isEmpty ||
                      d.title.toLowerCase().contains(query.toLowerCase()) ||
                      d.subtitle.toLowerCase().contains(query.toLowerCase());
                  if (!match) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ProjectPreviewCard(
                      data: d,
                      onTap: () {
                        context.push(
                          AppRoutes.study,
                          extra: StudyArgs(
                            id: 's$index',
                            title: d.title,
                            goal: d.subtitle,
                            collected: d.collected,
                            target: d.target,
                            ethicalBoard: d.ethicalBoard,
                            endsAt: d.endsAt,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Simulate initial fetch
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _loadingInitial = false;
        _items.addAll(_mockBatch(0));
      });
    });
  }

  void _setupScrollListener() {
    if (_scrollController.hasListeners) return;
    _scrollController.addListener(() {
      if (_loadingMore || _loadingInitial) return;
      final pos = _scrollController.position;
      if (pos.pixels > pos.maxScrollExtent - 600) {
        _loadMore();
      }
    });
  }

  void _loadMore() {
    setState(() => _loadingMore = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _items.addAll(_mockBatch(_items.length));
        _loadingMore = false;
      });
    });
  }

  List<ProjectCardData> _mockBatch(int offset) {
    final list = <ProjectCardData>[];
    final titles = [
      'Омега‑3 (EPA/DHA)',
      'Магній (гліцинат)',
      'Вітамін D3',
      'Пробіотики',
      'Ашваганда',
      'Куркумін',
    ];
    for (int i = 0; i < 8; i++) {
      final t = titles[(offset + i) % titles.length];
      final collected = 20000 + ((offset + i) * 1200) % 40000;
      final target = 60000;
      list.add(ProjectCardData(
        title: t,
        subtitle: 'Вплив на біомаркери у RCT/Observational',
        collected: collected.toDouble(),
        target: target.toDouble(),
        status: '🧪 Набір',
        design: i.isEven ? 'RCT' : 'Observational',
        term: '${2 + (i % 4)} міс',
        risk: i % 3 == 0
            ? RiskLevel.low
            : i % 3 == 1
                ? RiskLevel.mid
                : RiskLevel.high,
        ethicalBoard: i % 2 == 0,
        endsAt: DateTime.now().add(Duration(days: 30 - ((offset + i) % 15))),
      ));
    }
    return list;
  }
}
