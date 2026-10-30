import 'package:flutter_test/flutter_test.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';
import 'package:fitmorph_ai/core/network/gemini_service.dart';
import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';

void main() {
  group('WorkoutEngine & Biomechanics Tests', () {
    test('Gera ficha de 4 dias no split Upper / Lower com adaptação biomecânica', () {
      final anamnese = AnamneseModel.sample().copyWith(
        daysPerWeek: 4,
        splitStyle: WorkoutSplitStyle.upperLower,
      );
      final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);

      expect(plan.days.length, equals(4));
      expect(plan.splitType, contains('Upper / Lower'));
      expect(plan.days.first.exercises.isNotEmpty, isTrue);
    });

    test('Exclui agachamento livre pesado e substitui por leg press se houver dor no joelho', () {
      final anamnese = AnamneseModel.sample().copyWith(
        daysPerWeek: 4,
        splitStyle: WorkoutSplitStyle.upperLower,
        jointPains: ['Joelho'],
      );
      final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);

      final lowerDay = plan.days.firstWhere((d) => d.dayLetter == 'B');
      final exerciseCatalogIds = lowerDay.exercises.map((e) => e.exerciseCatalogId).toList();

      expect(exerciseCatalogIds.contains('legs_barbell_squat'), isFalse);
      expect(exerciseCatalogIds.contains('legs_leg_press_45'), isTrue);
    });

    test('Compactação de Treino converte exercícios em Bi-Sets quando tempo é reduzido', () {
      final anamnese = AnamneseModel.sample();
      final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);
      final originalDay = plan.days.first;

      final compactedDay = GeminiService.compactWorkoutForTime(originalDay, 30);

      expect(compactedDay.estimatedMinutes, equals(30));
      expect(compactedDay.exercises.any((e) => e.isSuperSet), isTrue);
      expect(compactedDay.exercises.first.restSeconds, equals(45));
    });

    test('Catálogo de Exercícios retorna substitutos biomecânicos compatíveis', () {
      final substitutes = ExerciseCatalog.getSubstitutes('chest_bench_press_barbell');

      expect(substitutes.isNotEmpty, isTrue);
      expect(substitutes.any((s) => s.muscleGroup == 'Peito'), isTrue);
    });

    test('Treino em Casa (Home Gym) NUNCA inclui máquinas ou cabos', () {
      for (final days in [3, 4, 5]) {
        final anamnese = AnamneseModel.sample().copyWith(
          location: WorkoutLocation.homeGym,
          daysPerWeek: days,
        );
        final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);

        for (final day in plan.days) {
          for (final ex in day.exercises) {
            final def = ExerciseCatalog.findById(ex.exerciseCatalogId);
            final equip = (def?.equipment ?? ex.equipment).toLowerCase();
            expect(equip.contains('máquina'), isFalse, reason: 'Encontrada máquina no treino em casa: ${ex.name}');
            expect(equip.contains('cabo'), isFalse, reason: 'Encontrado cabo no treino em casa: ${ex.name}');
          }
        }
      }
    });

    test('Filtro de substituição para Home Gym exclui máquinas e cabos', () {
      final substitutes = ExerciseCatalog.getSubstitutes(
        'chest_bench_press_dumbbell',
        locationFilter: 'homeGym',
      );

      for (final sub in substitutes) {
        expect(sub.equipment, isNot(equals('Máquina')));
        expect(sub.equipment, isNot(equals('Cabos')));
      }
    });

    test('Treino de Calistenia (bodyweightOnly) prescreve 100% peso corporal', () {
      final anamnese = AnamneseModel.sample().copyWith(
        location: WorkoutLocation.bodyweightOnly,
        daysPerWeek: 3,
      );
      final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);

      for (final day in plan.days) {
        for (final ex in day.exercises) {
          final def = ExerciseCatalog.findById(ex.exerciseCatalogId);
          expect(def?.equipment ?? ex.equipment, equals('Peso Corporal'));
        }
      }
    });

    test('Prescreve protocolo de cardio (Esteira Inclinada, Escada, Bike) para Academia Comercial', () {
      final anamnese = AnamneseModel.sample().copyWith(
        location: WorkoutLocation.commercialGym,
        primaryGoal: 'hypertrophy',
        daysPerWeek: 4,
      );
      final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);

      for (final day in plan.days) {
        expect(day.cardioProtocol, isNotNull);
        expect(day.cardioProtocol!.durationMinutes, greaterThanOrEqualTo(15));
        expect(day.cardioProtocol!.estimatedCalories, greaterThan(100));
        expect(day.cardioProtocol!.speedInclineRecommendation.isNotEmpty, isTrue);
      }

      final dayA = plan.days.firstWhere((d) => d.dayLetter == 'A');
      expect(dayA.cardioProtocol!.equipment, equals('Esteira'));
      expect(dayA.cardioProtocol!.title, contains('Esteira'));
    });

    test('Adapta protocolo de cardio para Treino em Casa / Calistenia (Zero Esteira Elétrica)', () {
      final anamnese = AnamneseModel.sample().copyWith(
        location: WorkoutLocation.homeGym,
        daysPerWeek: 4,
      );
      final plan = GeminiService.generateScientificWorkoutPlanLocal(anamnese);

      for (final day in plan.days) {
        expect(day.cardioProtocol, isNotNull);
        final equip = day.cardioProtocol!.equipment.toLowerCase();
        expect(equip.contains('esteira'), isFalse, reason: 'Encontrada esteira elétrica no treino em casa');
        expect(equip.contains('escada') && day.cardioProtocol!.modality == 'Simulador de Escada', isFalse);
      }
    });

    test('Aumenta duração e gasto calórico do cardio quando o objetivo é Definição / Fat Loss', () {
      final cuttingAnamnese = AnamneseModel.sample().copyWith(
        location: WorkoutLocation.commercialGym,
        primaryGoal: 'fatLoss',
        daysPerWeek: 4,
      );
      final bulkAnamnese = AnamneseModel.sample().copyWith(
        location: WorkoutLocation.commercialGym,
        primaryGoal: 'hypertrophy',
        daysPerWeek: 4,
      );

      final cuttingPlan = GeminiService.generateScientificWorkoutPlanLocal(cuttingAnamnese);
      final bulkPlan = GeminiService.generateScientificWorkoutPlanLocal(bulkAnamnese);

      final cuttingCardioA = cuttingPlan.days.first.cardioProtocol!;
      final bulkCardioA = bulkPlan.days.first.cardioProtocol!;

      expect(cuttingCardioA.durationMinutes, greaterThan(bulkCardioA.durationMinutes));
      expect(cuttingCardioA.estimatedCalories, greaterThan(bulkCardioA.estimatedCalories));
    });
  });
}
