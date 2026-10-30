import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/models/ranking_models.dart';
import '../providers/ranking_providers.dart';
import '../widgets/podium_widget.dart';
import '../widgets/badge_card.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> {
  int _activeTab = 0; // 0: Ranking de Presença, 1: Caminhada na Esteira por Tempo, 2: Conquistas & Badges
  String _badgeFilter = 'all'; // 'all', 'attendance', 'comeback', 'streak'

  @override
  Widget build(BuildContext context) {
    final rankingState = ref.watch(rankingProvider);
    final sortedMembers = rankingState.sortedMembers;
    final top3 = sortedMembers.take(3).toList();
    final remainingMembers = sortedMembers.skip(3).toList();
    final currentUser = rankingState.currentUser;
    final userRank = rankingState.currentUserRank;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: Color(0xFFEAB308)),
            const SizedBox(width: 8),
            Text('Ranking & Conquistas', style: AppTextStyles.heading2),
          ],
        ),
      ),
      body: Column(
        children: [
          // Segmented Tab Switcher (Modern Pill com 3 Abas)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSegmentButton(
                    index: 0,
                    icon: Icons.leaderboard,
                    label: 'Ranking da Academia',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildSegmentButton(
                    index: 1,
                    icon: Icons.directions_walk,
                    label: 'Esteira por Tempo',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildSegmentButton(
                    index: 2,
                    icon: Icons.military_tech,
                    label: 'Badges & Superação',
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _activeTab == 0
                ? _buildRankingTab(context, rankingState, top3, remainingMembers, currentUser, userRank)
                : _activeTab == 1
                    ? _buildTreadmillTab(context, rankingState)
                    : _buildBadgesTab(context, rankingState),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.neonLime : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.neonLime.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ABA 0: RANKING DE PRESENÇA E COMPETIÇÃO SAUDÁVEL
  // ==========================================================
  Widget _buildRankingTab(
    BuildContext context,
    RankingState state,
    List<RankingMember> top3,
    List<RankingMember> others,
    RankingMember? currentUser,
    int userRank,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPeriodChip('Mês Atual (Outubro)', RankingPeriod.month, state.selectedPeriod),
                _buildPeriodChip('Geral Acumulado', RankingPeriod.allTime, state.selectedPeriod),
                _buildPeriodChip('Ofensiva (Dias Seguidos)', RankingPeriod.streak, state.selectedPeriod),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Pódio do Top 3
          if (top3.isNotEmpty) PodiumWidget(top3: top3),
          const SizedBox(height: 16),

          // Card de Status do Usuário Atual (Hero de Posição)
          if (currentUser != null) _buildCurrentUserHeroCard(currentUser, userRank),
          const SizedBox(height: 16),

          // Banner Empático de Incentivo ao Retorno (Anti-Desistência)
          _buildComebackIncentiveBanner(),
          const SizedBox(height: 16),

          // Cabeçalho da Lista Completa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Demais Competidores da Academia', style: AppTextStyles.labelBold),
              Text(
                '${others.length + top3.length} atletas ativos',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Lista de Competidores
          ...others.asMap().entries.map((entry) {
            final position = entry.key + 4;
            final member = entry.value;
            return _buildMemberTile(member, position, state.selectedPeriod);
          }),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String label, RankingPeriod period, RankingPeriod current) {
    final isSel = period == current;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        selectedColor: AppColors.neonLime.withOpacity(0.2),
        backgroundColor: AppColors.surfaceLight,
        labelStyle: TextStyle(
          color: isSel ? AppColors.neonLime : AppColors.textSecondary,
          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
          fontSize: 11,
        ),
        side: BorderSide(color: isSel ? AppColors.neonLime : AppColors.cardBorder),
        onSelected: (selected) {
          if (selected) {
            ref.read(rankingProvider.notifier).setPeriod(period);
          }
        },
      ),
    );
  }

  Widget _buildCurrentUserHeroCard(RankingMember user, int rank) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neonLime.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neonLime, width: 2),
            ),
            child: Text(
              '#$rank',
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.neonLime,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (user.isComebackHero) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE11D48),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'RETOMADA',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  rank <= 3
                      ? 'Parabéns! Você está no Pódio de Ouro da Academia!'
                      : 'Faltam apenas ${20 - user.workoutsMonth} treinos para alcançar o Top 3!',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.workoutsMonth}',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.neonLime,
                ),
              ),
              const Text(
                'treinos',
                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComebackIncentiveBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECDD3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE11D48),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Faltou dias ou semanas? A hora de voltar é HOJE!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9F1239),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Ganhe a badge especial "Fênix de Ferro" e pontos bônus no seu retorno. Sem culpa, sem julgamentos!',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFFBE123C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(RankingMember member, int position, RankingPeriod period) {
    String metricLabel;
    String metricValue;

    switch (period) {
      case RankingPeriod.month:
        metricLabel = 'treinos no mês';
        metricValue = '${member.workoutsMonth}';
        break;
      case RankingPeriod.allTime:
        metricLabel = 'treinos no total';
        metricValue = '${member.totalWorkouts}';
        break;
      case RankingPeriod.streak:
        metricLabel = 'dias seguidos';
        metricValue = '${member.currentStreak} 🔥';
        break;
    }

    final isUser = member.isCurrentUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? AppColors.neonLime.withOpacity(0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUser ? AppColors.neonLime.withOpacity(0.5) : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          // Posição
          SizedBox(
            width: 28,
            child: Text(
              '#$position',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isUser ? AppColors.neonLime : AppColors.textMuted,
              ),
            ),
          ),

          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: isUser ? AppColors.neonLime.withOpacity(0.2) : AppColors.surfaceLight,
            child: Text(
              member.initials,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isUser ? AppColors.neonLime : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Nome & Detalhe
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isUser ? FontWeight.bold : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (member.isComebackHero) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.local_fire_department, size: 14, color: Color(0xFFE11D48)),
                    ],
                  ],
                ),
                if (member.comebackMessage != null)
                  Text(
                    member.comebackMessage!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFE11D48),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Text(
                    '${member.currentStreak} dias seguidos • ${(member.totalVolumeKg / 1000).toStringAsFixed(1)}k kg',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                  ),
              ],
            ),
          ),

          // Métrica
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metricValue,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isUser ? AppColors.neonLime : AppColors.textPrimary,
                ),
              ),
              Text(
                metricLabel,
                style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ABA 1: GALERIA DE BADGES & CONQUISTAS (SUPERÇÃO & RETOMADA)
  // ==========================================================
  Widget _buildBadgesTab(BuildContext context, RankingState state) {
    List<GymBadge> filteredBadges = state.allBadges;
    if (_badgeFilter == 'attendance') {
      filteredBadges = state.allBadges.where((b) => b.category == BadgeCategory.attendance).toList();
    } else if (_badgeFilter == 'comeback') {
      filteredBadges = state.allBadges.where((b) => b.isComebackSpecial).toList();
    } else if (_badgeFilter == 'streak') {
      filteredBadges = state.allBadges.where((b) => b.category == BadgeCategory.streak).toList();
    }

    final unlockedCount = state.allBadges.where((b) => b.isUnlocked).length;
    final totalCount = state.allBadges.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de Progresso Geral das Badges
          GlassCard(
            borderColor: AppColors.neonLime.withOpacity(0.3),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.neonLime.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.military_tech, color: AppColors.neonLime, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Suas Conquistas', style: AppTextStyles.labelBold),
                      const SizedBox(height: 2),
                      Text(
                        '$unlockedCount de $totalCount badges desbloqueadas',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: totalCount > 0 ? unlockedCount / totalCount : 0.0,
                          backgroundColor: AppColors.surfaceLight,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonLime),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filtros de Categoria de Badge
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildBadgeFilterChip('Todas as Conquistas', 'all'),
                _buildBadgeFilterChip('🔥 Volta por Cima (Retomada)', 'comeback'),
                _buildBadgeFilterChip('Presença & Dias', 'attendance'),
                _buildBadgeFilterChip('Ofensivas (Streaks)', 'streak'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Grid de Badges
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredBadges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final badge = filteredBadges[index];
              return BadgeCard(
                badge: badge,
                onTap: () => BadgeDetailModal.show(context, badge),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeFilterChip(String label, String filterKey) {
    final isSel = _badgeFilter == filterKey;
    final isComeback = filterKey == 'comeback';

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSel,
        selectedColor: isComeback
            ? const Color(0xFFFFF1F2)
            : AppColors.neonLime.withOpacity(0.2),
        backgroundColor: AppColors.surfaceLight,
        labelStyle: TextStyle(
          color: isSel
              ? (isComeback ? const Color(0xFFE11D48) : AppColors.neonLime)
              : AppColors.textSecondary,
          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
          fontSize: 11,
        ),
        side: BorderSide(
          color: isSel
              ? (isComeback ? const Color(0xFFE11D48) : AppColors.neonLime)
              : AppColors.cardBorder,
        ),
        onSelected: (selected) {
          if (selected) setState(() => _badgeFilter = filterKey);
        },
      ),
    );
  }

  // ==========================================================
  // ABA 1: RANKING DE CAMINHADA NA ESTEIRA (MEDIDA POR TEMPO)
  // ==========================================================
  Widget _buildTreadmillTab(BuildContext context, RankingState state) {
    final sortedTreadmill = state.sortedTreadmillMembers;
    final top3 = sortedTreadmill.take(3).toList();
    final remaining = sortedTreadmill.skip(3).toList();
    final currentUser = state.currentUser;
    final userRank = state.currentUserTreadmillRank;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Informativo: Foco em Cardio LISS Zona 2
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Color(0xFF16A34A), size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ranking por Tempo na Esteira (Horas & Minutos)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF15803D),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Caminhada contínua ou inclinada (LISS Zona 2). Acumule minutos e suba no ranking da comunidade!',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: const Color(0xFF166534).withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Pódio dos Top 3 em Tempo de Esteira
          if (top3.isNotEmpty)
            PodiumWidget(
              top3: top3,
              isTreadmillMode: true,
            ),
          const SizedBox(height: 16),

          // Card Hero do Usuário Atual (com botão de registro rápido de caminhada)
          if (currentUser != null)
            _buildTreadmillUserHeroCard(context, currentUser, userRank),
          const SizedBox(height: 16),

          // Dica Científica de Caminhada na Esteira
          _buildTreadmillScienceCard(),
          const SizedBox(height: 16),

          // Cabeçalho da Lista Completa de Caminhantes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Demais Caminhantes da Academia', style: AppTextStyles.labelBold),
              Text(
                '${remaining.length + top3.length} membros ativos',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Lista dos Demais Atletas
          ...remaining.asMap().entries.map((entry) {
            final position = entry.key + 4;
            final member = entry.value;
            return _buildTreadmillMemberTile(member, position);
          }),
        ],
      ),
    );
  }

  Widget _buildTreadmillUserHeroCard(BuildContext context, RankingMember user, int rank) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF38BDF8), width: 2),
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF38BDF8),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      rank <= 3
                          ? 'Sensacional! Você está no Pódio de Tempo de Esteira!'
                          : 'Você já acumulou ${user.treadmillFormattedTime} de caminhada este mês.',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    user.treadmillFormattedTime,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                  Text(
                    '~${user.treadmillCalories} kcal',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFF334155), height: 1),
          const SizedBox(height: 12),
          // Botão de Ação Rápida: Registrar Caminhada
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showLogTreadmillWalkModal(context),
              icon: const Icon(Icons.add, size: 18, color: Color(0xFF0F172A)),
              label: const Text(
                'Registrar Caminhada na Esteira',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38BDF8),
                foregroundColor: const Color(0xFF0F172A),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreadmillScienceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_walk, color: Color(0xFF0284C7), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Caminhada LISS & Zona 2: Por que por tempo?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Caminhadas de 30 a 60 minutos em inclinação moderada estimulam a biogênese mitocondrial e queima de gordura sem gerar fadiga no SNC ou catabolismo muscular.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreadmillMemberTile(RankingMember member, int position) {
    final isUser = member.isCurrentUser;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFF38BDF8).withOpacity(0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUser ? const Color(0xFF38BDF8).withOpacity(0.6) : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          // Posição
          SizedBox(
            width: 28,
            child: Text(
              '#$position',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isUser ? const Color(0xFF0284C7) : AppColors.textMuted,
              ),
            ),
          ),

          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: isUser ? const Color(0xFF38BDF8).withOpacity(0.2) : AppColors.surfaceLight,
            child: Text(
              member.initials,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isUser ? const Color(0xFF0284C7) : AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Nome & Detalhes de Caloria e Minutos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isUser ? FontWeight.bold : FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${member.treadmillCalories} kcal gastas • ${member.treadmillMinutesMonth} min total',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          // Métrica Formatada em Horas e Minutos
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                member.treadmillFormattedTime,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isUser ? const Color(0xFF0284C7) : AppColors.textPrimary,
                ),
              ),
              const Text(
                'tempo no mês',
                style: TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLogTreadmillWalkModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        int selectedMinutes = 30;
        int selectedIncline = 5;

        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final estimatedCalories = (selectedMinutes * (6 + (selectedIncline * 0.4))).round();

            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barra de arraste
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.cardBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Título
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.directions_walk, color: Color(0xFF0284C7), size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Registrar Caminhada',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        icon: const Icon(Icons.close, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Adicione sua sessão de esteira para somar minutos ao ranking.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),

                  // Seletor de Duração (Minutos)
                  const Text(
                    'Duração da Caminhada',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [15, 20, 30, 45, 60, 90].map((mins) {
                      final isSelected = selectedMinutes == mins;
                      return ChoiceChip(
                        label: Text('$mins min'),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0284C7).withOpacity(0.2),
                        backgroundColor: AppColors.surfaceLight,
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF0284C7) : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 12,
                        ),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF0284C7) : AppColors.cardBorder,
                        ),
                        onSelected: (selected) {
                          if (selected) setModalState(() => selectedMinutes = mins);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Seletor de Inclinação
                  const Text(
                    'Inclinação da Esteira (%)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [0, 3, 5, 8, 10, 12].map((inc) {
                      final isSelected = selectedIncline == inc;
                      String label = inc == 0 ? '0% (Plano)' : (inc == 12 ? '12% (12-3-30)' : '$inc%');
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        selectedColor: AppColors.neonLime.withOpacity(0.25),
                        backgroundColor: AppColors.surfaceLight,
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF15803D) : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 12,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.neonLime : AppColors.cardBorder,
                        ),
                        onSelected: (selected) {
                          if (selected) setModalState(() => selectedIncline = inc);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Card de Resumo de Calorias & Impacto
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Tempo a somar', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            const SizedBox(height: 2),
                            Text(
                              '+$selectedMinutes min',
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 28, color: AppColors.cardBorder),
                        Column(
                          children: [
                            const Text('Gasto Estimado', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            const SizedBox(height: 2),
                            Text(
                              '~$estimatedCalories kcal',
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botão Salvar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(rankingProvider.notifier).logTreadmillWalk(
                              selectedMinutes,
                              calories: estimatedCalories,
                            );
                        Navigator.pop(modalContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Caminhada de $selectedMinutes min somada com sucesso ao seu ranking!',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF0F172A),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonLime,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Salvar Caminhada (+$selectedMinutes min)',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          },
        );
      },
    );
  }
}
