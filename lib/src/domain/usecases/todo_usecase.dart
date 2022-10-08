import 'dart:async';

import 'package:hive/hive.dart';

import '../../data/repositories/todo_repository.dart';
import '../entities/todo.dart';

class TodoUsecase {
  TodoUsecase({
    TodoRepository? repository,
  }) : _repository = repository ?? TodoRepository();

  final TodoRepository _repository;

  Future<Todo> add(Todo todo) => _repository.add(todo);

  List<Todo> getAll() => _repository.getAll();

  Stream<BoxEvent> listen() => _repository.listen();

  Future<void> update(int id, Todo todo) => _repository.update(id, todo);

  Future<void> remove(Todo todo) => _repository.remove(todo);

  /// Complete [todo]. If already completed, do not perform update.
  Future<void> complete(Todo todo) async {
    if (todo.isCompleted) {
      return;
    }
    await update(todo.id, Todo.complete(todo));
  }
}
