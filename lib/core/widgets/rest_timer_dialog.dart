import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'neon_button.dart';

class RestTimerDialog extends StatefulWidget {
  final int initialSeconds;
  final String nextExerciseName;
  final VoidCallback onCompleted;
  final VoidCallback onSkip;

  const RestTimerDialog({
    super.key,
    required this.initialSeconds,
    required this.nextExerciseName,
    required this.onCompleted,
    required this.onSkip,
  });

  @override
  State<RestTimerDialog> createState() => _RestTimerDialogState();
}

class _RestTimerDialogState extends State<RestTimerDialog> {
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.initialSeconds;
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        widget.onCompleted();
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  void _adjustTime(int delta) {
    setState(() {
      _remainingSeconds = (_remainingSeconds + delta).clamp(5, 600);
      if (_remainingSeconds > _totalSeconds) {
        _totalSeconds = _remainingSeconds;
      }
    });
  }

  String _formatTime(int totalSecs) {
    final minutes = totalSecs ~/ 60;
    final seconds = totalSecs % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalSeconds > 0 ? _remainingSeconds / _totalSeconds : 0.0;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: AppColors.neonLime, size: 22),
                    const SizedBox(width: 8),
                    Text('TEMPO DE DESCANSO', style: AppTextStyles.labelBold.copyWith(color: AppColors.neonLime)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                  onPressed: () {
                    _timer?.cancel();
                    widget.onSkip();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 170,
                  height: 170,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _remainingSeconds <= 10 ? AppColors.pulseOrange : AppColors.neonLime,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: AppTextStyles.timerDisplay.copyWith(
                        color: _remainingSeconds <= 10 ? AppColors.pulseOrange : AppColors.neonLime,
                      ),
                    ),
                    Text(
                      'segundos restantes',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => _adjustTime(-15),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('-15s', style: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => _adjustTime(30),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('+30s', style: TextStyle(color: AppColors.neonLime)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.nextExerciseName.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_forward, color: AppColors.electricCyan, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Próximo: ${widget.nextExerciseName}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            NeonButton(
              text: 'Pular Descanso',
              onPressed: () {
                _timer?.cancel();
                widget.onSkip();
                Navigator.of(context).pop();
              },
              isOutlined: true,
              height: 46,
            ),
          ],
        ),
      ),
    );
  }
}
