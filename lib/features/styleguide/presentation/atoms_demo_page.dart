import 'package:flutter/material.dart';
import 'package:peopleslab/common/widgets/app_button.dart';
import 'package:peopleslab/common/widgets/app_checkbox.dart';
import 'package:peopleslab/common/widgets/app_radio.dart';
import 'package:peopleslab/common/widgets/app_text_field.dart';
import 'package:peopleslab/common/widgets/app_toggle.dart';
import 'package:peopleslab/common/widgets/app_filter_chip.dart';
import 'package:peopleslab/common/widgets/app_linear_progress.dart';
import 'package:peopleslab/common/widgets/app_circular_progress.dart';
import 'package:peopleslab/common/widgets/risk_tag.dart';
import 'package:peopleslab/common/widgets/soft_card.dart';
import 'package:peopleslab/common/widgets/project_preview_card.dart';
import 'package:go_router/go_router.dart';
import 'package:peopleslab/core/router/app_router.dart';
import 'package:peopleslab/features/donation/presentation/donation_args.dart';

class AtomsDemoPage extends StatefulWidget {
  const AtomsDemoPage({super.key});

  @override
  State<AtomsDemoPage> createState() => _AtomsDemoPageState();
}

class _AtomsDemoPageState extends State<AtomsDemoPage> {
  bool toggle = true;
  bool checked = false;
  String radio = 'once';
  bool chipSelected = true;
  double pct = 0.63;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atoms Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Buttons', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              SizedBox(
                width: 200,
                child: AppButton.primary(label: 'Підтримати'),
              ),
              SizedBox(
                width: 200,
                child: AppButton.outlined(label: 'Узяти участь'),
              ),
              AppButton.text(label: 'Деталі'),
              SizedBox(
                width: 200,
                child: AppButton.destructive(label: 'Видалити'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Text('Inputs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const AppTextField(
            labelText: 'Пошта',
            hintText: 'name@example.com',
            variant: AppTextFieldVariant.outline,
            prefixIcon: Icon(Icons.alternate_email_rounded),
          ),
          const SizedBox(height: 12),
          const AppTextField(
            labelText: 'Пароль',
            hintText: '••••••••',
            obscureText: true,
            variant: AppTextFieldVariant.filled,
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
          const SizedBox(height: 12),
          const AppTextField(
            labelText: 'Коментар',
            hintText: 'Ваш відгук',
            variant: AppTextFieldVariant.multiline,
          ),

          const SizedBox(height: 24),
          Text('Chips & Tags', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppFilterChip(
                label: 'Низький ризик',
                selected: chipSelected,
                icon: Icons.shield_outlined,
                onPressed: () => setState(() => chipSelected = !chipSelected),
              ),
              const AppFilterChip(
                label: 'RCT',
                selected: false,
              ),
              const RiskTag(level: RiskLevel.low),
              const RiskTag(level: RiskLevel.mid),
              const RiskTag(level: RiskLevel.high),
            ],
          ),

          const SizedBox(height: 24),
          Text('Progress', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          AppLinearProgress(value: pct, label: '${(pct * 100).round()}%'),
          const SizedBox(height: 12),
          Row(
            children: [
              AppCircularProgress(
                value: pct,
                center: const Icon(Icons.emoji_events_rounded, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Рівень 3'),
                    Text('Нагороди: бейдж, ранній доступ'),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 24),
          Text('Soft Card', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const SoftCard(
            child: Text('Пухка картка з м’якою тінню'),
          ),

          const SizedBox(height: 24),
          Text('Toggles & Checks', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          Text('Project Card', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ProjectPreviewCard(
            data: ProjectCardData(
              title: 'Омега‑3 (EPA/DHA)',
              subtitle: 'Вплив на профіль ліпідів у RCT',
              collected: 45000,
              target: 80000,
              status: '🧪 Набір',
              design: 'RCT',
              term: '3 міс',
              risk: RiskLevel.low,
              ethicalBoard: true,
              endsAt: null,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          AppButton.outlined(
            label: 'Відкрити «Панель донату»',
            onPressed: () => context.push(
              AppRoutes.donate,
              extra: const DonationArgs(projectTitle: 'Омега‑3 (EPA/DHA)'),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              AppToggle(
                value: toggle,
                showIcons: true,
                semanticsLabel: 'Не друкувати чек',
                onChanged: (v) => setState(() => toggle = v),
              ),
              const SizedBox(width: 12),
              Text(toggle ? 'ON' : 'OFF'),
            ],
          ),
          const SizedBox(height: 12),
          AppCheckbox(
            value: checked,
            label: 'Публікувати як Анонім',
            onChanged: (v) => setState(() => checked = v),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppRadio<String>(
                value: 'once',
                groupValue: radio,
                label: 'Разово',
                onChanged: (v) => setState(() => radio = v),
              ),
              AppRadio<String>(
                value: 'monthly',
                groupValue: radio,
                label: 'Щомісяця',
                onChanged: (v) => setState(() => radio = v),
              ),
            ],
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
