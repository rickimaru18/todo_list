import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/domain/entities/todo.dart';
import 'package:todo_list/src/presentation/pages/home/home_page.dart';
import 'package:todo_list/src/presentation/pages/home/home_page_vm.dart';
import 'package:todo_list/src/presentation/widgets/cards/todo_card.dart';
import 'package:todo_list/src/presentation/widgets/dropdowns/todo_sort_dropdown.dart';

import '../../../build_widget.dart';
import '../../../mocks.dart';
import '../../widgets/dialogs/todo_form_dialog_test.dart';

void main() {
  final List<Todo> todos = List<Todo>.generate(
    3,
    (int i) => Todo(
      task: 'Task $i',
    )..testKey = i,
  );

  late MockTodoUsecase usecase;
  late StreamController<BoxEvent> listenStream;
  late HomePageViewModel vm;

  setUp(() {
    usecase = MockTodoUsecase();
    listenStream = StreamController<BoxEvent>();

    when(usecase.getAll()).thenReturn(todos);
    when(usecase.listen()).thenAnswer((_) => listenStream.stream);
  });

  Future<void> buildWidgetTmp(
    WidgetTester tester, {
    List<Todo>? data,
  }) {
    when(usecase.getAll()).thenReturn(data ?? todos);

    return buildWidget(
      tester,
      ChangeNotifierProvider<HomePageViewModel>.value(
        value: vm = HomePageViewModel(usecase: usecase),
        child: const HomePage(),
      ),
    );
  }

  group('[UI checks]', () {
    testWidgets('Empty list', (WidgetTester tester) async {
      await buildWidgetTmp(tester, data: <Todo>[]);

      verify(usecase.getAll());
      verify(usecase.listen());
      verifyNoMoreInteractions(usecase);

      expect(find.widgetWithText(AppBar, 'Todos'), findsOneWidget);

      // Sort dropdown
      expect(find.byType(TodoSortDropdown), findsOneWidget);
      expect(
        find.widgetWithText(TodoSortDropdown, TodoSortBy.none.prettyName),
        findsOneWidget,
      );

      // Todo list
      expect(find.text('No tasks yet'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(TodoCard), findsNothing);

      // Footer
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('No tasks completed'), findsOneWidget);
    });

    testWidgets('Non-empty list', (WidgetTester tester) async {
      await buildWidgetTmp(tester);

      verify(usecase.getAll());
      verify(usecase.listen());
      verifyNoMoreInteractions(usecase);

      expect(find.widgetWithText(AppBar, 'Todos'), findsOneWidget);

      // Sort dropdown
      expect(find.byType(TodoSortDropdown), findsOneWidget);
      expect(
        find.widgetWithText(TodoSortDropdown, TodoSortBy.none.prettyName),
        findsOneWidget,
      );

      // Todo list
      expect(find.text('No tasks yet'), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
      expect(
        find.byType(TodoCard, skipOffstage: false),
        findsNWidgets(todos.length),
      );

      // Footer
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(
        find.text(
          '${vm.completedTodos} out of ${vm.totalTodos} task(s) completed',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'Non-empty list (all task completed)',
      (WidgetTester tester) async {
        final List<Todo> completedTodos = <Todo>[
          Todo(
            task: 'Completed task',
            isCompleted: true,
          ),
        ];

        await buildWidgetTmp(
          tester,
          data: completedTodos,
        );

        verify(usecase.getAll());
        verify(usecase.listen());
        verifyNoMoreInteractions(usecase);

        expect(find.widgetWithText(AppBar, 'Todos'), findsOneWidget);

        // Sort dropdown
        expect(find.byType(TodoSortDropdown), findsOneWidget);
        expect(
          find.widgetWithText(TodoSortDropdown, TodoSortBy.none.prettyName),
          findsOneWidget,
        );

        // Todo list
        expect(find.text('No tasks yet'), findsNothing);
        expect(find.byType(ListView), findsOneWidget);
        expect(
          find.byType(TodoCard, skipOffstage: false),
          findsNWidgets(completedTodos.length),
        );

        // Footer
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.text('All tasks completed'), findsOneWidget);
      },
    );
  });

  group('[Event chekcs]', () {
    testWidgets('Create new Todo', (WidgetTester tester) async {
      await buildWidgetTmp(tester);

      verify(usecase.getAll());
      verify(usecase.listen());

      late final Todo newTodo;

      when(usecase.add(any)).thenAnswer((Invocation invocation) async {
        newTodo = invocation.positionalArguments.first as Todo;
        newTodo.testKey = todos.length + 1;

        listenStream.add(BoxEvent(newTodo.testKey, newTodo, false));

        return newTodo;
      });

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Input form and submit
      await inputTodoFormDialogWithChecks(tester);
      await tester.tap(
        // TODO: why so slow?
        // find.descendant(
        //   of: find.byType(AlertDialog),
        //   matching: find.widgetWithIcon(IconButton, Icons.check),
        // ),
        find.widgetWithIcon(IconButton, Icons.check),
      );
      await tester.pumpAndSettle();

      verify(usecase.add(newTodo));
      verifyNoMoreInteractions(usecase);

      expect(
        find.byType(TodoCard, skipOffstage: false),
        findsNWidgets(todos.length + 1),
      );
      expect(find.widgetWithText(TodoCard, newTodo.task), findsOneWidget);
    });

    testWidgets('Edit Todo', (WidgetTester tester) async {
      final Todo todoToEdit = todos.last;

      await buildWidgetTmp(tester);

      verify(usecase.getAll());
      verify(usecase.listen());

      late final Todo editedTodo;

      when(usecase.update(any, any)).thenAnswer((Invocation invocation) async {
        editedTodo = invocation.positionalArguments[1] as Todo;
        editedTodo.testKey = todoToEdit.testKey;
        listenStream.add(BoxEvent(editedTodo.testKey, editedTodo, false));
      });

      await tester.tap(find.widgetWithText(TodoCard, todoToEdit.task));
      await tester.pumpAndSettle();

      // Input form and submit
      await inputTodoFormDialogWithChecks(tester);
      await tester.tap(find.widgetWithIcon(IconButton, Icons.check));
      await tester.pumpAndSettle();

      verify(usecase.update(editedTodo.id, editedTodo));
      verifyNoMoreInteractions(usecase);

      expect(find.byType(TodoCard), findsNWidgets(todos.length));
      expect(find.widgetWithText(TodoCard, editedTodo.task), findsOneWidget);
    });

    testWidgets('Delete Todo', (WidgetTester tester) async {
      final Todo todoToRemove = todos.last;

      await buildWidgetTmp(tester);

      verify(usecase.getAll());
      verify(usecase.listen());

      late final Todo removedTodo;

      when(usecase.remove(any)).thenAnswer((Invocation invocation) async {
        removedTodo = invocation.positionalArguments.first as Todo;
        removedTodo.testKey = todoToRemove.testKey;

        listenStream.add(BoxEvent(removedTodo.testKey, removedTodo, true));
      });

      await tester.tap(find.widgetWithText(TextButton, 'Delete').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Yes'));
      await tester.pumpAndSettle();

      verify(usecase.remove(todoToRemove));
      verifyNoMoreInteractions(usecase);

      expect(find.byType(TodoCard), findsNWidgets(todos.length - 1));
      expect(find.widgetWithText(TodoCard, removedTodo.task), findsNothing);
    });

    testWidgets('Complete Todo', (WidgetTester tester) async {
      final Todo todoToComplete = todos.last;

      await buildWidgetTmp(tester);

      verify(usecase.getAll());
      verify(usecase.listen());

      late final Todo completedTodo;

      // TODO: I think it's better to mock repository not usecase.
      when(usecase.complete(any)).thenAnswer((Invocation invocation) async {
        completedTodo =
            Todo.complete(invocation.positionalArguments.first as Todo);
        completedTodo.testKey = todoToComplete.testKey;

        listenStream.add(BoxEvent(completedTodo.testKey, completedTodo, false));
      });

      await tester.tap(find.widgetWithText(TextButton, 'Complete').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Yes'));
      await tester.pumpAndSettle();

      verify(usecase.complete(todoToComplete));
      verifyNoMoreInteractions(usecase);

      expect(find.byType(TodoCard), findsNWidgets(todos.length));
      expect(
        find.widgetWithText(TextButton, 'Complete'),
        findsNWidgets(todos.length - 1),
      );
      expect(
        find.descendant(
          of: find.widgetWithText(TodoCard, completedTodo.task),
          matching: find.widgetWithText(TextButton, 'Complete'),
        ),
        findsNothing,
      );
    });

    testWidgets('Sort Todos', (WidgetTester tester) async {
      // TODO: Add sort checks.
    });
  });
}
