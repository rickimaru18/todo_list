import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_list/src/domain/entities/todo.dart';
import 'package:todo_list/src/domain/usecases/todo_usecase.dart';

import '../../mocks.dart';

void main() {
  late MockTodoRepository repository;
  late TodoUsecase usecase;

  setUp(() {
    repository = MockTodoRepository();
    usecase = TodoUsecase(repository: repository);
  });

  test('Adding [Todo]', () async {
    when(repository.add(any)).thenAnswer((Invocation invocation) async {
      return invocation.positionalArguments.first as Todo;
    });

    final Todo todo = Todo(task: 'sample');
    final Todo res = await usecase.add(todo);

    verify(repository.add(todo));
    verifyNoMoreInteractions(repository);

    expect(res, todo);
  });

  test('Getting all [Todo]', () async {
    final List<Todo> todos = <Todo>[
      Todo(task: 'sample'),
    ];

    when(repository.getAll()).thenReturn(todos);

    final List<Todo> res = usecase.getAll();

    verify(repository.getAll());
    verifyNoMoreInteractions(repository);

    expect(res, todos);
  });

  test('Update [Todo]', () async {
    const int id = 123;
    final Todo todo = Todo(task: 'sample');
    await usecase.update(id, todo);

    verify(repository.update(id, todo));
    verifyNoMoreInteractions(repository);
  });

  test('Remove [Todo]', () async {
    final Todo todo = Todo(task: 'sample');
    await usecase.remove(todo);

    verify(repository.remove(todo));
    verifyNoMoreInteractions(repository);
  });

  group('Complete [Todo] checks', () {
    test('Not yet completed', () async {
      final Todo todo = Todo(task: 'sample');
      await usecase.complete(todo);

      verify(repository.update(todo.id, any));
      verifyNoMoreInteractions(repository);
    });

    test('Already completed', () async {
      final Todo todo = Todo(
        task: 'sample',
        isCompleted: true,
      );
      await usecase.complete(todo);

      verifyNever(repository.update(todo.id, any));
      verifyNoMoreInteractions(repository);
    });
  });
}
