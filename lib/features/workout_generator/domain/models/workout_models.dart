import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';

class ExerciseSet {
  final int setNumber;
  final int targetReps;
  int? completedReps;
  double? weightKg;
  bool isCompleted;
  int? rpeReal;

  ExerciseSet({
    required this.setNumber,
    required this.targetReps,
    this.completedReps,
    this.weightKg,
    this.isCompleted = false,
    this.rpeReal,
  });

  ExerciseSet copyWith({
    int? setNumber,
    int? targetReps,
    int? completedReps,
    double? weightKg,
    bool? isCompleted,
    int? rpeReal,
  }) {
    return ExerciseSet(
      setNumber: setNumber ?? this.setNumber,
      targetReps: targetReps ?? this.targetReps,
      completedReps: completedReps ?? this.completedReps,
      weightKg: weightKg ?? this.weightKg,
      isCompleted: isCompleted ?? this.isCompleted,
      rpeReal: rpeReal ?? this.rpeReal,
    );
  }

  Map<String, dynamic> toJson() => {
    'setNumber': setNumber,
    'targetReps': targetReps,
    'completedReps': completedReps,
    'weightKg': weightKg,
    'isCompleted': isCompleted,
    'rpeReal': rpeReal,
  };

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => ExerciseSet(
    setNumber: json['setNumber'] as int? ?? 1,
    targetReps: json['targetReps'] as int? ?? 10,
    completedReps: json['completedReps'] as int?,
    weightKg: (json['weightKg'] as num?)?.toDouble(),
    isCompleted: json['isCompleted'] as bool? ?? false,
    rpeReal: json['rpeReal'] as int?,
  );
}

class WorkoutExercise {
  final String id;
  final String exerciseCatalogId;
  final String name;
  final String targetMuscle;
  final int setsCount;
  final String repsRange; // '8-12' ou '6-8' ou '12-15'
  final String rpeTarget; // 'RPE 8 / RIR 2'
  final int restSeconds; // 60, 90, 120, 180
  final String notes;
  final String equipment;
  final bool isSuperSet;
  final String? superSetGroup;
  final List<String> substituteIds;
  List<ExerciseSet> sets;

  WorkoutExercise({
    required this.id,
    required this.exerciseCatalogId,
    required this.name,
    required this.targetMuscle,
    required this.setsCount,
    required this.repsRange,
    required this.rpeTarget,
    required this.restSeconds,
    this.notes = '',
    required this.equipment,
    this.isSuperSet = false,
    this.superSetGroup,
    required this.substituteIds,
    List<ExerciseSet>? sets,
  }) : sets = sets ?? List.generate(
         setsCount,
         (i) => ExerciseSet(
           setNumber: i + 1,
           targetReps: int.tryParse(repsRange.split('-').last) ?? 10,
         ),
       );

