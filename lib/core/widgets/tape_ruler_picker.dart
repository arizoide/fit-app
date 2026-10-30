import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';

class TapeRulerResult {
  final double weight;
  final int reps;

  const TapeRulerResult({required this.weight, required this.reps});
}

class TapeRulerPickerModal extends StatefulWidget {
  final double initialWeight;
  final int initialReps;
  final bool startWithReps;
  final Function(double weight, int reps)? onConfirm;

  const TapeRulerPickerModal({
    super.key,
    required this.initialWeight,
    required this.initialReps,
    this.startWithReps = false,
    this.onConfirm,
  });

  static Future<TapeRulerResult?> show(
    BuildContext context, {
    required double initialWeight,
    required int initialReps,
    bool startWithReps = false,
  }) {
    return showModalBottomSheet<TapeRulerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TapeRulerPickerModal(
        initialWeight: initialWeight,
        initialReps: initialReps,
        startWithReps: startWithReps,
      ),
    );
  }

  @override
  State<TapeRulerPickerModal> createState() => _TapeRulerPickerModalState();
}

class _TapeRulerPickerModalState extends State<TapeRulerPickerModal> {
  late bool _isEditingReps;
  late double _currentWeight;
  late int _currentReps;

  late TextEditingController _textCtrl;
  late ScrollController _scrollCtrl;
  bool _isUserTyping = false;
  bool _isUserScrolling = false;

  // Ruler parameters
  static const double _stepWidth = 14.0; // pixels per unit/step
  static const double _minWeight = 0.0;
  static const double _maxWeight = 300.0;
  static const double _weightStep = 0.5; // step size in kg

  static const int _minReps = 1;
  static const int _maxReps = 60;

