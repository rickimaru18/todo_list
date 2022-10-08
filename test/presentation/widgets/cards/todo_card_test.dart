import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/src/domain/entities/todo.dart';
import 'package:todo_list/src/presentation/widgets/cards/todo_card.dart';

import '../../../build_widget.dart';

void main() {
  final Todo todo = Todo(
    task: 'Sample task',
    priority: Priority.high,
    dueDate: DateTime.now(),
  );

  Future<void> buildWidgetTmp(
    WidgetTester tester, {
    VoidCallback? onTap,
    VoidCallback? onDelete,
    VoidCallback? onComplete,
    Todo? data,
  }) {
    return buildWidget(
      tester,
      TodoCard(
        onTap: onTap ?? () {},
        onDelete: onDelete ?? () {},
        onComplete: onComplete ?? () {},
        todo: data ?? todo,
      ),
    );
  }

  group('[UI checks]', () {
    testWidgets('Display all details', (WidgetTester tester) async {
      await buildWidgetTmp(tester);

      final Card card = tester.widget(find.byType(Card));
      expect(card.color, null);

      // Details
      expect(find.text(todo.priority.name), findsOneWidget);
      expect(find.text(todo.task), findsOneWidget);
      expect(
        find.text('Due date: ${DateFormat.yMMMMd().format(todo.dueDate!)}'),
        findsOneWidget,
      );

      // Actions
      expect(find.widgetWithText(TextButton, 'Delete'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Complete'), findsOneWidget);
    });

    testWidgets('No priority', (WidgetTester tester) async {
      await buildWidgetTmp(
        tester,
        data: Todo(
          task: todo.task,
          dueDate: todo.dueDate,
        ),
      );

      final Card card = tester.widget(find.byType(Card));
      expect(card.color, null);

      // Details
      expect(find.text(todo.priority.name), findsNothing);
      expect(find.text(todo.task), findsOneWidget);
      expect(
        find.text('Due date: ${DateFormat.yMMMMd().format(todo.dueDate!)}'),
        findsOneWidget,
      );

      // Actions
      expect(find.widgetWithText(TextButton, 'Delete'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Complete'), findsOneWidget);
    });

    testWidgets('No due date', (WidgetTester tester) async {
      await buildWidgetTmp(
        tester,
        data: Todo(
          task: todo.task,
          priority: todo.priority,
        ),
      );

      final Card card = tester.widget(find.byType(Card));
      expect(card.color, null);

      // Details
      expect(find.text(todo.priority.name), findsOneWidget);
      expect(find.text(todo.task), findsOneWidget);
      expect(
        find.text('Due date: ${DateFormat.yMMMMd().format(todo.dueDate!)}'),
        findsNothing,
      );

      // Actions
      expect(find.widgetWithText(TextButton, 'Delete'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Complete'), findsOneWidget);
    });

    testWidgets('Completed', (WidgetTester tester) async {
      await buildWidgetTmp(
        tester,
        data: Todo.complete(todo),
      );

      final Card card = tester.widget(find.byType(Card));
      expect(card.color, Colors.green.shade100);

      // Details
      expect(find.text(todo.priority.name), findsOneWidget);
      expect(find.text(todo.task), findsOneWidget);
      expect(
        find.text('Due date: ${DateFormat.yMMMMd().format(todo.dueDate!)}'),
        findsOneWidget,
      );

      // Actions
      expect(find.widgetWithText(TextButton, 'Delete'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Complete'), findsNothing);
    });
  });

  group('[Event checks]', () {
    testWidgets('Tap card', (WidgetTester tester) async {
      bool? res;

      await buildWidgetTmp(tester, onTap: () => res = true);

      await tester.tap(find.byType(TodoCard));
      expect(res, true);
    });

    testWidgets('Delete', (WidgetTester tester) async {
      bool? res;

      await buildWidgetTmp(tester, onDelete: () => res = true);

      await tester.tap(find.widgetWithText(TextButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(
          AlertDialog,
          'Are you sure you want to delete [${todo.task}]?',
        ),
        findsOneWidget,
      );
      expect(res, null);

      await tester.tap(find.widgetWithText(TextButton, 'Yes'));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(
          AlertDialog,
          'Are you sure you want to delete [${todo.task}]?',
        ),
        findsNothing,
      );
      expect(res, true);
    });

    testWidgets('Complete', (WidgetTester tester) async {
      bool? res;

      await buildWidgetTmp(tester, onComplete: () => res = true);

      await tester.tap(find.widgetWithText(TextButton, 'Complete'));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(AlertDialog, 'Complete [${todo.task}]?'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(
          AlertDialog,
          "NOTE: You can't revert this request.",
        ),
        findsOneWidget,
      );
      expect(res, null);

      await tester.tap(find.widgetWithText(TextButton, 'Yes'));
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(AlertDialog, 'Complete [${todo.task}]?'),
        findsNothing,
      );
      expect(
        find.widgetWithText(
          AlertDialog,
          "NOTE: You can't revert this request.",
        ),
        findsNothing,
      );
      expect(res, true);
    });
  });
}
