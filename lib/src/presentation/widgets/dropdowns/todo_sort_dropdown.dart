import 'package:flutter/material.dart';

class TodoSortDropdown extends StatefulWidget {
  const TodoSortDropdown({
    required this.onSortBy,
    this.initialValue,
    super.key,
  });

  final ValueChanged<TodoSortBy> onSortBy;
  final TodoSortBy? initialValue;

  @override
  State<TodoSortDropdown> createState() => _TodoSortDropdownState();
}

class _TodoSortDropdownState extends State<TodoSortDropdown> {
  late TodoSortBy _sortBy = widget.initialValue ?? TodoSortBy.none;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TodoSortBy>(
      onChanged: (TodoSortBy? value) => setState(() {
        _sortBy = value!;
        widget.onSortBy(_sortBy);
      }),
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Sort by',
      ),
      value: _sortBy,
      items: TodoSortBy.values
          .map(
            (TodoSortBy todoSortBy) => DropdownMenuItem<TodoSortBy>(
              value: todoSortBy,
              child: Text(todoSortBy.prettyName),
            ),
          )
          .toList(),
    );
  }
}

//------------------------------------------------------------------------------
enum TodoSortBy {
  none,
  name,
  highToLowPriority,
  lowToHighPriority,
  dueDateAscending,
  dueDateDescending,
}

//------------------------------------------------------------------------------
extension TodoSortByExt on TodoSortBy {
  String get prettyName {
    final String res;

    switch (this) {
      case TodoSortBy.none:
        res = 'None';
        break;
      case TodoSortBy.name:
        res = 'Name';
        break;
      case TodoSortBy.highToLowPriority:
        res = 'Priority: high -> low';
        break;
      case TodoSortBy.lowToHighPriority:
        res = 'Priority: low -> high';
        break;
      case TodoSortBy.dueDateAscending:
        res = 'Due date: urgent -> non-urgent';
        break;
      case TodoSortBy.dueDateDescending:
        res = 'Due date: non-urgent -> urgent';
        break;
    }

    return res;
  }
}