  @override
  void initState() {
    super.initState();
    _isEditingReps = widget.startWithReps;
    _currentWeight = widget.initialWeight;
    _currentReps = widget.initialReps;

    _textCtrl = TextEditingController(
      text: _isEditingReps
          ? _currentReps.toString()
          : (_currentWeight == _currentWeight.toInt()
              ? _currentWeight.toInt().toString()
              : _currentWeight.toStringAsFixed(1)),
    );

    _scrollCtrl = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncRulerToCurrentValue(animate: false);
    });

    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isUserTyping) return;
    _isUserScrolling = true;

    final offset = _scrollCtrl.offset;
    if (_isEditingReps) {
      final calculated = (_minReps + (offset / _stepWidth)).round();
      final clamped = calculated.clamp(_minReps, _maxReps);
      if (clamped != _currentReps) {
        setState(() {
          _currentReps = clamped;
          _textCtrl.text = _currentReps.toString();
        });
      }
    } else {
      // Weight has 0.5 kg increments
      final steps = (offset / _stepWidth).round();
      final calculated = _minWeight + (steps * _weightStep);
      final clamped = calculated.clamp(_minWeight, _maxWeight);
      if (clamped != _currentWeight) {
        setState(() {
          _currentWeight = clamped;
          _textCtrl.text = _currentWeight == _currentWeight.toInt()
              ? _currentWeight.toInt().toString()
              : _currentWeight.toStringAsFixed(1);
        });
      }
    }

    _isUserScrolling = false;
  }

  void _syncRulerToCurrentValue({bool animate = true}) {
    if (!_scrollCtrl.hasClients) return;

    double targetOffset = 0.0;
    if (_isEditingReps) {
      targetOffset = (_currentReps - _minReps) * _stepWidth;
    } else {
      final steps = (_currentWeight - _minWeight) / _weightStep;
      targetOffset = steps * _stepWidth;
    }

    final maxScroll = _scrollCtrl.position.maxScrollExtent;
    targetOffset = targetOffset.clamp(0.0, maxScroll);

    if (animate) {
      _scrollCtrl.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollCtrl.jumpTo(targetOffset);
    }
  }

  void _onTextChanged(String text) {
    if (_isUserScrolling) return;
    _isUserTyping = true;

    final normalized = text.replaceAll(',', '.');
    if (_isEditingReps) {
      final parsed = int.tryParse(normalized);
      if (parsed != null && parsed >= _minReps && parsed <= _maxReps) {
        setState(() => _currentReps = parsed);
        _syncRulerToCurrentValue(animate: true);
      }
    } else {
      final parsed = double.tryParse(normalized);
      if (parsed != null && parsed >= _minWeight && parsed <= _maxWeight) {
        setState(() => _currentWeight = parsed);
        _syncRulerToCurrentValue(animate: true);
      }
    }

    _isUserTyping = false;
  }

  void _adjustValue(double delta) {
    if (_isEditingReps) {
      final next = (_currentReps + delta.round()).clamp(_minReps, _maxReps);
      setState(() {
        _currentReps = next;
        _textCtrl.text = _currentReps.toString();
      });
    } else {
      final next = ((_currentWeight + delta) * 2).round() / 2; // snap to 0.5
      final clamped = next.clamp(_minWeight, _maxWeight);
      setState(() {
        _currentWeight = clamped;
        _textCtrl.text = _currentWeight == _currentWeight.toInt()
            ? _currentWeight.toInt().toString()
            : _currentWeight.toStringAsFixed(1);
      });
    }
    _syncRulerToCurrentValue(animate: true);
  }

  void _switchTab(bool isReps) {
    if (_isEditingReps == isReps) return;
    setState(() {
      _isEditingReps = isReps;
      _textCtrl.text = _isEditingReps
          ? _currentReps.toString()
          : (_currentWeight == _currentWeight.toInt()
              ? _currentWeight.toInt().toString()
              : _currentWeight.toStringAsFixed(1));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncRulerToCurrentValue(animate: false);
    });
  }

  void _handleConfirm() {
    final result = TapeRulerResult(
      weight: _currentWeight,
      reps: _currentReps,
    );
    if (widget.onConfirm != null) {
      widget.onConfirm!(_currentWeight, _currentReps);
    }
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _isEditingReps ? AppColors.electricCyan : AppColors.neonLime;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Tab Selector (Carga kg vs Repetições)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _switchTab(false),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isEditingReps ? AppColors.neonLime : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  size: 18,
                                  color: !_isEditingReps ? Colors.white : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Carga: ${_currentWeight == _currentWeight.toInt() ? _currentWeight.toInt() : _currentWeight.toStringAsFixed(1)} kg',
                                  style: TextStyle(
                                    color: !_isEditingReps ? Colors.white : AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: InkWell(
                        onTap: () => _switchTab(true),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isEditingReps ? AppColors.electricCyan : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.repeat,
                                  size: 18,
                                  color: _isEditingReps ? Colors.white : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Reps: $_currentReps',
                                  style: TextStyle(
                                    color: _isEditingReps ? Colors.white : AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Big Value Display & Direct Keyboard Input
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                IntrinsicWidth(
                  child: TextField(
                    controller: _textCtrl,
                    keyboardType: TextInputType.numberWithOptions(decimal: !_isEditingReps),
                    textAlign: TextAlign.center,
                    onChanged: _onTextChanged,
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isEditingReps ? 'reps' : 'kg',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Text(
              'Arraste a fita métrica abaixo ou digite o valor diretamente',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
            ),

            const SizedBox(height: 16),

            // Horizontal Tape Ruler Canvas
            SizedBox(
              height: 75,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Tape Ruler Scrollable Ticks
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final halfWidth = constraints.maxWidth / 2;
                      final totalSteps = _isEditingReps
                          ? (_maxReps - _minReps)
                          : ((_maxWeight - _minWeight) / _weightStep).round();

                      return ListView.builder(
                        controller: _scrollCtrl,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: halfWidth),
                        itemCount: totalSteps + 1,
                        itemBuilder: (context, index) {
                          final value = _isEditingReps
                              ? (_minReps + index)
                              : (_minWeight + (index * _weightStep));

                          final isMajor = _isEditingReps
                              ? (value % 5 == 0)
                              : (value % 5.0 == 0);
                          final isMedium = _isEditingReps
                              ? false
                              : (value % 1.0 == 0);

                          return SizedBox(
                            width: _stepWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isMajor) ...[
                                  Text(
                                    value.toInt().toString(),
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                Container(
                                  width: isMajor ? 2.0 : 1.0,
                                  height: isMajor ? 28 : (isMedium ? 18 : 10),
                                  decoration: BoxDecoration(
                                    color: isMajor
                                        ? AppColors.textSecondary
                                        : AppColors.cardBorder.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // Center Laser Pointer / Needle Indicator
                  IgnorePointer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: themeColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: themeColor.withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 2.5,
                          height: 38,
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: themeColor.withOpacity(0.5),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Step Increment Buttons (+ / -)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _isEditingReps
                      ? [
                          _buildQuickButton('-5', () => _adjustValue(-5)),
                          _buildQuickButton('-1', () => _adjustValue(-1)),
                          _buildQuickButton('+1', () => _adjustValue(1), isPositive: true),
                          _buildQuickButton('+2', () => _adjustValue(2), isPositive: true),
                          _buildQuickButton('+5', () => _adjustValue(5), isPositive: true),
                        ]
                      : [
                          _buildQuickButton('-5 kg', () => _adjustValue(-5)),
                          _buildQuickButton('-2.5 kg', () => _adjustValue(-2.5)),
                          _buildQuickButton('-1 kg', () => _adjustValue(-1)),
                          _buildQuickButton('+1 kg', () => _adjustValue(1), isPositive: true),
                          _buildQuickButton('+2.5 kg', () => _adjustValue(2.5), isPositive: true),
                          _buildQuickButton('+5 kg', () => _adjustValue(5), isPositive: true),
                          _buildQuickButton('+10 kg', () => _adjustValue(10), isPositive: true),
                        ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons (Confirmar / Fechar)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: NeonButton(
                      text: 'Salvar Série (${_currentWeight == _currentWeight.toInt() ? _currentWeight.toInt() : _currentWeight.toStringAsFixed(1)} kg • $_currentReps reps)',
                      icon: Icons.check_circle_outline,
                      height: 48,
                      onPressed: _handleConfirm,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onTap, {bool isPositive = false}) {
    final themeColor = _isEditingReps ? AppColors.electricCyan : AppColors.neonLime;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isPositive ? themeColor.withOpacity(0.15) : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isPositive ? themeColor.withOpacity(0.4) : AppColors.cardBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isPositive ? themeColor : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
