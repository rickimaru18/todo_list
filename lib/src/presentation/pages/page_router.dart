import 'package:go_router/go_router.dart';

import 'home/home_page.dart';

GoRouter pageRouter = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: HomePage.route,
      builder: (_, __) => const HomePage(),
    ),
  ],
);
