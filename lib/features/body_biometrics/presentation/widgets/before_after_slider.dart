import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BeforeAfterSlider extends StatefulWidget {
  final Widget beforeWidget;
  final Widget afterWidget;
  final String beforeLabel;
  final String afterLabel;
  final double height;

  const BeforeAfterSlider({
    super.key,
    required this.beforeWidget,
    required this.afterWidget,
    this.beforeLabel = 'Antes (Mês 1)',
    this.afterLabel = 'Depois (Atual)',
    this.height = 320,
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  double _sliderPosition = 0.5; // 0.0 a 1.0

  void _updatePosition(Offset localPosition, double totalWidth) {
    setState(() {
      _sliderPosition = (localPosition.dx / totalWidth).clamp(0.05, 0.95);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder, width: 1.5),
            ),
            child: GestureDetector(
              onPanUpdate: (details) => _updatePosition(details.localPosition, totalWidth),
              onTapDown: (details) => _updatePosition(details.localPosition, totalWidth),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // After Image (Base)
                  widget.afterWidget,

                  // After Label Tag (Top Right)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.neonLime.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.afterLabel,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),

                  // Before Image (Clipped by slider position)
                  ClipRect(
                    clipper: _HorizontalClipper(_sliderPosition * totalWidth),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        widget.beforeWidget,
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Text(
                              widget.beforeLabel,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider Line & Handle
                  Positioned(
                    left: (_sliderPosition * totalWidth) - 1.5,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3,
                      color: AppColors.neonLime,
                    ),
                  ),

                  // Slider Knob Handle
                  Positioned(
                    left: (_sliderPosition * totalWidth) - 18,
                    top: (widget.height / 2) - 18,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.neonLime, width: 2.5),
                        boxShadow: const [
                          BoxShadow(color: AppColors.neonLimeGlow, blurRadius: 10, spreadRadius: 2),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.unfold_more, color: AppColors.neonLime, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HorizontalClipper extends CustomClipper<Rect> {
  final double width;
  _HorizontalClipper(this.width);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(covariant _HorizontalClipper oldClipper) {
    return oldClipper.width != width;
  }
}
