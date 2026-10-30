import 'package:fitmorph_ai/features/workout_generator/domain/models/workout_models.dart';

class ActiveWorkoutState {
  final WorkoutDay workoutDay;
  final int elapsedSeconds;
  final bool isPaused;
  final bool isResting;
  final int restRemainingSeconds;
  final int restTotalSeconds;
  final int currentExerciseIndex;
  final int currentSetIndex;
  final DateTime startedAt;

  const ActiveWorkoutState({
    required this.workoutDay,
    required this.elapsedSeconds,
    this.isPaused = false,
    this.isResting = false,
    this.restRemainingSeconds = 0,
    this.restTotalSeconds = 90,
    this.currentExerciseIndex = 0,
    this.currentSetIndex = 0,
    required this.startedAt,
  });

  ActiveWorkoutState copyWith({
    WorkoutDay? workoutDay,
    int? elapsedSeconds,
    bool? isPaused,
    bool? isResting,
    int? restRemainingSeconds,
    int? restTotalSeconds,
    int? currentExerciseIndex,
    int? currentSetIndex,
    DateTime? startedAt,
  }) {
    return ActiveWorkoutState(
      workoutDay: workoutDay ?? this.workoutDay,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isPaused: isPaused ?? this.isPaused,
      isResting: isResting ?? this.isResting,
      restRemainingSeconds: restRemainingSeconds ?? this.restRemainingSeconds,
      restTotalSeconds: restTotalSeconds ?? this.restTotalSeconds,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSetIndex: currentSetIndex ?? this.currentSetIndex,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  double calculateTotalVolumeKg() {
    double total = 0;
    for (final ex in workoutDay.exercises) {
      for (final s in ex.sets) {
        if (s.isCompleted && s.weightKg != null && s.completedReps != null) {
          total += (s.weightKg! * s.completedReps!);
        }
      }
    }
    return total;
  }

  int get completedSetsCount {
    int count = 0;
    for (final ex in workoutDay.exercises) {
      for (final s in ex.sets) {
        if (s.isCompleted) count++;
      }
    }
    return count;
  }

  int get totalSetsCount {
    int count = 0;
    for (final ex in workoutDay.exercises) {
      count += ex.sets.length;
    }
    return count;
  }

  double get progressPercentage {
    if (totalSetsCount == 0) return 0.0;
    return (completedSetsCount / totalSetsCount).clamp(0.0, 1.0).toDouble();
  }
}
