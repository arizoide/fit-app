enum BiologicalSex { male, female }
enum ActivityLevel {
  sedentary, // 1.2
  lightlyActive, // 1.375 (1-3 days/week)
  moderatelyActive, // 1.55 (3-5 days/week)
  veryActive, // 1.725 (6-7 days/week)
  extremelyActive, // 1.9 (physical job + 2x training)
}

enum FitnessGoal {
  hypertrophy, // Hipertrofia / Ganho de Massa
  fatLoss, // Definição / Perda de Gordura
  recomposition, // Recomposição Corporal
  endurance, // Condicionamento Geral
}

class MacroBreakdown {
  final int totalCalories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatsGrams;
  final double proteinPerKg;
  final int recommendedWaterMl;

  const MacroBreakdown({
    required this.totalCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.proteinPerKg,
    required this.recommendedWaterMl,
  });
}

class TdeeCalculator {
  /// Calcula a Taxa Metabólica Basal (TMB) usando Mifflin-St Jeor ou Katch-McArdle se houver %BF
  static double calculateBmr({
    required BiologicalSex sex,
    required double weightKg,
    required double heightCm,
    required int age,
    double? bodyFatPercentage,
  }) {
    // Se o percentual de gordura for informado, utiliza Katch-McArdle (mais preciso)
    if (bodyFatPercentage != null && bodyFatPercentage > 3 && bodyFatPercentage < 50) {
      final leanMassKg = weightKg * (1 - (bodyFatPercentage / 100));
      return 370 + (21.6 * leanMassKg);
    }

    // Fórmula Mifflin-St Jeor padrão
    if (sex == BiologicalSex.male) {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }

  /// Multiplicador do nível de atividade diária
  static double getActivityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extremelyActive:
        return 1.9;
    }
  }

  /// Gasto Calórico Total Diário (TDEE)
  static double calculateTdee({
    required BiologicalSex sex,
    required double weightKg,
    required double heightCm,
    required int age,
    required ActivityLevel activityLevel,
    double? bodyFatPercentage,
  }) {
    final bmr = calculateBmr(
      sex: sex,
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      bodyFatPercentage: bodyFatPercentage,
    );
    return bmr * getActivityMultiplier(activityLevel);
  }

  /// Distribuição completa de calorias e macronutrientes conforme meta científica
  static MacroBreakdown calculateMacros({
    required BiologicalSex sex,
    required double weightKg,
    required double heightCm,
    required int age,
    required ActivityLevel activityLevel,
    required FitnessGoal goal,
    double? bodyFatPercentage,
  }) {
    final tdee = calculateTdee(
      sex: sex,
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      activityLevel: activityLevel,
      bodyFatPercentage: bodyFatPercentage,
    );

    int targetCalories;
    double targetProteinPerKg;
    double fatCaloriesRatio;

    switch (goal) {
      case FitnessGoal.hypertrophy:
        // Superávit calórico controlado de 10% a 15% (aprox 300 kcal)
        targetCalories = (tdee + 300).round();
        targetProteinPerKg = 2.0; // 2.0g/kg
        fatCaloriesRatio = 0.25; // 25% das calorias em gordura
        break;

      case FitnessGoal.fatLoss:
        // Déficit calórico moderado de 20% (aprox 400-500 kcal)
        targetCalories = (tdee - 450).clamp(1200, 5000).round();
        targetProteinPerKg = 2.2; // 2.2g/kg para preservar massa magra
        fatCaloriesRatio = 0.25;
        break;

      case FitnessGoal.recomposition:
        // Quase normocalórica (leve déficit 5%) com proteína alta
        targetCalories = (tdee - 100).round();
        targetProteinPerKg = 2.3;
        fatCaloriesRatio = 0.25;
        break;

      case FitnessGoal.endurance:
        targetCalories = tdee.round();
        targetProteinPerKg = 1.6;
        fatCaloriesRatio = 0.22;
        break;
    }

    final proteinGrams = (weightKg * targetProteinPerKg).round();
    final proteinCalories = proteinGrams * 4;

    final fatCalories = targetCalories * fatCaloriesRatio;
    final fatsGrams = (fatCalories / 9).round();

    final remainingCalories = targetCalories - proteinCalories - (fatsGrams * 9);
    final carbsGrams = (remainingCalories / 4).clamp(30, 800).round();

    // 35ml a 40ml de água por kg
    final recommendedWaterMl = (weightKg * 38).round();

    return MacroBreakdown(
      totalCalories: targetCalories,
      proteinGrams: proteinGrams,
      carbsGrams: carbsGrams,
      fatsGrams: fatsGrams,
      proteinPerKg: targetProteinPerKg,
      recommendedWaterMl: recommendedWaterMl,
    );
  }
}
