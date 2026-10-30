import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';
import 'package:fitmorph_ai/core/network/gemini_service.dart';
import 'package:fitmorph_ai/core/utils/tdee_calculator.dart';
import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';
import 'package:fitmorph_ai/features/active_workout/domain/models/active_workout_state.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';

void main() {
  group('🛡️ QA Product Tester — End-to-End Quality Certification Suite', () {
    
    test('QA Gate 1: Geração de Treino com Múltiplos Músculos de Foco & Adaptação de Dores', () {
      final anamnese = AnamneseModel.sample().copyWith(
        preferredMuscles: ['Peitoral', 'Braços', 'Deltóides'],
        jointPains: ['Joelho', 'Ombro'],
        daysPerWeek: 4,
        splitStyle: WorkoutSplitStyle.upperLower,
      );

      final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);

      // Verificação de estrutura
      expect(plan.days.length, equals(4));
      expect(plan.splitType, contains('Upper / Lower'));

      // Verificação biomecânica de dores articulares
      final allExercises = plan.days.expand((d) => d.exercises).toList();
      final allCatalogIds = allExercises.map((e) => e.exerciseCatalogId).toSet();

      // Dor no Joelho: Não pode ter agachamento livre pesado com barra
      expect(allCatalogIds.contains('legs_barbell_squat'), isFalse,
          reason: 'QA Falha: Usuário com dor no joelho não deve receber agachamento livre com barra');

      // Dor no Ombro: Supino reto pesado com barra deve ser substituído por máquina ou halteres
      expect(allCatalogIds.contains('chest_bench_press_barbell'), isFalse,
          reason: 'QA Falha: Usuário com dor no ombro não deve receber supino pesado reto com barra');
    });

    test('QA Gate 2: Certificação do Modo Express (Tempo Curto) sem Perda de Eficiência', () {
      final anamnese = AnamneseModel.sample();
      final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);
      final normalDay = plan.days.first;

      final expressDay = GeminiService.compactWorkoutForTime(normalDay, 25);

      expect(expressDay.estimatedMinutes, equals(25));
      expect(expressDay.exercises.isNotEmpty, isTrue);
      // Deve criar bi-sets para otimizar densidade
      expect(expressDay.exercises.any((e) => e.isSuperSet), isTrue);
      // Intervalo reduzido para densidade metabólica
      expect(expressDay.exercises.first.restSeconds, lessThanOrEqualTo(60));
    });

    test('QA Gate 3: Validação Científica dos Cálculos Nutricionais & Divisão de Macros', () {
      // Caso 1: Hipertrofia Masculino (Superávit de 300 kcal e alta proteína)
      final bulkMacros = TdeeCalculator.calculateMacros(
        sex: BiologicalSex.male,
        weightKg: 80,
        heightCm: 180,
        age: 26,
        activityLevel: ActivityLevel.moderatelyActive,
        goal: FitnessGoal.hypertrophy,
        bodyFatPercentage: 14.0,
      );

      expect(bulkMacros.totalCalories, greaterThan(2200));
      expect(bulkMacros.proteinPerKg, greaterThanOrEqualTo(2.0));
      expect(bulkMacros.recommendedWaterMl, greaterThanOrEqualTo(2800));

      // Particionamento de 4 refeições
      final perMealCalories = bulkMacros.totalCalories / 4;
      expect(perMealCalories, inInclusiveRange(500, 800));

      // Caso 2: Emagrecimento / Cutting Feminino (Déficit calórico seguro)
      final cutMacros = TdeeCalculator.calculateMacros(
        sex: BiologicalSex.female,
        weightKg: 65,
        heightCm: 165,
        age: 30,
        activityLevel: ActivityLevel.moderatelyActive,
        goal: FitnessGoal.fatLoss,
      );

      expect(cutMacros.totalCalories, lessThan(1900));
      expect(cutMacros.proteinPerKg, greaterThanOrEqualTo(2.0));
    });

    test('QA Gate 4: Máquina de Estados da Sessão Ativa de Treino (Active Workout)', () {
      final container = ProviderContainer();
      final anamnese = AnamneseModel.sample();
      final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);
      final day = plan.days.first;

      final notifier = container.read(activeWorkoutProvider.notifier);

      // Iniciar sessão ativa
      notifier.startWorkout(day);
      var state = container.read(activeWorkoutProvider);

      expect(state, isNotNull);
      expect(state!.workoutDay.id, equals(day.id));
      expect(state.completedSetsCount, equals(0));
      expect(state.progressPercentage, equals(0.0));

      // Concluir série 1 do primeiro exercício
      notifier.completeSet(
        exerciseIndex: 0,
        setIndex: 0,
        weightKg: 60.0,
        reps: 10,
        rpe: 8,
      );

      state = container.read<ActiveWorkoutState?>(activeWorkoutProvider);
      expect(state, isNotNull);
      expect(state!.completedSetsCount, equals(1));
      expect(state.isResting, isTrue);
      expect(state.calculateTotalVolumeKg(), equals(600.0));
      expect(state.progressPercentage, greaterThan(0.0));

      // Parar descanso
      notifier.stopRestTimer();
      state = container.read<ActiveWorkoutState?>(activeWorkoutProvider);
      expect(state!.isResting, isFalse);

      // Finalizar treino
      notifier.endWorkout();
      final finalState = container.read<ActiveWorkoutState?>(activeWorkoutProvider);
      expect(finalState, isNull);
    });

    test('QA Gate 5: Sincronização Dinâmica de Perfil entre Academia e Home Gym', () async {
      final container = ProviderContainer();

      final initialAnamnese = AnamneseModel.sample().copyWith(
        location: WorkoutLocation.commercialGym,
      );

      container.read(anamneseProvider.notifier).updateAnamnese(initialAnamnese);
      await container.read(workoutPlanProvider.notifier).generateNewPlan(initialAnamnese);

      final initialPlan = container.read(workoutPlanProvider).value;
      expect(initialPlan, isNotNull);

      // Atualiza para Home Gym
      final homeAnamnese = initialAnamnese.copyWith(
        location: WorkoutLocation.homeGym,
      );
      container.read(anamneseProvider.notifier).updateAnamnese(homeAnamnese);
      await container.read(workoutPlanProvider.notifier).generateNewPlan(homeAnamnese);

      final homePlan = container.read(workoutPlanProvider).value;
      expect(homePlan, isNotNull);

      // Garante que nenhum exercício necessita de máquinas de academia
      for (final day in homePlan!.days) {
        for (final ex in day.exercises) {
          final def = ExerciseCatalog.findById(ex.exerciseCatalogId);
          expect(def, isNotNull, reason: 'QA Falha: Exercício ${ex.exerciseCatalogId} não encontrado no catálogo');
          expect(ExerciseCatalog.isHomeEquipment(def!.equipment), isTrue,
              reason: 'QA Falha: Exercício ${def.name} usa equipamento não compatível com Home Gym (${def.equipment})');
        }
      }
    });

  });
}
