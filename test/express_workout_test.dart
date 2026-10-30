import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';
import 'package:fitmorph_ai/features/workout_generator/domain/models/workout_models.dart';

void main() {
  group('Modo Treino Express ("Pouco Tempo") Tests', () {
    test('WorkoutDay.adaptToExpressTime reduz treino para 15 min priorizando compostos', () {
      final sampleDay = WorkoutDay(
        id: 'day-a',
        dayLetter: 'A',
        title: 'Treino A - Peito, Ombros & Tríceps',
        focusMuscles: ['Peito', 'Ombros', 'Tríceps'],
        estimatedMinutes: 55,
        exercises: [
          WorkoutExercise(
            id: 'ex-1',
            exerciseCatalogId: 'chest_bench_press_barbell',
            name: 'Supino Reto com Barra',
            targetMuscle: 'Peito',
            setsCount: 4,
            repsRange: '8-10',
            rpeTarget: 'RPE 8',
            restSeconds: 90,
            equipment: 'Barra',
            substituteIds: [],
          ),
          WorkoutExercise(
            id: 'ex-2',
            exerciseCatalogId: 'shoulder_overhead_press_dumbbell',
            name: 'Desenvolvimento com Halteres',
            targetMuscle: 'Ombros',
            setsCount: 4,
            repsRange: '8-10',
            rpeTarget: 'RPE 8',
            restSeconds: 90,
            equipment: 'Halteres',
            substituteIds: [],
          ),
          WorkoutExercise(
            id: 'ex-3',
            exerciseCatalogId: 'chest_cable_fly',
            name: 'Crucifixo no Crossover',
            targetMuscle: 'Peito',
            setsCount: 3,
            repsRange: '12-15',
            rpeTarget: 'RPE 8',
            restSeconds: 60,
            equipment: 'Cabo',
            substituteIds: [],
          ),
          WorkoutExercise(
            id: 'ex-4',
            exerciseCatalogId: 'triceps_rope_pushdown',
            name: 'Tríceps Corda no Pulley',
            targetMuscle: 'Tríceps',
            setsCount: 3,
            repsRange: '10-12',
            rpeTarget: 'RPE 8',
            restSeconds: 60,
            equipment: 'Cabo',
            substituteIds: [],
          ),
        ],
        cardioProtocol: const CardioProtocol(
          title: 'Esteira Inclinada',
          modality: 'Esteira',
          durationMinutes: 20,
          intensityZone: 'Zona 2',
          speedInclineRecommendation: '5.5 km/h @ 6%',
          estimatedCalories: 150,
        ),
      );

      // Adapta para 15 minutos
      final expressDay = sampleDay.adaptToExpressTime(15);

      expect(expressDay.isExpressMode, isTrue);
      expect(expressDay.estimatedMinutes, 15);
      expect(expressDay.originalEstimatedMinutes, 55);
      expect(expressDay.originalExercises?.length, 4);

      // Deve manter apenas os 2 exercícios compostos principais
      expect(expressDay.exercises.length, 2);
      expect(expressDay.exercises.first.name, 'Supino Reto com Barra');
      expect(expressDay.exercises[1].name, 'Desenvolvimento com Halteres');

      // Séries reduzidas e descanso denso
      for (final ex in expressDay.exercises) {
        expect(ex.setsCount, 2);
        expect(ex.restSeconds, 45);
      }

      // Restauração completa
      final restoredDay = expressDay.restoreOriginal();
      expect(restoredDay.isExpressMode, isFalse);
      expect(restoredDay.estimatedMinutes, 55);
      expect(restoredDay.exercises.length, 4);
    });

    test('Riverpod workoutPlanProvider adapta e restaura dia via notifier', () async {
      final container = ProviderContainer();

      const anamnese = AnamneseModel(
        id: 'test-1',
        name: 'Aluno Express',
        age: 26,
        weightKg: 78,
        heightCm: 178,
        gender: 'male',
        daysPerWeek: 4,
        availableMinutesPerSession: 60,
        experienceLevel: ExperienceLevel.intermediate,
        primaryGoal: 'Hipertrofia',
        location: WorkoutLocation.commercialGym,
        jointPains: [],
        preferredMuscles: ['Peito'],
      );

      container.read(anamneseProvider.notifier).updateAnamnese(anamnese);
      await container.read(workoutPlanProvider.notifier).generateNewPlan(anamnese);

      final plan = container.read(workoutPlanProvider).value;
      expect(plan, isNotNull);
      final firstDayId = plan!.days.first.id;
      final originalMinutes = plan.days.first.estimatedMinutes;

      // Executa adaptação express para 20 min
      container.read(workoutPlanProvider.notifier).adaptDayForExpressTime(
        dayId: firstDayId,
        targetMinutes: 20,
      );

      final adaptedPlan = container.read(workoutPlanProvider).value;
      final adaptedDay = adaptedPlan!.days.firstWhere((d) => d.id == firstDayId);

      expect(adaptedDay.isExpressMode, isTrue);
      expect(adaptedDay.estimatedMinutes, 20);
      expect(adaptedDay.originalEstimatedMinutes, originalMinutes);

      // Executa restauração
      container.read(workoutPlanProvider.notifier).restoreOriginalDay(dayId: firstDayId);

      final restoredPlan = container.read(workoutPlanProvider).value;
      final restoredDay = restoredPlan!.days.firstWhere((d) => d.id == firstDayId);

      expect(restoredDay.isExpressMode, isFalse);
      expect(restoredDay.estimatedMinutes, originalMinutes);
    });
  });
}
