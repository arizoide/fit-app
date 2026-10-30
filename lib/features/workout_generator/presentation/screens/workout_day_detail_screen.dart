import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/widgets/muscle_tag.dart';
import 'package:fitmorph_ai/core/widgets/exercise_guide_dialog.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/exercise_substitution/presentation/widgets/exercise_substitution_modal.dart';
import 'package:fitmorph_ai/features/workout_generator/presentation/widgets/express_workout_modal.dart';
import 'package:fitmorph_ai/core/widgets/rpe_dictionary_dialog.dart';
import 'package:fitmorph_ai/core/utils/first_day_weight_helper.dart';

class WorkoutDayDetailScreen extends ConsumerWidget {
  final String dayId;

  const WorkoutDayDetailScreen({super.key, required this.dayId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutPlanAsync = ref.watch(workoutPlanProvider);
    final anamnese = ref.watch(anamneseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Treino'),
      ),
      body: workoutPlanAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erro: $err')),
        data: (plan) {
          if (plan == null) {
            return const Center(child: Text('Nenhum treino encontrado.'));
          }

          final day = plan.days.firstWhere(
            (d) => d.id == dayId,
            orElse: () => plan.days.first,
          );

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Header
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.neonLime,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    day.dayLetter,
                                    style: AppTextStyles.labelBold.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(day.title, style: AppTextStyles.heading2),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ...day.focusMuscles.map((m) => MuscleTag(muscleName: m)),
                              if (day.focusMuscles.length >= 2)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.neonLime.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.neonLime.withOpacity(0.4)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.hub, size: 12, color: AppColors.neonLime),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Multi-Músculo (${day.focusMuscles.length} Grupos)',
                                        style: const TextStyle(fontSize: 10, color: AppColors.neonLime, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Duração Estimada: ${day.estimatedMinutes} minutos • ${day.exercises.length} Exercícios',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Express Mode Banner / Trigger
                    if (day.isExpressMode)
                      GlassCard(
                        borderColor: AppColors.pulseOrange,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.pulseOrange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.bolt, color: AppColors.pulseOrange, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Modo Express Ativo (${day.estimatedMinutes} min)',
                                        style: AppTextStyles.labelBold.copyWith(color: AppColors.pulseOrange),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Composto 80/20 • Séries condensadas',
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.tune, color: AppColors.pulseOrange),
                              tooltip: 'Alterar Tempo',
                              onPressed: () => ExpressWorkoutModal.show(context, ref, day),
                            ),
                            IconButton(
                              icon: const Icon(Icons.restore, color: AppColors.electricCyan),
                              tooltip: 'Restaurar Original',
                              onPressed: () {
                                ref.read(workoutPlanProvider.notifier).restoreOriginalDay(dayId: day.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Treino original completo restaurado!'),
                                    backgroundColor: AppColors.electricCyan,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    else
                      InkWell(
                        onTap: () => ExpressWorkoutModal.show(context, ref, day),
                        borderRadius: BorderRadius.circular(16),
                        child: GlassCard(
                          borderColor: AppColors.pulseOrange.withOpacity(0.4),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.pulseOrange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.pulseOrange.withOpacity(0.5)),
                                ),
                                child: const Icon(Icons.bolt, color: AppColors.pulseOrange, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '⏱️ Pouco tempo hoje?',
                                          style: AppTextStyles.labelBold.copyWith(color: AppColors.pulseOrange),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.pulseOrange.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '15-30 min',
                                            style: AppTextStyles.bodySmall.copyWith(
                                              color: AppColors.pulseOrange,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Adapte este treino para o tempo exato que você tem.',
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.pulseOrange),
                            ],
                          ),
                        ),
                      ),

                    if (day.cardioProtocol != null) ...[
                      const SizedBox(height: 20),
                      Text('Cardio & Aeróbico Prescrito', style: AppTextStyles.labelBold),
                      const SizedBox(height: 12),
                      GlassCard(
                        borderColor: AppColors.pulseOrange.withOpacity(0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.pulseOrange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.pulseOrange.withOpacity(0.6)),
                                  ),
                                  child: const Icon(Icons.directions_run, color: AppColors.pulseOrange, size: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        day.cardioProtocol!.title,
                                        style: AppTextStyles.heading3.copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${day.cardioProtocol!.durationMinutes} min • ~${day.cardioProtocol!.estimatedCalories} kcal • ${day.cardioProtocol!.intensityZone}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.neonLime,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.info_outline, color: AppColors.electricCyan, size: 22),
                                  tooltip: 'Ver Aparelho & Regulagem',
                                  onPressed: () {
                                    final equip = day.cardioProtocol!.equipment.toLowerCase();
                                    String guideId = 'cardio_incline_treadmill';
                                    if (equip.contains('escada')) guideId = 'cardio_stairmaster';
                                    if (equip.contains('bike') || equip.contains('bicicleta')) guideId = 'cardio_stationary_bike';
                                    if (equip.contains('elíptico') || equip.contains('eliptico')) guideId = 'cardio_elliptical';
                                    if (equip.contains('corda')) guideId = 'cardio_jump_rope';
                                    if (equip.contains('peso corporal') || equip.contains('caminhada')) guideId = 'cardio_outdoor_walk';
                                    ExerciseGuideDialog.show(context, guideId);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.speed, color: AppColors.electricCyan, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Ajuste do Aparelho & Intensidade:',
                                        style: AppTextStyles.labelBold.copyWith(fontSize: 12, color: AppColors.electricCyan),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    day.cardioProtocol!.speedInclineRecommendation,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (day.cardioProtocol!.notes.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      day.cardioProtocol!.notes,
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, height: 1.3),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    Text('Exercícios de Musculação', style: AppTextStyles.labelBold),
                    const SizedBox(height: 12),

                    ...day.exercises.asMap().entries.map((entry) {
                      final index = entry.key;
                      final exercise = entry.value;

                                   final def = ExerciseCatalog.findById(exercise.exerciseCatalogId);
                                   return Container(
                                     margin: const EdgeInsets.only(bottom: 14),
                                     child: GlassCard(
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Row(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Container(
                                                 width: 28,
                                                 height: 28,
                                                 decoration: BoxDecoration(
                                                   color: AppColors.surfaceLight,
                                                   borderRadius: BorderRadius.circular(6),
                                                 ),
                                                 child: Center(
                                                   child: Text(
                                                     '${index + 1}',
                                                     style: AppTextStyles.bodySmall.copyWith(
                                                       fontWeight: FontWeight.bold,
                                                       color: AppColors.neonLime,
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                               const SizedBox(width: 12),
                                               Expanded(
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Text(exercise.name, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                                                     const SizedBox(height: 4),
                                                     Wrap(
                                                       spacing: 6,
                                                       runSpacing: 4,
                                                       crossAxisAlignment: WrapCrossAlignment.center,
                                                       children: [
                                                         MuscleTag(muscleName: exercise.targetMuscle),
                                                         if (def != null && def.secondaryMuscles.isNotEmpty)
                                                           Container(
                                                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                             decoration: BoxDecoration(
                                                               color: AppColors.electricCyan.withOpacity(0.12),
                                                               borderRadius: BorderRadius.circular(4),
                                                               border: Border.all(color: AppColors.electricCyan.withOpacity(0.35)),
                                                             ),
                                                             child: Row(
                                                               mainAxisSize: MainAxisSize.min,
                                                               children: [
                                                                 const Icon(Icons.hub, size: 10, color: AppColors.electricCyan),
                                                                 const SizedBox(width: 3),
                                                                 Text(
                                                                   '+ ${def.secondaryMuscles.join(', ')}',
                                                                   style: const TextStyle(
                                                                     fontSize: 10,
                                                                     color: AppColors.electricCyan,
                                                                     fontWeight: FontWeight.bold,
                                                                   ),
                                                                 ),
                                                               ],
                                                             ),
                                                           ),
                                                         Text(
                                                           exercise.equipment,
                                                           style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
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
                                        tooltip: 'Guia Postural & Execução',
                                        onPressed: () {
                                          ExerciseGuideDialog.show(context, exercise.exerciseCatalogId);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.swap_horiz, color: AppColors.neonLime, size: 20),
                                        tooltip: 'Substituir',
                                        onPressed: () {
                                          ExerciseSubstitutionModal.show(
                                            context: context,
                                            currentExercise: exercise,
                                            location: anamnese.location,
                                            onSelectSubstitute: (newDef) {
                                              ref.read(workoutPlanProvider.notifier).swapExerciseInPlan(
                                                dayId: day.id,
                                                oldExerciseId: exercise.id,
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
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildParam('Séries', '${exercise.setsCount}x'),
                                    _buildParam('Reps', exercise.repsRange),
                                    _buildParam('Esforço', exercise.rpeTarget),
                                    _buildParam('Descanso', '${exercise.restSeconds}s'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Balãozinho Dicionário RPE/RIR
                              InkWell(
                                onTap: () => RpeDictionaryDialog.show(context),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
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
                              const SizedBox(height: 6),

                              // Sugestão de Carga para o 1º Dia
                              Builder(
                                builder: (ctx) {
                                  final advice = FirstDayWeightHelper.getAdvice(
                                    exerciseName: exercise.name,
                                    equipment: exercise.equipment,
                                    muscle: exercise.targetMuscle,
                                  );
                                  return Container(
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
                              if (exercise.notes.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.info_outline, size: 14, color: AppColors.electricCyan),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        exercise.notes,
                                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Bottom Start Workout Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.cardBorder)),
                ),
                child: NeonButton(
                  text: 'Iniciar Treino Agora',
                  icon: Icons.play_arrow,
                  onPressed: () {
                    ref.read(activeWorkoutProvider.notifier).startWorkout(day);
                    context.go('/active-workout');
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildParam(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.labelBold.copyWith(fontSize: 13, color: AppColors.neonLime)),
      ],
    );
  }
}
