import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class PainMapSelector extends StatelessWidget {
  final List<String> selectedPains;
  final Function(List<String>) onChanged;

  const PainMapSelector({
    super.key,
    required this.selectedPains,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> jointOptions = [
    {'name': 'Ombro Direito/Esquerdo', 'icon': Icons.accessibility_new, 'key': 'Ombro'},
    {'name': 'Joelhos / Condromalácia', 'icon': Icons.directions_walk, 'key': 'Joelho'},
    {'name': 'Lombar / Coluna', 'icon': Icons.airline_seat_recline_normal, 'key': 'Lombar'},
    {'name': 'Punhos / Tendinite', 'icon': Icons.front_hand, 'key': 'Punho'},
    {'name': 'Cotovelos / Epicondilite', 'icon': Icons.pan_tool_alt, 'key': 'Cotovelo'},
    {'name': 'Cervical / Trapézio', 'icon': Icons.person_pin, 'key': 'Cervical'},
    {'name': 'Nenhuma dor (100% Livre)', 'icon': Icons.check_circle_outline, 'key': 'Nenhuma'},
  ];

  void _togglePain(String key) {
    List<String> updated = List.from(selectedPains);
    if (key == 'Nenhuma') {
      updated = ['Nenhuma'];
    } else {
      updated.remove('Nenhuma');
      if (updated.contains(key)) {
        updated.remove(key);
      } else {
        updated.add(key);
      }
    }
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecione se você possui dores ou limitações articulares:',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: jointOptions.map((opt) {
            final key = opt['key'] as String;
            final isSelected = selectedPains.contains(key);
            final isNone = key == 'Nenhuma';

            return InkWell(
              onTap: () => _togglePain(key),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isNone ? AppColors.neonLime.withOpacity(0.2) : AppColors.alertRed.withOpacity(0.2))
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? (isNone ? AppColors.neonLime : AppColors.alertRed)
                        : AppColors.cardBorder,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      opt['icon'] as IconData,
                      size: 18,
                      color: isSelected
                          ? (isNone ? AppColors.neonLime : AppColors.alertRed)
                          : AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      opt['name'] as String,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
