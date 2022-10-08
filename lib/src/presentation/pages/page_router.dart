import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';
import 'home/home_page_vm.dart';

GoRouter pageRouter = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: HomePage.route,
      builder: (_, __) => ChangeNotifierProvider<HomePageViewModel>(
        create: (_) => HomePageViewModel(),
        lazy: false,
        child: const HomePage(),
      ),
    ),
  ],
);
