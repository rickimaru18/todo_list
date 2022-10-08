import 'dart:async';

import 'package:hive/hive.dart';

import '../../domain/entities/todo.dart';
import '../datasources/todo_datasource.dart';

class TodoRepository {
  TodoRepository({
    TodoDataSource? dataSource,
  }) : _dataSource = dataSource ?? TodoDataSource();

  final TodoDataSource _dataSource;

  /// Add [todo] to local storage.
  Future<Todo> add(Todo todo) => _dataSource.add(todo);

  /// Get all [Todo] from local storage.
  List<Todo> getAll() => _dataSource.getAll();

  /// Listen to [Todo] local storage changes.
  Stream<BoxEvent> listen() => _dataSource.listen();

  /// Update [Todo] with [id] from local storage.
  Future<void> update(int id, Todo todo) => _dataSource.update(id, todo);

  /// Remove [todo] from local storage.
  Future<void> remove(Todo todo) => _dataSource.remove(todo.id);
}
