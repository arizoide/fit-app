import 'package:flutter/material.dart';

enum BadgeCategory {
  attendance, // Quantidade de dias / Presença
  streak,     // Dias seguidos
  comeback,   // Incentivos de retorno após abandono (A Volta por Cima)
  volume,     // Cargas e Tonelagem
}

class GymBadge {
  final String id;
  final String title;
  final String description;
  final String motivationalQuote;
  final IconData icon;
  final Color color;
  final BadgeCategory category;
  final int requiredValue; // Ex: 10 treinos, 14 dias ausente e volta, etc.
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final bool isComebackSpecial;

  const GymBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.motivationalQuote,
    required this.icon,
    required this.color,
    required this.category,
    required this.requiredValue,
    this.isUnlocked = false,
    this.unlockedAt,
    this.isComebackSpecial = false,
  });

  GymBadge copyWith({
    String? id,
    String? title,
    String? description,
    String? motivationalQuote,
    IconData? icon,
    Color? color,
    BadgeCategory? category,
    int? requiredValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
    bool? isComebackSpecial,
  }) {
    return GymBadge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      motivationalQuote: motivationalQuote ?? this.motivationalQuote,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      category: category ?? this.category,
      requiredValue: requiredValue ?? this.requiredValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isComebackSpecial: isComebackSpecial ?? this.isComebackSpecial,
    );
  }
}

class RankingMember {
  final String id;
  final String name;
  final String initials;
  final int workoutsMonth;
  final int totalWorkouts;
  final int currentStreak;
  final double totalVolumeKg;
  final bool isCurrentUser;
  final bool isComebackHero; // Voltou após período parado
  final String? comebackMessage;
  final List<String> badgeIds;

  final int treadmillMinutesMonth; // Minutos de esteira no mês atual
  final int totalTreadmillMinutes; // Minutos acumulados históricos
  final int treadmillCalories;    // Calorias estimadas queimadas na esteira

  const RankingMember({
    required this.id,
    required this.name,
    required this.initials,
    required this.workoutsMonth,
    required this.totalWorkouts,
    required this.currentStreak,
    required this.totalVolumeKg,
    this.treadmillMinutesMonth = 0,
    this.totalTreadmillMinutes = 0,
    this.treadmillCalories = 0,
    this.isCurrentUser = false,
    this.isComebackHero = false,
    this.comebackMessage,
    this.badgeIds = const [],
  });

  String get treadmillFormattedTime {
    final hours = treadmillMinutesMonth ~/ 60;
    final mins = treadmillMinutesMonth % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  String get totalTreadmillFormattedTime {
    final hours = totalTreadmillMinutes ~/ 60;
    final mins = totalTreadmillMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  RankingMember copyWith({
    String? id,
    String? name,
    String? initials,
    int? workoutsMonth,
    int? totalWorkouts,
    int? currentStreak,
    double? totalVolumeKg,
    int? treadmillMinutesMonth,
    int? totalTreadmillMinutes,
    int? treadmillCalories,
    bool? isCurrentUser,
    bool? isComebackHero,
    String? comebackMessage,
    List<String>? badgeIds,
  }) {
    return RankingMember(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      workoutsMonth: workoutsMonth ?? this.workoutsMonth,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      currentStreak: currentStreak ?? this.currentStreak,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
      treadmillMinutesMonth: treadmillMinutesMonth ?? this.treadmillMinutesMonth,
      totalTreadmillMinutes: totalTreadmillMinutes ?? this.totalTreadmillMinutes,
      treadmillCalories: treadmillCalories ?? this.treadmillCalories,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isComebackHero: isComebackHero ?? this.isComebackHero,
      comebackMessage: comebackMessage ?? this.comebackMessage,
      badgeIds: badgeIds ?? this.badgeIds,
    );
  }
}
