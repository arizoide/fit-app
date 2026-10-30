import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeState = ref.watch(activeWorkoutProvider);
    final elapsedSecs = activeState?.elapsedSeconds ?? 3120;
    final totalVolume = activeState?.calculateTotalVolumeKg() ?? 12450.0;
    final completedSets = activeState?.completedSetsCount ?? 18;
    final totalSets = activeState?.totalSetsCount ?? 18;
    final workoutTitle = activeState?.workoutDay.title ?? 'Treino A - Peito e Tríceps';

    final minutes = elapsedSecs ~/ 60;
    final estimatedCalories = (minutes * 6.5).round();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.neonLime.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.neonLime, width: 2),
                ),
                child: const Icon(Icons.emoji_events, color: AppColors.neonLime, size: 44),
              ),
              const SizedBox(height: 16),
              Text('TREINO CONCLUÍDO!', style: AppTextStyles.heading1.copyWith(color: AppColors.neonLime)),
              const SizedBox(height: 6),
              Text(
                'Excelente intensidade e adesão ao volume prescrito.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 28),

              // Metric Cards Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.timer_outlined,
                      color: AppColors.electricCyan,
                      label: 'Duração',
                      value: '$minutes min',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.fitness_center,
                      color: AppColors.neonLime,
                      label: 'Volume Total',
                      value: '${totalVolume.toInt()} kg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.checklist_rtl,
                      color: AppColors.purpleAccent,
                      label: 'Séries Realizadas',
                      value: '$completedSets / $totalSets',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      icon: Icons.local_fire_department,
                      color: AppColors.pulseOrange,
                      label: 'Gasto Estimado',
                      value: '$estimatedCalories kcal',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resumo da Sessão', style: AppTextStyles.labelBold),
                    const SizedBox(height: 8),
                    Text(workoutTitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    Text(
                      'Tensão mecânica efetiva registrada. Suas cargas foram salvas no histórico para sugestão de sobrecarga progressiva na próxima semana.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              NeonButton(
                text: 'Salvar e Voltar ao Início',
                onPressed: () {
                  ref.read(activeWorkoutProvider.notifier).endWorkout();
                  context.go('/workout-plan');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.heading2.copyWith(fontSize: 20)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
