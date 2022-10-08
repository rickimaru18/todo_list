import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/dialogs/confirmation_dialog.dart';
import '../../../domain/entities/todo.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    required this.onTap,
    required this.onDelete,
    required this.onComplete,
    required this.todo,
    super.key,
  });

  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onComplete;
  final Todo todo;

  Future<void> _onDelete(BuildContext context) async {
    final bool res = await showConfirmationDialog(
      context,
      'Are you sure you want to delete [${todo.task}]?',
    );

    if (res) {
      onDelete();
    }
  }

  Future<void> _onComplete(BuildContext context) async {
    final bool res = await showConfirmationDialog(
      context,
      'Complete [${todo.task}]?',
      description: "NOTE: You can't revert this request.",
    );

    if (res) {
      onComplete();
    }
  }

  Widget _buildPriorityText(TextTheme textTheme) {
    final Color? color;

    switch (todo.priority) {
      case Priority.high:
        color = Colors.red;
        break;
      case Priority.medium:
        color = Colors.orange;
        break;
      case Priority.low:
      case Priority.none:
        color = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color ?? Colors.black,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        todo.priority.name,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            onPressed: () => _onDelete(context),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          if (!todo.isCompleted)
            TextButton(
              onPressed: () => _onComplete(context),
              child: const Text('Complete'),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 5,
      color: todo.isCompleted ? Colors.green.shade100 : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (todo.priority != Priority.none) _buildPriorityText(textTheme),
              Text(
                todo.task,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              if (todo.dueDate != null)
                Text(
                  'Due date: ${DateFormat.yMMMMd().format(todo.dueDate!)}',
                  style: textTheme.titleMedium,
                ),
              const Divider(),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }
}
