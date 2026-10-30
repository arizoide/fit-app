import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';

void main() {
  group('Profile & Workout Plan Dynamic Sync Tests', () {
    test('Atualizar perfil para Home Gym recalcula ficha sem máquinas', () async {
      final container = ProviderContainer();

      const initialAnamnese = AnamneseModel(
        id: 'test-user-1',
        name: 'Aluno Teste',
        age: 28,
        weightKg: 80,
        heightCm: 180,
        gender: 'male',
        daysPerWeek: 4,
        availableMinutesPerSession: 60,
        experienceLevel: ExperienceLevel.intermediate,
        primaryGoal: 'Hipertrofia',
        location: WorkoutLocation.commercialGym,
        jointPains: [],
        preferredMuscles: ['Peito', 'Costas'],
      );

      container.read(anamneseProvider.notifier).updateAnamnese(initialAnamnese);
      await container.read(workoutPlanProvider.notifier).generateNewPlan(initialAnamnese);

      final gymPlan = container.read(workoutPlanProvider).value;
      expect(gymPlan, isNotNull);

      // Agora atualiza perfil para Treino em Casa (Home Gym)
      final homeAnamnese = initialAnamnese.copyWith(
        location: WorkoutLocation.homeGym,
        preferredCardio: 'Pular Corda',
      );

      container.read(anamneseProvider.notifier).updateAnamnese(homeAnamnese);
      await container.read(workoutPlanProvider.notifier).generateNewPlan(homeAnamnese);

      final updatedPlan = container.read(workoutPlanProvider).value;
      expect(updatedPlan, isNotNull);

      // Verifica se todos os exercícios do plano agora são adaptados para halteres/peso corporal
      final allExercises = updatedPlan!.days
          .expand((d) => d.exercises)
          .map((e) => e.name.toLowerCase())
          .toList();

      // Não deve conter máquinas pesadas de academia comercial
      for (final name in allExercises) {
        expect(name.contains('leg press'), isFalse);
        expect(name.contains('pulley'), isFalse);
        expect(name.contains('peck deck'), isFalse);
      }
    });

    test('Atualizar perfil com dor articular substitui exercícios arriscados', () async {
      final container = ProviderContainer();

      const anamneseWithShoulderPain = AnamneseModel(
        id: 'test-user-2',
        name: 'Aluno Ombro',
        age: 30,
        weightKg: 75,
        heightCm: 175,
        gender: 'male',
        daysPerWeek: 4,
        availableMinutesPerSession: 60,
        experienceLevel: ExperienceLevel.intermediate,
        primaryGoal: 'Hipertrofia',
        location: WorkoutLocation.commercialGym,
        jointPains: ['Ombro'],
        preferredMuscles: ['Peito'],
      );

      container.read(anamneseProvider.notifier).updateAnamnese(anamneseWithShoulderPain);
      await container.read(workoutPlanProvider.notifier).generateNewPlan(anamneseWithShoulderPain);

      final plan = container.read(workoutPlanProvider).value;
      expect(plan, isNotNull);

      final allExercises = plan!.days
          .expand((d) => d.exercises)
          .map((e) => e.name.toLowerCase())
          .toList();

      // Não deve prescrever desenvolvimento militar com barra quando há dor no ombro
      for (final name in allExercises) {
        expect(name.contains('desenvolvimento militar barra'), isFalse);
      }
    });
  });
}
