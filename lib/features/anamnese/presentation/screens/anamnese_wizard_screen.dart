import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../../../core/providers/app_providers.dart';
import '../../domain/models/anamnese_model.dart';
import '../widgets/pain_map_selector.dart';

class AnamneseWizardScreen extends ConsumerStatefulWidget {
  const AnamneseWizardScreen({super.key});

  @override
  ConsumerState<AnamneseWizardScreen> createState() => _AnamneseWizardScreenState();
}

class _AnamneseWizardScreenState extends ConsumerState<AnamneseWizardScreen> {
  int _currentStep = 0;
  bool _isGenerating = false;

  // Controllers & Form State
  late TextEditingController _nameCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _heightCtrl;

  String _gender = 'male';
  ExperienceLevel _experience = ExperienceLevel.intermediate;
  String _goal = 'hypertrophy';
  int _daysPerWeek = 4;
  int _minutesPerSession = 60;
  WorkoutLocation _location = WorkoutLocation.commercialGym;
  List<String> _jointPains = ['Ombro'];
  List<String> _preferredMuscles = ['Peitoral', 'Braços'];
  WorkoutSplitStyle _splitStyle = WorkoutSplitStyle.adaptive;
  String _preferredCardio = 'Esteira Inclinada';

  @override
  void initState() {
    super.initState();
    final initial = ref.read(anamneseProvider);
    _nameCtrl = TextEditingController(text: initial.name);
    _ageCtrl = TextEditingController(text: initial.age > 0 ? initial.age.toString() : '');
    _weightCtrl = TextEditingController(text: initial.weightKg > 0 ? initial.weightKg.toString() : '');
    _heightCtrl = TextEditingController(text: initial.heightCm > 0 ? initial.heightCm.toInt().toString() : '');
    _gender = initial.gender;
    _experience = initial.experienceLevel;
    _goal = initial.primaryGoal;
    _daysPerWeek = initial.daysPerWeek;
    _minutesPerSession = initial.availableMinutesPerSession;
    _location = initial.location;
    _jointPains = List.from(initial.jointPains);
    _preferredMuscles = List.from(initial.preferredMuscles);
    _splitStyle = initial.splitStyle;
    _preferredCardio = initial.preferredCardio ?? 'Esteira Inclinada';
  }

