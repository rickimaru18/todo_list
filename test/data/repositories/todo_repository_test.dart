import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_list/src/data/repositories/todo_repository.dart';
import 'package:todo_list/src/domain/entities/todo.dart';

import '../../mocks.dart';

void main() {
  late MockTodoDataSource dataSource;
  late TodoRepository repository;

  setUp(() {
    dataSource = MockTodoDataSource();
    repository = TodoRepository(dataSource: dataSource);
  });

  test('Adding [Todo] to [TodoDataSource]', () async {
    when(dataSource.add(any)).thenAnswer((Invocation invocation) async {
      return invocation.positionalArguments.first as Todo;
    });

    final Todo todo = Todo(task: 'sample');
    final Todo res = await repository.add(todo);

    verify(dataSource.add(todo));
    verifyNoMoreInteractions(dataSource);

    expect(res, todo);
  });

  test('Getting all [Todo] from [TodoDataSource]', () async {
    final List<Todo> todos = <Todo>[
      Todo(task: 'sample'),
    ];

    when(dataSource.getAll()).thenReturn(todos);

    final List<Todo> res = repository.getAll();

    verify(dataSource.getAll());
    verifyNoMoreInteractions(dataSource);

    expect(res, todos);
  });

  test('Update [Todo] from [TodoDataSource]', () async {
    const int id = 123;
    final Todo todo = Todo(task: 'sample');
    await repository.update(id, todo);

    verify(dataSource.update(id, todo));
    verifyNoMoreInteractions(dataSource);
  });

  test('Remove [Todo] from [TodoDataSource]', () async {
    final Todo todo = Todo(task: 'sample');
    await repository.remove(todo);

    verify(dataSource.remove(todo.id));
    verifyNoMoreInteractions(dataSource);
  });
}
