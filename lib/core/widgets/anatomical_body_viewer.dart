import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';

enum MuscleRegion {
  chest,
  deltoids,
  abs,
  biceps,
  forearms,
  quadriceps,
  calves,
  trapezius,
  lats,
  triceps,
  glutes,
  hamstrings,
}

class AnatomicalBodyViewer extends StatefulWidget {
  final List<String> highlightedMuscles;
  final Map<String, int>? weeklyVolumePerMuscle;
  final Function(String muscleName)? onMuscleSelected;
  final String? selectedMuscleName;
  final double height;

  const AnatomicalBodyViewer({
    super.key,
    required this.highlightedMuscles,
    this.weeklyVolumePerMuscle,
    this.onMuscleSelected,
    this.selectedMuscleName,
    this.height = 360,
  });

  @override
  State<AnatomicalBodyViewer> createState() => _AnatomicalBodyViewerState();
}

class _AnatomicalBodyViewerState extends State<AnatomicalBodyViewer> {
  bool _showFront = true;
  MuscleRegion? _selectedRegion;

  final Map<MuscleRegion, String> _regionNames = {
    MuscleRegion.chest: 'Peito',
    MuscleRegion.deltoids: 'Ombros',
    MuscleRegion.abs: 'Abdômen',
    MuscleRegion.biceps: 'Bíceps',
    MuscleRegion.forearms: 'Antebraços',
    MuscleRegion.quadriceps: 'Pernas',
    MuscleRegion.calves: 'Panturrilhas',
    MuscleRegion.trapezius: 'Trapézio',
    MuscleRegion.lats: 'Costas',
    MuscleRegion.triceps: 'Tríceps',
    MuscleRegion.glutes: 'Glúteos',
    MuscleRegion.hamstrings: 'Isquiotibiais',
  };

  final Map<MuscleRegion, String> _anatomicalDetails = {
    MuscleRegion.chest: 'Peitoral Maior (Fibras Esternais e Claviculares)',
    MuscleRegion.deltoids: 'Deltóide Anterior, Lateral e Posterior',
    MuscleRegion.abs: 'Reto Abdominal, Oblíquos e Transverso do Abdômen',
    MuscleRegion.biceps: 'Bíceps Braquial (Cabeça Longa e Curta) e Braquial',
    MuscleRegion.forearms: 'Braquiorradial e Flexores/Extensores do Punho',
    MuscleRegion.quadriceps: 'Reto Femoral, Vasto Lateral, Vasto Medial e Intermédio',
    MuscleRegion.calves: 'Gastrocnêmio (Medial/Lateral) e Sóleo',
    MuscleRegion.trapezius: 'Trapézio Superior, Médio e Inferior',
    MuscleRegion.lats: 'Grande Dorsal, Redondo Maior e Rombóides',
    MuscleRegion.triceps: 'Tríceps Braquial (Cabeça Longa, Lateral e Medial)',
    MuscleRegion.glutes: 'Glúteo Máximo, Médio e Mínimo',
    MuscleRegion.hamstrings: 'Bíceps Femoral, Semitendíneo e Semimembranoso',
  };

  @override
  void initState() {
    super.initState();
    _syncRegionFromMuscleName(widget.selectedMuscleName);
  }

