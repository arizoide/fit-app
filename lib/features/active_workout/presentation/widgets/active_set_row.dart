import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/tape_ruler_picker.dart';
import 'package:fitmorph_ai/features/workout_generator/domain/models/workout_models.dart';

class ActiveSetRow extends StatefulWidget {
  final int exerciseIndex;
  final int setIndex;
  final ExerciseSet set;
  final String repsRange;
  final Function(double weight, int reps, int? rpe) onComplete;
  final VoidCallback onUncomplete;

  const ActiveSetRow({
    super.key,
    required this.exerciseIndex,
    required this.setIndex,
    required this.set,
    required this.repsRange,
    required this.onComplete,
    required this.onUncomplete,
  });

  @override
  State<ActiveSetRow> createState() => _ActiveSetRowState();
}

class _ActiveSetRowState extends State<ActiveSetRow> {
  late TextEditingController _weightCtrl;
  late TextEditingController _repsCtrl;
  int? _selectedRpe;

  @override
  void initState() {
    super.initState();
    _weightCtrl = TextEditingController(
      text: widget.set.weightKg != null ? widget.set.weightKg!.toString() : '20',
    );
    _repsCtrl = TextEditingController(
      text: widget.set.completedReps != null
          ? widget.set.completedReps!.toString()
          : widget.set.targetReps.toString(),
    );
    _selectedRpe = widget.set.rpeReal ?? 8;
  }

  @override
  void didUpdateWidget(covariant ActiveSetRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.set.isCompleted != widget.set.isCompleted) {
      if (widget.set.weightKg != null) {
        _weightCtrl.text = widget.set.weightKg.toString();
      }
      if (widget.set.completedReps != null) {
        _repsCtrl.text = widget.set.completedReps.toString();
      }
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    super.dispose();
  }

  void _openTapeRuler({bool startWithReps = false}) async {
    if (widget.set.isCompleted) return;

    final currentWeight = double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? 20.0;
    final currentReps = int.tryParse(_repsCtrl.text) ?? widget.set.targetReps;

    final result = await TapeRulerPickerModal.show(
      context,
      initialWeight: currentWeight,
      initialReps: currentReps,
      startWithReps: startWithReps,
    );

    if (result != null) {
      final newWeight = result.weight;
      final newReps = result.reps;

      setState(() {
        _weightCtrl.text = newWeight == newWeight.toInt()
            ? newWeight.toInt().toString()
            : newWeight.toStringAsFixed(1);
        _repsCtrl.text = newReps.toString();
      });
    }
  }

  void _handleToggle() {
    if (widget.set.isCompleted) {
      widget.onUncomplete();
    } else {
      final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? 20.0;
      final reps = int.tryParse(_repsCtrl.text) ?? widget.set.targetReps;
      widget.onComplete(weight, reps, _selectedRpe);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.set.isCompleted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDone ? AppColors.neonLime.withOpacity(0.12) : AppColors.surfaceLight.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDone ? AppColors.neonLime.withOpacity(0.5) : AppColors.cardBorder.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          // Número da Série
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isDone ? AppColors.neonLime : AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${widget.set.setNumber}',
                style: TextStyle(
                  color: isDone ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Campo de Carga (kg) com suporte a Fita Métrica & Digitação
          Expanded(
            flex: 3,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightCtrl,
                      enabled: !isDone,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDone ? AppColors.neonLime : AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: !isDone ? () => _openTapeRuler(startWithReps: false) : null,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('kg', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                          const SizedBox(width: 2),
                          Icon(Icons.tune, size: 12, color: isDone ? AppColors.neonLime : AppColors.electricCyan),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Campo de Repetições com suporte a Fita Métrica & Digitação
          Expanded(
            flex: 3,
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _repsCtrl,
                      enabled: !isDone,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDone ? AppColors.neonLime : AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: !isDone ? () => _openTapeRuler(startWithReps: true) : null,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('reps', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                          const SizedBox(width: 2),
                          Icon(Icons.tune, size: 12, color: isDone ? AppColors.neonLime : AppColors.electricCyan),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Botão Check
          InkWell(
            onTap: _handleToggle,
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDone ? AppColors.neonLime : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDone ? AppColors.neonLime : AppColors.cardBorder,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.check,
                color: isDone ? Colors.white : AppColors.textMuted,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

