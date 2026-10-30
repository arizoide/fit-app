import 'package:flutter/material.dart';

class FirstDayWeightAdvice {
  final String startingWeight;
  final String targetZone;
  final String safetyTip;
  final IconData icon;

  const FirstDayWeightAdvice({
    required this.startingWeight,
    required this.targetZone,
    required this.safetyTip,
    required this.icon,
  });
}

class FirstDayWeightHelper {
  static FirstDayWeightAdvice getAdvice({
    required String exerciseName,
    required String equipment,
    String muscle = '',
  }) {
    final lowerName = exerciseName.toLowerCase();
    final lowerEq = equipment.toLowerCase();

    // 1. Barras Olímpicas & Compostos Pesados
    if (lowerEq.contains('barra') ||
        lowerName.contains('supino') ||
        lowerName.contains('agachamento') ||
        lowerName.contains('terra') ||
        lowerName.contains('stiff')) {
      return const FirstDayWeightAdvice(
        startingWeight: 'Barra livre (20kg) ou barra guiada no Smith sem anilhas',
        targetZone: 'Apenas a barra (0 anilhas)',
        safetyTip: 'No 1º dia, aprenda o trajeto da barra sem peso extra. Domine o equilíbrio antes de colocar placas.',
        icon: Icons.fitness_center,
      );
    }

    // 2. Halteres (Dumbbells)
    if (lowerEq.contains('halter') || lowerName.contains('halter')) {
      if (lowerName.contains('lateral') || lowerName.contains('ombro') || lowerName.contains('tríceps') || lowerName.contains('triceps')) {
        return const FirstDayWeightAdvice(
          startingWeight: 'Halteres de 2kg a 4kg cada lado',
          targetZone: '2kg a 4kg por mão',
          safetyTip: 'Músculos pequenos (ombro e tríceps) precisam de pouco peso. Priorize o controle sem balançar o corpo.',
          icon: Icons.pan_tool_alt,
        );
      }
      return const FirstDayWeightAdvice(
        startingWeight: 'Halteres leves de 4kg a 6kg cada lado',
        targetZone: '4kg a 6kg por mão',
        safetyTip: 'Mantenha os pulsos retos e suba em 1 segundo e desça em 2 segundos controlando.',
        icon: Icons.fitness_center,
      );
    }

    // 3. Máquinas, Cabos e Polias
    if (lowerEq.contains('máquina') ||
        lowerEq.contains('maquina') ||
        lowerEq.contains('cabo') ||
        lowerEq.contains('polia') ||
        lowerName.contains('press') ||
        lowerName.contains('extensora') ||
        lowerName.contains('flexora') ||
        lowerName.contains('puxador') ||
        lowerName.contains('crossover')) {
      return const FirstDayWeightAdvice(
        startingWeight: '2 a 3 placas (10kg a 15kg)',
        targetZone: '10kg a 15kg no pino',
        safetyTip: 'Regule a altura do banco e apoios antes de começar para não forçar as articulações.',
        icon: Icons.tune,
      );
    }

    // 4. Peso Corporal (Calistenia / Livre)
    if (lowerEq.contains('corpo') || lowerEq.contains('livre') || lowerName.contains('flexão') || lowerName.contains('abdominal')) {
      return const FirstDayWeightAdvice(
        startingWeight: 'Peso do próprio corpo com apoio',
        targetZone: 'Sem carga externa',
        safetyTip: 'Para flexões, apoie os joelhos no chão. Foque em contrair o abdômen e respirar ritmadamente.',
        icon: Icons.accessibility_new,
      );
    }

    // Padrão Geral
    return const FirstDayWeightAdvice(
      startingWeight: 'Carga inicial leve (5kg a 10kg)',
      targetZone: '5kg a 10kg',
      safetyTip: 'Comece leve para acordar a musculatura. O foco da primeira semana é criar o hábito!',
      icon: Icons.lightbulb_outline,
    );
  }
}
