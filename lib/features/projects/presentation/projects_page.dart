import 'package:flutter/material.dart';

/// Displays a list of crowdfunding research projects.
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = _dummyProjects;
    return Scaffold(
      appBar: AppBar(title: const Text('Проєкти')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final p = projects[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ProjectCard(project: p),
          );
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final _Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.08),
            colorScheme.primary.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: project.progress,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(project.progress * 100).round()}%'),
              Text('${project.raised} / ${project.goal}'),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {},
            child: const Text('Підтримати'),
          ),
        ],
      ),
    );
  }
}

class _Project {
  const _Project({
    required this.title,
    required this.description,
    required this.progress,
    required this.raised,
    required this.goal,
  });

  final String title;
  final String description;
  final double progress;
  final String raised;
  final String goal;
}

const _dummyProjects = <_Project>[
  _Project(
    title: 'Дослідження омега‑3 комплексу',
    description:
        'Вивчаємо вплив концентрованих омега‑3 на серцево‑судинну систему.',
    progress: 0.74,
    raised: '74 000₴',
    goal: '100 000₴',
  ),
  _Project(
    title: 'Нове дослідження пробіотиків',
    description: 'Порівнюємо різні штами для покращення кишкового мікробіому.',
    progress: 0.46,
    raised: '23 000₴',
    goal: '50 000₴',
  ),
  _Project(
    title: 'B12 та енергія',
    description: 'Як вітамін B12 допомагає при хронічній втомі.',
    progress: 0.2,
    raised: '10 000₴',
    goal: '50 000₴',
  ),
];

