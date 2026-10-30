import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';

class PlateCalculatorDialog extends StatefulWidget {
  final double initialWeight;

  const PlateCalculatorDialog({
    super.key,
    required this.initialWeight,
  });

  static Future<void> show(BuildContext context, double initialWeight) {
    return showDialog(
      context: context,
      builder: (context) => PlateCalculatorDialog(initialWeight: initialWeight),
    );
  }

  @override
  State<PlateCalculatorDialog> createState() => _PlateCalculatorDialogState();
}

class _PlateCalculatorDialogState extends State<PlateCalculatorDialog> {
  late double _targetWeight;
  final double _barWeight = 20.0; // Barra olímpica padrão (20kg)

  final List<double> _availablePlates = [25.0, 20.0, 15.0, 10.0, 5.0, 2.5, 1.25];

  @override
  void initState() {
    super.initState();
    _targetWeight = widget.initialWeight > 0 ? widget.initialWeight : 60.0;
  }

  Map<double, int> _calculatePlatesPerSide() {
    double remaining = (_targetWeight - _barWeight) / 2.0;
    if (remaining <= 0) return {};

    Map<double, int> platesCount = {};
    for (final plate in _availablePlates) {
      if (remaining >= plate) {
        int count = (remaining / plate).floor();
        platesCount[plate] = count;
        remaining -= count * plate;
      }
    }
    return platesCount;
  }

  Color _getPlateColor(double plate) {
    switch (plate.toInt()) {
      case 25:
        return const Color(0xFFD32F2F); // Vermelho
      case 20:
        return const Color(0xFF1976D2); // Azul
      case 15:
        return const Color(0xFFFBC02D); // Amarelo
      case 10:
        return const Color(0xFF388E3C); // Verde
      case 5:
        return const Color(0xFFFFFFFF); // Branco
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final plates = _calculatePlatesPerSide();
    final weightPerSide = (_targetWeight - _barWeight).clamp(0, 999) / 2.0;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calculate_outlined, color: AppColors.neonLime),
                    const SizedBox(width: 8),
                    Text('Calculadora de Anilhas', style: AppTextStyles.heading3),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Peso Total Alvo:', style: AppTextStyles.bodyMedium),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.neonLime),
                      onPressed: () => setState(() => _targetWeight = (_targetWeight - 2.5).clamp(20.0, 400.0)),
                    ),
                    Text(
                      '${_targetWeight.toStringAsFixed(1)} kg',
                      style: AppTextStyles.heading2.copyWith(color: AppColors.neonLime),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.neonLime),
                      onPressed: () => setState(() => _targetWeight = (_targetWeight + 2.5).clamp(20.0, 400.0)),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: AppColors.cardBorder, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Barra Olímpica:', style: AppTextStyles.bodySmall),
                Text('$_barWeight kg', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Carga por Lado:', style: AppTextStyles.bodySmall),
                Text('${weightPerSide.toStringAsFixed(1)} kg', style: AppTextStyles.labelBold.copyWith(color: AppColors.electricCyan)),
              ],
            ),
            const SizedBox(height: 16),
            Text('Anilhas em CADA lado da barra:', style: AppTextStyles.labelBold),
            const SizedBox(height: 10),
            if (plates.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Apenas o peso da barra ($_barWeight kg)',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: plates.entries.map((entry) {
                  final plateKg = entry.key;
                  final count = entry.value;
                  final color = _getPlateColor(plateKg);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$count x ${plateKg.toStringAsFixed(plateKg % 1 == 0 ? 0 : 2)} kg',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            NeonButton(
              text: 'Entendido',
              onPressed: () => Navigator.of(context).pop(),
              height: 44,
            ),
          ],
        ),
      ),
    );
  }
}
