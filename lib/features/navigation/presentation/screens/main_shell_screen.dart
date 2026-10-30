import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/app_providers.dart';

class MainShellScreen extends ConsumerWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/workout-plan') || location.startsWith('/workout-day')) {
      return 0;
    }
    if (location.startsWith('/active-workout')) {
      return 1;
    }
    if (location.startsWith('/biometrics')) {
      return 2;
    }
    if (location.startsWith('/diet')) {
      return 3;
    }
    if (location.startsWith('/profile') || location.startsWith('/history')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/workout-plan');
        break;
      case 1:
        context.go('/active-workout');
        break;
      case 2:
        context.go('/biometrics');
        break;
      case 3:
        context.go('/diet');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWorkout = ref.watch(activeWorkoutProvider);
    final isWorkoutActive = activeWorkout != null;
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.neonLime,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Ficha',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.play_circle_outline),
                  if (isWorkoutActive)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.neonLime,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Treino Ativo',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.remove_red_eye_outlined),
              label: 'Biometria',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Nutrição',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
