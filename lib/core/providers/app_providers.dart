import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmorph_ai/core/network/gemini_service.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';
import 'package:fitmorph_ai/features/workout_generator/domain/models/workout_models.dart';
import 'package:fitmorph_ai/features/active_workout/domain/models/active_workout_state.dart';
import 'package:fitmorph_ai/features/body_biometrics/domain/models/biometrics_model.dart';
import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';

// ANAMNESE PROVIDER
class AnamneseNotifier extends StateNotifier<AnamneseModel> {
  AnamneseNotifier() : super(AnamneseModel.empty());

  void updateAnamnese(AnamneseModel updated) {
    state = updated;
  }

  void loadSample() {
    state = AnamneseModel.sample();
  }

  void reset() {
    state = AnamneseModel.empty();
  }
}

final anamneseProvider = StateNotifierProvider<AnamneseNotifier, AnamneseModel>((ref) {
  return AnamneseNotifier();
});

// WORKOUT PLAN PROVIDER
class WorkoutPlanNotifier extends StateNotifier<AsyncValue<WorkoutPlan?>> {
  final Ref ref;

  WorkoutPlanNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> generateNewPlan(AnamneseModel anamnese) async {
    state = const AsyncValue.loading();
    try {
      final plan = await GeminiService.generateWorkoutPlan(anamnese);
      state = AsyncValue.data(plan);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void loadSamplePlan() {
    final sampleAnamnese = AnamneseModel.sample();
    ref.read(anamneseProvider.notifier).updateAnamnese(sampleAnamnese);
    final samplePlan = GeminiService.generateScientificWorkoutPlanLocal(sampleAnamnese);
    state = AsyncValue.data(samplePlan);
  }

  void resetPlan() {
    state = const AsyncValue.data(null);
  }

  void swapExerciseInPlan({
    required String dayId,
    required String oldExerciseId,
    required ExerciseDefinition newExerciseDef,
  }) {
    state.whenData((plan) {
      if (plan == null) return;
      final updatedDays = plan.days.map((day) {
        if (day.id == dayId) {
          final updatedExercises = day.exercises.map((ex) {
            if (ex.id == oldExerciseId) {
              return ex.copyWith(
                exerciseCatalogId: newExerciseDef.id,
                name: newExerciseDef.name,
                targetMuscle: newExerciseDef.muscleGroup,
                equipment: newExerciseDef.equipment,
                notes: newExerciseDef.instructions,
                substituteIds: newExerciseDef.substituteIds,
              );
            }
            return ex;
          }).toList();
          return day.copyWith(exercises: updatedExercises);
        }
        return day;
      }).toList();

      state = AsyncValue.data(plan.copyWith(days: updatedDays));
    });
  }

  void adaptDayForExpressTime({
    required String dayId,
    required int targetMinutes,
  }) {
    state.whenData((plan) {
      if (plan == null) return;
      final updatedDays = plan.days.map((day) {
        if (day.id == dayId) {
          return day.adaptToExpressTime(targetMinutes);
        }
        return day;
      }).toList();

      state = AsyncValue.data(plan.copyWith(days: updatedDays));
    });
  }

  void restoreOriginalDay({required String dayId}) {
    state.whenData((plan) {
      if (plan == null) return;
      final updatedDays = plan.days.map((day) {
        if (day.id == dayId) {
          return day.restoreOriginal();
        }
        return day;
      }).toList();

      state = AsyncValue.data(plan.copyWith(days: updatedDays));
    });
  }

  void adaptAllDaysForExpress(int targetMinutes) {
    state.whenData((plan) {
      if (plan == null) return;
      final updatedDays = plan.days.map((day) {
        return day.adaptToExpressTime(targetMinutes);
      }).toList();

      state = AsyncValue.data(plan.copyWith(days: updatedDays));
    });
  }

  void restoreAllDaysOriginal() {
    state.whenData((plan) {
      if (plan == null) return;
      final updatedDays = plan.days.map((day) {
        return day.restoreOriginal();
      }).toList();

      state = AsyncValue.data(plan.copyWith(days: updatedDays));
    });
  }
}

final workoutPlanProvider = StateNotifierProvider<WorkoutPlanNotifier, AsyncValue<WorkoutPlan?>>((ref) {
  return WorkoutPlanNotifier(ref);
});

// ACTIVE WORKOUT PROVIDER
class ActiveWorkoutNotifier extends StateNotifier<ActiveWorkoutState?> {
  Timer? _sessionTimer;
  Timer? _restTimer;

  ActiveWorkoutNotifier() : super(null);

  void startWorkout(WorkoutDay day) {
    _sessionTimer?.cancel();
    _restTimer?.cancel();

    state = ActiveWorkoutState(
      workoutDay: day,
      elapsedSeconds: 0,
      startedAt: DateTime.now(),
    );

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state != null && !state!.isPaused) {
        state = state!.copyWith(elapsedSeconds: state!.elapsedSeconds + 1);
      }
    });
  }

  void togglePause() {
    if (state != null) {
      state = state!.copyWith(isPaused: !state!.isPaused);
    }
  }

  void completeSet({
    required int exerciseIndex,
    required int setIndex,
    required double weightKg,
    required int reps,
    int? rpe,
  }) {
    if (state == null) return;

    final exercises = [...state!.workoutDay.exercises];
    final exercise = exercises[exerciseIndex];
    final sets = [...exercise.sets];

    sets[setIndex] = sets[setIndex].copyWith(
      isCompleted: true,
      weightKg: weightKg,
      completedReps: reps,
      rpeReal: rpe,
    );

    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    // Auto-trigger rest timer
    final restTime = exercise.restSeconds;
    startRestTimer(restTime);

    state = state!.copyWith(
      workoutDay: state!.workoutDay.copyWith(exercises: exercises),
      currentExerciseIndex: exerciseIndex,
      currentSetIndex: setIndex,
    );
  }

  void uncompleteSet({required int exerciseIndex, required int setIndex}) {
    if (state == null) return;
    final exercises = [...state!.workoutDay.exercises];
    final exercise = exercises[exerciseIndex];
    final sets = [...exercise.sets];

    sets[setIndex] = sets[setIndex].copyWith(isCompleted: false);
    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    state = state!.copyWith(
      workoutDay: state!.workoutDay.copyWith(exercises: exercises),
    );
  }

  void startRestTimer(int seconds) {
    _restTimer?.cancel();
    if (state == null) return;

    state = state!.copyWith(
      isResting: true,
      restRemainingSeconds: seconds,
      restTotalSeconds: seconds,
    );

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == null) {
        timer.cancel();
        return;
      }
      if (state!.restRemainingSeconds > 1) {
        state = state!.copyWith(restRemainingSeconds: state!.restRemainingSeconds - 1);
      } else {
        timer.cancel();
        state = state!.copyWith(isResting: false, restRemainingSeconds: 0);
      }
    });
  }

  void stopRestTimer() {
    _restTimer?.cancel();
    if (state != null) {
      state = state!.copyWith(isResting: false, restRemainingSeconds: 0);
    }
  }

  void swapExercise({required int exerciseIndex, required ExerciseDefinition newExerciseDef}) {
    if (state == null) return;
    final exercises = [...state!.workoutDay.exercises];
    final currentEx = exercises[exerciseIndex];

    exercises[exerciseIndex] = currentEx.copyWith(
      exerciseCatalogId: newExerciseDef.id,
      name: newExerciseDef.name,
      targetMuscle: newExerciseDef.muscleGroup,
      equipment: newExerciseDef.equipment,
      notes: 'Substituído: ${newExerciseDef.instructions}',
      substituteIds: newExerciseDef.substituteIds,
    );

    state = state!.copyWith(
      workoutDay: state!.workoutDay.copyWith(exercises: exercises),
    );
  }

  void compactWorkout(int targetMinutes) {
    if (state == null) return;
    final compactedDay = GeminiService.compactWorkoutForTime(state!.workoutDay, targetMinutes);
    state = state!.copyWith(workoutDay: compactedDay);
  }

  void endWorkout() {
    _sessionTimer?.cancel();
    _restTimer?.cancel();
    state = null;
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }
}

final activeWorkoutProvider = StateNotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState?>((ref) {
  return ActiveWorkoutNotifier();
});

// BIOMETRICS HISTORY PROVIDER
class BiometricsNotifier extends StateNotifier<List<BiometricEntry>> {
  BiometricsNotifier() : super([]);

  void addEntry(BiometricEntry entry) {
    state = [entry, ...state];
  }

  void loadSample() {
    state = [
      BiometricEntry(
        id: 'b1',
        date: DateTime.now().subtract(const Duration(days: 30)),
        weightKg: 81.0,
        bodyFatPercentage: 17.5,
        chestCm: 101,
        waistCm: 84,
        armCm: 37,
        notes: 'Início da periodização FitMorph.',
      ),
      BiometricEntry(
        id: 'b2',
        date: DateTime.now().subtract(const Duration(days: 7)),
        weightKg: 78.5,
        bodyFatPercentage: 15.0,
        chestCm: 103,
        waistCm: 80,
        armCm: 38,
        notes: 'Evolução na densidade do peitoral e redução da cintura.',
      ),
    ];
  }
}

final biometricsProvider = StateNotifierProvider<BiometricsNotifier, List<BiometricEntry>>((ref) {
  return BiometricsNotifier();
});
