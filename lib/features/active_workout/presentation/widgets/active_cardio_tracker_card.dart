import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/exercise_guide_dialog.dart';
import 'package:fitmorph_ai/features/workout_generator/domain/models/workout_models.dart';

class ActiveCardioTrackerCard extends StatefulWidget {
  final CardioProtocol cardioProtocol;

  const ActiveCardioTrackerCard({
    super.key,
    required this.cardioProtocol,
  });

  @override
  State<ActiveCardioTrackerCard> createState() => _ActiveCardioTrackerCardState();
}

class _ActiveCardioTrackerCardState extends State<ActiveCardioTrackerCard> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  bool _isCompleted = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds++;
          final targetSeconds = widget.cardioProtocol.durationMinutes * 60;
          if (_elapsedSeconds >= targetSeconds && !_isCompleted) {
            _isCompleted = true;
          }
        });
      });
      setState(() => _isRunning = true);
    }
  }

  void _toggleComplete() {
    setState(() {
      _isCompleted = !_isCompleted;
      if (_isCompleted) {
        _timer?.cancel();
        _isRunning = false;
        if (_elapsedSeconds == 0) {
          _elapsedSeconds = widget.cardioProtocol.durationMinutes * 60;
        }
      }
    });
  }

  String _formatTimer(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  int get _calculatedCalories {
    final targetSeconds = widget.cardioProtocol.durationMinutes * 60;
    if (targetSeconds <= 0) return 0;
    final ratio = (_elapsedSeconds / targetSeconds).clamp(0.0, 2.0);
    return (ratio * widget.cardioProtocol.estimatedCalories).toInt();
  }

  double get _progressRatio {
    final targetSeconds = widget.cardioProtocol.durationMinutes * 60;
    if (targetSeconds <= 0) return 0.0;
    return (_elapsedSeconds / targetSeconds).clamp(0.0, 1.0);
  }

  void _openGuideDialog(BuildContext context) {
    final equip = widget.cardioProtocol.equipment.toLowerCase();
    String guideId = 'cardio_incline_treadmill';
    if (equip.contains('escada')) guideId = 'cardio_stairmaster';
    if (equip.contains('bike') || equip.contains('bicicleta')) guideId = 'cardio_stationary_bike';
    if (equip.contains('elíptico') || equip.contains('eliptico')) guideId = 'cardio_elliptical';
    if (equip.contains('corda')) guideId = 'cardio_jump_rope';
    if (equip.contains('peso corporal') || equip.contains('caminhada')) guideId = 'cardio_outdoor_walk';
    ExerciseGuideDialog.show(context, guideId);
  }

  @override
  Widget build(BuildContext context) {
    final cardio = widget.cardioProtocol;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GlassCard(
        borderColor: _isCompleted
            ? AppColors.neonLime
            : AppColors.pulseOrange.withOpacity(0.7),
        backgroundColor: _isCompleted
            ? AppColors.neonLime.withOpacity(0.06)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isCompleted
                        ? AppColors.neonLime.withOpacity(0.2)
                        : AppColors.pulseOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isCompleted
                          ? AppColors.neonLime
                          : AppColors.pulseOrange.withOpacity(0.6),
                    ),
                  ),
                  child: Icon(
                    Icons.directions_run,
                    color: _isCompleted ? AppColors.neonLime : AppColors.pulseOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cardio.title,
                              style: AppTextStyles.heading3.copyWith(fontSize: 16),
                            ),
                          ),
                          if (_isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.neonLime.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.neonLime),
                              ),
                              child: Text(
                                'CONCLUÍDO',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.neonLime,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Meta: ${cardio.durationMinutes} min • ${cardio.intensityZone}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: AppColors.electricCyan, size: 20),
                  tooltip: 'Ver Regulagem do Aparelho',
                  onPressed: () => _openGuideDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Speed / Incline Guidance
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.speed, color: AppColors.electricCyan, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cardio.speedInclineRecommendation,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Live Timer & Calorie Tracker Display
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1A24),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isRunning ? AppColors.neonLime : AppColors.cardBorder,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TEMPO CARDIO',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textMuted,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatTimer(_elapsedSeconds),
                            style: AppTextStyles.heading1.copyWith(
                              fontSize: 26,
                              color: _isRunning ? AppColors.neonLime : AppColors.textPrimary,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'GASTO ESTIMADO',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                              color: AppColors.textMuted,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.local_fire_department, color: AppColors.pulseOrange, size: 20),
                              const SizedBox(width: 2),
                              Text(
                                '$_calculatedCalories kcal',
                                style: AppTextStyles.heading2.copyWith(
                                  fontSize: 20,
                                  color: AppColors.pulseOrange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Linear Progress
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progressRatio,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isCompleted ? AppColors.neonLime : AppColors.pulseOrange,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning
                          ? AppColors.pulseOrange.withOpacity(0.25)
                          : AppColors.neonLime.withOpacity(0.2),
                      foregroundColor: _isRunning ? AppColors.pulseOrange : AppColors.neonLime,
                      side: BorderSide(
                        color: _isRunning ? AppColors.pulseOrange : AppColors.neonLime,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 20),
                    label: Text(
                      _isRunning ? 'Pausar Cardio' : (_elapsedSeconds > 0 ? 'Continuar' : 'Iniciar Cardio'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _toggleTimer,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCompleted
                        ? AppColors.neonLime
                        : AppColors.surfaceLight,
                    foregroundColor: _isCompleted ? Colors.white : AppColors.textPrimary,
                    side: BorderSide(
                      color: _isCompleted ? AppColors.neonLime : AppColors.cardBorder,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  icon: Icon(
                    _isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                    size: 20,
                    color: _isCompleted ? Colors.white : AppColors.textSecondary,
                  ),
                  label: Text(
                    _isCompleted ? 'Feito' : 'Concluir',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isCompleted ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  onPressed: _toggleComplete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
