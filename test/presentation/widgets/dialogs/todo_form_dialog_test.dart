import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/core/utils/date_utils.dart';
import 'package:todo_list/src/domain/entities/todo.dart';
import 'package:todo_list/src/presentation/widgets/dialogs/todo_form_dialog.dart';

import '../../../build_widget.dart';

void main() {
  Future<void> buildWidgetTmp(
    WidgetTester tester, {
    ValueChanged<Todo?>? onSubmit,
    Todo? todo,
  }) async {
    await buildWidget(
      tester,
      Builder(
        builder: (BuildContext context) => TextButton(
          onPressed: () async {
            final Todo? res = await showTodoFormDialog(context, todo: todo);
            onSubmit?.call(res);
          },
          child: const Text('show'),
        ),
      ),
    );

    await tester.tap(find.text('show'));
    await tester.pumpAndSettle();
  }

  group('[UI checks]', () {
    testWidgets('New TODO default display', (WidgetTester tester) async {
      await buildWidgetTmp(tester);

      expect(find.byType(AlertDialog), findsOneWidget);

      // Title
      expect(find.text('New TODO'), findsOneWidget);

      // Form
      expect(find.widgetWithText(TextFormField, 'Task name'), findsOneWidget);
      expect(
        find.widgetWithText(DropdownButtonFormField<Priority>, 'Priority'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(DropdownButtonFormField<Priority>, 'none'),
        findsOneWidget,
      );
      expect(find.text('Due date'), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.date_range), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Clear'), findsNothing);

      // Actions
      expect(find.widgetWithIcon(IconButton, Icons.close), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.check), findsOneWidget);
    });

    testWidgets('Edit TODO default display', (WidgetTester tester) async {
      final Todo todo = Todo(
        task: 'Sample task',
        priority: Priority.high,
        dueDate: DateTime.now(),
      );

      await buildWidgetTmp(tester, todo: todo);

      expect(find.byType(AlertDialog), findsOneWidget);

      // Title
      expect(find.text('Edit TODO'), findsOneWidget);

      // Form
      expect(find.widgetWithText(TextFormField, 'Task name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, todo.task), findsOneWidget);
      expect(
        find.widgetWithText(DropdownButtonFormField<Priority>, 'Priority'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(
          DropdownButtonFormField<Priority>,
          todo.priority.name,
        ),
        findsOneWidget,
      );
      expect(find.text('Due date'), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.date_range), findsOneWidget);
      expect(
        find.text(DateFormat.yMMMMd().format(todo.dueDate!)),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextButton, 'Clear'), findsOneWidget);

      // Actions
      expect(find.widgetWithIcon(IconButton, Icons.close), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.check), findsOneWidget);
    });
  });

  group('[Event checks]', () {
    // Input form fields with [expect] checks.
    Future<void> inputFormWithChecks(WidgetTester tester) async {
      // Input task name
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Task name'),
        'Sample task',
      );
      expect(find.widgetWithText(TextFormField, 'Sample task'), findsOneWidget);

      // TODO: priority dropdown change
      // Tap priority dropdown
      // expect(
      //   find.widgetWithText(DropdownButtonFormField<Priority>, 'none'),
      //   findsOneWidget,
      // );
      // await tester.tap(find.byType(DropdownButtonFormField<Priority>));
      // await tester.pumpAndSettle();

      // // Priority dropdown items
      // expect(
      //   find.widgetWithText(DropdownMenuItem<Priority>, 'none'),
      //   // 2 because the default selected is "none"
      //   findsNWidgets(2),
      // );
      // expect(
      //   find.widgetWithText(DropdownMenuItem<Priority>, 'low'),
      //   // Not sure why it finds 2
      //   findsNWidgets(2),
      // );
      // expect(
      //   find.widgetWithText(DropdownMenuItem<Priority>, 'medium'),
      //   // Not sure why it finds 2
      //   findsNWidgets(2),
      // );
      // expect(
      //   find.widgetWithText(DropdownMenuItem<Priority>, 'high'),
      //   // Not sure why it finds 2
      //   findsNWidgets(2),
      // );

      // await tester.tap(find.text('low').last);
      // await tester.pumpAndSettle();

      // expect(
      //   find.widgetWithText(DropdownButtonFormField<Priority>, 'none'),
      //   findsNothing,
      // );
      // expect(
      //   find.widgetWithText(DropdownButtonFormField<Priority>, 'low'),
      //   findsOneWidget,
      // );

      // Tap due date icon button
      await tester.tap(find.widgetWithIcon(IconButton, Icons.date_range));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsNothing);

      expect(find.text('Due date'), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.date_range), findsOneWidget);
      expect(
        find.text(DateFormat.yMMMMd().format(DateTime.now())),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextButton, 'Clear'), findsOneWidget);
    }

    testWidgets('New TODO inputs + submit', (WidgetTester tester) async {
      Todo? res;

      await buildWidgetTmp(tester, onSubmit: (Todo? value) => res = value);

      expect(find.byType(AlertDialog), findsOneWidget);

      await inputFormWithChecks(tester);

      // Submit
      await tester.tap(find.widgetWithIcon(IconButton, Icons.check));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(res?.task, 'Sample task');
      expect(res?.priority, Priority.none);
      expect(res?.dueDate?.isSameYMD(DateTime.now()), true);
      expect(res?.isCompleted, false);
    });

    testWidgets('New TODO inputs + cancel', (WidgetTester tester) async {
      Todo? res;

      await buildWidgetTmp(tester, onSubmit: (Todo? value) => res = value);

      expect(find.byType(AlertDialog), findsOneWidget);

      await inputFormWithChecks(tester);

      // Submit
      await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(res, null);
    });

    testWidgets(
      'New TODO inputs + clear due date',
      (WidgetTester tester) async {
        await buildWidgetTmp(tester);

        expect(find.byType(AlertDialog), findsOneWidget);

        await inputFormWithChecks(tester);

        // Clear due date
        await tester.tap(find.widgetWithText(TextButton, 'Clear'));
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.widgetWithText(TextButton, 'Clear'), findsNothing);
      },
    );

    testWidgets('Validation error', (WidgetTester tester) async {
      await buildWidgetTmp(tester);

      expect(find.byType(AlertDialog), findsOneWidget);

      // Tap check icon button.
      Future<void> tapSubmit() async {
        await tester.tap(find.widgetWithIcon(IconButton, Icons.check));
        await tester.pump();

        // Form
        expect(find.widgetWithText(TextFormField, 'Task name'), findsOneWidget);
        expect(find.text('This is a required field'), findsOneWidget);

        expect(find.byType(AlertDialog), findsOneWidget);
      }

      await tapSubmit();

      // Input whitespaces
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Task name'),
        '     ',
      );

      await tapSubmit();
    });

    testWidgets('Edit TODO inputs + submit', (WidgetTester tester) async {
      final Todo todo = Todo(
        task: 'New todo',
        dueDate: DateTime.now(),
        priority: Priority.high,
      );

      Todo? res;

      await buildWidgetTmp(
        tester,
        onSubmit: (Todo? value) => res = value,
        todo: todo,
      );

      expect(find.byType(AlertDialog), findsOneWidget);

      await inputFormWithChecks(tester);

      // Submit
      await tester.tap(find.widgetWithIcon(IconButton, Icons.check));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(res?.task, 'Sample task');
      expect(res?.priority, todo.priority);
      expect(res?.dueDate?.isSameYMD(DateTime.now()), true);
      expect(res?.isCompleted, false);
    });

    testWidgets('Edit TODO inputs + cancel', (WidgetTester tester) async {
      final Todo todo = Todo(
        task: 'New todo',
        dueDate: DateTime.now(),
        priority: Priority.high,
      );

      Todo? res;

      await buildWidgetTmp(
        tester,
        onSubmit: (Todo? value) => res = value,
        todo: todo,
      );

      expect(find.byType(AlertDialog), findsOneWidget);

      await inputFormWithChecks(tester);

      // Submit
      await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(res, null);
    });
  });
}
