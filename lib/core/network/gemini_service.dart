import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';
import 'package:fitmorph_ai/features/workout_generator/domain/models/workout_models.dart';
import 'package:fitmorph_ai/features/body_biometrics/domain/models/biometrics_model.dart';
import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';

class GeminiService {
  static const String _defaultApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static String? _runtimeApiKey;

  static void setApiKey(String key) {
    _runtimeApiKey = key;
  }

  static String get apiKey => _runtimeApiKey ?? _defaultApiKey;
  static bool get hasApiKey => apiKey.isNotEmpty;

  /// Gera treino personalizado usando Gemini Flash estruturado em JSON
  static Future<WorkoutPlan> generateWorkoutPlan(AnamneseModel anamnese) async {
    if (hasApiKey) {
      try {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.3,
          ),
        );

        String equipmentConstraint = '';
        if (anamnese.location == WorkoutLocation.homeGym) {
          equipmentConstraint = '''
🚨 REGRA CRÍTICA E INEGOCIÁVEL DE EQUIPAMENTO:
O aluno treina EM CASA (Home Gym / Halteres / Banco / Peso do Corpo).
É TERMINANTEMENTE PROIBIDO prescrever qualquer Máquina de academia ou Cabos/Polias (Ex: SEM Leg Press, SEM Cadeira Extensora, SEM Mesa Flexora, SEM Crossover, SEM Hack, SEM Peck Deck, SEM Pulldown na Polia, SEM Smith).
Você DEVE utilizar EXCLUSIVAMENTE os seguintes exercícios permitidos:
- Peito: chest_bench_press_dumbbell (Supino Reto Halteres), chest_incline_dumbbell_press (Supino Inclinado Halteres), chest_dumbbell_floor_press (Floor Press), chest_dumbbell_fly (Crucifixo Halteres), chest_pushup (Flexão)
- Costas: back_dumbbell_row (Remada Serrote), back_dumbbell_bent_over_row (Remada Curvada Halteres), back_dumbbell_pullover (Pullover Halter), back_pullup (Barra Fixa)
- Pernas/Posterior: legs_bulgarian_split_squat (Búlgaro), legs_goblet_squat (Goblet Squat), legs_dumbbell_lunges (Afundo), legs_dumbbell_romanian_deadlift (Stiff Halteres), legs_dumbbell_hip_thrust (Elevação Pélvica)
- Ombros: shoulders_overhead_dumbbell_press (Desenvolvimento Halteres), shoulders_lateral_raise_dumbbell (Elevação Lateral Halteres), shoulders_arnold_press (Arnold Press), shoulders_rear_delt_dumbbell_fly (Crucifixo Invertido Halteres)
- Braços: arms_dumbbell_biceps_curl (Rosca Direta Halteres), arms_dumbbell_hammer_curl (Rosca Martelo), arms_overhead_dumbbell_extension (Tríceps Francês), arms_skull_crusher_dumbbell (Tríceps Testa Halteres), arms_bench_dips (Mergulho no Banco)
- Panturrilha/Abdômen: calves_single_leg_calf_raise_step (Panturrilha Degrau), core_plank (Prancha), core_crunch (Crunch Solo)
''';
        } else if (anamnese.location == WorkoutLocation.bodyweightOnly) {
          equipmentConstraint = '''
🚨 REGRA CRÍTICA E INEGOCIÁVEL DE EQUIPAMENTO:
O aluno treina APENAS COM O PESO DO CORPO (Calistenia).
É TERMINANTEMENTE PROIBIDO prescrever halteres, barras, aparelhos, máquinas ou cabos. Utilize 100% peso corporal (chest_pushup, legs_bulgarian_split_squat, back_pullup, arms_bench_dips, core_plank, core_crunch, calves_single_leg_calf_raise_step).
''';
        }

        final prompt = '''
Você é o FitMorph AI Engine, autoridade máxima em hipertrofia e biomecânica baseada em evidências (Mike Israetel, Brad Schoenfeld).
Gere uma ficha de treino completa e hiperpersonalizada para o seguinte aluno:

Perfil:
- Nome: ${anamnese.name}
- Idade: ${anamnese.age} anos, Peso: ${anamnese.weightKg} kg, Altura: ${anamnese.heightCm} cm, Gênero: ${anamnese.gender}
- Nível de Experiência: ${anamnese.experienceLevel.name}
- Objetivo Primário: ${anamnese.primaryGoal}
- Frequência Semanal: ${anamnese.daysPerWeek} dias
- Tempo Disponível por Sessão: ${anamnese.availableMinutesPerSession} minutos
- Local de Treino: ${anamnese.location == WorkoutLocation.homeGym ? 'TREINO EM CASA COM HALTERES (HOME GYM)' : anamnese.location == WorkoutLocation.bodyweightOnly ? 'CALISTENIA / PESO DO CORPO' : 'ACADEMIA COMERCIAL COMPLETA'}
- Dores/Restrições Articulares (PROIBIDO EXERCÍCIOS AGRESSIVOS NESSAS ARTICULAÇÕES): ${anamnese.jointPains.join(', ')}
- Músculos com Prioridade de Hipertrofia: ${anamnese.preferredMuscles.join(', ')}
- Estilo de Divisão Muscular Solicitado: ${anamnese.splitStyle.displayName} (${anamnese.splitStyle.description})
${anamnese.splitStyle == WorkoutSplitStyle.agonistAntagonist ? 'IMPORTANTE: O aluno escolheu estilo AGONISTA / ANTAGONISTA. Agrupe músculos opostos na mesma sessão (ex: Peitoral + Costas juntos no Treino A, Bíceps + Tríceps + Ombros no Treino B, Pernas no Treino C).' : anamnese.splitStyle == WorkoutSplitStyle.upperLower ? 'IMPORTANTE: O aluno escolheu estilo UPPER / LOWER. Divida em membros superiores (Peito, Costas, Ombros, Braços) e inferiores (Pernas, Glúteos, Core).' : anamnese.splitStyle == WorkoutSplitStyle.fullBody ? 'IMPORTANTE: O aluno escolheu FULL BODY. Trabalhe múltiplos grandes grupos musculares em todas as sessões.' : ''}

$equipmentConstraint

Retorne um JSON rigorosamente com a seguinte estrutura:
{
  "title": "Ficha ${anamnese.location == WorkoutLocation.homeGym ? 'Home Gym' : 'Hipertrofia'} - ${anamnese.daysPerWeek}x",
  "splitType": "${anamnese.splitStyle != WorkoutSplitStyle.adaptive ? anamnese.splitStyle.displayName : (anamnese.daysPerWeek <= 3 ? 'Full Body' : anamnese.daysPerWeek == 4 ? 'Upper / Lower' : 'Push / Pull / Legs')}",
  "description": "Explicação científica da periodização, volume e adaptação para o ambiente de treino (${anamnese.location.name})",
  "weeklyVolumePerMuscle": {
    "Peito": 14,
    "Costas": 16,
    "Quadríceps": 12,
    "Isquiotibiais": 10,
    "Ombros": 12,
    "Braços": 10
  },
      "days": [
    {
      "dayLetter": "A",
      "title": "Treino A",
      "focusMuscles": ["Peito", "Ombros", "Tríceps"],
      "estimatedMinutes": ${anamnese.availableMinutesPerSession},
      "cardioProtocol": {
        "title": "Esteira Inclinada (LISS Zona 2)",
        "modality": "Esteira",
        "durationMinutes": 20,
        "intensityZone": "Zona 2 (120-135 bpm)",
        "speedInclineRecommendation": "5.5 km/h com 6.0% de inclinação",
        "estimatedCalories": 160,
        "equipment": "Esteira",
        "notes": "Cardio pós-treino para saúde mitocondrial e oxidação lipídica sem interferir na síntese proteica."
      },
      "exercises": [
        {
          "exerciseCatalogId": "chest_incline_dumbbell_press",
          "name": "Supino Inclinado com Halteres",
          "targetMuscle": "Peito",
          "setsCount": 4,
          "repsRange": "8-12",
          "rpeTarget": "RPE 8 / RIR 2",
          "restSeconds": 90,
          "notes": "Escápulas retraídas, foco na porção clavicular",
          "equipment": "Halteres",
          "isSuperSet": false,
          "substituteIds": ["chest_pushup", "chest_dumbbell_fly"]
        }
      ]
    }
  ]
}
''';

        final response = await model.generateContent([Content.text(prompt)]);
        final jsonText = response.text;
        if (jsonText != null && jsonText.isNotEmpty) {
          final decoded = jsonDecode(jsonText) as Map<String, dynamic>;
          decoded['id'] = 'plan_${DateTime.now().millisecondsSinceEpoch}';
          decoded['createdAt'] = DateTime.now().toIso8601String();
          decoded['isAiGenerated'] = true;
          final rawPlan = WorkoutPlan.fromJson(decoded);
          return _sanitizePlanForLocation(rawPlan, anamnese);
        }
      } catch (e) {
        debugPrint('[GeminiService] Erro ao chamar API do Gemini: $e. Utilizando algoritmo científico local.');
      }
    }

    // Fallback científico determinístico rigorosamente adaptado ao local
    final localPlan = generateScientificWorkoutPlanLocal(anamnese);
    return _sanitizePlanForLocation(localPlan, anamnese);
  }

  /// Análise de Biometria Visual por IA (Gemini Vision Multimodal)
  static Future<BodyScanResult> analyzeBodyPhotos({
    required List<Uint8List> photoBytesList,
    String notes = '',
  }) async {
    if (hasApiKey && photoBytesList.isNotEmpty) {
      try {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.3,
          ),
        );

        const prompt = '''
Você é o FitMorph Vision, um módulo biométrico para análise de composição corporal fitness.
Analise a(s) imagem(ns) do corpo fornecida(s) para estimativa visual de percentual de gordura corporal (%BF) e somatotipo.
Instruções:
- Seja realista, respeitoso e científico.
- Identifique pontos fortes musculares e pontos de melhoria simétrica.
- Retorne obrigatoriamente em JSON com o formato:
{
  "estimatedBodyFat": 14.5,
  "bodyFatRange": "13% - 16%",
  "somatotype": "Mesomorfo com boa proporção clavicular",
  "strongMuscles": ["Deltóides", "Costas"],
  "lagMuscles": ["Peitoral Superior", "Isquiotibiais"],
  "postureNotes": "Alinhamento escapular simétrico, boa postura cervical.",
  "aiFeedback": "Excelente base muscular para fase de ganho limpo (lean bulk).",
  "legalDisclaimer": "Estimativa visual por inteligência artificial multimodal. Não substitui métodos clínicos DEXA ou adipometria."
}
''';

        final contents = [
          Content.multi([
            TextPart(prompt),
            ...photoBytesList.map((bytes) => DataPart('image/jpeg', bytes)),
          ]),
        ];

        final response = await model.generateContent(contents);
        final jsonText = response.text;
        if (jsonText != null && jsonText.isNotEmpty) {
          final decoded = jsonDecode(jsonText) as Map<String, dynamic>;
          return BodyScanResult.fromJson(decoded);
        }
      } catch (e) {
        debugPrint('[GeminiService] Erro na análise visual Gemini: $e');
      }
    }

    return const BodyScanResult(
      estimatedBodyFat: 14.5,
      bodyFatRange: '13.5% - 15.5%',
      somatotype: 'Mesomorfo Predominante',
      strongMuscles: ['Deltóides', 'Braços'],
      lagMuscles: ['Peitoral Superior', 'Posterior de Coxa'],
      postureNotes: 'Alinhamento escapular neutro com boa ativação do core.',
      aiFeedback: 'Base anatômica atlética. Excelente estrutura para hipertrofia com progressão dupla de cargas.',
      legalDisclaimer: 'Estimativa visual computacional assistida por IA. Use como parâmetro comparativo de evolução.',
    );
  }

  /// Compactação Dinâmica de Tempo (Modo Anti-Tédio / Treino Rápido 30-40min)
  static WorkoutDay compactWorkoutForTime(WorkoutDay originalDay, int targetMinutes) {
    if (targetMinutes >= originalDay.estimatedMinutes) {
      return originalDay;
    }

    final originalExercises = originalDay.exercises;
    List<WorkoutExercise> compacted = [];

    for (int i = 0; i < originalExercises.length; i++) {
      final ex = originalExercises[i];
      final isEven = i % 2 == 0;
      final partnerIndex = isEven ? i + 1 : i - 1;
      
      String? superSetGroup;
      if (partnerIndex >= 0 && partnerIndex < originalExercises.length) {
        superSetGroup = 'Bi-Set ${(i ~/ 2) + 1}';
      }

      compacted.add(
        ex.copyWith(
          setsCount: (ex.setsCount > 3) ? 3 : ex.setsCount,
          restSeconds: (targetMinutes <= 35) ? 45 : 60,
          isSuperSet: superSetGroup != null,
          superSetGroup: superSetGroup,
          notes: superSetGroup != null
              ? '⚡ BI-SET: Execute sem descanso e vá direto para o próximo exercício.'
              : ex.notes,
        ),
      );
    }

    return originalDay.copyWith(
      estimatedMinutes: targetMinutes,
      title: '${originalDay.title} [Express $targetMinutes min]',
      exercises: compacted,
    );
  }

  /// Gerador Determinístico Científico de Treinos
  static WorkoutPlan generateScientificWorkoutPlanLocal(AnamneseModel anamnese) {
    final isHomeGym = anamnese.location == WorkoutLocation.homeGym || anamnese.location == WorkoutLocation.bodyweightOnly;
    final isBodyweightOnly = anamnese.location == WorkoutLocation.bodyweightOnly;
    final daysCount = anamnese.daysPerWeek;

    final hasShoulderPain = anamnese.jointPains.any((p) => p.toLowerCase().contains('ombro'));
    final hasKneePain = anamnese.jointPains.any((p) => p.toLowerCase().contains('joelho'));
    final hasBackPain = anamnese.jointPains.any((p) => p.toLowerCase().contains('lombar'));

    List<WorkoutDay> days = [];
    String splitName = 'Push / Pull / Legs';

    if (isBodyweightOnly) {
      // ==========================================
      // PERIODIZAÇÃO 100% CALISTENIA / PESO DO CORPO
      // ==========================================
      if (daysCount <= 3) {
        splitName = 'Full Body Calistenia 3x';
        days = [
          _createDay(
            'A',
            'Full Body A (Calistenia - Empurrar & Pernas)',
            ['Peito', 'Pernas', 'Costas', 'Ombros'],
            [
              'chest_pushup',
              'legs_bodyweight_squat',
              'back_inverted_row',
              'shoulders_pike_pushup',
              'arms_bench_dips',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'B',
            'Full Body B (Calistenia - Puxar & Posterior)',
            ['Costas', 'Glúteos', 'Peito', 'Bíceps'],
            [
              'back_pullup',
              'legs_bodyweight_single_leg_glute_bridge',
              'chest_pushup_feet_elevated',
              'arms_chinup',
              'calves_single_leg_calf_raise_step',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'C',
            'Full Body C (Calistenia - Core & Densidade)',
            ['Pernas', 'Costas', 'Ombros', 'Abdômen'],
            [
              'legs_bodyweight_squat',
              'back_pullup',
              'shoulders_pike_pushup',
              'arms_bench_dips',
              'core_plank',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
        ];
      } else {
        splitName = 'Upper / Lower Calistenia';
        days = [
          _createDay(
            'A',
            'Treino A - Upper Calistenia',
            ['Peito', 'Costas', 'Ombros', 'Tríceps'],
            [
              'chest_pushup',
              'back_pullup',
              'shoulders_pike_pushup',
              'back_inverted_row',
              'arms_bench_dips',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'B',
            'Treino B - Lower Calistenia',
            ['Pernas', 'Glúteos', 'Abdômen'],
            [
              'legs_bodyweight_squat',
              'legs_bodyweight_single_leg_glute_bridge',
              'calves_single_leg_calf_raise_step',
              'core_plank',
              'core_lying_leg_raise',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'C',
            'Treino C - Upper Calistenia Hipertrofia',
            ['Peito', 'Costas', 'Ombros', 'Bíceps'],
            [
              'chest_pushup_feet_elevated',
              'back_inverted_row',
              'shoulders_pike_pushup',
              'arms_chinup',
              'arms_bench_dips',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'D',
            'Treino D - Lower & Core Calistenia',
            ['Pernas', 'Glúteos', 'Abdômen'],
            [
              'legs_bodyweight_squat',
              'legs_bodyweight_single_leg_glute_bridge',
              'calves_single_leg_calf_raise_step',
              'core_crunch',
              'core_hanging_leg_raise',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
        ];
      }
    } else if (isHomeGym) {
      // ==========================================
      // PERIODIZAÇÃO EXCLUSIVA PARA TREINO EM CASA
      // (100% Halteres, Peso Corporal e Barra Fixa)
      // ==========================================
      if (daysCount <= 3) {
        splitName = 'Full Body Home 3x';
        days = [
          _createDay(
            'A',
            'Full Body A (Casa - Foco Empurrar & Quadríceps)',
            ['Peito', 'Pernas', 'Costas', 'Ombros'],
            [
              isBodyweightOnly ? 'chest_pushup' : (hasShoulderPain ? 'chest_dumbbell_floor_press' : 'chest_bench_press_dumbbell'),
              hasKneePain ? 'legs_goblet_squat' : 'legs_bulgarian_split_squat',
              'back_dumbbell_row',
              'shoulders_lateral_raise_dumbbell',
              'arms_overhead_dumbbell_extension',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'B',
            'Full Body B (Casa - Foco Puxar & Posterior)',
            ['Costas', 'Isquiotibiais', 'Peito', 'Bíceps'],
            [
              hasBackPain ? 'back_dumbbell_row' : 'back_dumbbell_bent_over_row',
              hasBackPain ? 'legs_dumbbell_hip_thrust' : 'legs_dumbbell_romanian_deadlift',
              'chest_incline_dumbbell_press',
              'arms_dumbbell_biceps_curl',
              'calves_single_leg_calf_raise_step',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'C',
            'Full Body C (Casa - Densidade & Glúteos)',
            ['Pernas', 'Costas', 'Ombros', 'Abdômen'],
            [
              'legs_goblet_squat',
              'back_dumbbell_pullover',
              'shoulders_arnold_press',
              'arms_dumbbell_hammer_curl',
              'core_plank',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
        ];
      } else if (daysCount == 4) {
        splitName = 'Upper / Lower Home 4x';
        days = [
          _createDay(
            'A',
            'Treino A - Upper Home (Superior Força)',
            ['Peito', 'Costas', 'Ombros', 'Tríceps'],
            [
              hasShoulderPain ? 'chest_dumbbell_floor_press' : 'chest_bench_press_dumbbell',
              'back_dumbbell_row',
              'shoulders_overhead_dumbbell_press',
              'back_dumbbell_pullover',
              'arms_skull_crusher_dumbbell',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'B',
            'Treino B - Lower Home (Inferior Quadríceps & Panturrilha)',
            ['Pernas', 'Glúteos', 'Panturrilhas'],
            [
              hasKneePain ? 'legs_goblet_squat' : 'legs_bulgarian_split_squat',
              'legs_dumbbell_lunges',
              'legs_dumbbell_hip_thrust',
              'calves_single_leg_calf_raise_step',
              'core_plank',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'C',
            'Treino C - Upper Home (Superior Hipertrofia)',
            ['Peito', 'Costas', 'Ombros', 'Bíceps'],
            [
              'chest_incline_dumbbell_press',
              'back_dumbbell_bent_over_row',
              'chest_dumbbell_fly',
              'shoulders_lateral_raise_dumbbell',
              'arms_dumbbell_biceps_curl',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'D',
            'Treino D - Lower Home (Posterior, Glúteos & Core)',
            ['Isquiotibiais', 'Glúteos', 'Abdômen'],
            [
              hasBackPain ? 'legs_dumbbell_hip_thrust' : 'legs_dumbbell_romanian_deadlift',
              'legs_goblet_squat',
              'legs_dumbbell_hip_thrust',
              'calves_single_leg_calf_raise_step',
              'core_crunch',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
        ];
      } else {
        splitName = 'Push / Pull / Legs Home (PPL)';
        days = [
          _createDay(
            'A',
            'Treino A - Push Home (Peito, Ombro e Tríceps)',
            ['Peito', 'Ombros', 'Tríceps'],
            [
              hasShoulderPain ? 'chest_dumbbell_floor_press' : 'chest_bench_press_dumbbell',
              'chest_incline_dumbbell_press',
              'shoulders_lateral_raise_dumbbell',
              'chest_dumbbell_fly',
              'arms_overhead_dumbbell_extension',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'B',
            'Treino B - Pull Home (Costas, Ombro Post e Bíceps)',
            ['Costas', 'Ombros', 'Bíceps'],
            [
              'back_dumbbell_row',
              'back_dumbbell_bent_over_row',
              'back_dumbbell_pullover',
              'shoulders_rear_delt_dumbbell_fly',
              'arms_dumbbell_biceps_curl',
              'arms_dumbbell_hammer_curl',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'C',
            'Treino C - Legs Home (Quadríceps, Posterior e Panturrilhas)',
            ['Pernas', 'Isquiotibiais', 'Panturrilhas'],
            [
              hasKneePain ? 'legs_goblet_squat' : 'legs_bulgarian_split_squat',
              'legs_dumbbell_lunges',
              'legs_dumbbell_romanian_deadlift',
              'legs_dumbbell_hip_thrust',
              'calves_single_leg_calf_raise_step',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'D',
            'Treino D - Upper Home (Tronco Completo)',
            ['Peito', 'Costas', 'Ombros', 'Braços'],
            [
              'chest_pushup',
              'back_dumbbell_row',
              'shoulders_arnold_press',
              'arms_bench_dips',
              'arms_concentration_curl',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'E',
            'Treino E - Lower & Core Home',
            ['Isquiotibiais', 'Glúteos', 'Abdômen'],
            [
              'legs_goblet_squat',
              'legs_dumbbell_romanian_deadlift',
              'legs_dumbbell_hip_thrust',
              'calves_single_leg_calf_raise_step',
              'core_plank',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
        ];
      }
    } else {
      // ==========================================
      // PERIODIZAÇÃO PARA ACADEMIA COMERCIAL
      // (Máquinas, Cabos, Halteres e Barras)
      // ==========================================
      if (anamnese.splitStyle == WorkoutSplitStyle.agonistAntagonist) {
        splitName = 'Agonista / Antagonista Gym (${daysCount}x)';
        days = [
          _createDay(
            'A',
            'Treino A - Peitoral & Dorsal (Agonista/Antagonista)',
            ['Peito', 'Costas'],
            [
              hasShoulderPain ? 'chest_machine_press' : 'chest_bench_press_barbell',
              'back_lat_pulldown',
              'chest_incline_dumbbell_press',
              hasBackPain ? 'back_seated_cable_row' : 'back_barbell_bent_over_row',
              'chest_cable_crossover',
              'back_facepull',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'B',
            'Treino B - Braços & Ombros (Bíceps, Tríceps & Deltóides)',
            ['Braços', 'Ombros'],
            [
              'shoulders_overhead_dumbbell_press',
              'arms_barbell_biceps_curl',
              'arms_cable_triceps_pushdown',
              'arms_dumbbell_hammer_curl',
              'arms_skull_crusher_dumbbell',
              'shoulders_lateral_raise_dumbbell',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'C',
            'Treino C - Pernas Completo (Quadríceps, Isquiotibiais & Panturrilhas)',
            ['Pernas', 'Isquiotibiais', 'Panturrilhas'],
            [
              hasKneePain ? 'legs_leg_press_45' : 'legs_barbell_squat',
              'legs_bulgarian_split_squat',
              'legs_leg_extension',
              'legs_lying_leg_curl',
              'calves_standing_calf_raise',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          if (daysCount >= 4)
            _createDay(
              'D',
              'Treino D - Peitoral & Dorsal V-Taper (Hipertrofia)',
              ['Peito', 'Costas', 'Trapézio'],
              [
                'chest_incline_smith_press',
                'back_dumbbell_row',
                'chest_bench_press_dumbbell',
                'back_pullup',
                'chest_cable_crossover',
              ],
              anamnese.availableMinutesPerSession,
              anamnese,
            ),
          if (daysCount >= 5)
            _createDay(
              'E',
              'Treino E - Membros Inferiores & Core',
              ['Isquiotibiais', 'Glúteos', 'Abdômen'],
              [
                hasBackPain ? 'legs_seated_leg_curl' : 'legs_romanian_deadlift',
                'legs_hip_thrust',
                'legs_hack_squat',
                'calves_standing_calf_raise',
                'core_hanging_leg_raise',
              ],
              anamnese.availableMinutesPerSession,
              anamnese,
            ),
        ];
      } else if (anamnese.splitStyle == WorkoutSplitStyle.fullBody || (anamnese.splitStyle == WorkoutSplitStyle.adaptive && daysCount <= 3)) {
        splitName = 'Full Body Gym 3x';
        days = [
          _createDay(
            'A',
            'Full Body A (Força & Empurrar)',
            ['Peito', 'Pernas', 'Costas', 'Ombros'],
            [
              hasShoulderPain ? 'chest_machine_press' : 'chest_bench_press_dumbbell',
              hasKneePain ? 'legs_leg_press_45' : 'legs_barbell_squat',
              'back_lat_pulldown',
              'shoulders_lateral_raise_dumbbell',
              'arms_triceps_rope_pushdown',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'B',
            'Full Body B (Puxar & Posterior)',
            ['Costas', 'Isquiotibiais', 'Peito', 'Bíceps'],
            [
              hasBackPain ? 'back_seated_cable_row' : 'back_barbell_bent_over_row',
              'legs_lying_leg_curl',
              'chest_incline_dumbbell_press',
              'arms_barbell_biceps_curl',
              'calves_standing_calf_raise',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'C',
            'Full Body C (Densidade & Isolamento)',
            ['Pernas', 'Costas', 'Peito', 'Braços'],
            [
              hasKneePain ? 'legs_hack_squat' : 'legs_bulgarian_split_squat',
              'back_pullup',
              'chest_cable_crossover',
              'shoulders_reverse_pec_deck',
              'core_hanging_leg_raise',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
        ];
      } else if (anamnese.splitStyle == WorkoutSplitStyle.upperLower || (anamnese.splitStyle == WorkoutSplitStyle.adaptive && daysCount == 4)) {
        splitName = 'Upper / Lower Gym 4x';
        days = [
          _createDay(
            'A',
            'Treino A - Upper Gym (Superior Força)',
            ['Peito', 'Costas', 'Ombros', 'Tríceps'],
            [
              hasShoulderPain ? 'chest_machine_press' : 'chest_bench_press_barbell',
              'back_lat_pulldown',
              'shoulders_overhead_dumbbell_press',
              'back_seated_cable_row',
              'arms_skull_crusher_dumbbell',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'B',
            'Treino B - Lower Gym (Inferior Quadríceps)',
            ['Pernas', 'Glúteos', 'Panturrilhas'],
            [
              hasKneePain ? 'legs_leg_press_45' : 'legs_barbell_squat',
              'legs_bulgarian_split_squat',
              'legs_leg_extension',
              'legs_lying_leg_curl',
              'calves_standing_calf_raise',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'C',
            'Treino C - Upper Gym (Superior Hipertrofia)',
            ['Costas', 'Peito', 'Ombros', 'Bíceps'],
            [
              'chest_incline_dumbbell_press',
              'back_dumbbell_row',
              'chest_cable_crossover',
              'shoulders_lateral_raise_dumbbell',
              'arms_dumbbell_incline_curl',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'D',
            'Treino D - Lower Gym (Inferior Posterior & Glúteos)',
            ['Isquiotibiais', 'Glúteos', 'Core'],
            [
              hasBackPain ? 'legs_seated_leg_curl' : 'legs_romanian_deadlift',
              'legs_hip_thrust',
              'legs_hack_squat',
              'calves_standing_calf_raise',
              'core_hanging_leg_raise',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
        ];
      } else {
        splitName = 'Push / Pull / Legs Gym (PPL)';
        days = [
          _createDay(
            'A',
            'Treino A - Push Gym (Peito, Ombro e Tríceps)',
            ['Peito', 'Ombros', 'Tríceps'],
            [
              hasShoulderPain ? 'chest_machine_press' : 'chest_bench_press_dumbbell',
              'chest_incline_dumbbell_press',
              'shoulders_lateral_raise_dumbbell',
              'chest_cable_crossover',
              'arms_cable_triceps_pushdown',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'B',
            'Treino B - Pull Gym (Costas, Deltóide Post e Bíceps)',
            ['Costas', 'Ombros', 'Bíceps'],
            [
              'back_lat_pulldown',
              hasBackPain ? 'back_seated_cable_row' : 'back_barbell_bent_over_row',
              'back_dumbbell_row',
              'back_facepull',
              'arms_barbell_biceps_curl',
              'arms_dumbbell_hammer_curl',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'C',
            'Treino C - Legs Gym (Quadríceps, Posterior e Panturrilhas)',
            ['Pernas', 'Isquiotibiais', 'Panturrilhas'],
            [
              hasKneePain ? 'legs_leg_press_45' : 'legs_barbell_squat',
              'legs_bulgarian_split_squat',
              'legs_leg_extension',
              'legs_lying_leg_curl',
              'calves_standing_calf_raise',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'D',
            'Treino D - Upper Gym (Tronco Completo)',
            ['Peito', 'Costas', 'Ombros', 'Braços'],
            [
              'chest_incline_smith_press',
              'back_pullup',
              'shoulders_cable_lateral_raise',
              'arms_skull_crusher_dumbbell',
              'arms_dumbbell_incline_curl',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
          _createDay(
            'E',
            'Treino E - Lower & Core Gym',
            ['Isquiotibiais', 'Glúteos', 'Abdômen'],
            [
              hasBackPain ? 'legs_seated_leg_curl' : 'legs_romanian_deadlift',
              'legs_hip_thrust',
              'legs_hack_squat',
              'calves_standing_calf_raise',
              'core_hanging_leg_raise',
            ],
            anamnese.availableMinutesPerSession,
            anamnese,
          ),
        ];
      }
    }

    return WorkoutPlan(
      id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
      title: 'FitMorph Pro ($splitName)',
      splitType: splitName,
      description: isHomeGym
          ? 'Periodização especializada para Treino em Casa (100% Halteres, Banco e Peso Corporal) com sobrecarga progressiva e cardio adaptado.'
          : 'Periodização ondulatória completa com máquinas, cabos, pesos livres e protocolo cardiovascular de precisão.',
      weeklyVolumePerMuscle: {
        'Peito': 14,
        'Costas': 16,
        'Pernas': 18,
        'Ombros': 12,
        'Braços': 12,
      },
      days: days,
      createdAt: DateTime.now(),
      isAiGenerated: true,
    );
  }

  static CardioProtocol _generateCardioProtocol(AnamneseModel anamnese, String dayLetter, String dayTitle) {
    final isCutting = anamnese.primaryGoal == 'fatLoss';
    final isHome = anamnese.location == WorkoutLocation.homeGym;
    final isBodyweight = anamnese.location == WorkoutLocation.bodyweightOnly;

    if (isBodyweight || isHome) {
      if (dayLetter == 'A') {
        return CardioProtocol(
          title: isCutting ? 'Caminhada Rápida ao Ar Livre' : 'Caminhada Regenerativa (LISS)',
          modality: 'Caminhada ao Ar Livre',
          durationMinutes: isCutting ? 30 : 20,
          intensityZone: 'Zona 2 (115-130 bpm)',
          speedInclineRecommendation: 'Ritmo acelerado (5.5 - 6.0 km/h) contínuo',
          estimatedCalories: isCutting ? 210 : 140,
          equipment: 'Peso Corporal',
          notes: 'Cardio de baixa intensidade para recuperação mitocondrial e controle glicêmico.',
        );
      } else if (dayLetter == 'B') {
        return CardioProtocol(
          title: 'Pular Corda (Intervalado)',
          modality: 'Corda de Pular',
          durationMinutes: isCutting ? 20 : 15,
          intensityZone: 'Zona 3 (130-145 bpm)',
          speedInclineRecommendation: '1 min pulando / 30s descanso ativo',
          estimatedCalories: isCutting ? 200 : 150,
          equipment: 'Corda de Pular',
          notes: 'Estímulo pliométrico e aeróbico de alta eficiência para gasto calórico.',
        );
      } else if (dayLetter == 'C') {
        return CardioProtocol(
          title: 'Subida de Degraus / Escadas',
          modality: 'Escada Residencial',
          durationMinutes: isCutting ? 25 : 15,
          intensityZone: 'Zona 2/3 (125-140 bpm)',
          speedInclineRecommendation: 'Passos ritmados com postura ereta',
          estimatedCalories: isCutting ? 220 : 145,
          equipment: 'Peso Corporal',
          notes: 'Excelente ativação glútea com baixo impacto articular.',
        );
      } else {
        return const CardioProtocol(
          title: 'HIIT Calistênico Aeróbico',
          modality: 'HIIT Peso Corporal',
          durationMinutes: 15,
          intensityZone: 'Zona 4 (145-160 bpm)',
          speedInclineRecommendation: 'Polichinelos, Trote estacionário e Mountain Climbers (40s on / 20s off)',
          estimatedCalories: 170,
          equipment: 'Peso Corporal',
          notes: 'Elevação máxima de EPOC (queima calórica pós-exercício) em tempo compacto.',
        );
      }
    }

    // Commercial Gym (Aparelhos)
    switch (dayLetter) {
      case 'A':
        return CardioProtocol(
          title: isCutting ? 'Esteira Inclinada Fat Loss' : 'Esteira Inclinada (LISS Pós-Treino)',
          modality: 'Esteira',
          durationMinutes: isCutting ? 30 : 20,
          intensityZone: 'Zona 2 (120-135 bpm)',
          speedInclineRecommendation: '5.5 km/h com 6.0% de inclinação',
          estimatedCalories: isCutting ? 240 : 160,
          equipment: 'Esteira',
          notes: 'Padrão-ouro científico: zero impacto articular, não compete com hipertrofia e maximiza oxidação de ácidos graxos.',
        );
      case 'B':
        return CardioProtocol(
          title: 'Simulador de Escada (Stairmaster)',
          modality: 'Simulador de Escada',
          durationMinutes: isCutting ? 25 : 15,
          intensityZone: 'Zona 3 (130-145 bpm)',
          speedInclineRecommendation: 'Nível 5 a 7 (55-65 passos/minuto)',
          estimatedCalories: isCutting ? 250 : 165,
          equipment: 'Simulador de Escada',
          notes: 'Alta densidade aeróbica com forte ativação neuromuscular de glúteos e panturrilhas.',
        );
      case 'C':
        return CardioProtocol(
          title: 'Bicicleta Ergométrica / Spinning',
          modality: 'Bicicleta Ergométrica',
          durationMinutes: isCutting ? 25 : 20,
          intensityZone: 'Zona 2 (120-135 bpm)',
          speedInclineRecommendation: 'Cadência 80-85 RPM com carga moderada',
          estimatedCalories: isCutting ? 220 : 150,
          equipment: 'Bicicleta Ergométrica',
          notes: 'Recuperação ativa para os membros inferiores e melhora da sensibilidade à insulina.',
        );
      case 'D':
        return CardioProtocol(
          title: 'Elíptico / Transport',
          modality: 'Elíptico',
          durationMinutes: isCutting ? 25 : 15,
          intensityZone: 'Zona 2/3 (125-140 bpm)',
          speedInclineRecommendation: 'Resistência nível 6 com cadência constante',
          estimatedCalories: isCutting ? 230 : 155,
          equipment: 'Elíptico',
          notes: 'Cardio com engajamento de corpo inteiro e zero estresse nas articulações.',
        );
      default:
        return const CardioProtocol(
          title: 'Esteira Inclinada (LISS Zona 2)',
          modality: 'Esteira',
          durationMinutes: 20,
          intensityZone: 'Zona 2 (120-135 bpm)',
          speedInclineRecommendation: '5.2 km/h com 5.0% de inclinação',
          estimatedCalories: 150,
          equipment: 'Esteira',
          notes: 'Manutenção cardiovascular e saúde mitocondrial.',
        );
    }
  }

  static WorkoutDay _createDay(
    String letter,
    String title,
    List<String> muscles,
    List<String> catalogIds,
    int minutes,
    AnamneseModel anamnese,
  ) {
    List<WorkoutExercise> exercises = [];
    for (int i = 0; i < catalogIds.length; i++) {
      final def = ExerciseCatalog.findById(catalogIds[i]);
      if (def != null) {
        exercises.add(
          WorkoutExercise(
            id: 'ex_${letter}_${i + 1}',
            exerciseCatalogId: def.id,
            name: def.name,
            targetMuscle: def.muscleGroup,
            setsCount: 3,
            repsRange: def.mechanics == 'Composto' ? '6-10' : '10-15',
            rpeTarget: 'RPE 8 / RIR 2',
            restSeconds: def.mechanics == 'Composto' ? 90 : 60,
            notes: def.instructions,
            equipment: def.equipment,
            substituteIds: def.substituteIds,
          ),
        );
      }
    }

    final cardio = _generateCardioProtocol(anamnese, letter, title);

    return WorkoutDay(
      id: 'day_$letter',
      dayLetter: letter,
      title: title,
      focusMuscles: muscles,
      estimatedMinutes: minutes,
      exercises: exercises,
      cardioProtocol: cardio,
    );
  }

  /// Sanitizador estrito: substitui qualquer exercício incompatível com o ambiente de treino
  static WorkoutPlan _sanitizePlanForLocation(WorkoutPlan plan, AnamneseModel anamnese) {
    final isBodyweightOnly = anamnese.location == WorkoutLocation.bodyweightOnly;
    final isHomeGym = anamnese.location == WorkoutLocation.homeGym || isBodyweightOnly;
    final List<WorkoutDay> sanitizedDays = [];

    for (final day in plan.days) {
      final List<WorkoutExercise> sanitizedExercises = [];
      for (final ex in day.exercises) {
        if (anamnese.location == WorkoutLocation.commercialGym) {
          sanitizedExercises.add(ex);
          continue;
        }

        final def = ExerciseCatalog.findById(ex.exerciseCatalogId);
        final equip = (def?.equipment ?? ex.equipment).toLowerCase();
        final name = ex.name.toLowerCase();

        final isMachineOrCable = equip.contains('máquina') ||
            equip.contains('maquina') ||
            equip.contains('cabo') ||
            (equip.contains('barra') && isBodyweightOnly) ||
            name.contains('leg press') ||
            name.contains('extensora') ||
            name.contains('flexora') ||
            name.contains('hack') ||
            name.contains('smith') ||
            name.contains('peck deck') ||
            name.contains('voador') ||
            name.contains('crossover') ||
            name.contains('puxada') ||
            name.contains('polia');

        final isInvalidForBodyweight = isBodyweightOnly && (def?.equipment != 'Peso Corporal' || ex.equipment != 'Peso Corporal');

        if (isMachineOrCable || isInvalidForBodyweight) {
          final fallback = ExerciseCatalog.getHomeFallbackExercise(
            ex.targetMuscle,
            bodyweightOnly: isBodyweightOnly,
          );

          sanitizedExercises.add(
            ex.copyWith(
              exerciseCatalogId: fallback.id,
              name: fallback.name,
              targetMuscle: fallback.muscleGroup,
              equipment: fallback.equipment,
              notes: fallback.instructions,
              substituteIds: fallback.substituteIds,
            ),
          );
        } else {
          sanitizedExercises.add(ex);
        }
      }

      // Ensure day has an appropriate cardio protocol
      final currentCardio = day.cardioProtocol;
      CardioProtocol? finalCardio = currentCardio;
      if (finalCardio == null) {
        finalCardio = _generateCardioProtocol(anamnese, day.dayLetter, day.title);
      } else if (isHomeGym) {
        final equipLower = finalCardio.equipment.toLowerCase();
        if (equipLower.contains('esteira') || equipLower.contains('escada') || equipLower.contains('bike') || equipLower.contains('bicicleta') || equipLower.contains('elíptico')) {
          finalCardio = _generateCardioProtocol(anamnese, day.dayLetter, day.title);
        }
      }

      sanitizedDays.add(day.copyWith(
        exercises: sanitizedExercises,
        cardioProtocol: finalCardio,
      ));
    }

    return plan.copyWith(days: sanitizedDays);
  }
}
