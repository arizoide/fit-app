import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/utils/tdee_calculator.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import '../../domain/models/brazilian_dish_options.dart';
import '../widgets/brazilian_dish_selector_modal.dart';

class DietCaloriesScreen extends ConsumerStatefulWidget {
  const DietCaloriesScreen({super.key});

  @override
  ConsumerState<DietCaloriesScreen> createState() => _DietCaloriesScreenState();
}

class _DietCaloriesScreenState extends ConsumerState<DietCaloriesScreen> {
  final ActivityLevel _activityLevel = ActivityLevel.moderatelyActive;
  late FitnessGoal _selectedGoal;
  int _consumedWaterMl = 1750;

  BrazilianDishOption? _selectedBreakfast;
  BrazilianDishOption? _selectedLunch;
  BrazilianDishOption? _selectedSnack;
  BrazilianDishOption? _selectedDinner;

  @override
  void initState() {
    super.initState();
    final anamnese = ref.read(anamneseProvider);
    if (anamnese.primaryGoal == 'fatLoss') {
      _selectedGoal = FitnessGoal.fatLoss;
    } else if (anamnese.primaryGoal == 'recomposition') {
      _selectedGoal = FitnessGoal.recomposition;
    } else {
      _selectedGoal = FitnessGoal.hypertrophy;
    }

    _selectedBreakfast = BrazilianDishesCatalog.getDishesForMeal('cafe').first;
    _selectedLunch = BrazilianDishesCatalog.getDishesForMeal('almoco').first;
    _selectedSnack = BrazilianDishesCatalog.getDishesForMeal('lanche').first;
    _selectedDinner = BrazilianDishesCatalog.getDishesForMeal('jantar').first;
  }

  void _addWater(int ml) {
    setState(() {
      _consumedWaterMl = (_consumedWaterMl + ml).clamp(0, 8000);
    });
  }