  WorkoutExercise copyWith({
    String? id,
    String? exerciseCatalogId,
    String? name,
    String? targetMuscle,
    int? setsCount,
    String? repsRange,
    String? rpeTarget,
    int? restSeconds,
    String? notes,
    String? equipment,
    bool? isSuperSet,
    String? superSetGroup,
    List<String>? substituteIds,
    List<ExerciseSet>? sets,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      exerciseCatalogId: exerciseCatalogId ?? this.exerciseCatalogId,
      name: name ?? this.name,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      setsCount: setsCount ?? this.setsCount,
      repsRange: repsRange ?? this.repsRange,
      rpeTarget: rpeTarget ?? this.rpeTarget,
      restSeconds: restSeconds ?? this.restSeconds,
      notes: notes ?? this.notes,
      equipment: equipment ?? this.equipment,
      isSuperSet: isSuperSet ?? this.isSuperSet,
      superSetGroup: superSetGroup ?? this.superSetGroup,
      substituteIds: substituteIds ?? this.substituteIds,
      sets: sets ?? this.sets.map((s) => s.copyWith()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exerciseCatalogId': exerciseCatalogId,
    'name': name,
    'targetMuscle': targetMuscle,
    'setsCount': setsCount,
    'repsRange': repsRange,
    'rpeTarget': rpeTarget,
    'restSeconds': restSeconds,
    'notes': notes,
    'equipment': equipment,
    'isSuperSet': isSuperSet,
    'superSetGroup': superSetGroup,
    'substituteIds': substituteIds,
    'sets': sets.map((s) => s.toJson()).toList(),
  };

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) => WorkoutExercise(
    id: json['id'] as String,
    exerciseCatalogId: json['exerciseCatalogId'] as String? ?? json['id'] as String,
    name: json['name'] as String,
    targetMuscle: json['targetMuscle'] as String,
    setsCount: json['setsCount'] as int? ?? 3,
    repsRange: json['repsRange'] as String? ?? '8-12',
    rpeTarget: json['rpeTarget'] as String? ?? 'RPE 8',
    restSeconds: json['restSeconds'] as int? ?? 90,
    notes: json['notes'] as String? ?? '',
    equipment: json['equipment'] as String? ?? 'Halteres',
    isSuperSet: json['isSuperSet'] as bool? ?? false,
    superSetGroup: json['superSetGroup'] as String?,
    substituteIds: List<String>.from(json['substituteIds'] ?? []),
    sets: (json['sets'] as List?)?.map((s) => ExerciseSet.fromJson(s)).toList(),
  );
}

class CardioProtocol {
  final String title;
  final String modality; // 'Esteira Inclinada', 'Bicicleta Ergométrica', 'Escada', 'Elíptico', 'Caminhada/Corrida', 'Pular Corda', 'HIIT'
  final int durationMinutes;
  final String intensityZone; // 'Zona 2 (120-135 bpm)', 'Moderado (130-145 bpm)', 'HIIT Alta Intensidade'
  final String speedInclineRecommendation; // 'Velocidade 5.5 - 6.0 km/h • Inclinação 5% a 8%'
  final int estimatedCalories;
  final String equipment; // 'Esteira', 'Bicicleta', 'Escada', 'Elíptico', 'Solo'
  final String notes;

  const CardioProtocol({
    required this.title,
    required this.modality,
    required this.durationMinutes,
    required this.intensityZone,
    required this.speedInclineRecommendation,
    required this.estimatedCalories,
    this.equipment = 'Esteira',
    this.notes = '',
  });

  CardioProtocol copyWith({
    String? title,
    String? modality,
    int? durationMinutes,
    String? intensityZone,
    String? speedInclineRecommendation,
    int? estimatedCalories,
    String? equipment,
    String? notes,
  }) {
    return CardioProtocol(
      title: title ?? this.title,
      modality: modality ?? this.modality,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensityZone: intensityZone ?? this.intensityZone,
      speedInclineRecommendation: speedInclineRecommendation ?? this.speedInclineRecommendation,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      equipment: equipment ?? this.equipment,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'modality': modality,
    'durationMinutes': durationMinutes,
    'intensityZone': intensityZone,
    'speedInclineRecommendation': speedInclineRecommendation,
    'estimatedCalories': estimatedCalories,
    'equipment': equipment,
    'notes': notes,
  };

  factory CardioProtocol.fromJson(Map<String, dynamic> json) => CardioProtocol(
    title: json['title'] as String? ?? 'Cardio Pós-Treino',
    modality: json['modality'] as String? ?? 'Esteira Inclinada',
    durationMinutes: json['durationMinutes'] as int? ?? 20,
    intensityZone: json['intensityZone'] as String? ?? 'Zona 2 (Lipólise - 120-135 bpm)',
    speedInclineRecommendation: json['speedInclineRecommendation'] as String? ?? 'Velocidade 5.5 km/h • Inclinação 6%',
    estimatedCalories: json['estimatedCalories'] as int? ?? 160,
    equipment: json['equipment'] as String? ?? 'Esteira',
    notes: json['notes'] as String? ?? '',
  );
}

class WorkoutDay {
  final String id;
  final String dayLetter; // 'A', 'B', 'C', 'D', 'E'
  final String title; // 'Treino A - Peitoral, Ombros & Tríceps'
  final List<String> focusMuscles;
  final int estimatedMinutes;
  final List<WorkoutExercise> exercises;
  final CardioProtocol? cardioProtocol;
  final bool isExpressMode;
  final int? originalEstimatedMinutes;
  final List<WorkoutExercise>? originalExercises;
  final CardioProtocol? originalCardioProtocol;

