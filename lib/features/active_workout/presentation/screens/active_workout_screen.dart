import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/widgets/muscle_tag.dart';
import 'package:fitmorph_ai/core/widgets/rest_timer_dialog.dart';
import 'package:fitmorph_ai/core/widgets/exercise_guide_dialog.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/exercise_substitution/presentation/widgets/exercise_substitution_modal.dart';
import 'package:fitmorph_ai/features/active_workout/presentation/widgets/active_set_row.dart';
import 'package:fitmorph_ai/features/active_workout/presentation/widgets/plate_calculator_dialog.dart';
import 'package:fitmorph_ai/features/active_workout/presentation/widgets/active_cardio_tracker_card.dart';
import 'package:fitmorph_ai/core/widgets/rpe_dictionary_dialog.dart';
import 'package:fitmorph_ai/core/utils/first_day_weight_helper.dart';

class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key});

  String _formatTimer(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showRestModal(BuildContext context, WidgetRef ref, int seconds, String nextName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RestTimerDialog(
        initialSeconds: seconds,
        nextExerciseName: nextName,
        onCompleted: () => ref.read(activeWorkoutProvider.notifier).stopRestTimer(),
        onSkip: () => ref.read(activeWorkoutProvider.notifier).stopRestTimer(),
      ),
    );
  }

  void _showTimeCompressDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.bolt, color: AppColors.pulseOrange),
            const SizedBox(width: 8),
            Text('Compactar Treino', style: AppTextStyles.heading3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pouco tempo hoje? A IA converte seu treino em Bi-sets antagônicos e ajusta os descansos para manter o volume em menor tempo!',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [25, 30, 45].map((mins) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pulseOrange.withOpacity(0.2),
                        foregroundColor: AppColors.pulseOrange,
                        side: const BorderSide(color: AppColors.pulseOrange),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        ref.read(activeWorkoutProvider.notifier).compactWorkout(mins);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('⚡ Treino compactado para $mins minutos com Bi-sets!'),
                            backgroundColor: AppColors.pulseOrange,
                          ),
                        );
                      },
                      child: Text('$mins min'),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeState = ref.watch(activeWorkoutProvider);
    final anamnese = ref.watch(anamneseProvider);

    if (activeState == null) {
      final workoutPlan = ref.watch(workoutPlanProvider).value;
      final recommendedDay = (workoutPlan != null && workoutPlan.days.isNotEmpty) ? workoutPlan.days.first : null;

      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.fitness_center, color: AppColors.neonLime),
              const SizedBox(width: 8),
              Text('Treino Ativo', style: AppTextStyles.heading2),
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.neonLime.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.neonLime.withOpacity(0.5), width: 1.5),
                  ),
                  child: const Icon(Icons.flash_on, size: 40, color: AppColors.neonLime),
                ),
                const SizedBox(height: 20),
                Text(
                  recommendedDay != null ? 'Pronto para Treinar Hoje?' : 'Nenhum Treino em Andamento',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  recommendedDay != null
                      ? 'Inicie o treino de hoje imediatamente com 1 clique abaixo:'
                      : 'Crie uma ficha de treino com a IA para iniciar sua rotina.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),
                if (recommendedDay != null) ...[
                  GlassCard(
                    borderColor: AppColors.neonLime.withOpacity(0.6),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.neonLime.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.neonLime, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  recommendedDay.dayLetter,
                                  style: AppTextStyles.labelBold.copyWith(color: AppColors.neonLime),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recommendedDay.title,
                                    style: AppTextStyles.heading3.copyWith(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${recommendedDay.exercises.length} exercícios • ~${recommendedDay.estimatedMinutes} min',
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: recommendedDay.focusMuscles.map((m) => MuscleTag(muscleName: m)).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  NeonButton(
                    text: 'INICIAR ${recommendedDay.title.toUpperCase()}',
                    icon: Icons.play_arrow,
                    height: 50,
                    onPressed: () {
                      ref.read(activeWorkoutProvider.notifier).startWorkout(recommendedDay);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                OutlinedButton.icon(
                  icon: const Icon(Icons.format_list_bulleted, size: 16, color: AppColors.electricCyan),
                  label: const Text(
                    'Ver Ficha Completa',
                    style: TextStyle(color: AppColors.electricCyan, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.electricCyan),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => context.go('/workout-plan'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final day = activeState.workoutDay;
    final totalVolume = activeState.calculateTotalVolumeKg();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Active Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(day.title, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _formatTimer(activeState.elapsedSeconds),
                                style: AppTextStyles.labelBold.copyWith(
                                  color: AppColors.neonLime,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${totalVolume.toInt()} kg levantados',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.bolt, color: AppColors.pulseOrange),
                            tooltip: 'Modo Express / Tempo Curto',
                            onPressed: () => _showTimeCompressDialog(context, ref),
                          ),
                          IconButton(
                            icon: Icon(
                              activeState.isPaused ? Icons.play_arrow : Icons.pause,
                              color: AppColors.neonLime,
                            ),
                            onPressed: () => ref.read(activeWorkoutProvider.notifier).togglePause(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: activeState.progressPercentage,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonLime),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${activeState.completedSetsCount} de ${activeState.totalSetsCount} séries concluídas',
                        style: AppTextStyles.bodySmall,
                      ),
                      Text(
                        '${(activeState.progressPercentage * 100).toInt()}%',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.neonLime, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Exercise List & Cardio Tracker
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: day.exercises.length + (day.cardioProtocol != null ? 1 : 0),
                itemBuilder: (context, exIdx) {
                  if (exIdx == day.exercises.length) {
                    return ActiveCardioTrackerCard(cardioProtocol: day.cardioProtocol!);
                  }

                  final exercise = day.exercises[exIdx];
                  final isSuperSet = exercise.isSuperSet;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: GlassCard(
                      borderColor: isSuperSet ? AppColors.pulseOrange.withOpacity(0.6) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isSuperSet) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.pulseOrange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.bolt, color: AppColors.pulseOrange, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    exercise.superSetGroup ?? 'BI-SET',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.pulseOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise.name,
                                      style: AppTextStyles.heading3.copyWith(fontSize: 17),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        MuscleTag(muscleName: exercise.targetMuscle),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.surfaceLight,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${exercise.repsRange} reps • ${exercise.rpeTarget}',
                                            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.info_outline, color: AppColors.electricCyan, size: 20),
                                    tooltip: 'Ver Aparelho & Regulagem',
                                    onPressed: () {
                                      ExerciseGuideDialog.show(context, exercise.exerciseCatalogId);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.calculate_outlined, color: AppColors.electricCyan, size: 20),
                                    tooltip: 'Calculadora de Anilhas',
                                    onPressed: () {
                                      final currentWeight = exercise.sets.first.weightKg ?? 40.0;
                                      PlateCalculatorDialog.show(context, currentWeight);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.swap_horiz, color: AppColors.neonLime, size: 22),
                                    tooltip: 'Substituir Aparelho',
                                    onPressed: () {
                                       ExerciseSubstitutionModal.show(
                                         context: context,
                                         currentExercise: exercise,
                                         location: anamnese.location,
                                         onSelectSubstitute: (newDef) {
                                           ref.read(activeWorkoutProvider.notifier).swapExercise(
                                             exerciseIndex: exIdx,
                                             newExerciseDef: newDef,
                                           );
                                         },
                                       );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (exercise.notes.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              exercise.notes,
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                          const SizedBox(height: 8),

                          // Balãozinho Dicionário RPE
                          InkWell(
                            onTap: () => RpeDictionaryDialog.show(context),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.neonLime),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Dicionário RPE: "Pare quando sentir que aguentaria só mais 2 reps"',
                                      style: TextStyle(fontSize: 10.5, color: Colors.white, fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(Icons.help_outline, size: 14, color: Color(0xFF94A3B8)),
                                ],
                              ),
                            ),
                          ),

                          // Sugestão de Carga para o 1º Dia
                          Builder(
                            builder: (ctx) {
                              final advice = FirstDayWeightHelper.getAdvice(
                                exerciseName: exercise.name,
                                equipment: exercise.equipment,
                                muscle: exercise.targetMuscle,
                              );
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFBBF7D0)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(advice.icon, size: 15, color: const Color(0xFF16A34A)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Sugestão 1º Dia: ',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF15803D),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  advice.targetZone,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFF166534),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            advice.safetyTip,
                                            style: const TextStyle(fontSize: 10, color: Color(0xFF166534)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // Set Rows
                          ...List.generate(exercise.sets.length, (setIdx) {
                            final set = exercise.sets[setIdx];
                            return ActiveSetRow(
                              exerciseIndex: exIdx,
                              setIndex: setIdx,
                              set: set,
                              repsRange: exercise.repsRange,
                              onComplete: (weight, reps, rpe) {
                                ref.read(activeWorkoutProvider.notifier).completeSet(
                                  exerciseIndex: exIdx,
                                  setIndex: setIdx,
                                  weightKg: weight,
                                  reps: reps,
                                  rpe: rpe,
                                );
                                // Suggest rest popup
                                final nextName = (exIdx < day.exercises.length - 1)
                                    ? day.exercises[exIdx + 1].name
                                    : 'Fim do Treino';
                                _showRestModal(context, ref, exercise.restSeconds, nextName);
                              },
                              onUncomplete: () {
                                ref.read(activeWorkoutProvider.notifier).uncompleteSet(
                                  exerciseIndex: exIdx,
                                  setIndex: setIdx,
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Finish Action Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.cardBorder)),
              ),
              child: NeonButton(
                text: 'Finalizar Treino',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  context.push('/workout-summary');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
