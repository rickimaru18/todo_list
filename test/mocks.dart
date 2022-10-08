import 'package:mockito/annotations.dart';
import 'package:todo_list/src/data/datasources/todo_datasource.dart';

export 'mocks.mocks.dart';

@GenerateMocks(
  <Type>[
    TodoDataSource,
  ],
)
class Mocks {}
