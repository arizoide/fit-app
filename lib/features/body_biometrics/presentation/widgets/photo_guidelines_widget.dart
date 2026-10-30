import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';

class PhotoGuidelinesWidget extends StatefulWidget {
  final bool isCompact;

  const PhotoGuidelinesWidget({
    super.key,
    this.isCompact = false,
  });

  static Future<void> showModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.electricCyan, width: 2.5)),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.electricCyan.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: AppColors.electricCyan, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Guia de Fotos Biométricas', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
                          Text('Como posicionar para máxima precisão da IA', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.cardBorder, height: 1),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: PhotoGuidelinesWidget(isCompact: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<PhotoGuidelinesWidget> createState() => _PhotoGuidelinesWidgetState();
}

class _PhotoGuidelinesWidgetState extends State<PhotoGuidelinesWidget> {
  int _selectedPoseIndex = 0; // 0 = Frente, 1 = Costas, 2 = Perfil

  final List<Map<String, dynamic>> _poses = [
    {
      'title': 'Foto Frontal (Frente)',
      'subtitle': 'Avalia peitoral, abdômen, simetria clavicular e coxas',
      'tag': 'POSE 1',
      'icon': Icons.accessibility_new,
      'instructions': [
        'Pés alinhados na largura dos ombros',
        'Braços levemente afastados do tronco (~30°)',
        'Abdômen em postura neutra (sem encolher a barriga)',
        'Olhar fixo na linha do horizonte',
      ],
      'aiFocus': 'Definição abdominal, proporção peitoral/ombros e simetria de quadríceps.',
      'color': AppColors.neonLime,
    },
    {
      'title': 'Foto Posterior (Costas)',
      'subtitle': 'Avalia largura de dorsais (V-Taper), trapézio e glúteos',
      'tag': 'POSE 2',
      'icon': Icons.airline_seat_recline_normal,
      'instructions': [
        'Costas voltadas diretamente para a câmera',
        'Escápulas relaxadas em repouso natural',
        'Cotovelos levemente flexionados para fora',
        'Pernas retas com calcanhares alinhados',
      ],
      'aiFocus': 'V-taper, densidade do trapézio médio/superior e curvatura da coluna.',
      'color': AppColors.electricCyan,
    },
    {
      'title': 'Foto Lateral (Perfil)',
      'subtitle': 'Avalia curvatura lombar, projeção torácica e glúteo/coxa',
      'tag': 'POSE 3',
      'icon': Icons.directions_walk,
      'instructions': [
        'Posicione-se totalmente de lado para a lente',
        'Coluna ereta e queixo alinhado ao chão',
        'Braço mais próximo levemente flexionado sem tapar a cintura',
        'Peso distribuído igualmente em ambos os pés',
      ],
      'aiFocus': 'Postura sagital, cifose/lordose e espessura torácica.',
      'color': AppColors.pulseOrange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentPose = _poses[_selectedPoseIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Selector Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.photo_camera_front, color: AppColors.electricCyan, size: 20),
                const SizedBox(width: 8),
                Text('Exemplos de Poses Esperadas', style: AppTextStyles.labelBold.copyWith(fontSize: 14)),
              ],
            ),
            if (widget.isCompact)
              TextButton(
                onPressed: () => PhotoGuidelinesWidget.showModal(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ver Tudo', style: TextStyle(color: AppColors.electricCyan, fontSize: 12, fontWeight: FontWeight.bold)),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.electricCyan),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // Pose Selection Switcher
        Row(
          children: List.generate(_poses.length, (index) {
            final isSelected = _selectedPoseIndex == index;
            final pose = _poses[index];
            final color = pose['color'] as Color;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < _poses.length - 1 ? 8 : 0),
                child: InkWell(
                  onTap: () => setState(() => _selectedPoseIndex = index),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.18) : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? color : AppColors.cardBorder,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          pose['tag'],
                          style: TextStyle(
                            color: isSelected ? color : AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pose['title'].toString().split(' ').first,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),

        // Pose Detail Showcase Card
        GlassCard(
          borderColor: (currentPose['color'] as Color).withOpacity(0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pose Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (currentPose['color'] as Color).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          currentPose['icon'] as IconData,
                          color: currentPose['color'] as Color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentPose['title'] as String,
                            style: AppTextStyles.labelBold.copyWith(fontSize: 15, color: currentPose['color'] as Color),
                          ),
                          Text(
                            currentPose['subtitle'] as String,
                            style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Visual Silhouette Blueprint / Mock Frame
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Grid lines
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _PoseGuideBlueprintPainter(color: currentPose['color'] as Color),
                      ),
                    ),
                    // Silhouette Figure Representation
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          currentPose['icon'] as IconData,
                          size: 56,
                          color: currentPose['color'] as Color,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: (currentPose['color'] as Color).withOpacity(0.5)),
                          ),
                          child: Text(
                            '📸 Enquadramento de Corpo Inteiro (Cabeça aos Pés)',
                            style: TextStyle(
                              color: currentPose['color'] as Color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Instructions Checklist
              Text('Como se Posicionar:', style: AppTextStyles.labelBold.copyWith(fontSize: 12)),
              const SizedBox(height: 8),
              ...((currentPose['instructions'] as List<String>).map((inst) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 14, color: AppColors.neonLime),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(inst, style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                      ),
                    ],
                  ),
                );
              })),
              const SizedBox(height: 8),

              // AI Focus Note
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.electricCyan, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'O que a IA foca: ${currentPose['aiFocus']}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 4 Golden Rules Cards (always visible or expanded)
        Text('Os 4 Pilares da Foto Perfeita', style: AppTextStyles.labelBold),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.65,
          children: [
            _buildRuleCard(
              icon: Icons.wb_sunny_outlined,
              title: '1. Iluminação',
              desc: 'Luz frontal natural ou branca. Evite sombras que ocultem linhas.',
              accentColor: AppColors.pulseOrange,
            ),
            _buildRuleCard(
              icon: Icons.checkroom_outlined,
              title: '2. Vestimenta',
              desc: 'Roupas de treino justas (shorts/top) para contornos anatômicos.',
              accentColor: AppColors.electricCyan,
            ),
            _buildRuleCard(
              icon: Icons.straighten,
              title: '3. Distância & Altura',
              desc: 'Câmera na altura do umbigo, a 2.0m a 2.5m de distância.',
              accentColor: AppColors.neonLime,
            ),
            _buildRuleCard(
              icon: Icons.schedule,
              title: '4. Consistência',
              desc: 'Mesmo horário (preferência em jejum matinal) para padrão de BF.',
              accentColor: AppColors.purpleAccent,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Do's and Don'ts Accordion / Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Checklist: O que Fazer vs O que Evitar', style: AppTextStyles.labelBold.copyWith(fontSize: 13)),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.neonLime, size: 14),
                            const SizedBox(width: 4),
                            Text('RECOMENDADO', style: AppTextStyles.bodySmall.copyWith(color: AppColors.neonLime, fontWeight: FontWeight.bold, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildBulletPoint('Postura ereta e relaxada'),
                        _buildBulletPoint('Foto nítida e sem tremor'),
                        _buildBulletPoint('Corpo inteiro enquadrado'),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 75, color: AppColors.cardBorder),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.cancel, color: AppColors.alertRed, size: 14),
                            const SizedBox(width: 4),
                            Text('EVITAR', style: AppTextStyles.bodySmall.copyWith(color: AppColors.alertRed, fontWeight: FontWeight.bold, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildBulletPoint('Contrações forçadas irreais'),
                        _buildBulletPoint('Celular cobrindo o peito no espelho'),
                        _buildBulletPoint('Filtros ou sombras duras'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '• $text',
        style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildRuleCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              desc,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PoseGuideBlueprintPainter extends CustomPainter {
  final Color color;

  _PoseGuideBlueprintPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Center vertical alignment axis
    final centerPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), centerPaint);

    // Horizontal guideline bars
    canvas.drawLine(Offset(20, size.height * 0.25), Offset(size.width - 20, size.height * 0.25), paint);
    canvas.drawLine(Offset(20, size.height * 0.50), Offset(size.width - 20, size.height * 0.50), paint);
    canvas.drawLine(Offset(20, size.height * 0.75), Offset(size.width - 20, size.height * 0.75), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
