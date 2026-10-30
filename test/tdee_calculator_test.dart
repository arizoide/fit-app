import 'package:flutter_test/flutter_test.dart';
import 'package:fitmorph_ai/core/utils/tdee_calculator.dart';

void main() {
  group('TdeeCalculator Tests', () {
    test('Calcula TMB masculino com precisão usando Mifflin-St Jeor', () {
      final bmr = TdeeCalculator.calculateBmr(
        sex: BiologicalSex.male,
        weightKg: 80,
        heightCm: 180,
        age: 25,
      );
      // (10 * 80) + (6.25 * 180) - (5 * 25) + 5 = 800 + 1125 - 125 + 5 = 1805
      expect(bmr, equals(1805.0));
    });

    test('Calcula TMB usando Katch-McArdle quando %BF é informado', () {
      final bmr = TdeeCalculator.calculateBmr(
        sex: BiologicalSex.male,
        weightKg: 80,
        heightCm: 180,
        age: 25,
        bodyFatPercentage: 15, // Massa magra = 68kg -> 370 + (21.6 * 68) = 1838.8
      );
      expect(bmr, closeTo(1838.8, 0.1));
    });

    test('Calcula TDEE com multiplicador de atividade moderada (1.55)', () {
      final tdee = TdeeCalculator.calculateTdee(
        sex: BiologicalSex.male,
        weightKg: 80,
        heightCm: 180,
        age: 25,
        activityLevel: ActivityLevel.moderatelyActive,
      );
      // 1805 * 1.55 = 2797.75
      expect(tdee, closeTo(2797.75, 0.1));
    });

    test('Distribui macros de Hipertrofia com superávit de ~300 kcal e 2.0g/kg de proteína', () {
      final macros = TdeeCalculator.calculateMacros(
        sex: BiologicalSex.male,
        weightKg: 80,
        heightCm: 180,
        age: 25,
        activityLevel: ActivityLevel.moderatelyActive,
        goal: FitnessGoal.hypertrophy,
      );

      expect(macros.proteinGrams, equals(160)); // 80kg * 2.0 = 160g
      expect(macros.totalCalories, equals(3098)); // 2798 + 300
      expect(macros.recommendedWaterMl, equals(3040)); // 80 * 38
      expect(macros.fatsGrams, greaterThan(0));
      expect(macros.carbsGrams, greaterThan(0));
    });

    test('Distribui macros de Definição (Fat Loss) com déficit e proteína alta (2.2g/kg)', () {
      final macros = TdeeCalculator.calculateMacros(
        sex: BiologicalSex.male,
        weightKg: 80,
        heightCm: 180,
        age: 25,
        activityLevel: ActivityLevel.moderatelyActive,
        goal: FitnessGoal.fatLoss,
      );

      expect(macros.proteinGrams, equals(176)); // 80kg * 2.2 = 176g
      expect(macros.totalCalories, equals(2348)); // 2798 - 450
    });
  });
}
