enum ExperienceLevel {
  beginner, // Iniciante (< 1 ano)
  intermediate, // Intermediário (1-3 anos)
  advanced, // Avançado (> 3 anos)
}

enum WorkoutLocation {
  commercialGym, // Academia Comercial Completa
  homeGym, // Academia em Casa / Halteres
  bodyweightOnly, // Calistenia / Peso do Corpo
}

enum WorkoutSplitStyle {
  adaptive, // IA escolhe automaticamente conforme a frequência
  agonistAntagonist, // Agonista / Antagonista (Peito + Costas, Braços Bíceps/Tríceps, Pernas)
  pushPullLegs, // Push (Empurrar: Peito/Ombro/Tríceps), Pull (Costas/Bíceps), Legs
  upperLower, // Upper / Lower (Superiores & Inferiores)
  fullBody, // Full Body (Corpo Inteiro na mesma sessão)
  aestheticSpecialization, // Especialização Estética de Foco Duplo (Músculos prioritários)
}

extension WorkoutSplitStyleExtension on WorkoutSplitStyle {
  String get displayName {
    switch (this) {
      case WorkoutSplitStyle.adaptive:
        return 'Automático / Adaptativo (IA)';
      case WorkoutSplitStyle.agonistAntagonist:
        return 'Agonista / Antagonista (Peito + Costas)';
      case WorkoutSplitStyle.pushPullLegs:
        return 'Push / Pull / Legs (Empurrar & Puxar)';
      case WorkoutSplitStyle.upperLower:
        return 'Upper / Lower (Superiores & Inferiores)';
      case WorkoutSplitStyle.fullBody:
        return 'Full Body (Corpo Inteiro por Sessão)';
      case WorkoutSplitStyle.aestheticSpecialization:
        return 'Especialização de Foco Duplo';
    }
  }

  String get shortName {
    switch (this) {
      case WorkoutSplitStyle.adaptive:
        return 'Adaptativo';
      case WorkoutSplitStyle.agonistAntagonist:
        return 'Agonista/Antagonista';
      case WorkoutSplitStyle.pushPullLegs:
        return 'PPL';
      case WorkoutSplitStyle.upperLower:
        return 'Upper/Lower';
      case WorkoutSplitStyle.fullBody:
        return 'Full Body';
      case WorkoutSplitStyle.aestheticSpecialization:
        return 'Foco Duplo';
    }
  }

  String get description {
    switch (this) {
      case WorkoutSplitStyle.adaptive:
        return 'A IA calibra a melhor divisão científica baseada no seu tempo e dias por semana.';
      case WorkoutSplitStyle.agonistAntagonist:
        return 'Treine músculos opostos juntos (Peito + Costas, Bíceps + Tríceps). Maior pump e eficiência.';
      case WorkoutSplitStyle.pushPullLegs:
        return 'Agrupa cadeias sinérgicas: Dia de Empurrar, Dia de Puxar e Dia de Pernas completas.';
      case WorkoutSplitStyle.upperLower:
        return 'Treina todos os membros superiores em um dia e inferiores no outro. Alta frequência muscular.';
      case WorkoutSplitStyle.fullBody:
        return 'Estimula múltiplos grupos musculares na mesma sessão. Ideal para 2 a 3x por semana.';
      case WorkoutSplitStyle.aestheticSpecialization:
        return 'Dobra o volume e a frequência nos músculos prioritários que você escolheu na anamnese.';
    }
  }
}

class AnamneseModel {
  final String id;
  final String name;
  final int age;
  final double weightKg;
  final double heightCm;
  final String gender; // 'male' | 'female' | 'other'
  final ExperienceLevel experienceLevel;
  final String primaryGoal; // 'hypertrophy' | 'fatLoss' | 'recomposition' | 'strength'
  final int daysPerWeek; // 2 a 6 dias
  final int availableMinutesPerSession; // 30, 45, 60, 90 min
  final WorkoutLocation location;
  final List<String> jointPains; // Ex: 'Joelho', 'Ombro', 'Lombar', 'Punho', 'Cotovelo'
  final List<String> preferredMuscles; // Ex: 'Peitoral', 'Glúteos', 'Braços', 'Dorsal'
  final WorkoutSplitStyle splitStyle;
  final String? preferredCardio; // Ex: 'Esteira Inclinada', 'Simulador de Escada', 'Bicicleta Ergométrica', 'Pular Corda', 'Caminhada ao Ar Livre'
  final double? estimatedBodyFat;

