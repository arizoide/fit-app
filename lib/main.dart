import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_theme.dart';
import 'core/network/supabase_config.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/anamnese/presentation/screens/anamnese_wizard_screen.dart';
import 'features/workout_generator/presentation/screens/workout_plan_screen.dart';
import 'features/workout_generator/presentation/screens/workout_day_detail_screen.dart';
import 'features/active_workout/presentation/screens/active_workout_screen.dart';
import 'features/active_workout/presentation/screens/workout_summary_screen.dart';
import 'features/body_biometrics/presentation/screens/body_biometrics_screen.dart';
import 'features/diet_calories/presentation/screens/diet_calories_screen.dart';
import 'features/profile_history/presentation/screens/profile_screen.dart';
import 'features/profile_history/presentation/screens/history_screen.dart';
import 'features/navigation/presentation/screens/main_shell_screen.dart';
import 'features/ranking/presentation/screens/ranking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  runApp(
    const ProviderScope(
      child: FitMorphApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/anamnese',
      builder: (context, state) => const AnamneseWizardScreen(),
    ),
    GoRoute(
      path: '/ranking',
      builder: (context, state) => const RankingScreen(),
    ),
    GoRoute(
      path: '/workout-day/:id',
      builder: (context, state) {
        final dayId = state.pathParameters['id'] ?? '';
        return WorkoutDayDetailScreen(dayId: dayId);
      },
    ),
    GoRoute(
      path: '/workout-summary',
      builder: (context, state) => const WorkoutSummaryScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/workout-plan',
          builder: (context, state) => const WorkoutPlanScreen(),
        ),
        GoRoute(
          path: '/active-workout',
          builder: (context, state) => const ActiveWorkoutScreen(),
        ),
        GoRoute(
          path: '/biometrics',
          builder: (context, state) => const BodyBiometricsScreen(),
        ),
        GoRoute(
          path: '/diet',
          builder: (context, state) => const DietCaloriesScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

class FitMorphApp extends StatelessWidget {
  const FitMorphApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitMorph AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.iceWhiteTheme,
      routerConfig: _router,
    );
  }
}
