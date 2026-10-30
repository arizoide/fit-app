import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/ranking_models.dart';
import '../../../../core/providers/app_providers.dart';

enum RankingPeriod {
  month, // Este Mês
  allTime, // Total Histórico
  streak, // Ofensiva / Sequência
}

class RankingState {
  final RankingPeriod selectedPeriod;
  final List<RankingMember> members;
  final List<GymBadge> allBadges;

  const RankingState({
    required this.selectedPeriod,
    required this.members,
    required this.allBadges,
  });

  RankingState copyWith({
    RankingPeriod? selectedPeriod,
    List<RankingMember>? members,
    List<GymBadge>? allBadges,
  }) {
    return RankingState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      members: members ?? this.members,
      allBadges: allBadges ?? this.allBadges,
    );
  }

  RankingMember? get currentUser {
    try {
      return members.firstWhere((m) => m.isCurrentUser);
    } catch (_) {
      return null;
    }
  }

  int get currentUserRank {
    final sorted = sortedMembers;
    final index = sorted.indexWhere((m) => m.isCurrentUser);
    return index >= 0 ? index + 1 : 0;
  }

  List<RankingMember> get sortedMembers {
    final list = [...members];
    switch (selectedPeriod) {
      case RankingPeriod.month:
        list.sort((a, b) => b.workoutsMonth.compareTo(a.workoutsMonth));
        break;
      case RankingPeriod.allTime:
        list.sort((a, b) => b.totalWorkouts.compareTo(a.totalWorkouts));
        break;
      case RankingPeriod.streak:
        list.sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
        break;
    }
    return list;
  }

  List<RankingMember> get sortedTreadmillMembers {
    final list = [...members];
    list.sort((a, b) => b.treadmillMinutesMonth.compareTo(a.treadmillMinutesMonth));
    return list;
  }

  int get currentUserTreadmillRank {
    final sorted = sortedTreadmillMembers;
    final index = sorted.indexWhere((m) => m.isCurrentUser);
    return index >= 0 ? index + 1 : 0;
  }
}

class RankingNotifier extends StateNotifier<RankingState> {
  RankingNotifier(Ref ref) : super(_createInitialState(ref));

