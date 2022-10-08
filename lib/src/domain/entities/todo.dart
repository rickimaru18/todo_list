import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject {
  Todo({
    required this.task,
    this.priority = Priority.none,
    this.dueDate,
    this.isCompleted = false,
  });

  factory Todo.complete(Todo todo) => todo.isCompleted
      ? todo
      : Todo(
          task: todo.task,
          priority: todo.priority,
          dueDate: todo.dueDate,
          isCompleted: true,
        );

  @HiveField(0)
  final String task;
  @HiveField(1)
  final Priority priority;
  @HiveField(2)
  final DateTime? dueDate;
  @HiveField(3)
  final bool isCompleted;

  int get id => key as int? ?? -1;
}

//------------------------------------------------------------------------------
@HiveType(typeId: 2)
enum Priority {
  @HiveField(0)
  none,
  @HiveField(1)
  low,
  @HiveField(2)
  medium,
  @HiveField(3)
  high,
}

//------------------------------------------------------------------------------
extension PriorityExt on Priority {
  int compareTo(
    Priority other, {
    bool isDescending = true,
  }) {
    if ((this == Priority.none && other != Priority.none) ||
        (this != Priority.none && other == Priority.none)) {
      return 1;
    }

    final int prevIdx = index;
    final int nextIdx = other.index;

    return isDescending ? nextIdx - prevIdx : prevIdx - nextIdx;
  }
}
