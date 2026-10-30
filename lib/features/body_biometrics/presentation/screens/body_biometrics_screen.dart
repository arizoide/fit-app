import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/widgets/muscle_tag.dart';
import 'package:fitmorph_ai/core/network/gemini_service.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/body_biometrics/domain/models/biometrics_model.dart';
import 'package:fitmorph_ai/features/body_biometrics/presentation/widgets/before_after_slider.dart';
import 'package:fitmorph_ai/features/body_biometrics/presentation/widgets/photo_guidelines_widget.dart';

class BodyBiometricsScreen extends ConsumerStatefulWidget {
  const BodyBiometricsScreen({super.key});

  @override
  ConsumerState<BodyBiometricsScreen> createState() => _BodyBiometricsScreenState();
}

class _BodyBiometricsScreenState extends ConsumerState<BodyBiometricsScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  BodyScanResult? _latestScanResult;

  // Measurement inputs
  final _weightCtrl = TextEditingController(text: '78.5');
  final _waistCtrl = TextEditingController(text: '80.0');
  final _chestCtrl = TextEditingController(text: '103.0');
  final _armCtrl = TextEditingController(text: '38.0');

  @override
  void initState() {
    super.initState();
    // Default sample scan result
    _latestScanResult = const BodyScanResult(
      estimatedBodyFat: 14.8,
      bodyFatRange: '14.0% - 15.5%',
      somatotype: 'Mesomorfo Predominante',
      strongMuscles: ['Deltóides', 'Peitoral', 'Tríceps'],
      lagMuscles: ['Dorsal Inferior', 'Panturrilhas'],
      postureNotes: 'Boa simetria clavicular com postura dorsal alinhada.',
      aiFeedback: 'Base excelente para ganhos limpos. Recomenda-se manter superávit calórico controlado (+250 kcal).',
    );
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _waistCtrl.dispose();
    _chestCtrl.dispose();
    _armCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndAnalyzePhoto() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null) return;

      setState(() => _isAnalyzing = true);

      final bytes = await image.readAsBytes();
      final result = await GeminiService.analyzeBodyPhotos(photoBytesList: [bytes]);

      setState(() {
        _latestScanResult = result;
        _isAnalyzing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✨ Biometria visual analisada com sucesso pelo Gemini Vision!'),
            backgroundColor: AppColors.neonLime,
          ),
        );
      }
    } catch (e) {
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao analisar foto: $e'),
            backgroundColor: AppColors.alertRed,
          ),
        );
      }
    }
  }

  void _saveMeasurement() {
    final weight = double.tryParse(_weightCtrl.text) ?? 78.5;
    final waist = double.tryParse(_waistCtrl.text);
    final chest = double.tryParse(_chestCtrl.text);
    final arm = double.tryParse(_armCtrl.text);

    final entry = BiometricEntry(
      id: 'bio_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      weightKg: weight,
      bodyFatPercentage: _latestScanResult?.estimatedBodyFat ?? 15.0,
      waistCm: waist,
      chestCm: chest,
      armCm: arm,
      notes: 'Registro manual de evolução física.',
    );

    ref.read(biometricsProvider.notifier).addEntry(entry);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medição corporal registrada no histórico!'),
        backgroundColor: AppColors.neonLime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(biometricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.remove_red_eye_outlined, color: AppColors.neonLime),
            const SizedBox(width: 8),
            Text('Biometria Visual IA', style: AppTextStyles.heading2),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.electricCyan),
            tooltip: 'Guia de Fotos',
            onPressed: () => PhotoGuidelinesWidget.showModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Privacy Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.electricCyan.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, color: AppColors.electricCyan, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('100% Opcional & Privacidade Blindada', style: AppTextStyles.labelBold.copyWith(fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(
                          'Suas fotos são privadas, criptografadas e utilizadas exclusivamente para comparação pessoal.',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // AI Scan Section Card
            GlassCard(
              borderColor: AppColors.neonLime.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Análise Corporal por Foto', style: AppTextStyles.heading3),
                      const Icon(Icons.auto_awesome, color: AppColors.neonLime, size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Envie fotos (frente/costas) para estimativa de % de gordura, somatotipo e simetria muscular.',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  NeonButton(
                    text: 'Escanear Foto com IA',
                    icon: Icons.camera_alt_outlined,
                    isLoading: _isAnalyzing,
                    onPressed: _pickAndAnalyzePhoto,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Visual Photo Guidelines & Examples Card
            const PhotoGuidelinesWidget(isCompact: false),
            const SizedBox(height: 28),

            // Result Display if Available
            if (_latestScanResult != null) ...[
              Text('Composição Corporal Estimada', style: AppTextStyles.labelBold),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gordura Corporal (%BF)', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 6),
                          Text(
                            '${_latestScanResult!.estimatedBodyFat}%',
                            style: AppTextStyles.heading1.copyWith(color: AppColors.neonLime),
                          ),
                          Text(
                            'Faixa: ${_latestScanResult!.bodyFatRange}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Biotipo / Somatotipo', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 6),
                          Text(
                            _latestScanResult!.somatotype.split(' ').first,
                            style: AppTextStyles.heading2.copyWith(color: AppColors.electricCyan),
                          ),
                          Text(
                            _latestScanResult!.somatotype,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Músculos com Destaque Simétrico:', style: AppTextStyles.labelBold),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _latestScanResult!.strongMuscles.map((m) => MuscleTag(muscleName: m)).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text('Sugestão de Foco na Periodização:', style: AppTextStyles.labelBold),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _latestScanResult!.lagMuscles.map((m) => MuscleTag(muscleName: m, isSecondary: true)).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text('Parecer Biomecânico:', style: AppTextStyles.labelBold),
                    const SizedBox(height: 4),
                    Text(_latestScanResult!.aiFeedback, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Before / After Slider Interactive Demo
            Text('Comparador Antes e Depois', style: AppTextStyles.labelBold),
            const SizedBox(height: 6),
            Text('Arraste a barra para visualizar a evolução física lado a lado:', style: AppTextStyles.bodySmall),
            const SizedBox(height: 12),
            BeforeAfterSlider(
              beforeLabel: '30 Dias Atrás (17.5% BF)',
              afterLabel: 'Atual (14.8% BF)',
              beforeWidget: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.accessibility_new, size: 72, color: AppColors.textMuted),
                      SizedBox(height: 8),
                      Text('Foto Anterior (81 kg • 17.5% BF)', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              afterWidget: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D324D), Color(0xFF7F5A83)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center, size: 72, color: AppColors.neonLime),
                      SizedBox(height: 8),
                      Text('Foto Atual (78.5 kg • 14.8% BF)', style: TextStyle(color: AppColors.neonLime, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Manual Anthropometric Log Form
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Registro Manual de Medidas (cm)', style: AppTextStyles.labelBold),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Peso (kg)'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _waistCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Cintura (cm)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chestCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Peitoral (cm)'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _armCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Braço (cm)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  NeonButton(
                    text: 'Salvar Medidas de Hoje',
                    onPressed: _saveMeasurement,
                    isOutlined: true,
                    height: 44,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // History Log List
            Text('Histórico de Avaliações', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            ...history.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.date.day.toString().padLeft(2, '0')}/${entry.date.month.toString().padLeft(2, '0')}/${entry.date.year}',
                            style: AppTextStyles.labelBold.copyWith(color: AppColors.electricCyan),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${entry.weightKg} kg • Cintura: ${entry.waistCm ?? '-'} cm • Braço: ${entry.armCm ?? '-'} cm',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      if (entry.bodyFatPercentage != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.neonLime.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${entry.bodyFatPercentage}% BF',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.neonLime, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Legal Disclaimer
            if (_latestScanResult != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _latestScanResult!.legalDisclaimer,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
