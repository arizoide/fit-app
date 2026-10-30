import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class MuscleTag extends StatelessWidget {
  final String muscleName;
  final bool isSecondary;

  const MuscleTag({
    super.key,
    required this.muscleName,
    this.isSecondary = false,
  });

  Color _getMuscleColor(String muscle) {
    switch (muscle.toLowerCase()) {
      case 'peito':
      case 'peitoral':
        return AppColors.chestColor;
      case 'costas':
      case 'dorsal':
        return AppColors.backColor;
      case 'pernas':
      case 'quadríceps':
      case 'glúteos':
        return AppColors.legsColor;
      case 'ombros':
      case 'deltóide':
        return AppColors.shouldersColor;
      case 'bíceps':
      case 'tríceps':
      case 'braços':
        return AppColors.armsColor;
      case 'abdômen':
      case 'core':
        return AppColors.coreColor;
      default:
        return AppColors.electricCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getMuscleColor(muscleName);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSecondary ? color.withOpacity(0.12) : color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSecondary ? color.withOpacity(0.3) : color.withOpacity(0.7),
          width: 1,
        ),
      ),
      child: Text(
        muscleName,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
