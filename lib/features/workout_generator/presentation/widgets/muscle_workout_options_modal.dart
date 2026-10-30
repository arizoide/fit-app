import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/widgets/muscle_tag.dart';
import 'package:fitmorph_ai/core/widgets/exercise_guide_dialog.dart';

class MuscleWorkoutOptionsModal extends StatefulWidget {
  final String muscleName;
  final String? anatomicalDetail;
  final int? weeklyVolume;

  const MuscleWorkoutOptionsModal({
    super.key,
    required this.muscleName,
    this.anatomicalDetail,
    this.weeklyVolume,
  });

  static Future<void> show(
    BuildContext context, {
    required String muscleName,
    String? anatomicalDetail,
    int? weeklyVolume,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MuscleWorkoutOptionsModal(
        muscleName: muscleName,
        anatomicalDetail: anatomicalDetail,
        weeklyVolume: weeklyVolume,
      ),
    );
  }

  @override
  State<MuscleWorkoutOptionsModal> createState() => _MuscleWorkoutOptionsModalState();
}

class _MuscleWorkoutOptionsModalState extends State<MuscleWorkoutOptionsModal> {
  String _selectedFilter = 'all'; // 'all', 'gym', 'home', 'bodyweight'
  final String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    String? locationFilter;
    if (_selectedFilter == 'home') locationFilter = 'homeGym';
    if (_selectedFilter == 'bodyweight') locationFilter = 'bodyweightOnly';

    final allForMuscle = ExerciseCatalog.getExercisesForMuscle(widget.muscleName);
    final filteredExercises = ExerciseCatalog.getExercisesForMuscle(
      widget.muscleName,
      locationFilter: locationFilter,
    ).where((e) {
      if (_searchQuery.isNotEmpty) {
        return e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            e.equipment.toLowerCase().contains(_searchQuery.toLowerCase());
      }
      return true;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.neonLime, width: 2.5)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.neonLime.withOpacity(0.18),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.neonLime.withOpacity(0.6)),
                      ),
                      child: const Icon(Icons.fitness_center, color: AppColors.neonLime, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.muscleName,
                              style: AppTextStyles.heading2.copyWith(fontSize: 19),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Text(
                                '${allForMuscle.length} opções',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.electricCyan,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.anatomicalDetail != null)
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              widget.anatomicalDetail!,
                              style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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

          // Filters Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', 'Todos (${allForMuscle.length})', Icons.grid_view),
                  const SizedBox(width: 8),
                  _buildFilterChip('gym', '🏋️ Academia / Máquinas', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('home', '🏠 Halteres / Casa', null),
                  const SizedBox(width: 8),
                  _buildFilterChip('bodyweight', '🤸 Calistenia / Livre', null),
                ],
              ),
            ),
          ),

          // Exercise List
          Expanded(
            child: filteredExercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text('Nenhum exercício encontrado com esse filtro.', style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => setState(() => _selectedFilter = 'all'),
                          child: const Text('Limpar Filtros', style: TextStyle(color: AppColors.neonLime)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];
                      return _buildExerciseItemCard(context, exercise);
                    },
                  ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: const Border(top: BorderSide(color: AppColors.cardBorder)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Fechar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Consumer(
                    builder: (context, ref, child) {
                      return NeonButton(
                        text: 'Montar Treino Focado',
                        icon: Icons.bolt,
                        height: 46,
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('⚡ IA gerando sessão focada em ${widget.muscleName}...'),
                              backgroundColor: AppColors.pulseOrange,
                            ),
                          );
                        },
                      );
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

  Widget _buildFilterChip(String filterKey, String label, IconData? icon) {
    final isSelected = _selectedFilter == filterKey;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = filterKey),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.neonLime.withOpacity(0.18) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.neonLime : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? AppColors.neonLime : AppColors.textMuted),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.neonLime : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItemCard(BuildContext context, ExerciseDefinition exercise) {
    final isCompound = exercise.mechanics.toLowerCase().contains('composto');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCompound ? AppColors.neonLime.withOpacity(0.15) : AppColors.electricCyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCompound ? AppColors.neonLime.withOpacity(0.4) : AppColors.electricCyan.withOpacity(0.4),
                    ),
                  ),
                  child: Icon(
                    isCompound ? Icons.fitness_center : Icons.accessibility_new,
                    color: isCompound ? AppColors.neonLime : AppColors.electricCyan,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: AppTextStyles.labelBold.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Text(
                              exercise.equipment,
                              style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (isCompound ? AppColors.neonLime : AppColors.electricCyan).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              exercise.mechanics,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isCompound ? AppColors.neonLime : AppColors.electricCyan,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: AppColors.electricCyan, size: 20),
                  tooltip: 'Guia de Execução',
                  onPressed: () => ExerciseGuideDialog.show(context, exercise.id),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              exercise.instructions,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (exercise.secondaryMuscles.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Text('Sinergistas: ', style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
                  ...exercise.secondaryMuscles.map(
                    (m) => MuscleTag(muscleName: m, isSecondary: true),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.menu_book_outlined, size: 16, color: AppColors.electricCyan),
                  label: const Text('Ver Técnica & Postura', style: TextStyle(color: AppColors.electricCyan, fontSize: 12)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => ExerciseGuideDialog.show(context, exercise.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