  const AnamneseModel({
    required this.id,
    required this.name,
    required this.age,
    required this.weightKg,
    required this.heightCm,
    required this.gender,
    required this.experienceLevel,
    required this.primaryGoal,
    required this.daysPerWeek,
    required this.availableMinutesPerSession,
    required this.location,
    required this.jointPains,
    required this.preferredMuscles,
    this.splitStyle = WorkoutSplitStyle.adaptive,
    this.preferredCardio,
    this.estimatedBodyFat,
  });

  AnamneseModel copyWith({
    String? id,
    String? name,
    int? age,
    double? weightKg,
    double? heightCm,
    String? gender,
    ExperienceLevel? experienceLevel,
    String? primaryGoal,
    int? daysPerWeek,
    int? availableMinutesPerSession,
    WorkoutLocation? location,
    List<String>? jointPains,
    List<String>? preferredMuscles,
    WorkoutSplitStyle? splitStyle,
    String? preferredCardio,
    double? estimatedBodyFat,
  }) {
    return AnamneseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      gender: gender ?? this.gender,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      availableMinutesPerSession: availableMinutesPerSession ?? this.availableMinutesPerSession,
      location: location ?? this.location,
      jointPains: jointPains ?? this.jointPains,
      preferredMuscles: preferredMuscles ?? this.preferredMuscles,
      splitStyle: splitStyle ?? this.splitStyle,
      preferredCardio: preferredCardio ?? this.preferredCardio,
      estimatedBodyFat: estimatedBodyFat ?? this.estimatedBodyFat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'gender': gender,
      'experienceLevel': experienceLevel.name,
      'primaryGoal': primaryGoal,
      'daysPerWeek': daysPerWeek,
      'availableMinutesPerSession': availableMinutesPerSession,
      'location': location.name,
      'jointPains': jointPains,
      'preferredMuscles': preferredMuscles,
      'splitStyle': splitStyle.name,
      'preferredCardio': preferredCardio,
      'estimatedBodyFat': estimatedBodyFat,
    };
  }

  factory AnamneseModel.fromJson(Map<String, dynamic> json) {
    return AnamneseModel(
      id: json['id'] as String? ?? 'default',
      name: json['name'] as String? ?? 'Atleta',
      age: json['age'] as int? ?? 25,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 75.0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 175.0,
      gender: json['gender'] as String? ?? 'male',
      experienceLevel: ExperienceLevel.values.firstWhere(
        (e) => e.name == json['experienceLevel'],
        orElse: () => ExperienceLevel.intermediate,
      ),
      primaryGoal: json['primaryGoal'] as String? ?? 'hypertrophy',
      daysPerWeek: json['daysPerWeek'] as int? ?? 4,
      availableMinutesPerSession: json['availableMinutesPerSession'] as int? ?? 60,
      location: WorkoutLocation.values.firstWhere(
        (e) => e.name == json['location'],
        orElse: () => WorkoutLocation.commercialGym,
      ),
      jointPains: List<String>.from(json['jointPains'] ?? []),
      preferredMuscles: List<String>.from(json['preferredMuscles'] ?? []),
      splitStyle: WorkoutSplitStyle.values.firstWhere(
        (e) => e.name == json['splitStyle'],
        orElse: () => WorkoutSplitStyle.adaptive,
      ),
      preferredCardio: json['preferredCardio'] as String?,
      estimatedBodyFat: (json['estimatedBodyFat'] as num?)?.toDouble(),
    );
  }

  static AnamneseModel empty() {
    return const AnamneseModel(
      id: '',
      name: '',
      age: 0,
      weightKg: 0,
      heightCm: 0,
      gender: 'male',
      experienceLevel: ExperienceLevel.beginner,
      primaryGoal: 'hypertrophy',
      daysPerWeek: 4,
      availableMinutesPerSession: 60,
      location: WorkoutLocation.commercialGym,
      jointPains: [],
      preferredMuscles: [],
      splitStyle: WorkoutSplitStyle.adaptive,
      preferredCardio: 'Esteira Inclinada',
      estimatedBodyFat: null,
    );
  }

  static AnamneseModel sample() {
    return const AnamneseModel(
      id: 'sample-1',
      name: 'Alexandre Silva',
      age: 28,
      weightKg: 78.5,
      heightCm: 178,
      gender: 'male',
      experienceLevel: ExperienceLevel.intermediate,
      primaryGoal: 'hypertrophy',
      daysPerWeek: 4,
      availableMinutesPerSession: 60,
      location: WorkoutLocation.commercialGym,
      jointPains: ['Ombro'],
      preferredMuscles: ['Peitoral', 'Braços'],
      splitStyle: WorkoutSplitStyle.agonistAntagonist,
      preferredCardio: 'Esteira Inclinada',
      estimatedBodyFat: 15.5,
    );
  }
}
