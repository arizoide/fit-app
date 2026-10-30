import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';

enum EquipmentVisualType {
  legPress,
  hackSquat,
  legExtension,
  legCurl,
  cablePulley,
  cableCrossover,
  peckDeck,
  smithMachine,
  chestPressMachine,
  latPulldown,
  seatedCableRow,
  standingCalfMachine,
  benchAndDumbbells,
  barbellRack,
  pullupStation,
  bodyweightMat,
  treadmill,
  stationaryBike,
  stairMaster,
  elliptical,
  jumpRope,
}

class EquipmentVisualCard extends StatelessWidget {
  final String equipmentName;
  final String exerciseName;
  final String exerciseId;
  final double height;
  final bool showAdjustmentGuide;

  const EquipmentVisualCard({
    super.key,
    required this.equipmentName,
    required this.exerciseName,
    required this.exerciseId,
    this.height = 180,
    this.showAdjustmentGuide = false,
  });

  static EquipmentVisualType resolveType(String id, String equipment, String name) {
    final lowerId = id.toLowerCase();
    final lowerName = name.toLowerCase();
    final lowerEquip = equipment.toLowerCase();

    // Cardio machines first
    if (lowerId.contains('treadmill') || lowerName.contains('esteira') || lowerEquip.contains('esteira')) {
      return EquipmentVisualType.treadmill;
    }
    if (lowerId.contains('stair') || lowerName.contains('escada') || lowerEquip.contains('escada')) {
      return EquipmentVisualType.stairMaster;
    }
    if (lowerId.contains('bike') || lowerName.contains('bicicleta') || lowerName.contains('spinning') || lowerEquip.contains('bicicleta') || lowerEquip.contains('bike')) {
      return EquipmentVisualType.stationaryBike;
    }
    if (lowerId.contains('elliptical') || lowerName.contains('elíptico') || lowerName.contains('eliptico') || lowerEquip.contains('elíptico')) {
      return EquipmentVisualType.elliptical;
    }
    if (lowerId.contains('jump_rope') || lowerName.contains('corda') || lowerEquip.contains('corda')) {
      return EquipmentVisualType.jumpRope;
    }

    if (lowerId.contains('leg_press') || lowerName.contains('leg press')) {
      return EquipmentVisualType.legPress;
    }
    if (lowerId.contains('hack') || lowerName.contains('hack')) {
      return EquipmentVisualType.hackSquat;
    }
    if (lowerId.contains('extension') || lowerName.contains('extensora')) {
      return EquipmentVisualType.legExtension;
    }
    if (lowerId.contains('curl') || lowerName.contains('flexora')) {
      return EquipmentVisualType.legCurl;
    }
    if (lowerId.contains('peck_deck') || lowerName.contains('peck deck') || lowerName.contains('voador')) {
      return EquipmentVisualType.peckDeck;
    }
    if (lowerId.contains('crossover') || lowerName.contains('crossover')) {
      return EquipmentVisualType.cableCrossover;
    }
    if (lowerId.contains('smith') || lowerName.contains('smith')) {
      return EquipmentVisualType.smithMachine;
    }
    if (lowerId.contains('machine_press') || lowerName.contains('supino na máquina') || lowerName.contains('chest press')) {
      return EquipmentVisualType.chestPressMachine;
    }
    if (lowerId.contains('lat_pulldown') || lowerName.contains('puxada frontal') || lowerName.contains('puxador')) {
      return EquipmentVisualType.latPulldown;
    }
    if (lowerId.contains('seated_cable_row') || lowerName.contains('remada baixa')) {
      return EquipmentVisualType.seatedCableRow;
    }
    if (lowerId.contains('standing_calf') || lowerName.contains('panturrilha em pé')) {
      return EquipmentVisualType.standingCalfMachine;
    }
    if (lowerEquip.contains('cabos') || lowerName.contains('polia')) {
      return EquipmentVisualType.cablePulley;
    }
    if (lowerId.contains('pullup') || lowerId.contains('chinup') || lowerName.contains('barra fixa')) {
      return EquipmentVisualType.pullupStation;
    }
    if (lowerEquip.contains('barra') || lowerId.contains('barbell') || lowerName.contains('barra')) {
      return EquipmentVisualType.barbellRack;
    }
    if (lowerEquip.contains('peso corporal') || lowerName.contains('solo') || lowerName.contains('flexão') || lowerName.contains('prancha') || lowerName.contains('caminhada') || lowerName.contains('corrida')) {
      return EquipmentVisualType.bodyweightMat;
    }
    return EquipmentVisualType.benchAndDumbbells;
  }

