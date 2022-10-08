import 'package:mockito/annotations.dart';
import 'package:todo_list/src/data/datasources/todo_datasource.dart';
import 'package:todo_list/src/data/repositories/todo_repository.dart';

export 'mocks.mocks.dart';

@GenerateMocks(
  <Type>[
    TodoDataSource,
    TodoRepository,
  ],
)
class Mocks {}
