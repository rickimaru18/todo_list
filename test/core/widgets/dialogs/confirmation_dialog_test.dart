import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/core/widgets/dialogs/confirmation_dialog.dart';

import '../../../build_widget.dart';

void main() {
  const String title = 'Sample title';
  const String description = 'This is my description';

  Future<void> buildWidgetTmp(
    WidgetTester tester, {
    ValueChanged<bool>? onConfirm,
    String? description,
  }) {
    return buildWidget(
      tester,
      Builder(
        builder: (BuildContext context) => TextButton(
          onPressed: () async {
            final bool res = await showConfirmationDialog(
              context,
              title,
              description: description,
            );
            onConfirm?.call(res);
          },
          child: const Text('show'),
        ),
      ),
    );
  }

  group('[UI checks]', () {
    testWidgets('No description', (WidgetTester tester) async {
      await buildWidgetTmp(tester);

      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.widgetWithText(AlertDialog, title), findsOneWidget);
      expect(find.widgetWithText(AlertDialog, description), findsNothing);
      expect(find.widgetWithText(TextButton, 'No'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Yes'), findsOneWidget);
    });

    testWidgets('With description', (WidgetTester tester) async {
      await buildWidgetTmp(tester, description: description);

      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.widgetWithText(AlertDialog, title), findsOneWidget);
      expect(find.widgetWithText(AlertDialog, description), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'No'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Yes'), findsOneWidget);
    });
  });

  group('[Event checks]', () {
    testWidgets('"No" tap', (WidgetTester tester) async {
      bool? res;

      await buildWidgetTmp(tester, onConfirm: (bool value) => res = value);

      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(res, null);

      await tester.tap(find.widgetWithText(TextButton, 'No'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(res, false);
    });

    testWidgets('"Yes" tap', (WidgetTester tester) async {
      bool? res;

      await buildWidgetTmp(tester, onConfirm: (bool value) => res = value);

      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(res, null);

      await tester.tap(find.widgetWithText(TextButton, 'Yes'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(res, true);
    });
  });
}
