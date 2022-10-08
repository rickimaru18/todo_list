import 'dart:async';
import 'dart:collection';

import 'package:hive/hive.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/view_model.dart';
import '../../../domain/entities/todo.dart';
import '../../../domain/usecases/todo_usecase.dart';
import '../../widgets/dropdowns/todo_sort_dropdown.dart';

class HomePageViewModel extends ViewModel {
  HomePageViewModel({
    TodoUsecase? usecase,
  }) : usecase = usecase ?? TodoUsecase() {
    _init();
  }

  final TodoUsecase usecase;

  final SplayTreeMap<int, Todo> _todos = SplayTreeMap<int, Todo>();

  late final StreamSubscription<BoxEvent> _todosListener;

  TodoSortBy get sortBy => _sortBy;
  TodoSortBy _sortBy = TodoSortBy.none;

  int get totalTodos => _todos.length;

  int get completedTodos => _todos.entries.fold(
        0,
        (int previousValue, MapEntry<int, Todo> todo) {
          return todo.value.isCompleted ? previousValue + 1 : previousValue;
        },
      );

  void _init() {
    usecase.getAll().forEach((Todo todo) {
      _todos[todo.id] = todo;
    });

    _todosListener = usecase.listen().listen((BoxEvent event) {
      if (event.deleted) {
        _todos.remove(event.key);
      } else {
        _todos[event.key as int] = event.value as Todo;
      }

      notifyListeners();
    });
  }

  /// Get [Todo] list and sort based from [sortBy] value.
  UnmodifiableListView<Todo> getTodos() {
    final Iterable<Todo> res;

    switch (sortBy) {
      case TodoSortBy.none:
        res = _todos.values.toList().reversed;
        break;
      case TodoSortBy.name:
        res = _todos.values.toList()
          ..sort((Todo prev, Todo next) => prev.task.compareTo(next.task));
        break;
      case TodoSortBy.highToLowPriority:
      case TodoSortBy.lowToHighPriority:
        res = _todos.values.toList()
          ..sort((Todo prev, Todo next) => prev.priority.compareTo(
                next.priority,
                isDescending: sortBy == TodoSortBy.highToLowPriority,
              ));
        break;
      case TodoSortBy.dueDateAscending:
      case TodoSortBy.dueDateDescending:
        res = _todos.values.toList()
          ..sort((Todo prev, Todo next) => compareDatesNullable(
                prev.dueDate,
                next.dueDate,
                isDescending: sortBy == TodoSortBy.dueDateDescending,
              ));
        break;
    }

    return UnmodifiableListView<Todo>(res);
  }

  /// Update [sortBy] and notify listeners.
  void sort(TodoSortBy sortBy) {
    if (_sortBy == sortBy) {
      return;
    }
    _sortBy = sortBy;
    notifyListeners();
  }

  @override
  void dispose() {
    _todosListener.cancel();
    super.dispose();
  }
}
