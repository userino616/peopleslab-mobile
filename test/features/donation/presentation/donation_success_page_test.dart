import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peopleslab/features/donation/presentation/donation_success_args.dart';
import 'package:peopleslab/features/donation/presentation/donation_success_page.dart';

void main() {
  testWidgets('shows amount in message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DonationSuccessPage(
          args: DonationSuccessArgs(amount: 100),
        ),
      ),
    );
    expect(
      find.text('Ваш внесок у розмірі 100 ₴ успішно оформлено.'),
      findsOneWidget,
    );
  });
}
