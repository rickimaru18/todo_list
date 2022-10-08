import 'package:flutter/material.dart';

import 'src/data/datasources/todo_datasource.dart';
import 'src/presentation/pages/page_router.dart';

Future<void> main() async {
  await TodoDataSource().init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: pageRouter,
    );
  }
}
