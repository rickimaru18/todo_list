import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/todo.dart';

/// A local data source for [Todo].
///
/// Can perform CRUD operations using [Hive].
///
/// NOTE: This is a singleton.
class TodoDataSource {
  factory TodoDataSource() => _instance;

  TodoDataSource._();

  static final TodoDataSource _instance = TodoDataSource._();

  late final Box<Todo> _box;

  bool _isInit = false;

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(PriorityAdapter());

    _box = await Hive.openBox<Todo>('todos');

    _isInit = true;
  }

  void _initCheck() {
    assert(_isInit, '[TodoDataSource] not yet initialized. Call [init] first');
  }

  /// Add [data] to box.
  Future<Todo> add(Todo data) async {
    _initCheck();
    return _box.get(await _box.add(data))!;
  }

  /// Get all [Todo] from box.
  List<Todo> getAll() {
    _initCheck();
    return _box.values.toList();
  }

  /// Listen to box changes.
  Stream<BoxEvent> listen() {
    _initCheck();
    return _box.watch();
  }

  /// Update data with [data] to box.
  Future<void> update(int id, Todo data) async {
    _initCheck();
    await _box.put(id, data);
  }

  /// Remove [Todo] with [id] from box.
  Future<void> remove(int id) async {
    _initCheck();
    await _box.delete(id);
  }
}