  @override
  Widget build(BuildContext context) {
    final anamnese = ref.watch(anamneseProvider);

    final macros = TdeeCalculator.calculateMacros(
      sex: anamnese.gender == 'female' ? BiologicalSex.female : BiologicalSex.male,
      weightKg: anamnese.weightKg,
      heightCm: anamnese.heightCm,
      age: anamnese.age,
      activityLevel: _activityLevel,
      goal: _selectedGoal,
      bodyFatPercentage: anamnese.estimatedBodyFat,
    );

    final bmr = TdeeCalculator.calculateBmr(
      sex: anamnese.gender == 'female' ? BiologicalSex.female : BiologicalSex.male,
      weightKg: anamnese.weightKg,
      heightCm: anamnese.heightCm,
      age: anamnese.age,
      bodyFatPercentage: anamnese.estimatedBodyFat,
    );

    final tdee = TdeeCalculator.calculateTdee(
      sex: anamnese.gender == 'female' ? BiologicalSex.female : BiologicalSex.male,
      weightKg: anamnese.weightKg,
      heightCm: anamnese.heightCm,
      age: anamnese.age,
      activityLevel: _activityLevel,
      bodyFatPercentage: anamnese.estimatedBodyFat,
    );

    final waterProgress = (_consumedWaterMl / macros.recommendedWaterMl).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.restaurant_menu, color: AppColors.neonLime),
            const SizedBox(width: 8),
            Text('Metas Calóricas & Macros', style: AppTextStyles.heading2),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Goal Toggle Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildGoalChip('Hipertrofia (+Superávit)', FitnessGoal.hypertrophy),
                  _buildGoalChip('Definição (-Déficit)', FitnessGoal.fatLoss),
                  _buildGoalChip('Recomposição', FitnessGoal.recomposition),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daily Target Calories Card
            GlassCard(
              borderColor: AppColors.neonLime.withOpacity(0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('META CALÓRICA DIÁRIA', style: AppTextStyles.labelBold.copyWith(color: AppColors.neonLime)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.neonLime.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _selectedGoal == FitnessGoal.hypertrophy
                              ? '+300 kcal (Ganho Limpo)'
                              : _selectedGoal == FitnessGoal.fatLoss
                                  ? '-450 kcal (Queima de Gordura)'
                                  : 'Normocalórica',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.neonLime,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${macros.totalCalories}',
                        style: AppTextStyles.heading1.copyWith(fontSize: 42, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 8),
                      Text('kcal / dia', style: AppTextStyles.heading3.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const Divider(color: AppColors.cardBorder, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildEnergyItem('Taxa Basal (TMB)', '${bmr.toInt()} kcal'),
                      _buildEnergyItem('Gasto Total (TDEE)', '${tdee.toInt()} kcal'),
                      _buildEnergyItem('Proteína / kg', '${macros.proteinPerKg}g / kg'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Macronutrient Cards
            Text('Distribuição de Macronutrientes', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMacroCard(
                    title: 'Proteína',
                    grams: macros.proteinGrams,
                    color: AppColors.chestColor,
                    subtitle: '${macros.proteinPerKg}g/kg',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMacroCard(
                    title: 'Carboidratos',
                    grams: macros.carbsGrams,
                    color: AppColors.electricCyan,
                    subtitle: 'Energia Treino',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMacroCard(
                    title: 'Gorduras',
                    grams: macros.fatsGrams,
                    color: AppColors.pulseOrange,
                    subtitle: 'Hormonal',
                  ),
                ),
              ],
            ),
            // Sugestões de Refeições & Pratos Caseiros Brasileiros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Refeições com Pratos Caseiros', style: AppTextStyles.labelBold),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: const Text(
                    '🇧🇷 Comida de Verdade',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Pratos balanceados para a sua meta diária de ${macros.totalCalories} kcal. Clique para ver ou trocar opções.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
            ),
            const SizedBox(height: 14),

            // 1. Café da Manhã (~20%)
            _buildMealCard(
              mealName: 'Café da Manhã',
              mealType: 'cafe',
              icon: Icons.free_breakfast,
              targetKcal: (macros.totalCalories * 0.20).round(),
              targetProtein: (macros.proteinGrams * 0.20).round(),
              selectedDish: _selectedBreakfast,
              onDishSelected: (d) => setState(() => _selectedBreakfast = d),
            ),
            const SizedBox(height: 12),

            // 2. Almoço (~35%)
            _buildMealCard(
              mealName: 'Almoço',
              mealType: 'almoco',
              icon: Icons.lunch_dining,
              targetKcal: (macros.totalCalories * 0.35).round(),
              targetProtein: (macros.proteinGrams * 0.35).round(),
              selectedDish: _selectedLunch,
              onDishSelected: (d) => setState(() => _selectedLunch = d),
            ),
            const SizedBox(height: 12),

            // 3. Lanche da Tarde (~15%)
            _buildMealCard(
              mealName: 'Lanche da Tarde',
              mealType: 'lanche',
              icon: Icons.local_cafe,
              targetKcal: (macros.totalCalories * 0.15).round(),
              targetProtein: (macros.proteinGrams * 0.15).round(),
              selectedDish: _selectedSnack,
              onDishSelected: (d) => setState(() => _selectedSnack = d),
            ),
            const SizedBox(height: 12),

            // 4. Jantar (~30%)
            _buildMealCard(
              mealName: 'Jantar',
              mealType: 'jantar',
              icon: Icons.dinner_dining,
              targetKcal: (macros.totalCalories * 0.30).round(),
              targetProtein: (macros.proteinGrams * 0.30).round(),
              selectedDish: _selectedDinner,
              onDishSelected: (d) => setState(() => _selectedDinner = d),
            ),
            const SizedBox(height: 24),

            // Water Tracker Card
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.water_drop, color: AppColors.electricCyan, size: 22),
                          const SizedBox(width: 8),
                          Text('Meta de Hidratação Diária', style: AppTextStyles.labelBold),
                        ],
                      ),
                      Text(
                        '$_consumedWaterMl / ${macros.recommendedWaterMl} ml',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: waterProgress,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.electricCyan),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('+250 ml'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.electricCyan,
                          side: const BorderSide(color: AppColors.electricCyan),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _addWater(250),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('+500 ml'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.electricCyan,
                          side: const BorderSide(color: AppColors.electricCyan),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _addWater(500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Scientific Guidelines
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.neonLime, size: 20),
                      const SizedBox(width: 8),
                      Text('Orientações de Timing Nutricional', style: AppTextStyles.labelBold),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildGuidelineItem('Pré-Treino (1-2h antes)', 'Carboidratos de média digestão + 20-30g de proteína para garantir glicogênio muscular e foco.'),
                  const SizedBox(height: 8),
                  _buildGuidelineItem('Pós-Treino', 'Refeição rica em proteínas (0.4g/kg) e carboidratos para sintetizar glicogênio e acelerar a recuperação tecidual.'),
                  const SizedBox(height: 8),
                  _buildGuidelineItem('Creatina Diária', 'Consuma 3g a 5g de creatina monohidratada todos os dias (mesmo em dias de descanso).'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalChip(String label, FitnessGoal goal) {
    final isSel = _selectedGoal == goal;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        selectedColor: AppColors.neonLime.withOpacity(0.2),
        backgroundColor: AppColors.surfaceLight,
        labelStyle: TextStyle(
          color: isSel ? AppColors.neonLime : AppColors.textSecondary,
          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(color: isSel ? AppColors.neonLime : AppColors.cardBorder),
        onSelected: (selected) {
          if (selected) setState(() => _selectedGoal = goal);
        },
      ),
    );
  }

  Widget _buildEnergyItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMacroCard({
    required String title,
    required int grams,
    required Color color,
    required String subtitle,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderColor: color.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('${grams}g', style: AppTextStyles.heading2.copyWith(fontSize: 22)),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(desc, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildMealCard({
    required String mealName,
    required String mealType,
    required IconData icon,
    required int targetKcal,
    required int targetProtein,
    required BrazilianDishOption? selectedDish,
    required Function(BrazilianDishOption) onDishSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: AppColors.textPrimary, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(mealName, style: AppTextStyles.labelBold),
                ],
              ),
              Text(
                'Alvo: ~$targetKcal kcal • ${targetProtein}g prot',
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (selectedDish != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedDish.name,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${selectedDish.calories} kcal',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedDish.ingredients.take(3).join(', ') + (selectedDish.ingredients.length > 3 ? '...' : ''),
                    style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${selectedDish.proteinGrams}g proteína • ${selectedDish.carbsGrams}g carbs • ${selectedDish.fatsGrams}g gord',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF0284C7), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.restaurant_menu, size: 15),
              label: Text(
                selectedDish != null ? 'Trocar Prato Caseiro' : 'Ver Opções de Pratos',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF15803D),
                side: const BorderSide(color: Color(0xFF86EFAC)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                BrazilianDishSelectorModal.show(
                  context: context,
                  mealName: mealName,
                  mealType: mealType,
                  targetCalories: targetKcal,
                  currentlySelected: selectedDish,
                  onSelectDish: onDishSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
