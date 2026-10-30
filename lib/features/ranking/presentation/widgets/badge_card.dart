import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/models/ranking_models.dart';

class BadgeCard extends StatelessWidget {
  final GymBadge badge;
  final VoidCallback onTap;

  const BadgeCard({
    super.key,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;
    final color = isUnlocked ? badge.color : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: badge.isComebackSpecial && isUnlocked
                ? const Color(0xFFE11D48).withOpacity(0.4)
                : (isUnlocked ? color.withOpacity(0.3) : AppColors.cardBorder),
            width: badge.isComebackSpecial && isUnlocked ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isUnlocked ? color.withOpacity(0.08) : Colors.black.withOpacity(0.01),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Selo especial de Volta por Cima
            if (badge.isComebackSpecial)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department, size: 10, color: Color(0xFFE11D48)),
                    SizedBox(width: 3),
                    Text(
                      'VOLTA POR CIMA',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE11D48),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

            // Ícone com anel
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUnlocked ? color.withOpacity(0.12) : AppColors.surfaceLight,
                    border: Border.all(
                      color: isUnlocked ? color : Colors.grey.shade400,
                      width: 1.8,
                    ),
                  ),
                  child: Icon(
                    badge.icon,
                    size: 26,
                    color: isUnlocked ? color : Colors.grey.shade500,
                  ),
                ),
                if (!isUnlocked)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock, size: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Título
            Text(
              badge.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),

            // Status Badge
            Text(
              isUnlocked ? 'Conquistado' : 'Bloqueado',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: isUnlocked ? color : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BadgeDetailModal {
  static void show(BuildContext context, GymBadge badge) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Ícone em destaque
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.isUnlocked ? badge.color.withOpacity(0.12) : AppColors.surfaceLight,
                border: Border.all(
                  color: badge.isUnlocked ? badge.color : Colors.grey,
                  width: 2.5,
                ),
                boxShadow: badge.isUnlocked
                    ? [
                        BoxShadow(
                          color: badge.color.withOpacity(0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                badge.icon,
                size: 40,
                color: badge.isUnlocked ? badge.color : Colors.grey,
              ),
            ),
            const SizedBox(height: 14),

            if (badge.isComebackSpecial)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department, size: 14, color: Color(0xFFE11D48)),
                    SizedBox(width: 4),
                    Text(
                      'CONQUISTA DE RETOMADA & SUPERAÇÃO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),

            // Título
            Text(badge.title, style: AppTextStyles.heading2, textAlign: TextAlign.center),
            const SizedBox(height: 6),

            // Descrição
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // Citação Inspiradora
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.format_quote, color: AppColors.electricCyan, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      badge.motivationalQuote,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  badge.isUnlocked ? Icons.check_circle : Icons.lock_outline,
                  color: badge.isUnlocked ? AppColors.neonLime : Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  badge.isUnlocked ? 'Conquistado e Ativo no seu Perfil' : 'Bloqueado (Continue treinando para liberar)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: badge.isUnlocked ? AppColors.neonLime : AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botão Fechar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
