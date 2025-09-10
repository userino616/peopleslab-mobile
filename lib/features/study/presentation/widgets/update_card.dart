import 'package:flutter/material.dart';
import 'package:peopleslab/common/widgets/micro_badge.dart';
import 'package:peopleslab/core/theme/design_tokens.dart';

class UpdateCard extends StatelessWidget {
  final String title;
  final String excerpt;
  final String? imageUrl; // optional
  final VoidCallback? onTap;

  const UpdateCard({
    super.key,
    required this.title,
    required this.excerpt,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadii.card),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: AppPalette.lavender,
                    child: imageUrl == null
                        ? const Icon(Icons.image_rounded, size: 48, color: Colors.white70)
                        : Image.network(imageUrl!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const MicroBadge(text: 'Оновлення', tone: BadgeTone.info, icon: Icons.update_rounded),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                excerpt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

