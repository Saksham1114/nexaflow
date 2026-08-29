import 'package:go_router/go_router.dart';

import 'package:nexaflow/features/ai/presentation/pages/ai_page.dart';
import 'package:nexaflow/features/home/presentation/pages/home_page.dart';
import 'package:nexaflow/features/profile/presentation/pages/profile_page.dart';
import 'package:nexaflow/features/settings/presentation/pages/settings_page.dart';
import 'package:nexaflow/features/tasks/presentation/pages/tasks_page.dart';
import 'package:nexaflow/navigation/navigation_shell.dart';
import 'package:nexaflow/features/habits/presentation/pages/habits_page.dart';
import 'package:nexaflow/features/focus/presentation/pages/focus_page.dart';
import 'package:nexaflow/features/water/presentation/pages/water_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/water',
        builder: (context, state) => const WaterPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (context, state) => const HomePage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/habits',
                builder: (context, state) => const HabitsPage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/focus',
                builder: (context, state) => const FocusPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/ai', builder: (context, state) => const AIPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
