import 'package:flutter/material.dart';
import 'package:peopleslab/common/widgets/shimmer_box.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class ProjectCardSkeleton extends StatelessWidget {
  const ProjectCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.elevation1,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerBox(height: 18, width: 180),
          SizedBox(height: 8),
          ShimmerBox(height: 14, width: 240),
          SizedBox(height: 12),
          ShimmerBox(height: 8),
          SizedBox(height: 8),
          ShimmerBox(height: 12, width: 160),
          SizedBox(height: 12),
          Row(
            children: [
              ShimmerBox(height: 26, width: 72, borderRadius: BorderRadius.all(Radius.circular(999))),
              SizedBox(width: 8),
              ShimmerBox(height: 26, width: 64, borderRadius: BorderRadius.all(Radius.circular(999))),
              SizedBox(width: 8),
              ShimmerBox(height: 26, width: 60, borderRadius: BorderRadius.all(Radius.circular(999))),
            ],
          ),
        ],
      ),
    );
  }
}