  const WorkoutDay({
    required this.id,
    required this.dayLetter,
    required this.title,
    required this.focusMuscles,
    required this.estimatedMinutes,
    required this.exercises,
    this.cardioProtocol,
    this.isExpressMode = false,
    this.originalEstimatedMinutes,
    this.originalExercises,
    this.originalCardioProtocol,
  });

  WorkoutDay copyWith({
    String? id,
    String? dayLetter,
    String? title,
    List<String>? focusMuscles,
    int? estimatedMinutes,
    List<WorkoutExercise>? exercises,
    CardioProtocol? cardioProtocol,
    bool? isExpressMode,
    int? originalEstimatedMinutes,
    List<WorkoutExercise>? originalExercises,
    CardioProtocol? originalCardioProtocol,
  }) {
    return WorkoutDay(
      id: id ?? this.id,
      dayLetter: dayLetter ?? this.dayLetter,
      title: title ?? this.title,
      focusMuscles: focusMuscles ?? this.focusMuscles,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      exercises: exercises ?? this.exercises,
      cardioProtocol: cardioProtocol ?? this.cardioProtocol,
      isExpressMode: isExpressMode ?? this.isExpressMode,
      originalEstimatedMinutes: originalEstimatedMinutes ?? this.originalEstimatedMinutes,
      originalExercises: originalExercises ?? this.originalExercises,
      originalCardioProtocol: originalCardioProtocol ?? this.originalCardioProtocol,
    );
  }

  WorkoutDay adaptToExpressTime(int targetMinutes) {
    final baseExercises = originalExercises ?? List<WorkoutExercise>.from(exercises);
    final baseMinutes = originalEstimatedMinutes ?? estimatedMinutes;
    final baseCardio = originalCardioProtocol ?? cardioProtocol;

    if (targetMinutes >= baseMinutes) {
      return restoreOriginal();
    }

    // Sort exercises by compound status / priority (Multiarticulares 80/20 no topo)
    final sortedExercises = List<WorkoutExercise>.from(baseExercises);
    sortedExercises.sort((a, b) {
      final defA = ExerciseCatalog.findById(a.exerciseCatalogId);
      final defB = ExerciseCatalog.findById(b.exerciseCatalogId);
      final isCompA = (defA?.mechanics == 'Composto') ? 1 : 0;
      final isCompB = (defB?.mechanics == 'Composto') ? 1 : 0;
      return isCompB.compareTo(isCompA);
    });

    int maxExercises;
    int setsPerEx;
    int restSec;
    String rpe;

    if (targetMinutes <= 15) {
      maxExercises = 2.clamp(1, sortedExercises.length);
      setsPerEx = 2;
      restSec = 45;
      rpe = 'RPE 9 / RIR 1 (Alta Intensidade)';
    } else if (targetMinutes <= 20) {
      maxExercises = 2.clamp(2, sortedExercises.length);
      setsPerEx = 2;
      restSec = 50;
      rpe = 'RPE 8.5 / RIR 1-2';
    } else if (targetMinutes <= 30) {
      maxExercises = 3.clamp(2, sortedExercises.length);
      setsPerEx = 2;
      restSec = 60;
      rpe = 'RPE 8 / RIR 2';
    } else if (targetMinutes <= 45) {
      maxExercises = 4.clamp(3, sortedExercises.length);
      setsPerEx = 3;
      restSec = 60;
      rpe = 'RPE 8 / RIR 2';
    } else {
      maxExercises = sortedExercises.length;
      setsPerEx = 3;
      restSec = 75;
      rpe = 'RPE 8';
    }

    final selected = sortedExercises.take(maxExercises).toList();
    final expressExercises = selected.map((ex) {
      return ex.copyWith(
        setsCount: setsPerEx,
        restSeconds: restSec,
        rpeTarget: rpe,
        notes: '⚡ Modo Express (${targetMinutes}min): Foco em execução perfeita e alta densidade.',
        sets: List.generate(
          setsPerEx,
          (i) => ExerciseSet(
            setNumber: i + 1,
            targetReps: int.tryParse(ex.repsRange.split('-').last) ?? 10,
          ),
        ),
      );
    }).toList();

    CardioProtocol? expressCardio;
    if (baseCardio != null && targetMinutes >= 25) {
      final cardioDur = targetMinutes <= 30 ? 6 : (targetMinutes <= 40 ? 10 : 15);
      expressCardio = baseCardio.copyWith(
        durationMinutes: cardioDur,
        title: '${baseCardio.title} (Express $cardioDur min)',
        intensityZone: 'HIIT / Queima Acelerada',
        estimatedCalories: (baseCardio.estimatedCalories * (cardioDur / (baseCardio.durationMinutes > 0 ? baseCardio.durationMinutes : 20))).round(),
        notes: '⚡ Versão Express de cardio adaptada ao seu tempo disponível hoje.',
      );
    }

    return copyWith(
      isExpressMode: true,
      estimatedMinutes: targetMinutes,
      exercises: expressExercises,
      cardioProtocol: expressCardio,
      originalExercises: baseExercises,
      originalEstimatedMinutes: baseMinutes,
      originalCardioProtocol: baseCardio,
    );
  }

