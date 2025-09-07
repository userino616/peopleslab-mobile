import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/common/widgets/search_field.dart';
import 'package:peopleslab/app/bottom_nav.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String query = '';
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  static const products = <String>[
    'Vitamin C 1000mg',
    'Omega-3 Fish Oil',
    'Magnesium Glycinate',
    'Whey Protein Powder',
    'Vitamin D3 5000IU',
    'Probiotic Complex',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabIndex = ref.watch(bottomNavIndexProvider);
    if (tabIndex == 1 && !_focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
    final filtered = products
        .where(
          (p) =>
              query.isNotEmpty && p.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: AppSearchField(
                  hintText: 'Пошук товарів',
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: (v) => setState(() => query = v),
                ),
              ),
            ),
            if (filtered.isNotEmpty)
              SliverList.separated(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      filtered[index],
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                },
                separatorBuilder: (_, _) => const Divider(height: 1),
              )
            else
              const SliverToBoxAdapter(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
