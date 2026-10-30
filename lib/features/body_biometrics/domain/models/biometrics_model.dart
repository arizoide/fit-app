class BodyScanResult {
  final double estimatedBodyFat;
  final String bodyFatRange; // Ex: '13% - 15%'
  final String somatotype; // 'Mesomorfo Predominante', 'Ectomorfo', 'Endomorfo'
  final List<String> strongMuscles;
  final List<String> lagMuscles; // Áreas para foco
  final String postureNotes;
  final String aiFeedback;
  final String legalDisclaimer;

  const BodyScanResult({
    required this.estimatedBodyFat,
    required this.bodyFatRange,
    required this.somatotype,
    required this.strongMuscles,
    required this.lagMuscles,
    required this.postureNotes,
    required this.aiFeedback,
    this.legalDisclaimer = 'Aviso: Esta estimativa é gerada por inteligência artificial multimodal para fins de acompanhamento físico e motivação. Não substitui exames antropométricos clínicos (como DEXA, bioimpedância tetrapolar ou adipômetro).',
  });

  Map<String, dynamic> toJson() => {
    'estimatedBodyFat': estimatedBodyFat,
    'bodyFatRange': bodyFatRange,
    'somatotype': somatotype,
    'strongMuscles': strongMuscles,
    'lagMuscles': lagMuscles,
    'postureNotes': postureNotes,
    'aiFeedback': aiFeedback,
    'legalDisclaimer': legalDisclaimer,
  };

  factory BodyScanResult.fromJson(Map<String, dynamic> json) => BodyScanResult(
    estimatedBodyFat: (json['estimatedBodyFat'] as num?)?.toDouble() ?? 15.0,
    bodyFatRange: json['bodyFatRange'] as String? ?? '14% - 16%',
    somatotype: json['somatotype'] as String? ?? 'Mesomorfo',
    strongMuscles: List<String>.from(json['strongMuscles'] ?? ['Peitoral', 'Ombros']),
    lagMuscles: List<String>.from(json['lagMuscles'] ?? ['Dorsais', 'Panturrilhas']),
    postureNotes: json['postureNotes'] as String? ?? 'Boa simetria frontal com leve rotação medial dos ombros.',
    aiFeedback: json['aiFeedback'] as String? ?? 'Excelente densidade no tronco superior. Foco em volume para costas e cadeia posterior.',
    legalDisclaimer: json['legalDisclaimer'] as String? ?? 'Esta análise visual é uma estimativa assistida por IA.',
  );
}

class BiometricEntry {
  final String id;
  final DateTime date;
  final double weightKg;
  final double? bodyFatPercentage;
  final double? chestCm;
  final double? waistCm;
  final double? armCm;
  final double? thighCm;
  final String? frontPhotoPath;
  final String? backPhotoPath;
  final String? notes;

  const BiometricEntry({
    required this.id,
    required this.date,
    required this.weightKg,
    this.bodyFatPercentage,
    this.chestCm,
    this.waistCm,
    this.armCm,
    this.thighCm,
    this.frontPhotoPath,
    this.backPhotoPath,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'weightKg': weightKg,
    'bodyFatPercentage': bodyFatPercentage,
    'chestCm': chestCm,
    'waistCm': waistCm,
    'armCm': armCm,
    'thighCm': thighCm,
    'frontPhotoPath': frontPhotoPath,
    'backPhotoPath': backPhotoPath,
    'notes': notes,
  };

  factory BiometricEntry.fromJson(Map<String, dynamic> json) => BiometricEntry(
    id: json['id'] as String,
    date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    weightKg: (json['weightKg'] as num?)?.toDouble() ?? 75.0,
    bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble(),
    chestCm: (json['chestCm'] as num?)?.toDouble(),
    waistCm: (json['waistCm'] as num?)?.toDouble(),
    armCm: (json['armCm'] as num?)?.toDouble(),
    thighCm: (json['thighCm'] as num?)?.toDouble(),
    frontPhotoPath: json['frontPhotoPath'] as String?,
    backPhotoPath: json['backPhotoPath'] as String?,
    notes: json['notes'] as String?,
  );
}
