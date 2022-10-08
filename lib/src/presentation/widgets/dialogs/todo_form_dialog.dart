import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/todo.dart';

/// Show [Todo] form dialog.
///
/// If [todo] is set, form will be in edit mode.
Future<Todo?> showTodoFormDialog(
  BuildContext context, {
  Todo? todo,
}) {
  return showDialog<Todo?>(
    context: context,
    builder: (_) => _TodoForm(
      todo: todo,
    ),
  );
}

//------------------------------------------------------------------------------
class _TodoForm extends StatefulWidget {
  const _TodoForm({
    this.todo,
  });

  final Todo? todo;

  @override
  State<_TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<_TodoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _taskController =
      TextEditingController(text: widget.todo?.task ?? '');

  late Priority _priority = widget.todo?.priority ?? Priority.none;
  late DateTime? _dueDate = widget.todo?.dueDate;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _onSetDueDate() async {
    final DateTime now = DateTime.now();
    final DateTime? res = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );

    if (res != null) {
      setState(() => _dueDate = res);
    }
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      Todo(
        task: _taskController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
        isCompleted: widget.todo?.isCompleted ?? false,
      ),
    );
  }

  List<Widget> _buildFormFields() => <Widget>[
        TextFormField(
          validator: (String? value) => value?.trim().isNotEmpty ?? false
              ? null
              : 'This is a required field.',
          controller: _taskController,
          decoration: const InputDecoration(
            labelText: 'Task name',
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<Priority>(
          onChanged: (Priority? value) => setState(() => _priority = value!),
          decoration: const InputDecoration(
            labelText: 'Priority',
          ),
          value: _priority,
          items: Priority.values
              .map(
                (Priority priority) => DropdownMenuItem<Priority>(
                  value: priority,
                  child: Text(priority.name),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Expanded(
                  child: Text('Due date'),
                ),
                IconButton(
                  onPressed: _onSetDueDate,
                  icon: const Icon(Icons.date_range),
                ),
              ],
            ),
            if (_dueDate != null) Text(DateFormat.yMMMMd().format(_dueDate!)),
            if (_dueDate != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _dueDate = null),
                  child: const Text(
                    'Clear',
                  ),
                ),
              ),
          ],
        ),
      ];

  List<Widget> _buildActions() => <Widget>[
        IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
        IconButton(
          onPressed: _onSubmit,
          icon: const Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.todo == null ? 'New' : 'Edit'} TODO'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildFormFields(),
        ),
      ),
      actions: _buildActions(),
    );
  }
}