  static RankingState _createInitialState(Ref ref) {
    final anamnese = ref.read(anamneseProvider);
    final userName = anamnese.name.isNotEmpty ? anamnese.name : 'Você';
    final userInitials = userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'V';

    final badges = [
      // ==========================================
      // BADGES DE DIAS / PRESENÇA (ATTENDANCE)
      // ==========================================
      const GymBadge(
        id: 'att_1',
        title: 'Primeiro Passo',
        description: 'Concluiu o 1º treino e deu início à sua transformação.',
        motivationalQuote: 'A jornada de mil quilômetros começa com um único levantamento de barra.',
        icon: Icons.flag,
        color: Color(0xFF00C853),
        category: BadgeCategory.attendance,
        requiredValue: 1,
        isUnlocked: true,
      ),
      const GymBadge(
        id: 'att_10',
        title: 'Constância Inicial',
        description: '10 treinos completados com disciplina no salão.',
        motivationalQuote: 'A motivação te fez começar, a disciplina está te mantendo de pé.',
        icon: Icons.fitness_center,
        color: Color(0xFF0284C7),
        category: BadgeCategory.attendance,
        requiredValue: 10,
        isUnlocked: true,
      ),
      const GymBadge(
        id: 'att_25',
        title: 'Ritmo de Ferro',
        description: '25 treinos registrados. O corpo já começa a mudar visivelmente.',
        motivationalQuote: 'Seus músculos não sabem contar, mas sabem sentir consistência.',
        icon: Icons.shield,
        color: Color(0xFF7C3AED),
        category: BadgeCategory.attendance,
        requiredValue: 25,
        isUnlocked: true,
      ),
      const GymBadge(
        id: 'att_50',
        title: 'Guerreiro de Ferro',
        description: '50 treinos executados. Você já faz parte da elite da consistência.',
        motivationalQuote: 'Menos de 15% das pessoas atingem essa marca. Respeito total!',
        icon: Icons.military_tech,
        color: Color(0xFFEA580C),
        category: BadgeCategory.attendance,
        requiredValue: 50,
        isUnlocked: false,
      ),
      const GymBadge(
        id: 'att_100',
        title: 'Clube dos 100',
        description: '100 treinos concluídos! Um marco lendário de compromisso e hipertrofia.',
        motivationalQuote: 'Você não vai mais à academia: você se tornou o estilo de vida atlético.',
        icon: Icons.workspace_premium,
        color: Color(0xFFEAB308),
        category: BadgeCategory.attendance,
        requiredValue: 100,
        isUnlocked: false,
      ),
      const GymBadge(
        id: 'att_200',
        title: 'Lenda da Academia',
        description: '200 treinos concluídos no FitMorph AI.',
        motivationalQuote: 'Consistência de ferro inabalável. Um exemplo para toda a comunidade!',
        icon: Icons.diamond,
        color: Color(0xFFEC4899),
        category: BadgeCategory.attendance,
        requiredValue: 200,
        isUnlocked: false,
      ),

      // ==========================================
      // BADGES DE RETORNO / INCENTIVO ANTI-DESISTÊNCIA (COMEBACK SPECIAL)
      // ==========================================
      const GymBadge(
        id: 'comeback_fenix',
        title: 'Fênix de Ferro',
        description: 'Voltou à academia após mais de 14 dias parado. O retorno do guerreiro!',
        motivationalQuote: 'Cair faz parte do caminho. Levantar e voltar a treinar é para os verdadeiros campeões.',
        icon: Icons.local_fire_department,
        color: Color(0xFFE11D48),
        category: BadgeCategory.comeback,
        requiredValue: 14,
        isUnlocked: true,
        isComebackSpecial: true,
      ),
      const GymBadge(
        id: 'comeback_nunca_tarde',
        title: 'Nunca é Tarde',
        description: 'Retomou os treinos após uma longa pausa (30+ dias sem treinar).',
        motivationalQuote: 'Sem culpa pelo tempo parado. O seu melhor treino é o que você faz hoje!',
        icon: Icons.spa,
        color: Color(0xFF059669),
        category: BadgeCategory.comeback,
        requiredValue: 30,
        isUnlocked: true,
        isComebackSpecial: true,
      ),
      const GymBadge(
        id: 'comeback_segunda_chance',
        title: 'Segunda Chance',
        description: 'Completou 3 treinos na primeira semana após o retorno.',
        motivationalQuote: 'A inércia foi quebrada! Você provou que a força de vontade vence a preguiça.',
        icon: Icons.replay,
        color: Color(0xFF0284C7),
        category: BadgeCategory.comeback,
        requiredValue: 3,
        isUnlocked: true,
        isComebackSpecial: true,
      ),
      const GymBadge(
        id: 'comeback_zero_julgamentos',
        title: 'Zero Julgamentos',
        description: 'Superou a vergonha de voltar e colocou os pés na academia de cabeça erguida.',
        motivationalQuote: 'A academia pertence a quem aparece, não a quem julga.',
        icon: Icons.psychology,
        color: Color(0xFF9333EA),
        category: BadgeCategory.comeback,
        requiredValue: 1,
        isUnlocked: true,
        isComebackSpecial: true,
      ),
      const GymBadge(
        id: 'comeback_turbo',
        title: 'Turbo de Retorno',
        description: 'Bateu a meta da semana inteira após a reativação.',
        motivationalQuote: 'O hábito foi reconquistado com louvor. O ferro sempre te recebe de volta!',
        icon: Icons.bolt,
        color: Color(0xFFF59E0B),
        category: BadgeCategory.comeback,
        requiredValue: 4,
        isUnlocked: false,
        isComebackSpecial: true,
      ),

      // ==========================================
      // BADGES DE OFENSIVA (STREAK)
      // ==========================================
      const GymBadge(
        id: 'streak_3',
        title: 'Foco Semanal',
        description: '3 dias consecutivos de treino sem falhar.',
        motivationalQuote: 'A engrenagem do hábito começou a girar.',
        icon: Icons.trending_up,
        color: Color(0xFF00C853),
        category: BadgeCategory.streak,
        requiredValue: 3,
        isUnlocked: true,
      ),
      const GymBadge(
        id: 'streak_7',
        title: 'Semana Imparável',
        description: '7 dias consecutivos ou frequência impecável de 5x no microciclo.',
        motivationalQuote: 'Inabalável! Sua constância semanal está no mais alto nível.',
        icon: Icons.auto_awesome,
        color: Color(0xFF0284C7),
        category: BadgeCategory.streak,
        requiredValue: 7,
        isUnlocked: false,
      ),
      const GymBadge(
        id: 'streak_21',
        title: 'Hábito Blindado',
        description: '21 dias de disciplina e presença assídua.',
        motivationalQuote: 'Cientificamente falando: treinar agora faz parte do seu DNA.',
        icon: Icons.verified,
        color: Color(0xFF7C3AED),
        category: BadgeCategory.streak,
        requiredValue: 21,
        isUnlocked: false,
      ),
    ];

    // Membros simulados da comunidade FitMorph para competição saudável
    final members = [
      const RankingMember(
        id: 'user_1',
        name: 'Camila Rocha',
        initials: 'CR',
        workoutsMonth: 23,
        totalWorkouts: 142,
        currentStreak: 6,
        totalVolumeKg: 48200,
        treadmillMinutesMonth: 480, // 8h 00m
        totalTreadmillMinutes: 2840,
        treadmillCalories: 3840,
        badgeIds: ['att_1', 'att_10', 'att_25', 'att_50', 'att_100', 'streak_7'],
      ),
      const RankingMember(
        id: 'user_2',
        name: 'Thiago Mendes',
        initials: 'TM',
        workoutsMonth: 21,
        totalWorkouts: 118,
        currentStreak: 5,
        totalVolumeKg: 52400,
        treadmillMinutesMonth: 435, // 7h 15m
        totalTreadmillMinutes: 2410,
        treadmillCalories: 3480,
        badgeIds: ['att_1', 'att_10', 'att_25', 'att_50', 'att_100'],
      ),
      const RankingMember(
        id: 'user_3',
        name: 'Mariana Duarte',
        initials: 'MD',
        workoutsMonth: 20,
        totalWorkouts: 94,
        currentStreak: 4,
        totalVolumeKg: 36100,
        treadmillMinutesMonth: 390, // 6h 30m
        totalTreadmillMinutes: 1980,
        treadmillCalories: 3120,
        badgeIds: ['att_1', 'att_10', 'att_25', 'att_50', 'streak_3'],
      ),
      // Usuário Atual (Posição de disputa alta, bem perto do Top 3)
      RankingMember(
        id: 'current_user',
        name: '$userName (Você)',
        initials: userInitials,
        workoutsMonth: 19,
        totalWorkouts: 48,
        currentStreak: 3,
        totalVolumeKg: 39500,
        treadmillMinutesMonth: 340, // 5h 40m
        totalTreadmillMinutes: 1250,
        treadmillCalories: 2720,
        isCurrentUser: true,
        isComebackHero: true,
        comebackMessage: 'Superou 18 dias parado e voltou com tudo!',
        badgeIds: ['att_1', 'att_10', 'att_25', 'comeback_fenix', 'comeback_segunda_chance', 'streak_3'],
      ),
      const RankingMember(
        id: 'user_4',
        name: 'Lucas Prado (Iniciante)',
        initials: 'LP',
        workoutsMonth: 17,
        totalWorkouts: 17,
        currentStreak: 3,
        totalVolumeKg: 18200,
        treadmillMinutesMonth: 280, // 4h 40m
        totalTreadmillMinutes: 280,
        treadmillCalories: 2240,
        isComebackHero: true,
        comebackMessage: 'Venceu a vergonha do 1º mês!',
        badgeIds: ['att_1', 'att_10', 'comeback_zero_julgamentos'],
      ),
      const RankingMember(
        id: 'user_5',
        name: 'Rodrigo Alencar (Avançado)',
        initials: 'RA',
        workoutsMonth: 16,
        totalWorkouts: 210,
        currentStreak: 4,
        totalVolumeKg: 78900,
        treadmillMinutesMonth: 240, // 4h 00m
        totalTreadmillMinutes: 4100,
        treadmillCalories: 1920,
        badgeIds: ['att_1', 'att_10', 'att_25', 'att_50', 'att_100', 'att_200'],
      ),
      const RankingMember(
        id: 'user_6',
        name: 'Juliana Paes',
        initials: 'JP',
        workoutsMonth: 15,
        totalWorkouts: 64,
        currentStreak: 2,
        totalVolumeKg: 28400,
        treadmillMinutesMonth: 210, // 3h 30m
        totalTreadmillMinutes: 1100,
        treadmillCalories: 1680,
        badgeIds: ['att_1', 'att_10', 'att_25', 'att_50'],
      ),
      const RankingMember(
        id: 'user_7',
        name: 'Felipe Santos',
        initials: 'FS',
        workoutsMonth: 14,
        totalWorkouts: 38,
        currentStreak: 2,
        totalVolumeKg: 25100,
        treadmillMinutesMonth: 180, // 3h 00m
        totalTreadmillMinutes: 620,
        treadmillCalories: 1440,
        isComebackHero: true,
        comebackMessage: 'Fênix de Ferro: Voltou após 2 meses parado',
        badgeIds: ['att_1', 'att_10', 'att_25', 'comeback_fenix', 'comeback_nunca_tarde'],
      ),
      const RankingMember(
        id: 'user_8',
        name: 'Beatriz Lima',
        initials: 'BL',
        workoutsMonth: 12,
        totalWorkouts: 29,
        currentStreak: 1,
        totalVolumeKg: 19800,
        treadmillMinutesMonth: 150, // 2h 30m
        totalTreadmillMinutes: 450,
        treadmillCalories: 1200,
        badgeIds: ['att_1', 'att_10', 'att_25'],
      ),
    ];

    return RankingState(
      selectedPeriod: RankingPeriod.month,
      members: members,
      allBadges: badges,
    );
  }

