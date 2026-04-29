import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/core/navigation/main_screen.dart';
import 'package:my_portfolio/features/home/home_screen.dart';
import 'package:my_portfolio/features/projects/projects_screen.dart';
import 'package:my_portfolio/features/projects/project_detail_screen.dart';
import 'package:my_portfolio/features/experience/experience_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      // ── Shell: persistent nav chrome ──────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProjectsScreen()),
          ),
          GoRoute(
            path: '/experience',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ExperienceScreen()),
          ),
        ],
      ),

      // ── Project detail: full-screen with Hero animation ───────────────
      // Intentionally outside ShellRoute so it renders without the nav chrome.
      GoRoute(
        path: '/projects/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return MaterialPage(
            // MaterialPage uses the default Hero flight path.
            child: ProjectDetailScreen(projectId: id),
          );
        },
      ),
    ],
  );
}