  WorkoutDay restoreOriginal() {
    if (!isExpressMode) return this;
    return copyWith(
      isExpressMode: false,
      estimatedMinutes: originalEstimatedMinutes ?? estimatedMinutes,
      exercises: originalExercises ?? exercises,
      cardioProtocol: originalCardioProtocol ?? cardioProtocol,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dayLetter': dayLetter,
    'title': title,
    'focusMuscles': focusMuscles,
    'estimatedMinutes': estimatedMinutes,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'cardioProtocol': cardioProtocol?.toJson(),
    'isExpressMode': isExpressMode,
    'originalEstimatedMinutes': originalEstimatedMinutes,
  };

  factory WorkoutDay.fromJson(Map<String, dynamic> json) => WorkoutDay(
    id: json['id'] as String,
    dayLetter: json['dayLetter'] as String? ?? 'A',
    title: json['title'] as String,
    focusMuscles: List<String>.from(json['focusMuscles'] ?? []),
    estimatedMinutes: json['estimatedMinutes'] as int? ?? 55,
    exercises: (json['exercises'] as List)
        .map((e) => WorkoutExercise.fromJson(e))
        .toList(),
    cardioProtocol: json['cardioProtocol'] != null
        ? CardioProtocol.fromJson(json['cardioProtocol'] as Map<String, dynamic>)
        : null,
    isExpressMode: json['isExpressMode'] as bool? ?? false,
    originalEstimatedMinutes: json['originalEstimatedMinutes'] as int?,
  );
}

class WorkoutPlan {
  final String id;
  final String title;
  final String splitType; // 'Push / Pull / Legs (PPL)', 'Upper / Lower', 'ABCDE'
  final String description;
  final Map<String, int> weeklyVolumePerMuscle; // Ex: {'Peito': 14, 'Costas': 16}
  final List<WorkoutDay> days;
  final DateTime createdAt;
  final bool isAiGenerated;

  const WorkoutPlan({
    required this.id,
    required this.title,
    required this.splitType,
    required this.description,
    required this.weeklyVolumePerMuscle,
    required this.days,
    required this.createdAt,
    this.isAiGenerated = true,
  });

  WorkoutPlan copyWith({
    String? id,
    String? title,
    String? splitType,
    String? description,
    Map<String, int>? weeklyVolumePerMuscle,
    List<WorkoutDay>? days,
    DateTime? createdAt,
    bool? isAiGenerated,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      splitType: splitType ?? this.splitType,
      description: description ?? this.description,
      weeklyVolumePerMuscle: weeklyVolumePerMuscle ?? this.weeklyVolumePerMuscle,
      days: days ?? this.days,
      createdAt: createdAt ?? this.createdAt,
      isAiGenerated: isAiGenerated ?? this.isAiGenerated,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'splitType': splitType,
    'description': description,
    'weeklyVolumePerMuscle': weeklyVolumePerMuscle,
    'days': days.map((d) => d.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'isAiGenerated': isAiGenerated,
  };

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) => WorkoutPlan(
    id: json['id'] as String,
    title: json['title'] as String,
    splitType: json['splitType'] as String,
    description: json['description'] as String,
    weeklyVolumePerMuscle: Map<String, int>.from(json['weeklyVolumePerMuscle'] ?? {}),
    days: (json['days'] as List).map((d) => WorkoutDay.fromJson(d)).toList(),
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    isAiGenerated: json['isAiGenerated'] as bool? ?? true,
  );
}
