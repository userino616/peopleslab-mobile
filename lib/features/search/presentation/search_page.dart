import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/common/widgets/search_field.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String query = '';

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
    final filtered = products
        .where(
          (p) =>
              query.isNotEmpty && p.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Пошук')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: AppSearchField(
                hintText: 'Пошук товарів',
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
    );
  }
}
