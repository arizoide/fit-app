import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/muscle_tag.dart';
import 'package:fitmorph_ai/core/widgets/exercise_guide_dialog.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';
import 'package:fitmorph_ai/features/workout_generator/domain/models/workout_models.dart';

class ExerciseSubstitutionModal extends StatefulWidget {
  final WorkoutExercise currentExercise;
  final WorkoutLocation location;
  final Function(ExerciseDefinition) onSelectSubstitute;

  const ExerciseSubstitutionModal({
    super.key,
    required this.currentExercise,
    this.location = WorkoutLocation.commercialGym,
    required this.onSelectSubstitute,
  });

  static Future<void> show({
    required BuildContext context,
    required WorkoutExercise currentExercise,
    WorkoutLocation location = WorkoutLocation.commercialGym,
    required Function(ExerciseDefinition) onSelectSubstitute,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ExerciseSubstitutionModal(
        currentExercise: currentExercise,
        location: location,
        onSelectSubstitute: onSelectSubstitute,
      ),
    );
  }

  @override
  State<ExerciseSubstitutionModal> createState() => _ExerciseSubstitutionModalState();
}

class _ExerciseSubstitutionModalState extends State<ExerciseSubstitutionModal> {
  String _selectedReason = 'Aparelho Ocupado';
  late List<ExerciseDefinition> _substitutes;

  final List<String> _reasons = [
    'Aparelho Ocupado',
    'Desconforto / Dor',
    'Sem esse equipamento',
    'Variação de estímulo',
  ];

  @override
  void initState() {
    super.initState();
    final filter = widget.location == WorkoutLocation.homeGym
        ? 'homeGym'
        : widget.location == WorkoutLocation.bodyweightOnly
            ? 'bodyweightOnly'
            : null;
    _substitutes = ExerciseCatalog.getSubstitutes(
      widget.currentExercise.exerciseCatalogId,
      locationFilter: filter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHome = widget.location == WorkoutLocation.homeGym;
    final isBodyweight = widget.location == WorkoutLocation.bodyweightOnly;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.swap_horiz, color: AppColors.neonLime, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Substituição Instantânea', style: AppTextStyles.heading2),
                    Text(
                      'Substituindo: ${widget.currentExercise.name}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isHome || isBodyweight) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (isHome ? AppColors.neonLime : AppColors.electricCyan).withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (isHome ? AppColors.neonLime : AppColors.electricCyan).withOpacity(0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isHome ? Icons.home_work_outlined : Icons.accessibility_new,
                    size: 16,
                    color: isHome ? AppColors.neonLime : AppColors.electricCyan,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isHome
                          ? 'Filtro Treino em Casa Ativo: Sugestões 100% com halteres e peso livre.'
                          : 'Filtro Calistenia Ativo: Sugestões 100% peso corporal.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isHome ? AppColors.neonLime : AppColors.electricCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text('Motivo da substituição:', style: AppTextStyles.labelBold),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _reasons.map((reason) {
                final isSel = _selectedReason == reason;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(reason),
                    selected: isSel,
                    selectedColor: AppColors.neonLime.withOpacity(0.25),
                    labelStyle: TextStyle(
                      color: isSel ? AppColors.neonLime : AppColors.textSecondary,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    backgroundColor: AppColors.surfaceLight,
                    side: BorderSide(
                      color: isSel ? AppColors.neonLime : AppColors.cardBorder,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedReason = reason);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Alternativas com o mesmo vetor biomecânico (${widget.currentExercise.targetMuscle}):',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _substitutes.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum substituto compatível encontrado no catálogo.',
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    itemCount: _substitutes.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _substitutes[index];
                      return GlassCard(
                        onTap: () {
                          widget.onSelectSubstitute(item);
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.neonLime.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                item.equipment == 'Máquina'
                                    ? Icons.precision_manufacturing
                                    : item.equipment == 'Cabos'
                                        ? Icons.cable
                                        : item.equipment == 'Peso Corporal'
                                            ? Icons.accessibility_new
                                            : Icons.fitness_center,
                                color: AppColors.neonLime,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      MuscleTag(muscleName: item.muscleGroup),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceLight,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item.equipment,
                                          style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.instructions,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.info_outline, color: AppColors.electricCyan, size: 20),
                              tooltip: 'Ver Foto/Esquema do Aparelho',
                              onPressed: () {
                                ExerciseGuideDialog.show(context, item.id);
                              },
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.neonLime),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