  @override
  void didUpdateWidget(covariant AnatomicalBodyViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMuscleName != widget.selectedMuscleName) {
      _syncRegionFromMuscleName(widget.selectedMuscleName);
    }
  }

  void _syncRegionFromMuscleName(String? name) {
    if (name == null || name.isEmpty) {
      _selectedRegion = null;
      return;
    }
    final q = name.toLowerCase();
    for (final entry in _regionNames.entries) {
      if (entry.value.toLowerCase() == q ||
          q.contains(entry.value.toLowerCase()) ||
          entry.value.toLowerCase().contains(q)) {
        _selectedRegion = entry.key;
        const backRegions = [
          MuscleRegion.trapezius,
          MuscleRegion.lats,
          MuscleRegion.triceps,
          MuscleRegion.glutes,
          MuscleRegion.hamstrings,
        ];
        if (backRegions.contains(entry.key)) {
          _showFront = false;
        } else {
          _showFront = true;
        }
        return;
      }
    }
  }

  bool _isRegionActive(MuscleRegion region) {
    final groupName = _regionNames[region] ?? '';
    return widget.highlightedMuscles.any(
      (m) => m.toLowerCase().contains(groupName.toLowerCase()) || groupName.toLowerCase().contains(m.toLowerCase()),
    );
  }

  void _onRegionTapped(MuscleRegion region) {
    setState(() {
      _selectedRegion = (_selectedRegion == region) ? null : region;
    });
    final groupName = _regionNames[region] ?? '';
    if (widget.onMuscleSelected != null) {
      widget.onMuscleSelected!(_selectedRegion != null ? groupName : '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: widget.height),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.electricCyan.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricCyan.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header & Frente/Costas Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.neonLime.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.accessibility_new, color: AppColors.neonLime, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Corpo Humano 3D Interativo', style: AppTextStyles.labelBold.copyWith(fontSize: 13)),
                      Text('Toque em qualquer músculo do corpo', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              // Switch Frente / Costas
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => setState(() {
                        _showFront = true;
                        _selectedRegion = null;
                      }),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _showFront ? AppColors.neonLime : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'FRENTE',
                          style: TextStyle(
                            color: _showFront ? Colors.black : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(() {
                        _showFront = false;
                        _selectedRegion = null;
                      }),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: !_showFront ? AppColors.neonLime : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'COSTAS',
                          style: TextStyle(
                            color: !_showFront ? Colors.black : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Interactive Human Body Canvas
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Blueprint Grid
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BodyGridPainter(),
                  ),
                ),
                // Silhouette Base Art
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HumanBodySilhouettePainter(
                      isFront: _showFront,
                      selectedRegion: _selectedRegion,
                      isRegionActive: _isRegionActive,
                    ),
                  ),
                ),
                // Clickable Muscle Touch Targets Overlay
                Positioned.fill(
                  child: _showFront ? _buildFrontInteractiveZones() : _buildBackInteractiveZones(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Selected Muscle Info Panel
          _buildSelectedInfoCard(),
        ],
      ),
    );
  }

  Widget _buildFrontInteractiveZones() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cx = constraints.maxWidth / 2;
        const cy = 110.0;

        return Stack(
          children: [
            // Ombros / Deltóides
            _buildInteractiveHitBox(
              left: cx - 65,
              top: cy - 65,
              width: 32,
              height: 32,
              region: MuscleRegion.deltoids,
              label: 'Deltóide',
            ),
            _buildInteractiveHitBox(
              left: cx + 33,
              top: cy - 65,
              width: 32,
              height: 32,
              region: MuscleRegion.deltoids,
              label: 'Deltóide',
            ),

            // Peitoral
            _buildInteractiveHitBox(
              left: cx - 35,
              top: cy - 65,
              width: 70,
              height: 36,
              region: MuscleRegion.chest,
              label: 'Peitoral',
            ),

            // Bíceps
            _buildInteractiveHitBox(
              left: cx - 72,
              top: cy - 30,
              width: 24,
              height: 35,
              region: MuscleRegion.biceps,
              label: 'Bíceps',
            ),
            _buildInteractiveHitBox(
              left: cx + 48,
              top: cy - 30,
              width: 24,
              height: 35,
              region: MuscleRegion.biceps,
              label: 'Bíceps',
            ),

            // Abdômen / Core
            _buildInteractiveHitBox(
              left: cx - 28,
              top: cy - 25,
              width: 56,
              height: 48,
              region: MuscleRegion.abs,
              label: 'Abdômen',
            ),

            // Antebraços
            _buildInteractiveHitBox(
              left: cx - 80,
              top: cy + 8,
              width: 22,
              height: 38,
              region: MuscleRegion.forearms,
              label: 'Antebraço',
            ),
            _buildInteractiveHitBox(
              left: cx + 58,
              top: cy + 8,
              width: 22,
              height: 38,
              region: MuscleRegion.forearms,
              label: 'Antebraço',
            ),

            // Quadríceps (Coxas)
            _buildInteractiveHitBox(
              left: cx - 36,
              top: cy + 26,
              width: 34,
              height: 48,
              region: MuscleRegion.quadriceps,
              label: 'Coxa E',
            ),
            _buildInteractiveHitBox(
              left: cx + 2,
              top: cy + 26,
              width: 34,
              height: 48,
              region: MuscleRegion.quadriceps,
              label: 'Coxa D',
            ),

            // Panturrilhas Frente
            _buildInteractiveHitBox(
              left: cx - 30,
              top: cy + 76,
              width: 26,
              height: 32,
              region: MuscleRegion.calves,
              label: 'Panturrilha',
            ),
            _buildInteractiveHitBox(
              left: cx + 4,
              top: cy + 76,
              width: 26,
              height: 32,
              region: MuscleRegion.calves,
              label: 'Panturrilha',
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackInteractiveZones() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cx = constraints.maxWidth / 2;
        const cy = 110.0;

        return Stack(
          children: [
            // Trapézio
            _buildInteractiveHitBox(
              left: cx - 30,
              top: cy - 80,
              width: 60,
              height: 25,
              region: MuscleRegion.trapezius,
              label: 'Trapézio',
            ),

            // Deltóide Posterior
            _buildInteractiveHitBox(
              left: cx - 65,
              top: cy - 65,
              width: 30,
              height: 30,
              region: MuscleRegion.deltoids,
              label: 'Delt. Post',
            ),
            _buildInteractiveHitBox(
              left: cx + 35,
              top: cy - 65,
              width: 30,
              height: 30,
              region: MuscleRegion.deltoids,
              label: 'Delt. Post',
            ),

            // Dorsal / Costas
            _buildInteractiveHitBox(
              left: cx - 38,
              top: cy - 55,
              width: 76,
              height: 42,
              region: MuscleRegion.lats,
              label: 'Dorsais',
            ),

            // Tríceps
            _buildInteractiveHitBox(
              left: cx - 72,
              top: cy - 30,
              width: 24,
              height: 35,
              region: MuscleRegion.triceps,
              label: 'Tríceps',
            ),
            _buildInteractiveHitBox(
              left: cx + 48,
              top: cy - 30,
              width: 24,
              height: 35,
              region: MuscleRegion.triceps,
              label: 'Tríceps',
            ),

            // Glúteos
            _buildInteractiveHitBox(
              left: cx - 32,
              top: cy - 5,
              width: 64,
              height: 35,
              region: MuscleRegion.glutes,
              label: 'Glúteos',
            ),

            // Isquiotibiais (Posterior de Coxa)
            _buildInteractiveHitBox(
              left: cx - 34,
              top: cy + 32,
              width: 32,
              height: 44,
              region: MuscleRegion.hamstrings,
              label: 'Posterior E',
            ),
            _buildInteractiveHitBox(
              left: cx + 2,
              top: cy + 32,
              width: 32,
              height: 44,
              region: MuscleRegion.hamstrings,
              label: 'Posterior D',
            ),

            // Panturrilhas
            _buildInteractiveHitBox(
              left: cx - 30,
              top: cy + 76,
              width: 26,
              height: 32,
              region: MuscleRegion.calves,
              label: 'Panturrilha',
            ),
            _buildInteractiveHitBox(
              left: cx + 4,
              top: cy + 76,
              width: 26,
              height: 32,
              region: MuscleRegion.calves,
              label: 'Panturrilha',
            ),
          ],
        );
      },
    );
  }

  Widget _buildInteractiveHitBox({
    required double left,
    required double top,
    required double width,
    required double height,
    required MuscleRegion region,
    required String label,
  }) {
    final isSelected = _selectedRegion == region;
    final isActive = _isRegionActive(region);

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onRegionTapped(region),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.neonLime.withOpacity(0.4)
                : (isActive ? AppColors.electricCyan.withOpacity(0.18) : Colors.transparent),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected
                  ? AppColors.neonLime
                  : (isActive ? AppColors.electricCyan.withOpacity(0.7) : AppColors.cardBorder.withOpacity(0.2)),
              width: isSelected ? 2 : (isActive ? 1.2 : 0.8),
            ),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.neonLime
                    : (isActive ? AppColors.electricCyan : AppColors.textMuted.withOpacity(0.6)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedInfoCard() {
    final region = _selectedRegion ?? (_showFront ? MuscleRegion.chest : MuscleRegion.lats);
    final groupName = _regionNames[region] ?? 'Músculo';
    final details = _anatomicalDetails[region] ?? '';
    final volume = widget.weeklyVolumePerMuscle?[groupName] ?? 12;
    final isActive = _isRegionActive(region);

    return InkWell(
      onTap: () {
        if (widget.onMuscleSelected != null) {
          widget.onMuscleSelected!(groupName);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.neonLime.withOpacity(0.5) : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isActive ? AppColors.neonLime : AppColors.electricCyan).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.fitness_center,
                color: isActive ? AppColors.neonLime : AppColors.electricCyan,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        groupName.toUpperCase(),
                        style: AppTextStyles.labelBold.copyWith(
                          color: isActive ? AppColors.neonLime : AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$volume séries/sem',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.electricCyan,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.electricCyan.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.electricCyan.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver Abaixo',
                    style: TextStyle(
                      color: AppColors.electricCyan,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_downward, color: AppColors.electricCyan, size: 13),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electricCyan.withOpacity(0.04)
      ..strokeWidth = 1.0;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HumanBodySilhouettePainter extends CustomPainter {
  final bool isFront;
  final MuscleRegion? selectedRegion;
  final bool Function(MuscleRegion) isRegionActive;

  _HumanBodySilhouettePainter({
    required this.isFront,
    required this.selectedRegion,
    required this.isRegionActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    const cy = 110.0;

    final bodyLinePaint = Paint()
      ..color = AppColors.cardBorder
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final headPaint = Paint()
      ..color = AppColors.surfaceLight
      ..style = PaintingStyle.fill;

    // Cabeça
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -90).translate(cx, cy), width: 26, height: 32),
      headPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, -90).translate(cx, cy), width: 26, height: 32),
      bodyLinePaint,
    );

    // Tronco contorno
    final torsoPath = Path()
      ..moveTo(cx - 15, cy - 74) // Pescoço esq
      ..lineTo(cx - 65, cy - 65) // Ombro esq
      ..lineTo(cx - 78, cy - 25) // Braço esq
      ..lineTo(cx - 86, cy + 30) // Antebraço esq
      ..lineTo(cx - 74, cy + 30) // Mão esq
      ..lineTo(cx - 60, cy - 10)
      ..lineTo(cx - 32, cy - 15) // Axila esq
      ..lineTo(cx - 24, cy + 18) // Cintura esq
      ..lineTo(cx - 38, cy + 24) // Quadril esq
      ..lineTo(cx - 36, cy + 74) // Joelho esq
      ..lineTo(cx - 32, cy + 105) // Tornozelo esq
      ..lineTo(cx - 20, cy + 105)
      ..lineTo(cx - 22, cy + 74)
      ..lineTo(cx - 8, cy + 24) // Virilha
      ..lineTo(cx + 8, cy + 24)
      ..lineTo(cx + 22, cy + 74)
      ..lineTo(cx + 20, cy + 105)
      ..lineTo(cx + 32, cy + 105)
      ..lineTo(cx + 36, cy + 74)
      ..lineTo(cx + 38, cy + 24)
      ..lineTo(cx + 24, cy + 18)
      ..lineTo(cx + 32, cy - 15)
      ..lineTo(cx + 60, cy - 10)
      ..lineTo(cx + 74, cy + 30)
      ..lineTo(cx + 86, cy + 30)
      ..lineTo(cx + 78, cy - 25)
      ..lineTo(cx + 65, cy - 65)
      ..lineTo(cx + 15, cy - 74)
      ..close();

    canvas.drawPath(
      torsoPath,
      Paint()
        ..color = AppColors.surfaceLight
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(torsoPath, bodyLinePaint);
  }

  @override
  bool shouldRepaint(covariant _HumanBodySilhouettePainter oldDelegate) {
    return oldDelegate.isFront != isFront || oldDelegate.selectedRegion != selectedRegion;
  }
}
