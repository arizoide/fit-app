import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/widgets/muscle_tag.dart';
import 'package:fitmorph_ai/core/widgets/equipment_visual_card.dart';

class ExerciseGuideDialog extends StatelessWidget {
  final ExerciseDefinition exercise;

  const ExerciseGuideDialog({super.key, required this.exercise});

  static Future<void> show(BuildContext context, String exerciseId) {
    final def = ExerciseCatalog.findById(exerciseId) ??
        ExerciseDefinition(
          id: exerciseId,
          name: 'Exercício',
          muscleGroup: 'Geral',
          secondaryMuscles: [],
          equipment: 'Livre',
          mechanics: 'Composto',
          instructions: 'Execute o movimento com amplitude completa e controle na fase excêntrica.',
          commonMistakes: ['Excesso de carga com perda de técnica'],
          substituteIds: [],
        );

    return showDialog(
      context: context,
      builder: (context) => ExerciseGuideDialog(exercise: def),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(exercise.name, style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  MuscleTag(muscleName: exercise.muscleGroup),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${exercise.mechanics} • ${exercise.equipment}',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Visual Equipment / Machine Showcase
              EquipmentVisualCard(
                equipmentName: exercise.equipment,
                exerciseName: exercise.name,
                exerciseId: exercise.id,
                showAdjustmentGuide: true,
                height: 180,
              ),
              const SizedBox(height: 16),

              // Step-by-Step Instructions
              Text('Instruções de Execução:', style: AppTextStyles.labelBold),
              const SizedBox(height: 6),
              Text(
                exercise.instructions,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, height: 1.4),
              ),
              const SizedBox(height: 16),

              // Secondary Muscles
              if (exercise.secondaryMuscles.isNotEmpty) ...[
                Text('Músculos Sinergistas (Secundários):', style: AppTextStyles.labelBold),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: exercise.secondaryMuscles
                      .map((m) => MuscleTag(muscleName: m, isSecondary: true))
                      .toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Common Mistakes Checklist
              if (exercise.commonMistakes.isNotEmpty) ...[
                Text('Erros Comuns a Evitar:', style: AppTextStyles.labelBold.copyWith(color: AppColors.alertRed)),
                const SizedBox(height: 8),
                ...exercise.commonMistakes.map((mistake) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.cancel_outlined, color: AppColors.alertRed, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            mistake,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],

              NeonButton(
                text: 'Fechar Guia',
                onPressed: () => Navigator.of(context).pop(),
                height: 44,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
