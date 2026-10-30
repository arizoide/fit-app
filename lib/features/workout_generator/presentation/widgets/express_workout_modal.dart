import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/widgets/muscle_tag.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/workout_generator/domain/models/workout_models.dart';

class ExpressWorkoutModal extends StatefulWidget {
  final WorkoutDay workoutDay;
  final WidgetRef ref;

  const ExpressWorkoutModal({
    super.key,
    required this.workoutDay,
    required this.ref,
  });

  static Future<void> show(BuildContext context, WidgetRef ref, WorkoutDay workoutDay) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExpressWorkoutModal(
        workoutDay: workoutDay,
        ref: ref,
      ),
    );
  }

  @override
  State<ExpressWorkoutModal> createState() => _ExpressWorkoutModalState();
}

class _ExpressWorkoutModalState extends State<ExpressWorkoutModal> {
  late int _selectedMinutes;

  @override
  void initState() {
    super.initState();
    final originalTime = widget.workoutDay.originalEstimatedMinutes ?? widget.workoutDay.estimatedMinutes;
    // Default to 20 or 30 min if current is longer, or current
    _selectedMinutes = widget.workoutDay.isExpressMode
        ? widget.workoutDay.estimatedMinutes
        : (originalTime > 30 ? 20 : 15);
  }

  @override
  Widget build(BuildContext context) {
    final originalTime = widget.workoutDay.originalEstimatedMinutes ?? widget.workoutDay.estimatedMinutes;
    final adaptedPreview = widget.workoutDay.adaptToExpressTime(_selectedMinutes);

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.pulseOrange, width: 2.5)),
      ),
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.pulseOrange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.bolt, color: AppColors.pulseOrange, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Modo Treino Express', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                        Text('Pouco tempo hoje? A IA otimiza sua sessão', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.cardBorder, height: 1),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pareto Principle Info Card
                  GlassCard(
                    borderColor: AppColors.pulseOrange.withOpacity(0.4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome, color: AppColors.pulseOrange, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ciência da Otimização (Pareto 80/20)',
                                style: AppTextStyles.labelBold.copyWith(color: AppColors.pulseOrange),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Mantemos os exercícios multiarticulares mais anabólicos, reduzimos o volume redundante e aceleramos os intervalos de descanso.',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Time Selection Section
                  Text('Quanto tempo você tem disponível hoje?', style: AppTextStyles.labelBold),
                  const SizedBox(height: 12),

                  // Quick Preset Chips
                  Row(
                    children: [
                      _buildPresetChip(15, '15 min', 'Super Rápido'),
                      const SizedBox(width: 8),
                      _buildPresetChip(20, '20 min', 'Express'),
                      const SizedBox(width: 8),
                      _buildPresetChip(30, '30 min', 'Equilibrado'),
                      const SizedBox(width: 8),
                      _buildPresetChip(45, '45 min', 'Compacto'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Slider
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.electricCyan, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Duração Alvo: $_selectedMinutes minutos',
                        style: AppTextStyles.labelBold.copyWith(color: AppColors.electricCyan),
                      ),
                      const Spacer(),
                      Text(
                        'Original: $originalTime min',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.pulseOrange,
                      thumbColor: AppColors.pulseOrange,
                      inactiveTrackColor: AppColors.surfaceLight,
                      overlayColor: AppColors.pulseOrange.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _selectedMinutes.toDouble(),
                      min: 10,
                      max: 60,
                      divisions: 10,
                      label: '$_selectedMinutes min',
                      onChanged: (val) {
                        setState(() => _selectedMinutes = val.round());
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Live Preview Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Prévia do Treino Adaptado', style: AppTextStyles.labelBold),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.neonLime.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.neonLime.withOpacity(0.4)),
                        ),
                        child: Text(
                          '${adaptedPreview.exercises.length} de ${widget.workoutDay.originalExercises?.length ?? widget.workoutDay.exercises.length} Exercícios',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.neonLime,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Preview Summary Stats Card
                  GlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCol(
                          'Tempo Alvo',
                          '$_selectedMinutes min',
                          Icons.schedule,
                          AppColors.pulseOrange,
                        ),
                        _buildStatCol(
                          'Séries / Ex',
                          '${adaptedPreview.exercises.firstOrNull?.setsCount ?? 2}x',
                          Icons.repeat,
                          AppColors.neonLime,
                        ),
                        _buildStatCol(
                          'Descanso',
                          '${adaptedPreview.exercises.firstOrNull?.restSeconds ?? 45}s',
                          Icons.hourglass_empty,
                          AppColors.electricCyan,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Exercise List Preview
                  ...adaptedPreview.exercises.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final ex = entry.value;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.pulseOrange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                '${idx + 1}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.pulseOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ex.name,
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    MuscleTag(muscleName: ex.targetMuscle),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${ex.setsCount}x • ${ex.repsRange} • ${ex.restSeconds}s rest',
                                      style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.check_circle_outline, color: AppColors.neonLime, size: 18),
                        ],
                      ),
                    );
                  }),

                  // Cardio preview if present
                  if (adaptedPreview.cardioProtocol != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.pulseOrange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.pulseOrange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.directions_run, color: AppColors.pulseOrange, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  adaptedPreview.cardioProtocol!.title,
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${adaptedPreview.cardioProtocol!.durationMinutes} min • ${adaptedPreview.cardioProtocol!.intensityZone}',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.pulseOrange),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (widget.workoutDay.isExpressMode) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.restore, color: AppColors.textMuted, size: 18),
                        label: const Text(
                          'Restaurar Treino Original Completo',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                        onPressed: () {
                          widget.ref.read(workoutPlanProvider.notifier).restoreOriginalDay(dayId: widget.workoutDay.id);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Treino original completo restaurado!'),
                              backgroundColor: AppColors.electricCyan,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.check, color: AppColors.neonLime, size: 18),
                    label: const Text(
                      'Salvar no Plano',
                      style: TextStyle(color: AppColors.neonLime, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.neonLime),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      widget.ref.read(workoutPlanProvider.notifier).adaptDayForExpressTime(
                            dayId: widget.workoutDay.id,
                            targetMinutes: _selectedMinutes,
                          );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('⚡ Treino adaptado para $_selectedMinutes min com sucesso!'),
                          backgroundColor: AppColors.pulseOrange,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeonButton(
                    text: 'Treinar Agora',
                    icon: Icons.play_arrow,
                    onPressed: () {
                      // Adapt day and launch active workout immediately
                      final expressDay = widget.workoutDay.adaptToExpressTime(_selectedMinutes);
                      widget.ref.read(workoutPlanProvider.notifier).adaptDayForExpressTime(
                            dayId: widget.workoutDay.id,
                            targetMinutes: _selectedMinutes,
                          );
                      widget.ref.read(activeWorkoutProvider.notifier).startWorkout(expressDay);
                      Navigator.of(context).pop();
                      context.go('/active-workout');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(int minutes, String label, String sub) {
    final isSelected = _selectedMinutes == minutes;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedMinutes = minutes),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.pulseOrange.withOpacity(0.2) : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.pulseOrange : AppColors.cardBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.pulseOrange : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sub,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 9,
                  color: isSelected ? AppColors.pulseOrange : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.labelBold.copyWith(color: color, fontSize: 13)),
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}