  static String getEquipmentDescription(EquipmentVisualType type) {
    switch (type) {
      case EquipmentVisualType.treadmill:
        return 'Esteira Ergométrica Profissional com absorção de impacto, ajuste digital de inclinação (0% a 15%) e monitor cardíaco por sensor.';
      case EquipmentVisualType.stairMaster:
        return 'Simulador de Escada Contínua (Stairmaster) com degraus rotativos e controle dinâmico de cadência de subida.';
      case EquipmentVisualType.stationaryBike:
        return 'Bicicleta Ergométrica / Spinning com volante de inércia magnético, selim e guidão com regulagem microajustável.';
      case EquipmentVisualType.elliptical:
        return 'Aparelho Elíptico (Transport) de baixo impacto articular com hastes sincronizadas para membros superiores e inferiores.';
      case EquipmentVisualType.jumpRope:
        return 'Corda de Pular de Alta Velocidade (Speed Rope) com rolamentos de aço para condicionamento aeróbico e agilidade.';
      case EquipmentVisualType.legPress:
        return 'Aparelho Leg Press 45° com plataforma deslizante sobre trilhos de aço e travas de segurança laterais.';
      case EquipmentVisualType.hackSquat:
        return 'Máquina Hack Squat com encosto inclinado acolchoado e ombreiras com trava manual.';
      case EquipmentVisualType.legExtension:
        return 'Cadeira Extensora com banco 90°, rolo ajustável sobre a canela e pino seletor de placas de peso.';
      case EquipmentVisualType.legCurl:
        return 'Mesa / Cadeira Flexora com rolo de calcanhar posterior e apoio estabilizador de coxas.';
      case EquipmentVisualType.peckDeck:
        return 'Máquina Peck Deck / Voador articulado com regulagem de altura do assento e amplitude dos braços.';
      case EquipmentVisualType.cableCrossover:
        return 'Estação Dupla de Polias Ajustáveis (Crossover) com cabos de aço e mosquetões para diferentes manoplas.';
      case EquipmentVisualType.smithMachine:
        return 'Smith Machine com barra olímpica guiada em trilhos verticais de precisão e travas de segurança.';
      case EquipmentVisualType.chestPressMachine:
        return 'Máquina de Supino Sentado (Chest Press) com pegada bi-articulada convergente e regulagem de assento.';
      case EquipmentVisualType.latPulldown:
        return 'Puxador Alto na Polia (Lat Pulldown) com barra longa e roletes acolchoados para travar os joelhos.';
      case EquipmentVisualType.seatedCableRow:
        return 'Máquina de Remada Baixa com cabo horizontal, apoio para os pés e pegador tipo triângulo.';
      case EquipmentVisualType.standingCalfMachine:
        return 'Máquina de Panturrilha em Pé com almofadas de ombros e degrau antiderrapante com amplitude livre.';
      case EquipmentVisualType.cablePulley:
        return 'Polia de Cabo Ajustável com regulagem de altura e seletor de carga magnético.';
      case EquipmentVisualType.barbellRack:
        return 'Barra Olímpica de 20kg com suporte J-Hooks, presilhas e anilhas de ferro/bumper.';
      case EquipmentVisualType.pullupStation:
        return 'Estação de Barra Fixa com pegadas pronada, supinada e neutra emborrachadas.';
      case EquipmentVisualType.bodyweightMat:
        return 'Espaço Livre / Colchonete de Alta Densidade para movimentos de peso corporal.';
      case EquipmentVisualType.benchAndDumbbells:
        return 'Halteres Emborrachados de Peso Ajustável ou Monobloco com Banco Inclinável (0° a 90°).';
    }
  }

