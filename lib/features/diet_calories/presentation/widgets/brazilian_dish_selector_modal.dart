import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import '../../domain/models/brazilian_dish_options.dart';

class BrazilianDishSelectorModal extends StatelessWidget {
  final String mealName;
  final String mealType;
  final int targetCalories;
  final BrazilianDishOption? currentlySelected;
  final Function(BrazilianDishOption dish) onSelectDish;

  const BrazilianDishSelectorModal({
    super.key,
    required this.mealName,
    required this.mealType,
    required this.targetCalories,
    this.currentlySelected,
    required this.onSelectDish,
  });

  static Future<void> show({
    required BuildContext context,
    required String mealName,
    required String mealType,
    required int targetCalories,
    BrazilianDishOption? currentlySelected,
    required Function(BrazilianDishOption dish) onSelectDish,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BrazilianDishSelectorModal(
        mealName: mealName,
        mealType: mealType,
        targetCalories: targetCalories,
        currentlySelected: currentlySelected,
        onSelectDish: onSelectDish,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dishes = BrazilianDishesCatalog.getDishesForMeal(mealType);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de arraste
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.neonLime.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.restaurant, color: Color(0xFF15803D), size: 22),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pratos Caseiros: $mealName',
                        style: AppTextStyles.heading3.copyWith(fontSize: 16),
                      ),
                      Text(
                        'Meta: ~$targetCalories kcal • Comida brasileira de verdade',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
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
          const SizedBox(height: 12),

          // Dica prática para o iniciante
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: const [
                Icon(Icons.lightbulb_outline, color: Color(0xFF16A34A), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Você não precisa de balança todo dia! 1 concha de feijão = ~100g, 1 escumadeira de arroz = ~100g e a palma da mão = ~150g de frango.',
                    style: TextStyle(fontSize: 10.5, color: Color(0xFF166534)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Lista de Pratos
          Expanded(
            child: ListView.separated(
              itemCount: dishes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final dish = dishes[index];
                final isSelected = currentlySelected?.id == dish.id;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF0FDF4) : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.neonLime : AppColors.cardBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome & Calorias
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              dish.name,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? const Color(0xFF15803D) : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.neonLime.withOpacity(0.2)
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${dish.calories} kcal',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? const Color(0xFF15803D) : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Macros em Linha
                      Row(
                        children: [
                          _buildMacroPill('Proteína: ${dish.proteinGrams}g', const Color(0xFFDC2626)),
                          const SizedBox(width: 6),
                          _buildMacroPill('Carbs: ${dish.carbsGrams}g', const Color(0xFF0284C7)),
                          const SizedBox(width: 6),
                          _buildMacroPill('Gord: ${dish.fatsGrams}g', const Color(0xFFD97706)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Ingredientes
                      ...dish.ingredients.map((ing) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(
                                  ing,
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 8),

                      // Dica Prática
                      Text(
                        '💡 ${dish.practicalTip}',
                        style: const TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 10),

                      // Botão Escolher
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            onSelectDish(dish);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? const Color(0xFF15803D) : AppColors.neonLime,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: Text(
                            isSelected ? '✓ Prato Selecionado' : 'Escolher este Prato',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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

  Widget _buildMacroPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
