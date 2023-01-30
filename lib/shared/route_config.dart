import 'package:go_router/go_router.dart';
import 'package:lets_chat/features/home/home.dart';
import 'package:lets_chat/features/onboarding/onboarding.dart';
import 'package:lets_chat/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: "/",
    builder: (context, state) => const MainScreen(),
    routes: [
      GoRoute(
        path: "onboarding",
        builder: (context, state) => const Onboarding(),
      ),
      GoRoute(
        path: "home",
        builder: (context, state) => const Home(),
      ),
    ],
  ),
]);
