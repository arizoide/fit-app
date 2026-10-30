import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/ranking_models.dart';

class PodiumWidget extends StatelessWidget {
  final List<RankingMember> top3;
  final bool isTreadmillMode;

  const PodiumWidget({
    super.key,
    required this.top3,
    this.isTreadmillMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (top3.length < 3) return const SizedBox.shrink();

    final first = top3[0];
    final second = top3[1];
    final third = top3[2];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2º LUGAR (PRATA)
              Expanded(
                child: _buildPodiumColumn(
                  member: second,
                  position: 2,
                  podiumHeight: 75,
                  pedestalColor: const Color(0xFFF1F5F9),
                  ringColor: const Color(0xFF94A3B8),
                  badgeLabel: '2º Prata',
                  icon: Icons.workspace_premium,
                ),
              ),
              const SizedBox(width: 8),

              // 1º LUGAR (OURO - CENTRO)
              Expanded(
                child: _buildPodiumColumn(
                  member: first,
                  position: 1,
                  podiumHeight: 105,
                  pedestalColor: const Color(0xFFFEF9C3),
                  ringColor: const Color(0xFFEAB308),
                  badgeLabel: '1º Ouro',
                  icon: Icons.emoji_events,
                  isCrown: true,
                ),
              ),
              const SizedBox(width: 8),

              // 3º LUGAR (BRONZE)
              Expanded(
                child: _buildPodiumColumn(
                  member: third,
                  position: 3,
                  podiumHeight: 60,
                  pedestalColor: const Color(0xFFFFEDD5),
                  ringColor: const Color(0xFFD97706),
                  badgeLabel: '3º Bronze',
                  icon: Icons.military_tech,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required RankingMember member,
    required int position,
    required double podiumHeight,
    required Color pedestalColor,
    required Color ringColor,
    required String badgeLabel,
    required IconData icon,
    bool isCrown = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Coroa para o 1º Lugar
        if (isCrown)
          const Padding(
            padding: EdgeInsets.only(bottom: 2),
            child: Icon(Icons.star, color: Color(0xFFEAB308), size: 24),
          )
        else
          const SizedBox(height: 10),

        // Avatar com anel colorido
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: ringColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: position == 1 ? 26 : 22,
            backgroundColor: ringColor.withOpacity(0.15),
            child: Text(
              member.initials,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontSize: position == 1 ? 16 : 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Nome
        Text(
          member.name.split(' ').first,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),

        // Estatística (Treinos ou Tempo de Esteira)
        Text(
          isTreadmillMode
              ? member.treadmillFormattedTime
              : '${member.workoutsMonth} treinos',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: ringColor,
          ),
        ),
        const SizedBox(height: 6),

        // Pedestal físico do pódio
        Container(
          height: podiumHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: pedestalColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: ringColor.withOpacity(0.4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: ringColor, size: 22),
              const SizedBox(height: 2),
              Text(
                '$positionº',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: ringColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
