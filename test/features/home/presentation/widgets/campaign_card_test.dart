import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peopleslab/l10n/app_localizations.dart';
import 'package:peopleslab/features/home/presentation/widgets/campaign_card.dart';

void main() {
  testWidgets('renders campaign card with progress and button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CampaignCard(
          title: 'Test study',
          description: 'Description',
          raised: 50,
          goal: 100,
        ),
      ),
    );

    expect(find.text('Test study'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.textContaining('Support project'), findsOneWidget);
  });
}

