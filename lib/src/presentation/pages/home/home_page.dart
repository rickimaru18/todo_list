import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/todo.dart';
import '../../widgets/cards/todo_card.dart';
import '../../widgets/dialogs/todo_form_dialog.dart';
import '../../widgets/dropdowns/todo_sort_dropdown.dart';
import 'home_page_vm.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  static const String route = '/';

  Future<void> _onNewTodo(BuildContext context) async {
    final HomePageViewModel vm = context.read<HomePageViewModel>();
    final Todo? res = await showTodoFormDialog(context);

    if (res != null) {
      vm.usecase.add(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomePageViewModel vm = context.read<HomePageViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TodoSortDropdown(
              onSortBy: vm.sort,
              initialValue: vm.sortBy,
            ),
          ),
          const _TodoList(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onNewTodo(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const _CompletedCountText(),
    );
  }
}

//------------------------------------------------------------------------------
class _CompletedCountText extends StatelessWidget {
  const _CompletedCountText();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Consumer<HomePageViewModel>(
          builder: (_, HomePageViewModel vm, __) {
            final String text;

            if (vm.totalTodos == 0) {
              text = 'No tasks completed';
            } else {
              final int completedTodos = vm.completedTodos;

              text = vm.totalTodos == completedTodos
                  ? 'All tasks completed'
                  : '$completedTodos out of ${vm.totalTodos} task(s) completed';
            }

            return Text(
              text,
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
class _TodoList extends StatelessWidget {
  const _TodoList();

  Future<void> _onEditTodo(BuildContext context, Todo todo) async {
    final HomePageViewModel vm = context.read<HomePageViewModel>();
    final Todo? res = await showTodoFormDialog(
      context,
      todo: todo,
    );

    if (res != null) {
      vm.usecase.update(todo.id, res);
    }
  }

  Widget _buildEmpty(BuildContext context) => Center(
        child: Text(
          'No tasks yet',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );

  Widget _buildList(List<Todo> todos) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int i) {
          final Todo todo = todos[i];

          return TodoCard(
            onTap: () => _onEditTodo(context, todo),
            onDelete: () =>
                context.read<HomePageViewModel>().usecase.remove(todo),
            onComplete: () =>
                context.read<HomePageViewModel>().usecase.complete(todo),
            todo: todo,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageViewModel>(
      builder: (_, HomePageViewModel vm, __) {
        final List<Todo> todos = vm.getTodos();
        return Expanded(
          child: todos.isEmpty ? _buildEmpty(context) : _buildList(todos),
        );
      },
    );
  }
}