  void _fillSampleData() {
    setState(() {
      _nameCtrl.text = 'Alexandre Silva';
      _ageCtrl.text = '28';
      _weightCtrl.text = '78.5';
      _heightCtrl.text = '178';
      _gender = 'male';
      _experience = ExperienceLevel.intermediate;
      _goal = 'hypertrophy';
      _daysPerWeek = 4;
      _minutesPerSession = 60;
      _location = WorkoutLocation.commercialGym;
      _jointPains = ['Ombro'];
      _preferredMuscles = ['Peitoral', 'Braços'];
      _splitStyle = WorkoutSplitStyle.agonistAntagonist;
      _preferredCardio = 'Esteira Inclinada';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚡ Dados de teste preenchidos no formulário!'),
        backgroundColor: AppColors.neonLime,
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      final age = int.tryParse(_ageCtrl.text) ?? 0;
      final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? 0;
      final height = double.tryParse(_heightCtrl.text.replaceAll(',', '.')) ?? 0;

      if (age <= 0 || weight <= 0 || height <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, informe Idade, Peso e Altura válidos para continuar.'),
            backgroundColor: AppColors.alertRed,
          ),
        );
        return;
      }
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _saveAndGenerate();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _saveAndGenerate() async {
    setState(() => _isGenerating = true);

    final model = AnamneseModel(
      id: 'anamnese_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim().isEmpty ? 'Atleta' : _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text) ?? 25,
      weightKg: double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? 75.0,
      heightCm: double.tryParse(_heightCtrl.text.replaceAll(',', '.')) ?? 175.0,
      gender: _gender,
      experienceLevel: _experience,
      primaryGoal: _goal,
      daysPerWeek: _daysPerWeek,
      availableMinutesPerSession: _minutesPerSession,
      location: _location,
      jointPains: _jointPains,
      preferredMuscles: _preferredMuscles,
      splitStyle: _splitStyle,
      preferredCardio: _preferredCardio,
    );

    ref.read(anamneseProvider.notifier).updateAnamnese(model);
    await ref.read(workoutPlanProvider.notifier).generateNewPlan(model);

    if (mounted) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚡ Treino hiperpersonalizado gerado com sucesso!'),
          backgroundColor: AppColors.neonLime,
        ),
      );
      context.go('/workout-plan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.neonLime, size: 22),
            const SizedBox(width: 8),
            Text('Anamnese Guiada IA', style: AppTextStyles.heading2),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: AppColors.pulseOrange, size: 20),
            tooltip: 'Preencher Dados de Teste',
            onPressed: _fillSampleData,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Etapa ${_currentStep + 1} de 4',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.neonLime, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de Progresso Superior
            LinearProgressIndicator(
              value: (_currentStep + 1) / 4,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonLime),
              minHeight: 4,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStepContent(),
              ),
            ),
            // Barra de Ação Inferior
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: const Border(top: BorderSide(color: AppColors.cardBorder)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      flex: 1,
                      child: NeonButton(
                        text: 'Voltar',
                        onPressed: _prevStep,
                        isOutlined: true,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: NeonButton(
                      text: _currentStep == 3 ? 'Gerar Treino com IA' : 'Avançar',
                      icon: _currentStep == 3 ? Icons.auto_awesome : Icons.arrow_forward,
                      isLoading: _isGenerating,
                      onPressed: _nextStep,
                      height: 50,
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

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Profile();
      case 1:
        return _buildStep2Goals();
      case 2:
        return _buildStep3Routine();
      case 3:
        return _buildStep4Restrictions();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1Profile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dados Antropométricos', style: AppTextStyles.heading2),
        const SizedBox(height: 6),
        Text('Essas métricas são utilizadas no cálculo de volume e TDEE metabólico.', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 24),
        GlassCard(
          child: Column(
            children: [
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Seu Nome',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.neonLime),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ageCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Idade',
                        suffixText: 'anos',
                        prefixIcon: Icon(Icons.cake_outlined, color: AppColors.electricCyan),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(
                        labelText: 'Gênero',
                        prefixIcon: Icon(Icons.wc, color: AppColors.electricCyan),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Masculino')),
                        DropdownMenuItem(value: 'female', child: Text('Feminino')),
                      ],
                      onChanged: (v) => setState(() => _gender = v ?? 'male'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Peso Atual',
                        suffixText: 'kg',
                        prefixIcon: Icon(Icons.monitor_weight_outlined, color: AppColors.neonLime),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _heightCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Altura',
                        suffixText: 'cm',
                        prefixIcon: Icon(Icons.height, color: AppColors.neonLime),
                      ),
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

  Widget _buildStep2Goals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Objetivo & Experiência', style: AppTextStyles.heading2),
        const SizedBox(height: 6),
        Text('O FitMorph AI ajusta o volume e faixas de RIR/RPE com base no seu nível.', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 20),
        Text('Qual o seu objetivo principal?', style: AppTextStyles.labelBold),
        const SizedBox(height: 12),
        _buildSelectableCard(
          title: 'Hipertrofia Muscular (Ganho de Massa)',
          subtitle: 'Foco em tensão mecânica e volume ótimo de 12-20 séries por grupo/semana.',
          icon: Icons.fitness_center,
          isSelected: _goal == 'hypertrophy',
          onTap: () => setState(() => _goal = 'hypertrophy'),
        ),
        const SizedBox(height: 10),
        _buildSelectableCard(
          title: 'Definição & Perda de Gordura (Cutting)',
          subtitle: 'Preservação máxima de massa magra com alta densidade de treino.',
          icon: Icons.local_fire_department_outlined,
          isSelected: _goal == 'fatLoss',
          onTap: () => setState(() => _goal = 'fatLoss'),
        ),
        const SizedBox(height: 10),
        _buildSelectableCard(
          title: 'Recomposição Corporal',
          subtitle: 'Ganho concomitante de massa muscular e queima de gordura para iniciantes/retorno.',
          icon: Icons.sync_alt,
          isSelected: _goal == 'recomposition',
          onTap: () => setState(() => _goal = 'recomposition'),
        ),
        const SizedBox(height: 24),
        Text('Nível de Experiência na Musculação:', style: AppTextStyles.labelBold),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildExperienceChip(
                label: 'Iniciante\n(< 1 ano)',
                level: ExperienceLevel.beginner,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildExperienceChip(
                label: 'Intermediário\n(1-3 anos)',
                level: ExperienceLevel.intermediate,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildExperienceChip(
                label: 'Avançado\n(> 3 anos)',
                level: ExperienceLevel.advanced,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3Routine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Disponibilidade & Rotina', style: AppTextStyles.heading2),
        const SizedBox(height: 6),
        Text('Ajustamos a divisão (Split) e volume de tempo sem desperdício.', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 24),
        Text('Quantos dias você treinará por semana?', style: AppTextStyles.labelBold),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Frequência:', style: AppTextStyles.bodyMedium),
                  Text('$_daysPerWeek dias / semana', style: AppTextStyles.labelBold.copyWith(color: AppColors.neonLime)),
                ],
              ),
              Slider(
                value: _daysPerWeek.toDouble(),
                min: 2,
                max: 6,
                divisions: 4,
                activeColor: AppColors.neonLime,
                inactiveColor: AppColors.surfaceLight,
                onChanged: (val) => setState(() => _daysPerWeek = val.round()),
              ),
              Text(
                _daysPerWeek <= 3 ? 'Divisão recomendada: Full Body' : _daysPerWeek == 4 ? 'Divisão recomendada: Upper / Lower' : 'Divisão recomendada: Push / Pull / Legs',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Tempo disponível por sessão:', style: AppTextStyles.labelBold),
        const SizedBox(height: 12),
        Row(
          children: [30, 45, 60, 90].map((mins) {
            final isSel = _minutesPerSession == mins;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => setState(() => _minutesPerSession = mins),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.neonLime.withOpacity(0.2) : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSel ? AppColors.neonLime : AppColors.cardBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$mins min',
                        style: AppTextStyles.labelBold.copyWith(
                          color: isSel ? AppColors.neonLime : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text('Local de Treino:', style: AppTextStyles.labelBold),
        const SizedBox(height: 12),
        _buildSelectableCard(
          title: 'Academia Comercial Completa',
          subtitle: 'Acesso a máquinas guiadas, polias/cabos, halteres e barras.',
          icon: Icons.domain,
          isSelected: _location == WorkoutLocation.commercialGym,
          onTap: () => setState(() => _location = WorkoutLocation.commercialGym),
        ),
        const SizedBox(height: 10),
        _buildSelectableCard(
          title: 'Treino em Casa / Halteres (Home Gym)',
          subtitle: 'Treinos 100% focados em halteres, banco, degrau e chão (Zero máquinas).',
          icon: Icons.home_work_outlined,
          isSelected: _location == WorkoutLocation.homeGym,
          onTap: () => setState(() => _location = WorkoutLocation.homeGym),
        ),
        const SizedBox(height: 10),
        _buildSelectableCard(
          title: 'Calistenia / Peso do Corpo',
          subtitle: 'Treinos 100% livres sem equipamentos (Flexões, barra fixa, agachamentos livres).',
          icon: Icons.accessibility_new,
          isSelected: _location == WorkoutLocation.bodyweightOnly,
          onTap: () => setState(() => _location = WorkoutLocation.bodyweightOnly),
        ),
        const SizedBox(height: 24),
        Text('Preferência de Exercício Aeróbico / Cardio:', style: AppTextStyles.labelBold),
        const SizedBox(height: 6),
        Text('A IA integrará a meta cardiovascular com a periodização de hipertrofia.', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Esteira Inclinada',
            'Simulador de Escada',
            'Bicicleta Ergométrica',
            'Pular Corda',
            'Caminhada ao Ar Livre',
          ].map((cardio) {
            final isSel = _preferredCardio == cardio;
            return ChoiceChip(
              label: Text(cardio),
              selected: isSel,
              selectedColor: AppColors.pulseOrange.withOpacity(0.25),
              labelStyle: TextStyle(
                color: isSel ? AppColors.pulseOrange : AppColors.textSecondary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppColors.surfaceLight,
              side: BorderSide(
                color: isSel ? AppColors.pulseOrange : AppColors.cardBorder,
                width: isSel ? 1.5 : 1.0,
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() => _preferredCardio = cardio);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep4Restrictions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Biomecânica & Foco Muscular', style: AppTextStyles.heading2),
        const SizedBox(height: 6),
        Text('A IA excluirá exercícios perigosos para suas articulações e priorizará seus pontos fracos.', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 24),
        PainMapSelector(
          selectedPains: _jointPains,
          onChanged: (pains) => setState(() => _jointPains = pains),
        ),
        const SizedBox(height: 28),
        Text('Músculos com Prioridade de Foco:', style: AppTextStyles.labelBold),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Peitoral', 'Costas / Dorsal', 'Ombros / Deltóide', 'Braços (Bíceps/Tríceps)', 'Glúteos', 'Quadríceps', 'Panturrilhas'].map((muscle) {
            final isSel = _preferredMuscles.contains(muscle);
            return FilterChip(
              label: Text(muscle),
              selected: isSel,
              selectedColor: AppColors.electricCyan.withOpacity(0.25),
              checkmarkColor: AppColors.electricCyan,
              labelStyle: TextStyle(
                color: isSel ? AppColors.electricCyan : AppColors.textSecondary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppColors.surfaceLight,
              side: BorderSide(
                color: isSel ? AppColors.electricCyan : AppColors.cardBorder,
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _preferredMuscles.add(muscle);
                  } else {
                    _preferredMuscles.remove(muscle);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Icon(Icons.hub, color: AppColors.neonLime, size: 20),
            const SizedBox(width: 8),
            Text('Divisão & Treino Multi-Músculo:', style: AppTextStyles.labelBold),
          ],
        ),
        const SizedBox(height: 6),
        Text('Escolha como deseja agrupar e focar em múltiplos músculos por sessão:', style: AppTextStyles.bodySmall),
        const SizedBox(height: 14),
        ...WorkoutSplitStyle.values.map((style) {
          final isSel = _splitStyle == style;
          IconData iconData;
          switch (style) {
            case WorkoutSplitStyle.agonistAntagonist:
              iconData = Icons.compare_arrows;
              break;
            case WorkoutSplitStyle.pushPullLegs:
              iconData = Icons.fitness_center;
              break;
            case WorkoutSplitStyle.upperLower:
              iconData = Icons.vertical_align_center;
              break;
            case WorkoutSplitStyle.fullBody:
              iconData = Icons.all_inclusive;
              break;
            case WorkoutSplitStyle.aestheticSpecialization:
              iconData = Icons.auto_awesome;
              break;
            case WorkoutSplitStyle.adaptive:
              iconData = Icons.psychology;
              break;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: GlassCard(
              onTap: () => setState(() => _splitStyle = style),
              borderColor: isSel ? AppColors.neonLime : AppColors.cardBorder,
              backgroundColor: isSel ? AppColors.neonLime.withOpacity(0.08) : null,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.neonLime.withOpacity(0.2) : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(iconData, color: isSel ? AppColors.neonLime : AppColors.textMuted, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          style.displayName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSel ? AppColors.neonLime : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          style.description,
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (isSel)
                    const Icon(Icons.check_circle, color: AppColors.neonLime, size: 20),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSelectableCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      borderColor: isSelected ? AppColors.neonLime : AppColors.cardBorder,
      backgroundColor: isSelected ? AppColors.neonLime.withOpacity(0.08) : null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.neonLime.withOpacity(0.2) : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isSelected ? AppColors.neonLime : AppColors.textMuted, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle, color: AppColors.neonLime, size: 20),
        ],
      ),
    );
  }

  Widget _buildExperienceChip({required String label, required ExperienceLevel level}) {
    final isSel = _experience == level;
    return InkWell(
      onTap: () => setState(() => _experience = level),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSel ? AppColors.neonLime.withOpacity(0.15) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSel ? AppColors.neonLime : AppColors.cardBorder,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSel ? AppColors.neonLime : AppColors.textSecondary,
              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