  void setPeriod(RankingPeriod period) {
    state = state.copyWith(selectedPeriod: period);
  }

  void registerNewWorkoutCheckin() {
    final current = state.currentUser;
    if (current == null) return;

    final updatedMembers = state.members.map((m) {
      if (m.isCurrentUser) {
        return m.copyWith(
          workoutsMonth: m.workoutsMonth + 1,
          totalWorkouts: m.totalWorkouts + 1,
          currentStreak: m.currentStreak + 1,
        );
      }
      return m;
    }).toList();

    state = state.copyWith(members: updatedMembers);
  }

  void logTreadmillWalk(int minutes, {int calories = 0}) {
    final current = state.currentUser;
    if (current == null || minutes <= 0) return;

    final estimatedCals = calories > 0 ? calories : (minutes * 8); // ~8 kcal/min em esteira inclinada LISS

    final updatedMembers = state.members.map((m) {
      if (m.isCurrentUser) {
        return m.copyWith(
          treadmillMinutesMonth: m.treadmillMinutesMonth + minutes,
          totalTreadmillMinutes: m.totalTreadmillMinutes + minutes,
          treadmillCalories: m.treadmillCalories + estimatedCals,
        );
      }
      return m;
    }).toList();

    state = state.copyWith(members: updatedMembers);
  }
}

final rankingProvider = StateNotifierProvider<RankingNotifier, RankingState>((ref) {
  return RankingNotifier(ref);
});
