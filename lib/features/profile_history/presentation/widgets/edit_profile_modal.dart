import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';

class EditProfileModal extends StatefulWidget {
  final AnamneseModel currentAnamnese;
  final WidgetRef ref;

  const EditProfileModal({
    super.key,
    required this.currentAnamnese,
    required this.ref,
  });

  static Future<void> show(BuildContext context, WidgetRef ref, AnamneseModel currentAnamnese) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileModal(
        currentAnamnese: currentAnamnese,
        ref: ref,
      ),
    );
  }

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  late TextEditingController _nameCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _heightCtrl;

  late String _gender;
  late ExperienceLevel _experience;
  late String _goal;
  late int _daysPerWeek;
  late int _minutesPerSession;
  late WorkoutLocation _location;
  late String _preferredCardio;
  late List<String> _jointPains;
  late List<String> _preferredMuscles;
  late WorkoutSplitStyle _splitStyle;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final a = widget.currentAnamnese;
    _nameCtrl = TextEditingController(text: a.name);
    _ageCtrl = TextEditingController(text: a.age > 0 ? a.age.toString() : '25');
    _weightCtrl = TextEditingController(text: a.weightKg > 0 ? a.weightKg.toString() : '75');
    _heightCtrl = TextEditingController(text: a.heightCm > 0 ? a.heightCm.toInt().toString() : '175');
    _gender = a.gender;
    _experience = a.experienceLevel;
    _goal = a.primaryGoal;
    _daysPerWeek = a.daysPerWeek;
    _minutesPerSession = a.availableMinutesPerSession;
    _location = a.location;
    _preferredCardio = a.preferredCardio ?? 'Esteira Inclinada';
    _jointPains = List.from(a.jointPains);
    _preferredMuscles = List.from(a.preferredMuscles);
    _splitStyle = a.splitStyle;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveAndRegeneratePlan() async {
    setState(() => _isSaving = true);

    final age = int.tryParse(_ageCtrl.text) ?? widget.currentAnamnese.age;
    final weight = double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? widget.currentAnamnese.weightKg;
    final height = double.tryParse(_heightCtrl.text.replaceAll(',', '.')) ?? widget.currentAnamnese.heightCm;

    final updated = widget.currentAnamnese.copyWith(
      name: _nameCtrl.text.trim().isEmpty ? 'Atleta' : _nameCtrl.text.trim(),
      age: age > 0 ? age : 25,
      weightKg: weight > 0 ? weight : 75.0,
      heightCm: height > 0 ? height : 175.0,
      gender: _gender,
      experienceLevel: _experience,
      primaryGoal: _goal,
      daysPerWeek: _daysPerWeek,
      availableMinutesPerSession: _minutesPerSession,
      location: _location,
      preferredCardio: _preferredCardio,
      jointPains: _jointPains,
      preferredMuscles: _preferredMuscles,
      splitStyle: _splitStyle,
    );

    widget.ref.read(anamneseProvider.notifier).updateAnamnese(updated);
    await widget.ref.read(workoutPlanProvider.notifier).generateNewPlan(updated);

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚡ Perfil salvo! Ficha de treino atualizada e adaptada automaticamente.'),
          backgroundColor: AppColors.neonLime,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.neonLime, width: 2)),
      ),
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit_note, color: AppColors.neonLime, size: 24),
                    const SizedBox(width: 8),
                    Text('Editar Perfil & Metas', style: AppTextStyles.heading2.copyWith(fontSize: 18)),
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

          // Content Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Metrics
                  Text('Dados Antropométricos', style: AppTextStyles.labelBold),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nome do Aluno',
                            prefixIcon: Icon(Icons.person_outline, color: AppColors.neonLime),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _ageCtrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Idade',
                                  suffixText: 'anos',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _gender,
                                decoration: const InputDecoration(labelText: 'Gênero'),
                                items: const [
                                  DropdownMenuItem(value: 'male', child: Text('Masculino')),
                                  DropdownMenuItem(value: 'female', child: Text('Feminino')),
                                ],
                                onChanged: (v) => setState(() => _gender = v ?? 'male'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _weightCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Peso',
                                  suffixText: 'kg',
                                  prefixIcon: Icon(Icons.monitor_weight_outlined, color: AppColors.neonLime),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
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
                  const SizedBox(height: 20),

                  // Goal & Experience
                  Text('Objetivo de Treino', style: AppTextStyles.labelBold),
                  const SizedBox(height: 10),
                  _buildGoalSelector(),
                  const SizedBox(height: 20),

                  Text('Nível de Experiência:', style: AppTextStyles.labelBold),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildChipExp('Iniciante', ExperienceLevel.beginner),
                      const SizedBox(width: 8),
                      _buildChipExp('Intermediário', ExperienceLevel.intermediate),
                      const SizedBox(width: 8),
                      _buildChipExp('Avançado', ExperienceLevel.advanced),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Frequency & Location
                  Text('Frequência Semanal: $_daysPerWeek dias / semana', style: AppTextStyles.labelBold),
                  Slider(
                    value: _daysPerWeek.toDouble(),
                    min: 2,
                    max: 6,
                    divisions: 4,
                    activeColor: AppColors.neonLime,
                    inactiveColor: AppColors.surfaceLight,
                    onChanged: (val) => setState(() => _daysPerWeek = val.round()),
                  ),
                  const SizedBox(height: 12),

                  Text('Duração por Sessão:', style: AppTextStyles.labelBold),
                  const SizedBox(height: 8),
                  Row(
                    children: [30, 45, 60, 90].map((mins) {
                      final isSel = _minutesPerSession == mins;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text('$mins min'),
                            selected: isSel,
                            selectedColor: AppColors.neonLime.withOpacity(0.2),
                            side: BorderSide(color: isSel ? AppColors.neonLime : AppColors.cardBorder),
                            labelStyle: TextStyle(
                              color: isSel ? AppColors.neonLime : AppColors.textSecondary,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            ),
                            backgroundColor: AppColors.surfaceLight,
                            onSelected: (sel) {
                              if (sel) setState(() => _minutesPerSession = mins);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Location
                  Text('Ambiente de Treino:', style: AppTextStyles.labelBold),
                  const SizedBox(height: 10),
                  _buildLocationOption('Academia Comercial', Icons.domain, WorkoutLocation.commercialGym),
                  const SizedBox(height: 6),
                  _buildLocationOption('Treino em Casa (Halteres/Banco)', Icons.home_work_outlined, WorkoutLocation.homeGym),
                  const SizedBox(height: 6),
                  _buildLocationOption('Calistenia (100% Peso Corporal)', Icons.accessibility_new, WorkoutLocation.bodyweightOnly),
                  const SizedBox(height: 20),

                  // Cardio Preference
                  Text('Modalidade Preferida de Cardio:', style: AppTextStyles.labelBold),
                  const SizedBox(height: 10),
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
                        side: BorderSide(
                          color: isSel ? AppColors.pulseOrange : AppColors.cardBorder,
                          width: isSel ? 1.5 : 1.0,
                        ),
                        labelStyle: TextStyle(
                          color: isSel ? AppColors.pulseOrange : AppColors.textSecondary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: AppColors.surfaceLight,
                        onSelected: (sel) {
                          if (sel) setState(() => _preferredCardio = cardio);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Joint Restrictions
                  Text('Dores ou Restrições Articulares:', style: AppTextStyles.labelBold),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Ombro', 'Joelho', 'Lombar', 'Cotovelo', 'Punho'].map((pain) {
                      final isSel = _jointPains.contains(pain);
                      return FilterChip(
                        label: Text(pain),
                        selected: isSel,
                        selectedColor: AppColors.alertRed.withOpacity(0.25),
                        checkmarkColor: AppColors.alertRed,
                        side: BorderSide(color: isSel ? AppColors.alertRed : AppColors.cardBorder),
                        labelStyle: TextStyle(
                          color: isSel ? AppColors.alertRed : AppColors.textSecondary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: AppColors.surfaceLight,
                        onSelected: (sel) {
                          setState(() {
                            if (sel) {
                              _jointPains.add(pain);
                            } else {
                              _jointPains.remove(pain);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Multi-Muscle Split Style
                  Row(
                    children: [
                      const Icon(Icons.hub, color: AppColors.neonLime, size: 20),
                      const SizedBox(width: 8),
                      Text('Divisão & Treino Multi-Músculo:', style: AppTextStyles.labelBold),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Como você prefere agrupar mais de um músculo por treino:', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 10),
                  ...WorkoutSplitStyle.values.map((style) {
                    final isSel = _splitStyle == style;
                    return InkWell(
                      onTap: () => setState(() => _splitStyle = style),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.neonLime.withOpacity(0.12) : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSel ? AppColors.neonLime : AppColors.cardBorder,
                            width: isSel ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    style.displayName,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                      color: isSel ? AppColors.neonLime : AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    style.description,
                                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            if (isSel) const Icon(Icons.check_circle, color: AppColors.neonLime, size: 18),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.cardBorder)),
            ),
            child: NeonButton(
              text: 'Salvar & Recalcular Ficha com IA',
              icon: Icons.auto_awesome,
              isLoading: _isSaving,
              onPressed: _saveAndRegeneratePlan,
              height: 52,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSelector() {
    return Column(
      children: [
        _buildGoalItem('Hipertrofia Muscular (Ganho de Massa)', 'hypertrophy', Icons.fitness_center),
        const SizedBox(height: 6),
        _buildGoalItem('Definição & Perda de Gordura (Cutting)', 'fatLoss', Icons.local_fire_department_outlined),
        const SizedBox(height: 6),
        _buildGoalItem('Recomposição Corporal', 'recomposition', Icons.sync_alt),
      ],
    );
  }

  Widget _buildGoalItem(String title, String value, IconData icon) {
    final isSel = _goal == value;
    return InkWell(
      onTap: () => setState(() => _goal = value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSel ? AppColors.neonLime.withOpacity(0.12) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSel ? AppColors.neonLime : AppColors.cardBorder, width: isSel ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSel ? AppColors.neonLime : AppColors.textMuted, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                  color: isSel ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
            if (isSel) const Icon(Icons.check_circle, color: AppColors.neonLime, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildChipExp(String label, ExperienceLevel level) {
    final isSel = _experience == level;
    return Expanded(
      child: ChoiceChip(
        label: Text(label, textAlign: TextAlign.center),
        selected: isSel,
        selectedColor: AppColors.electricCyan.withOpacity(0.2),
        side: BorderSide(color: isSel ? AppColors.electricCyan : AppColors.cardBorder),
        labelStyle: TextStyle(
          color: isSel ? AppColors.electricCyan : AppColors.textSecondary,
          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
          fontSize: 11,
        ),
        backgroundColor: AppColors.surfaceLight,
        onSelected: (sel) {
          if (sel) setState(() => _experience = level);
        },
      ),
    );
  }

  Widget _buildLocationOption(String title, IconData icon, WorkoutLocation loc) {
    final isSel = _location == loc;
    return InkWell(
      onTap: () => setState(() => _location = loc),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSel ? AppColors.neonLime.withOpacity(0.12) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSel ? AppColors.neonLime : AppColors.cardBorder, width: isSel ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSel ? AppColors.neonLime : AppColors.textMuted, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                  color: isSel ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ),
            if (isSel) const Icon(Icons.check_circle, color: AppColors.neonLime, size: 18),
          ],
        ),
      ),
    );
  }
}