  static String getAdjustmentTips(EquipmentVisualType type) {
    switch (type) {
      case EquipmentVisualType.treadmill:
        return '1. Prenda a chave/presilha de segurança magnética na roupa.\n2. Inicie com velocidade baixa (4.0-5.0 km/h) antes de aumentar a inclinação (ex: 4% a 8%).\n3. Evite segurar firmemente no painel para maximizar o gasto calórico e manter a postura ereta.';
      case EquipmentVisualType.stairMaster:
        return '1. Apoie o pé inteiro no degrau (não fique apenas na ponta dos pés).\n2. Mantenha as costas eretas e apoie as mãos levemente no corrimão apenas para equilíbrio.\n3. Ajuste o nível de velocidade para manter 50 a 70 passos por minuto em Zona 2/3.';
      case EquipmentVisualType.stationaryBike:
        return '1. Regule a altura do selim na linha da crista ilíaca (osso do quadril).\n2. Na extensão máxima do pedal, o joelho deve manter uma leve flexão (~25° a 30°).\n3. Ajuste a resistência magnética conforme a cadência desejada (70-90 RPM).';
      case EquipmentVisualType.elliptical:
        return '1. Ajuste a resistência e inclinação para cadência fluida sem travar o movimento.\n2. Pressione com o calcanhar e mantenha a coluna alinhada.\n3. Empurre e puxe as manoplas para engajar peito, costas e braços.';
      case EquipmentVisualType.jumpRope:
        return '1. Meça o tamanho pisando no meio da corda; as manoplas devem chegar na altura das axilas.\n2. Pule na ponta dos pés amortecendo com os joelhos macios.\n3. Mantenha os cotovelos colados às costelas e gire com os punhos.';
      case EquipmentVisualType.legPress:
        return '1. Regule o encosto para não arredondar a lombar na descida.\n2. Posição dos pés na largura dos ombros.\n3. Destrave as alavancas laterais com as pernas quase estendidas (sem travar os joelhos).';
      case EquipmentVisualType.hackSquat:
        return '1. Ajuste a altura das ombreiras para encostar firmemente sem curvar o pescoço.\n2. Apoie as costas 100% no encosto.';
      case EquipmentVisualType.legExtension:
        return '1. Alinhe o eixo de rotação da máquina com a linha lateral do seu joelho.\n2. O rolo deve ficar sobre o terço inferior da canela (logo acima dos tornozelos).';
      case EquipmentVisualType.legCurl:
        return '1. O rolo deve se apoiar atrás do tendão de Aquiles/panturrilha baixa.\n2. Trave bem a almofada sobre as coxas para evitar levantar o quadril.';
      case EquipmentVisualType.peckDeck:
        return '1. Ajuste a altura do banco para que os pegadores fiquem na linha do peitoral médio.\n2. Ajuste os pinos de abertura dos braços para um alongamento confortável.';
      case EquipmentVisualType.cableCrossover:
        return '1. Ajuste a altura das roldanas (alta para peito inferior, média para médio, baixa para superior).\n2. Dê um passo à frente para estabilizar o tronco.';
      case EquipmentVisualType.smithMachine:
        return '1. Posicione os limitadores de segurança na altura mínima da repetição.\n2. Gire os punhos para destravar a barra antes de iniciar o movimento.';
      case EquipmentVisualType.chestPressMachine:
        return '1. Regule a altura do assento para que as manoplas fiquem na linha dos mamilos.\n2. Retraia as escápulas contra o encosto.';
      case EquipmentVisualType.latPulldown:
        return '1. Ajuste a altura das almofadas para travar firmemente as coxas contra o assento.\n2. Mantenha o peito estufado e incline levemente o tronco para trás.';
      case EquipmentVisualType.seatedCableRow:
        return '1. Apoie os pés com joelhos levemente flexionados (não travar).\n2. Puxe com o tronco ereto e coluna alinhada.';
      case EquipmentVisualType.standingCalfMachine:
        return '1. Apoie a meia-ponta dos pés na borda do degrau.\n2. Regule a altura das ombreiras para conseguir alongar totalmente o calcanhar para baixo.';
      case EquipmentVisualType.cablePulley:
        return '1. Verifique se o mosquetão está fechado com segurança.\n2. Mantenha a postura estável alinhada ao vetor de tração do cabo.';
      case EquipmentVisualType.barbellRack:
        return '1. Regule os apoios na altura do esterno/peito.\n2. Use sempre presilhas de segurança nas pontas da barra.';
      case EquipmentVisualType.pullupStation:
        return '1. Segure com pegada firme na largura dos ombros.\n2. Ative as escápulas antes de flexionar os cotovelos.';
      case EquipmentVisualType.bodyweightMat:
        return '1. Verifique aderência das mãos no chão.\n2. Mantenha abdômen contraído durante todo o movimento.';
      case EquipmentVisualType.benchAndDumbbells:
        return '1. Trave o pino do banco no ângulo desejado (plano = 0°, inclinado = 30°-45°).\n2. Certifique-se de que os halteres estejam bem firmes.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = resolveType(exerciseId, equipmentName, exerciseName);
    final desc = getEquipmentDescription(type);
    final tips = getAdjustmentTips(type);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.electricCyan.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricCyan.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Visual Top
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0F1A24),
                  const Color(0xFF142433),
                  AppColors.surfaceLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Background Grid Accent
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BlueprintGridPainter(),
                  ),
                ),
                // Machine Illustration
                Center(
                  child: CustomPaint(
                    size: Size(double.infinity, height),
                    painter: _EquipmentSchematicPainter(type: type),
                  ),
                ),
                // Type Badge Top Left
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.neonLime, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.remove_red_eye, color: AppColors.neonLime, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          _getBadgeLabel(type),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.neonLime,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Location Category Top Right
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.electricCyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.electricCyan.withOpacity(0.5)),
                    ),
                    child: Text(
                      equipmentName.toUpperCase(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.electricCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Technical Description
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.precision_manufacturing, color: AppColors.electricCyan, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Esquemático do Aparelho & Configuração',
                        style: AppTextStyles.labelBold.copyWith(fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3),
                ),
                if (showAdjustmentGuide) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.tune, color: AppColors.neonLime, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Como Ajustar na Academia:',
                              style: AppTextStyles.labelBold.copyWith(color: AppColors.neonLime, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tips,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBadgeLabel(EquipmentVisualType type) {
    switch (type) {
      case EquipmentVisualType.treadmill:
        return 'Esteira Ergométrica';
      case EquipmentVisualType.stairMaster:
        return 'Simulador de Escada';
      case EquipmentVisualType.stationaryBike:
        return 'Bicicleta / Spinning';
      case EquipmentVisualType.elliptical:
        return 'Aparelho Elíptico';
      case EquipmentVisualType.jumpRope:
        return 'Corda de Pular';
      case EquipmentVisualType.legPress:
        return 'Leg Press 45°';
      case EquipmentVisualType.hackSquat:
        return 'Hack Machine';
      case EquipmentVisualType.legExtension:
        return 'Cadeira Extensora';
      case EquipmentVisualType.legCurl:
        return 'Mesa/Cadeira Flexora';
      case EquipmentVisualType.peckDeck:
        return 'Peck Deck / Voador';
      case EquipmentVisualType.cableCrossover:
        return 'Crossover (Cabos)';
      case EquipmentVisualType.smithMachine:
        return 'Smith Machine';
      case EquipmentVisualType.chestPressMachine:
        return 'Máquina Chest Press';
      case EquipmentVisualType.latPulldown:
        return 'Puxada na Polia';
      case EquipmentVisualType.seatedCableRow:
        return 'Remada Baixa (Cabo)';
      case EquipmentVisualType.standingCalfMachine:
        return 'Panturrilha Máquina';
      case EquipmentVisualType.cablePulley:
        return 'Polia de Cabos';
      case EquipmentVisualType.barbellRack:
        return 'Barra & Rack';
      case EquipmentVisualType.pullupStation:
        return 'Barra Fixa';
      case EquipmentVisualType.bodyweightMat:
        return 'Solo / Peso Corporal';
      case EquipmentVisualType.benchAndDumbbells:
        return 'Banco & Halteres';
    }
  }
}

class _BlueprintGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electricCyan.withOpacity(0.04)
      ..strokeWidth = 1.0;

    const step = 24.0;
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

class _EquipmentSchematicPainter extends CustomPainter {
  final EquipmentVisualType type;

  _EquipmentSchematicPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 10;

    final framePaint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = AppColors.electricCyan
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final accentPaint = Paint()
      ..color = AppColors.neonLime
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final padPaint = Paint()
      ..color = AppColors.pulseOrange.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    switch (type) {
      case EquipmentVisualType.treadmill:
        // Treadmill Base Platform with Incline
        canvas.drawLine(Offset(cx - 75, cy + 42), Offset(cx + 65, cy + 28), framePaint..strokeWidth = 6.0);
        // Belt Rollers
        canvas.drawCircle(Offset(cx - 70, cy + 42), 7, glowPaint);
        canvas.drawCircle(Offset(cx + 60, cy + 28), 7, glowPaint);
        // Deck Surface Neon Line
        canvas.drawLine(Offset(cx - 65, cy + 38), Offset(cx + 55, cy + 25), accentPaint);
        // Upright Support Posts
        canvas.drawLine(Offset(cx + 45, cy + 26), Offset(cx + 25, cy - 35), framePaint..strokeWidth = 4.0);
        canvas.drawLine(Offset(cx + 25, cy + 28), Offset(cx + 5, cy - 35), framePaint..strokeWidth = 4.0);
        // Handrails
        canvas.drawLine(Offset(cx + 25, cy - 35), Offset(cx - 25, cy - 25), glowPaint);
        // Digital Console Head
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 20, cy - 42), width: 34, height: 20), const Radius.circular(4)),
          padPaint,
        );
        // Safety Emergency Clip line
        canvas.drawCircle(Offset(cx + 20, cy - 32), 4, accentPaint);
        break;

      case EquipmentVisualType.stationaryBike:
        // Base stabilizers
        canvas.drawLine(Offset(cx - 65, cy + 48), Offset(cx + 65, cy + 48), framePaint);
        // Flywheel Front Circle
        canvas.drawCircle(Offset(cx + 35, cy + 15), 24, glowPaint);
        canvas.drawCircle(Offset(cx + 35, cy + 15), 10, accentPaint);
        // Triangle Frame
        canvas.drawLine(Offset(cx + 35, cy + 15), Offset(cx - 15, cy + 25), framePaint);
        canvas.drawLine(Offset(cx - 15, cy + 25), Offset(cx - 30, cy - 20), framePaint);
        canvas.drawLine(Offset(cx + 35, cy + 15), Offset(cx + 20, cy - 25), framePaint);
        canvas.drawLine(Offset(cx - 30, cy - 20), Offset(cx + 20, cy - 25), framePaint);
        // Saddle / Seat
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 32, cy - 26), width: 26, height: 8), const Radius.circular(3)),
          padPaint,
        );
        // Aero Handlebars
        canvas.drawLine(Offset(cx + 20, cy - 25), Offset(cx + 32, cy - 38), glowPaint);
        canvas.drawArc(Rect.fromCenter(center: Offset(cx + 30, cy - 42), width: 22, height: 16), 0, 3.14, false, accentPaint);
        // Pedals & Crank
        canvas.drawCircle(Offset(cx - 15, cy + 25), 6, padPaint);
        canvas.drawLine(Offset(cx - 15, cy + 25), Offset(cx - 8, cy + 40), glowPaint);
        canvas.drawLine(Offset(cx - 15, cy + 25), Offset(cx - 22, cy + 10), glowPaint);
        break;

      case EquipmentVisualType.stairMaster:
        // High Main Tower Frame
        canvas.drawLine(Offset(cx - 60, cy + 50), Offset(cx + 50, cy + 50), framePaint);
        canvas.drawLine(Offset(cx - 50, cy + 50), Offset(cx - 10, cy - 45), framePaint);
        canvas.drawLine(Offset(cx + 40, cy + 50), Offset(cx + 25, cy - 45), framePaint);
        // Step Stairs (4 Levels)
        canvas.drawLine(Offset(cx - 40, cy + 36), Offset(cx - 15, cy + 36), glowPaint);
        canvas.drawLine(Offset(cx - 15, cy + 36), Offset(cx - 15, cy + 18), glowPaint);
        canvas.drawLine(Offset(cx - 15, cy + 18), Offset(cx + 5, cy + 18), glowPaint);
        canvas.drawLine(Offset(cx + 5, cy + 18), Offset(cx + 5, cy), glowPaint);
        canvas.drawLine(Offset(cx + 5, cy), Offset(cx + 22, cy), glowPaint);
        canvas.drawLine(Offset(cx + 22, cy), Offset(cx + 22, cy - 18), glowPaint);
        // Side Safety Handrails
        canvas.drawLine(Offset(cx - 30, cy + 20), Offset(cx + 5, cy - 35), accentPaint);
        canvas.drawLine(Offset(cx + 5, cy - 35), Offset(cx + 25, cy - 35), accentPaint);
        // Top Command Console
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 22, cy - 48), width: 28, height: 16), const Radius.circular(3)),
          padPaint,
        );
        break;

      case EquipmentVisualType.elliptical:
        // Base
        canvas.drawLine(Offset(cx - 75, cy + 48), Offset(cx + 75, cy + 48), framePaint);
        // Rear Wheel
        canvas.drawCircle(Offset(cx - 50, cy + 25), 20, glowPaint);
        // Dual Moving Arm Poles
        canvas.drawLine(Offset(cx - 20, cy + 20), Offset(cx + 20, cy - 40), accentPaint);
        canvas.drawLine(Offset(cx + 20, cy + 20), Offset(cx - 10, cy - 40), glowPaint);
        // Foot Pedals
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 20, cy + 28), width: 34, height: 10), const Radius.circular(3)),
          padPaint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 25, cy + 35), width: 34, height: 10), const Radius.circular(3)),
          padPaint,
        );
        // Upright Mast & Console
        canvas.drawLine(Offset(cx + 35, cy + 48), Offset(cx + 15, cy - 30), framePaint);
        canvas.drawCircle(Offset(cx + 15, cy - 32), 10, padPaint);
        break;

      case EquipmentVisualType.jumpRope:
        // Handles
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 55, cy - 5), width: 10, height: 35), const Radius.circular(4)),
          padPaint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 55, cy - 5), width: 10, height: 35), const Radius.circular(4)),
          padPaint,
        );
        // Handle Grips
        canvas.drawLine(Offset(cx - 55, cy - 15), Offset(cx - 55, cy + 5), accentPaint);
        canvas.drawLine(Offset(cx + 55, cy - 15), Offset(cx + 55, cy + 5), accentPaint);
        // Parabolic Speed Rope Arc
        final ropePath = Path();
        ropePath.moveTo(cx - 55, cy + 12);
        ropePath.quadraticBezierTo(cx, cy + 70, cx + 55, cy + 12);
        canvas.drawPath(ropePath, glowPaint);
        // Bearing Glow Nodes
        canvas.drawCircle(Offset(cx - 55, cy + 12), 4, accentPaint);
        canvas.drawCircle(Offset(cx + 55, cy + 12), 4, accentPaint);
        break;

      case EquipmentVisualType.legPress:
        canvas.drawLine(Offset(cx - 80, cy + 50), Offset(cx + 80, cy + 50), framePaint);
        canvas.drawLine(Offset(cx - 60, cy + 45), Offset(cx + 60, cy - 45), framePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 35, cy - 25), width: 34, height: 18), const Radius.circular(4)), padPaint);
        canvas.drawCircle(Offset(cx + 48, cy - 36), 14, glowPaint);
        canvas.drawCircle(Offset(cx + 56, cy - 42), 11, glowPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 35, cy + 25), width: 28, height: 12), const Radius.circular(3)), padPaint);
        canvas.drawLine(Offset(cx - 45, cy + 20), Offset(cx - 65, cy - 15), accentPaint);
        canvas.drawLine(Offset(cx - 30, cy + 30), Offset(cx - 20, cy + 15), glowPaint);
        break;

      case EquipmentVisualType.hackSquat:
        canvas.drawLine(Offset(cx - 70, cy + 50), Offset(cx + 70, cy + 50), framePaint);
        canvas.drawLine(Offset(cx - 40, cy + 45), Offset(cx + 50, cy - 50), framePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 45, cy + 35), width: 32, height: 10), const Radius.circular(3)), padPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 10, cy - 10), width: 26, height: 38), const Radius.circular(5)), padPaint);
        canvas.drawCircle(Offset(cx + 26, cy - 26), 15, glowPaint);
        break;

      case EquipmentVisualType.legExtension:
        canvas.drawLine(Offset(cx - 70, cy + 50), Offset(cx + 70, cy + 50), framePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 50, cy), width: 22, height: 75), const Radius.circular(4)), glowPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 10, cy + 15), width: 38, height: 12), const Radius.circular(4)), padPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 10, cy - 12), width: 12, height: 38), const Radius.circular(4)), padPaint);
        canvas.drawCircle(Offset(cx + 28, cy + 15), 6, accentPaint);
        canvas.drawLine(Offset(cx + 28, cy + 15), Offset(cx + 42, cy + 42), accentPaint);
        canvas.drawCircle(Offset(cx + 42, cy + 42), 8, padPaint);
        break;

      case EquipmentVisualType.legCurl:
        canvas.drawLine(Offset(cx - 75, cy + 50), Offset(cx + 75, cy + 50), framePaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 10, cy + 10), width: 65, height: 14), const Radius.circular(4)), padPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 55, cy - 5), width: 20, height: 70), const Radius.circular(4)), glowPaint);
        canvas.drawCircle(Offset(cx + 25, cy + 10), 6, accentPaint);
        canvas.drawLine(Offset(cx + 25, cy + 10), Offset(cx + 48, cy + 28), accentPaint);
        canvas.drawCircle(Offset(cx + 48, cy + 28), 9, padPaint);
        break;

      case EquipmentVisualType.peckDeck:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - 10), width: 28, height: 85), const Radius.circular(5)), glowPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 30), width: 26, height: 10), const Radius.circular(3)), padPaint);
        canvas.drawLine(Offset(cx - 20, cy - 35), Offset(cx - 45, cy + 5), accentPaint);
        canvas.drawLine(Offset(cx + 20, cy - 35), Offset(cx + 45, cy + 5), accentPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 45, cy - 10), width: 8, height: 26), const Radius.circular(3)), padPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 45, cy - 10), width: 8, height: 26), const Radius.circular(3)), padPaint);
        break;

      case EquipmentVisualType.cableCrossover:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 65, cy), width: 18, height: 85), const Radius.circular(4)), glowPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 65, cy), width: 18, height: 85), const Radius.circular(4)), glowPaint);
        canvas.drawLine(Offset(cx - 65, cy - 40), Offset(cx + 65, cy - 40), framePaint);
        canvas.drawLine(Offset(cx - 56, cy - 20), Offset(cx - 15, cy + 15), accentPaint);
        canvas.drawLine(Offset(cx + 56, cy - 20), Offset(cx + 15, cy + 15), accentPaint);
        canvas.drawCircle(Offset(cx - 15, cy + 15), 5, padPaint);
        canvas.drawCircle(Offset(cx + 15, cy + 15), 5, padPaint);
        break;

      case EquipmentVisualType.smithMachine:
        canvas.drawLine(Offset(cx - 50, cy + 50), Offset(cx - 50, cy - 45), framePaint);
        canvas.drawLine(Offset(cx + 50, cy + 50), Offset(cx + 50, cy - 45), framePaint);
        canvas.drawLine(Offset(cx - 55, cy - 45), Offset(cx + 55, cy - 45), framePaint);
        canvas.drawLine(Offset(cx - 68, cy - 5), Offset(cx + 68, cy - 5), accentPaint);
        canvas.drawCircle(Offset(cx - 58, cy - 5), 14, glowPaint);
        canvas.drawCircle(Offset(cx + 58, cy - 5), 14, glowPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 25), width: 34, height: 12), const Radius.circular(3)), padPaint);
        break;

      case EquipmentVisualType.latPulldown:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 45, cy), width: 22, height: 80), const Radius.circular(4)), glowPaint);
        canvas.drawLine(Offset(cx - 45, cy - 40), Offset(cx + 15, cy - 40), framePaint);
        canvas.drawLine(Offset(cx + 15, cy - 40), Offset(cx + 15, cy - 15), accentPaint);
        canvas.drawLine(Offset(cx - 20, cy - 15), Offset(cx + 50, cy - 15), glowPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 15, cy + 25), width: 28, height: 10), const Radius.circular(3)), padPaint);
        canvas.drawCircle(Offset(cx + 15, cy + 8), 7, padPaint);
        break;

      case EquipmentVisualType.seatedCableRow:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 55, cy), width: 22, height: 75), const Radius.circular(4)), glowPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 10, cy + 22), width: 45, height: 10), const Radius.circular(3)), padPaint);
        canvas.drawLine(Offset(cx - 44, cy + 15), Offset(cx - 10, cy + 8), accentPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 30, cy + 22), width: 8, height: 18), const Radius.circular(2)), framePaint);
        break;

      case EquipmentVisualType.barbellRack:
        canvas.drawLine(Offset(cx - 40, cy + 48), Offset(cx - 40, cy - 35), framePaint);
        canvas.drawLine(Offset(cx + 40, cy + 48), Offset(cx + 40, cy - 35), framePaint);
        canvas.drawLine(Offset(cx - 65, cy - 15), Offset(cx + 65, cy - 15), accentPaint);
        canvas.drawCircle(Offset(cx - 52, cy - 15), 18, glowPaint);
        canvas.drawCircle(Offset(cx + 52, cy - 15), 18, glowPaint);
        break;

      case EquipmentVisualType.pullupStation:
        canvas.drawLine(Offset(cx - 45, cy + 50), Offset(cx - 45, cy - 45), framePaint);
        canvas.drawLine(Offset(cx + 45, cy + 50), Offset(cx + 45, cy - 45), framePaint);
        canvas.drawLine(Offset(cx - 55, cy - 40), Offset(cx + 55, cy - 40), accentPaint);
        canvas.drawLine(Offset(cx - 30, cy - 40), Offset(cx - 15, cy - 25), glowPaint);
        canvas.drawLine(Offset(cx + 30, cy - 40), Offset(cx + 15, cy - 25), glowPaint);
        break;

      case EquipmentVisualType.bodyweightMat:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 30), width: 110, height: 14), const Radius.circular(4)), padPaint);
        canvas.drawLine(Offset(cx - 40, cy + 10), Offset(cx + 40, cy + 10), accentPaint);
        canvas.drawCircle(Offset(cx + 45, cy + 5), 7, glowPaint);
        break;

      case EquipmentVisualType.benchAndDumbbells:
      default:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 10, cy + 22), width: 35, height: 10), const Radius.circular(3)), padPaint);
        canvas.drawLine(Offset(cx - 18, cy + 18), Offset(cx - 42, cy - 12), padPaint..strokeWidth = 10);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 32, cy - 5), width: 10, height: 26), const Radius.circular(2)), glowPaint);
        canvas.drawLine(Offset(cx + 32, cy - 5), Offset(cx + 52, cy - 5), accentPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + 52, cy - 5), width: 10, height: 26), const Radius.circular(2)), glowPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _EquipmentSchematicPainter oldDelegate) => oldDelegate.type != type;
}
