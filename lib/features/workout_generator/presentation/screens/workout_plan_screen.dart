import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/constants/exercise_catalog.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/widgets/muscle_tag.dart';
import 'package:fitmorph_ai/core/widgets/anatomical_body_viewer.dart';
import 'package:fitmorph_ai/core/widgets/exercise_guide_dialog.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';
import 'package:fitmorph_ai/features/workout_generator/domain/models/workout_models.dart';
import 'package:fitmorph_ai/features/workout_generator/presentation/widgets/express_workout_modal.dart';
import 'package:fitmorph_ai/features/active_workout/domain/models/active_workout_state.dart';

class WorkoutPlanScreen extends ConsumerStatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  ConsumerState<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends ConsumerState<WorkoutPlanScreen> {
  int _selectedTab = 0; // 0: Meus Treinos (Leve e Direto), 1: Anatomia 3D & Volume
  String? _selectedDayId;
  String? _selectedMuscle = 'Peito';
  String _equipmentFilter = 'all'; // 'all', 'gym', 'home', 'bodyweight'

  final Map<String, String> _muscleDetails = {
    'Peito': 'Peitoral Maior (Fibras Esternais e Claviculares)',
    'Ombros': 'Deltóide Anterior, Lateral e Posterior',
    'Abdômen': 'Reto Abdominal, Oblíquos e Transverso do Abdômen',
    'Bíceps': 'Bíceps Braquial (Cabeça Longa e Curta) e Braquial',
    'Antebraços': 'Braquiorradial e Flexores/Extensores do Punho',
    'Pernas': 'Quadríceps (Reto Femoral, Vasto Lateral, Medial e Intermédio)',
    'Quadríceps': 'Reto Femoral, Vasto Lateral, Vasto Medial e Intermédio',
    'Isquiotibiais': 'Posterior de Coxa (Bíceps Femoral, Semitendíneo e Semimembranoso)',
    'Panturrilhas': 'Gastrocnêmio (Medial/Lateral) e Sóleo',
    'Trapézio': 'Trapézio Superior, Médio e Inferior',
    'Costas': 'Grande Dorsal, Redondo Maior e Rombóides',
    'Tríceps': 'Tríceps Braquial (Cabeça Longa, Lateral e Medial)',
    'Glúteos': 'Glúteo Máximo, Médio e Mínimo',
  };

  List<ExerciseDefinition> _getFilteredExercises() {
    String? locationFilter;
    if (_equipmentFilter == 'home') locationFilter = 'homeGym';
    if (_equipmentFilter == 'bodyweight') locationFilter = 'bodyweightOnly';

    if (_selectedMuscle == null || _selectedMuscle!.isEmpty || _selectedMuscle!.toLowerCase() == 'todos') {
      return ExerciseCatalog.allExercises.where((e) {
        if (locationFilter == 'homeGym' && !ExerciseCatalog.isHomeEquipment(e.equipment)) return false;
        if (locationFilter == 'bodyweightOnly' && !ExerciseCatalog.isBodyweightEquipment(e.equipment)) return false;
        return true;
      }).toList();
    } else {
      return ExerciseCatalog.getExercisesForMuscle(_selectedMuscle!, locationFilter: locationFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workoutPlanAsync = ref.watch(workoutPlanProvider);
    final anamnese = ref.watch(anamneseProvider);
    final activeWorkout = ref.watch(activeWorkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.fitness_center, color: AppColors.neonLime),
            const SizedBox(width: 8),
            Text('Ficha Semanal IA', style: AppTextStyles.heading2),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Color(0xFFEAB308)),
            tooltip: 'Ranking & Conquistas',
            onPressed: () => context.push('/ranking'),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.electricCyan),
            tooltip: 'Ajustar Anamnese',
            onPressed: () => context.push('/anamnese'),
          ),
        ],
      ),
      body: workoutPlanAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.neonLime),
              SizedBox(height: 16),
              Text('FitMorph AI calculando volume ótimo e periodização...'),
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Text('Erro ao carregar treino: $err', style: const TextStyle(color: AppColors.alertRed)),
        ),
        data: (plan) {
          if (plan == null) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.neonLime.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.neonLime, width: 1.5),
                      ),
                      child: const Icon(Icons.fitness_center, size: 40, color: AppColors.neonLime),
                    ),
                    const SizedBox(height: 20),
                    Text('Nenhuma Ficha Criada Ainda', style: AppTextStyles.heading2),
                    const SizedBox(height: 8),
                    Text(
                      'Responda à Anamnese Inteligente para a IA prescrever sua rotina de hipertrofia sob medida.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    NeonButton(
                      text: 'Iniciar Anamnese IA',
                      icon: Icons.auto_awesome,
                      onPressed: () => context.push('/anamnese'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.flash_on, size: 18, color: AppColors.pulseOrange),
                      label: const Text(
                        'Carregar Ficha de Teste (Demo)',
                        style: TextStyle(color: AppColors.pulseOrange, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.pulseOrange),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        ref.read(workoutPlanProvider.notifier).loadSamplePlan();
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          final activeDayId = activeWorkout?.workoutDay.id;
          final effectiveDayId = _selectedDayId ?? activeDayId ?? (plan.days.isNotEmpty ? plan.days.first.id : null);
          final todayDay = plan.days.firstWhere(
            (d) => d.id == effectiveDayId,
            orElse: () => plan.days.first,
          );

          return Column(
            children: [
              // Segmented Tab Switcher (Modern Pill)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSegmentTab(
                        index: 0,
                        icon: Icons.flash_on,
                        label: 'Meus Treinos',
                        countBadge: '${plan.days.length} dias',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildSegmentTab(
                        index: 1,
                        icon: Icons.accessibility_new,
                        label: 'Anatomia & Volume',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _selectedTab == 0
                    ? _buildWorkoutsTab(context, ref, plan, anamnese, todayDay, activeWorkout)
                    : _buildAnatomyTab(context, ref, plan, anamnese),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // BOTÃO DO SEGMENTO DE ABAS
  // ==========================================================
  Widget _buildSegmentTab({
    required int index,
    required IconData icon,
    required String label,
    String? countBadge,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.neonLime : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.neonLime.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (countBadge != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.25) : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  countBadge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ABA 0: MEUS TREINOS (LEVE, ULTRA RÁPIDO, AÇÃO IMEDIATA)
  // ==========================================================
  Widget _buildWorkoutsTab(
    BuildContext context,
    WidgetRef ref,
    WorkoutPlan plan,
    AnamneseModel anamnese,
    WorkoutDay todayDay,
    ActiveWorkoutState? activeWorkout,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de Treino em Andamento (Se houver sessão ativa)
          if (activeWorkout != null) _buildActiveWorkoutBanner(context, ref, activeWorkout),

          // Card Hero: "Treino de Hoje" (0 Scroll! Ação Imediata no topo)
          _buildTodayWorkoutHero(context, ref, plan, todayDay),

          // Mini Resumo de Periodização IA
          _buildPlanSummaryBanner(context, ref, plan, anamnese),

          // Cabeçalho da Lista de Dias da Semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Divisão Completa da Semana', style: AppTextStyles.labelBold),
              Text(
                '${plan.days.length} dias planejados',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Cards elegantes e limpos de cada dia
          ...plan.days.map((day) => _buildDayCard(context, ref, day)),
        ],
      ),
    );
  }

  // ==========================================================
  // HERO CARD: TREINO DE HOJE (0 SCROLL PARA COMEÇAR)
  // ==========================================================
  Widget _buildTodayWorkoutHero(
    BuildContext context,
    WidgetRef ref,
    WorkoutPlan plan,
    WorkoutDay todayDay,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.neonLime.withOpacity(0.75),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonLime.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Tag "TREINO DE HOJE" + Modo Express badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonLime.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.neonLime.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.neonLime,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'TREINO DE HOJE',
                      style: TextStyle(
                        color: AppColors.neonLime,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              if (todayDay.isExpressMode)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.pulseOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.pulseOrange.withOpacity(0.5)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.bolt, color: AppColors.pulseOrange, size: 13),
                      SizedBox(width: 3),
                      Text(
                        'MODO EXPRESS',
                        style: TextStyle(
                          color: AppColors.pulseOrange,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Seletor Rápido de Dias (Pills Horizontais para trocar de dia com 1 toque)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: plan.days.map((d) {
                final isSelected = d.id == todayDay.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayId = d.id;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.neonLime : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.neonLime : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Dia ${d.dayLetter}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.check, size: 12, color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Letra do Dia e Título
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.neonLime.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.neonLime, width: 1.8),
                ),
                child: Center(
                  child: Text(
                    todayDay.dayLetter,
                    style: AppTextStyles.heading2.copyWith(color: AppColors.neonLime, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todayDay.title,
                      style: AppTextStyles.heading2.copyWith(fontSize: 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${todayDay.exercises.length} exercícios planejados',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Músculos Alvo
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: todayDay.focusMuscles.map((m) => MuscleTag(muscleName: m)).toList(),
          ),
          const SizedBox(height: 14),

          // Barra de estatísticas compacta: Exercícios, Tempo, Cardio
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeroStat(Icons.fitness_center, '${todayDay.exercises.length} exercícios'),
                Container(width: 1, height: 16, color: AppColors.cardBorder),
                _buildHeroStat(Icons.timer_outlined, '~${todayDay.estimatedMinutes} min'),
                if (todayDay.cardioProtocol != null) ...[
                  Container(width: 1, height: 16, color: AppColors.cardBorder),
                  _buildHeroStat(Icons.directions_run, '${todayDay.cardioProtocol!.durationMinutes}m cardio'),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // BOTÃO PRINCIPAL NEON: INICIAR TREINO DE HOJE (0 SCROLL!)
          NeonButton(
            text: todayDay.isExpressMode ? 'INICIAR TREINO EXPRESS' : 'INICIAR TREINO DE HOJE',
            icon: Icons.play_arrow,
            height: 48,
            onPressed: () {
              ref.read(activeWorkoutProvider.notifier).startWorkout(todayDay);
              context.go('/active-workout');
            },
          ),
          const SizedBox(height: 10),

          // Ações secundárias: Ver Lista de Exercícios e Ajustar Tempo Express
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.format_list_bulleted, size: 15, color: AppColors.electricCyan),
                  label: const Text(
                    'Ver Exercícios',
                    style: TextStyle(color: AppColors.electricCyan, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.electricCyan.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                  onPressed: () => context.push('/workout-day/${todayDay.id}'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.bolt, size: 15, color: AppColors.pulseOrange),
                label: const Text(
                  'Express',
                  style: TextStyle(color: AppColors.pulseOrange, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.pulseOrange.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                ),
                onPressed: () => ExpressWorkoutModal.show(context, ref, todayDay),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.neonLime),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // BANNER DE SESSÃO ATIVA EM ANDAMENTO
  // ==========================================================
  Widget _buildActiveWorkoutBanner(
    BuildContext context,
    WidgetRef ref,
    ActiveWorkoutState activeWorkout,
  ) {
    final mins = activeWorkout.elapsedSeconds ~/ 60;
    final secs = activeWorkout.elapsedSeconds % 60;
    final timeStr = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.pulseOrange.withOpacity(0.22),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.pulseOrange, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.pulseOrange.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.pulseOrange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_circle_fill, color: AppColors.pulseOrange, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'TREINO EM ANDAMENTO',
                      style: TextStyle(
                        color: AppColors.pulseOrange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.pulseOrange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        timeStr,
                        style: const TextStyle(
                          color: AppColors.pulseOrange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  activeWorkout.workoutDay.title,
                  style: AppTextStyles.labelBold.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pulseOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => context.go('/active-workout'),
            child: const Text('Retomar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MINI RESUMO DO PLANO
  // ==========================================================
  Widget _buildPlanSummaryBanner(
    BuildContext context,
    WidgetRef ref,
    WorkoutPlan plan,
    AnamneseModel anamnese,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.electricCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.electricCyan, size: 15),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.splitType,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${plan.days.length}x/sem • ${anamnese.location == WorkoutLocation.homeGym ? "🏠 Casa" : anamnese.location == WorkoutLocation.bodyweightOnly ? "🤸 Calistenia" : "🏋️ Academia"} • ${anamnese.primaryGoal == "hypertrophy" ? "Hipertrofia" : "Definição"}',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () => context.push('/anamnese'),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Ajustar',
                    style: TextStyle(
                      color: AppColors.neonLime,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_forward_ios, color: AppColors.neonLime, size: 9),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ABA 1: ANATOMIA 3D & VOLUME SEMANAL
  // ==========================================================
  Widget _buildAnatomyTab(
    BuildContext context,
    WidgetRef ref,
    WorkoutPlan plan,
    AnamneseModel anamnese,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          GlassCard(
            borderColor: AppColors.neonLime.withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.neonLime.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        plan.splitType,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neonLime,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: AppColors.electricCyan, size: 16),
                        const SizedBox(width: 4),
                        Text('IA Periodizada', style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(plan.title, style: AppTextStyles.heading2),
                const SizedBox(height: 6),
                Text(
                  plan.description,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const Divider(color: AppColors.cardBorder, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPlanStat('Frequência', '${plan.days.length}x / sem'),
                    _buildPlanStat(
                      'Ambiente',
                      anamnese.location == WorkoutLocation.homeGym
                          ? '🏠 Casa'
                          : anamnese.location == WorkoutLocation.bodyweightOnly
                              ? '🤸 Calistenia'
                              : '🏋️ Academia',
                    ),
                    _buildPlanStat(
                      'Cardio Semanal',
                      '${plan.days.fold<int>(0, (acc, d) => acc + (d.cardioProtocol?.durationMinutes ?? 0))} min',
                    ),
                    _buildPlanStat('Meta', anamnese.primaryGoal == 'hypertrophy' ? 'Hipertrofia' : 'Definição'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Volume Semanal por Músculo (Barra de Seleção Horizontal)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Volume Semanal (Séries/Semana)', style: AppTextStyles.labelBold),
              Text(
                _selectedMuscle != null ? 'Foco: $_selectedMuscle' : 'Toque para filtrar',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.neonLime, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Botão "Todos"
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: GlassCard(
                    onTap: () {
                      setState(() {
                        _selectedMuscle = null;
                      });
                    },
                    borderColor: _selectedMuscle == null ? AppColors.neonLime : AppColors.cardBorder,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _selectedMuscle == null ? AppColors.neonLime.withOpacity(0.2) : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'TODOS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _selectedMuscle == null ? AppColors.neonLime : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ver Ficha',
                          style: AppTextStyles.labelBold.copyWith(
                            color: _selectedMuscle == null ? AppColors.neonLime : AppColors.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ...plan.weeklyVolumePerMuscle.entries.map((entry) {
                  final isSelected = _selectedMuscle?.toLowerCase() == entry.key.toLowerCase();
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: GlassCard(
                      onTap: () {
                        setState(() {
                          _selectedMuscle = isSelected ? null : entry.key;
                        });
                      },
                      borderColor: isSelected ? AppColors.neonLime : AppColors.cardBorder,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MuscleTag(muscleName: entry.key),
                          const SizedBox(height: 8),
                          Text(
                            '${entry.value} séries',
                            style: AppTextStyles.labelBold.copyWith(
                              color: isSelected ? AppColors.neonLime : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Visualizador Anatômico Interativo 3D
          AnatomicalBodyViewer(
            highlightedMuscles: plan.weeklyVolumePerMuscle.keys.toList(),
            weeklyVolumePerMuscle: plan.weeklyVolumePerMuscle,
            selectedMuscleName: _selectedMuscle,
            onMuscleSelected: (muscleName) {
              setState(() {
                if (muscleName.isEmpty || _selectedMuscle?.toLowerCase() == muscleName.toLowerCase()) {
                  _selectedMuscle = null;
                } else {
                  _selectedMuscle = muscleName;
                }
              });
            },
          ),
          const SizedBox(height: 24),

          // ==========================================
          // SEÇÃO INLINE: EXPLORADOR DE TREINO DO MÚSCULO
          // ==========================================
          _buildInlineMuscleWorkoutExplorer(context, ref, plan),
          const SizedBox(height: 28),

          // Seletor Rápido de Treino Express
          _buildExpressQuickControl(context, ref, plan),
        ],
      ),
    );
  }

  // ==========================================================
  // WIDGET INLINE DE EXPLORADOR DE EXERCÍCIOS DO MÚSCULO
  // ==========================================================
  Widget _buildInlineMuscleWorkoutExplorer(BuildContext context, WidgetRef ref, WorkoutPlan plan) {
    final filteredExercises = _getFilteredExercises();
    final allForMuscle = _selectedMuscle == null ? ExerciseCatalog.allExercises : ExerciseCatalog.getExercisesForMuscle(_selectedMuscle!);
    final gymCount = allForMuscle.where((e) => !ExerciseCatalog.isBodyweightEquipment(e.equipment)).length;
    final homeCount = allForMuscle.where((e) => ExerciseCatalog.isHomeEquipment(e.equipment)).length;
    final bwCount = allForMuscle.where((e) => ExerciseCatalog.isBodyweightEquipment(e.equipment)).length;

    final anatomicalDesc = _selectedMuscle != null
        ? (_muscleDetails[_selectedMuscle] ?? 'Grupo Muscular Principal')
        : 'Todos os grupos musculares do corpo';

    final weeklyVolume = _selectedMuscle != null ? (plan.weeklyVolumePerMuscle[_selectedMuscle] ?? 0) : 0;

    // Achar os dias da semana que contêm esse músculo
    final matchingDays = plan.days.where((d) {
      if (_selectedMuscle == null) return true;
      final mLower = _selectedMuscle!.toLowerCase();
      final inFocus = d.focusMuscles.any((m) => m.toLowerCase().contains(mLower) || mLower.contains(m.toLowerCase()));
      final inExercises = d.exercises.any((e) => e.targetMuscle.toLowerCase().contains(mLower) || mLower.contains(e.targetMuscle.toLowerCase()));
      return inFocus || inExercises;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _selectedMuscle != null ? AppColors.neonLime.withOpacity(0.6) : AppColors.cardBorder,
          width: _selectedMuscle != null ? 1.8 : 1.0,
        ),
        boxShadow: [
          if (_selectedMuscle != null)
            BoxShadow(
              color: AppColors.neonLime.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho da Seção Inline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (_selectedMuscle != null ? AppColors.neonLime : AppColors.electricCyan).withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (_selectedMuscle != null ? AppColors.neonLime : AppColors.electricCyan).withOpacity(0.4),
                        ),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        color: _selectedMuscle != null ? AppColors.neonLime : AppColors.electricCyan,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _selectedMuscle != null ? _selectedMuscle!.toUpperCase() : 'TODOS OS MÚSCULOS',
                                style: AppTextStyles.heading2.copyWith(
                                  fontSize: 18,
                                  color: _selectedMuscle != null ? AppColors.neonLime : AppColors.textPrimary,
                                ),
                              ),
                              if (_selectedMuscle != null && weeklyVolume > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.electricCyan.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.electricCyan.withOpacity(0.4)),
                                  ),
                                  child: Text(
                                    '$weeklyVolume séries/sem',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.electricCyan,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            anatomicalDesc,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_selectedMuscle != null)
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                  tooltip: 'Ver Todos',
                  onPressed: () {
                    setState(() {
                      _selectedMuscle = null;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Seletor de Equipamento (Chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill('all', 'Todos (${allForMuscle.length})', Icons.grid_view),
                const SizedBox(width: 8),
                _buildFilterPill('gym', '🏋️ Academia ($gymCount)', null),
                const SizedBox(width: 8),
                _buildFilterPill('home', '🏠 Halteres ($homeCount)', null),
                const SizedBox(width: 8),
                _buildFilterPill('bodyweight', '🤸 Calistenia ($bwCount)', null),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Presença na Ficha Semanal Atual
          if (_selectedMuscle != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: AppColors.electricCyan, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        matchingDays.isNotEmpty
                            ? 'Treinado em ${matchingDays.length} dia(s) na sua semana:'
                            : 'Músculo não incluído na divisão principal atual',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: matchingDays.isNotEmpty ? AppColors.electricCyan : AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (matchingDays.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: matchingDays.map((day) {
                        return InkWell(
                          onTap: () => context.push('/workout-day/${day.id}'),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.neonLime.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.neonLime.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Treino ${day.dayLetter}: ${day.title}',
                                  style: const TextStyle(
                                    color: AppColors.neonLime,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward, color: AppColors.neonLime, size: 12),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Lista de Exercícios Filtrados (Inline Cards)
          Text(
            'Exercícios para ${_selectedMuscle ?? 'Corpo Inteiro'} (${filteredExercises.length} disponíveis)',
            style: AppTextStyles.labelBold.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 10),

          if (filteredExercises.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.search_off, color: AppColors.textMuted, size: 36),
                    const SizedBox(height: 8),
                    Text('Nenhum exercício encontrado com esse filtro.', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => setState(() => _equipmentFilter = 'all'),
                      child: const Text('Mostrar todos os equipamentos', style: TextStyle(color: AppColors.neonLime)),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredExercises.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final ex = filteredExercises[index];
                return _buildInlineExerciseCard(context, ref, ex, plan);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String filterKey, String label, IconData? icon) {
    final isSelected = _equipmentFilter == filterKey;
    return InkWell(
      onTap: () => setState(() => _equipmentFilter = filterKey),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.neonLime.withOpacity(0.2) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.neonLime : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? AppColors.neonLime : AppColors.textSecondary),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.neonLime : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineExerciseCard(BuildContext context, WidgetRef ref, ExerciseDefinition ex, WorkoutPlan plan) {
    final isCompound = ex.mechanics.toLowerCase().contains('composto');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.name,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Tag Equipamento
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Text(
                            ex.equipment,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Tag Composto / Isolado
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (isCompound ? AppColors.pulseOrange : AppColors.purpleAccent).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: (isCompound ? AppColors.pulseOrange : AppColors.purpleAccent).withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            ex.mechanics,
                            style: TextStyle(
                              color: isCompound ? AppColors.pulseOrange : AppColors.purpleAccent,
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
              // Botão Guia de Postura
              InkWell(
                onTap: () => ExerciseGuideDialog.show(context, ex.id),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.electricCyan.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.electricCyan.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book, color: AppColors.electricCyan, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Guia',
                        style: TextStyle(color: AppColors.electricCyan, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (ex.secondaryMuscles.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                Text('Sinergistas: ', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10)),
                ...ex.secondaryMuscles.map((m) => MuscleTag(muscleName: m, isSecondary: true)),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text(
            ex.instructions,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExpressQuickControl(BuildContext context, WidgetRef ref, WorkoutPlan plan) {
    final anyExpress = plan.days.any((d) => d.isExpressMode);
    final avgMinutes = plan.days.fold<int>(0, (acc, d) => acc + d.estimatedMinutes) ~/ (plan.days.isEmpty ? 1 : plan.days.length);

    return GlassCard(
      borderColor: anyExpress ? AppColors.pulseOrange.withOpacity(0.8) : AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.pulseOrange.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.pulseOrange.withOpacity(0.5)),
                    ),
                    child: const Icon(Icons.bolt, color: AppColors.pulseOrange, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Modo Treino Express', style: AppTextStyles.labelBold.copyWith(fontSize: 14, color: AppColors.pulseOrange)),
                      Text(
                        anyExpress ? '⚡ Modo Express ativo (~$avgMinutes min/dia)' : 'Pouco tempo? Compacte seus treinos com 1 clique',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              if (anyExpress)
                TextButton(
                  onPressed: () {
                    ref.read(workoutPlanProvider.notifier).restoreAllDaysOriginal();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rotina restaurada para o volume completo padrão!'),
                        backgroundColor: AppColors.neonLime,
                      ),
                    );
                  },
                  child: const Text('Restaurar', style: TextStyle(color: AppColors.neonLime, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildExpressTimeChip(
                  context,
                  ref,
                  label: '⚡ 15 min',
                  minutes: 15,
                  isSelected: anyExpress && avgMinutes <= 17,
                  plan: plan,
                ),
                const SizedBox(width: 8),
                _buildExpressTimeChip(
                  context,
                  ref,
                  label: '⚡ 20 min',
                  minutes: 20,
                  isSelected: anyExpress && avgMinutes > 17 && avgMinutes <= 25,
                  plan: plan,
                ),
                const SizedBox(width: 8),
                _buildExpressTimeChip(
                  context,
                  ref,
                  label: '⚡ 30 min',
                  minutes: 30,
                  isSelected: anyExpress && avgMinutes > 25 && avgMinutes <= 35,
                  plan: plan,
                ),
                const SizedBox(width: 8),
                _buildExpressTimeChip(
                  context,
                  ref,
                  label: '🏋️ Padrão (~50 min)',
                  minutes: null,
                  isSelected: !anyExpress,
                  plan: plan,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpressTimeChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required int? minutes,
    required bool isSelected,
    required WorkoutPlan plan,
  }) {
    return InkWell(
      onTap: () {
        if (minutes == null) {
          ref.read(workoutPlanProvider.notifier).restoreAllDaysOriginal();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Treinos restaurados para a duração completa!'),
              backgroundColor: AppColors.neonLime,
            ),
          );
        } else {
          ref.read(workoutPlanProvider.notifier).adaptAllDaysForExpress(minutes);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('⚡ Todos os treinos da semana ajustados para ~$minutes minutos!'),
              backgroundColor: AppColors.pulseOrange,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (minutes == null ? AppColors.neonLime.withOpacity(0.2) : AppColors.pulseOrange.withOpacity(0.25))
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? (minutes == null ? AppColors.neonLime : AppColors.pulseOrange)
                : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (minutes == null ? AppColors.neonLime : AppColors.pulseOrange)
                : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDayCard(BuildContext context, WidgetRef ref, WorkoutDay day) {
    final bool targetsSelectedMuscle = _selectedMuscle != null &&
        (day.focusMuscles.any((m) => m.toLowerCase().contains(_selectedMuscle!.toLowerCase()) || _selectedMuscle!.toLowerCase().contains(m.toLowerCase())) ||
            day.exercises.any((e) => e.targetMuscle.toLowerCase().contains(_selectedMuscle!.toLowerCase()) || _selectedMuscle!.toLowerCase().contains(e.targetMuscle.toLowerCase())));

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        onTap: () => context.push('/workout-day/${day.id}'),
        borderColor: targetsSelectedMuscle ? AppColors.neonLime : (day.isExpressMode ? AppColors.pulseOrange : AppColors.cardBorder),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (day.isExpressMode ? AppColors.pulseOrange : AppColors.neonLime).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: day.isExpressMode ? AppColors.pulseOrange : AppColors.neonLime, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      day.dayLetter,
                      style: AppTextStyles.labelBold.copyWith(color: day.isExpressMode ? AppColors.pulseOrange : AppColors.neonLime),
                    ),
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
                              day.title,
                              style: AppTextStyles.heading3.copyWith(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (targetsSelectedMuscle) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.neonLime.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.neonLime.withOpacity(0.5)),
                              ),
                              child: Text(
                                '🎯 Contém $_selectedMuscle',
                                style: const TextStyle(
                                  color: AppColors.neonLime,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (day.isExpressMode) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.pulseOrange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.pulseOrange.withOpacity(0.5)),
                              ),
                              child: Text(
                                '⚡ Express',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.pulseOrange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            '${day.exercises.length} exercícios • ~${day.estimatedMinutes} min',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: day.isExpressMode ? AppColors.pulseOrange : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.bolt, color: AppColors.pulseOrange, size: 20),
                  tooltip: 'Ajustar Tempo Express',
                  onPressed: () => ExpressWorkoutModal.show(context, ref, day),
                ),
                const Icon(Icons.chevron_right, color: AppColors.neonLime),
              ],
            ),
            if (day.cardioProtocol != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.pulseOrange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.pulseOrange.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_run, color: AppColors.pulseOrange, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${day.cardioProtocol!.title} • ${day.cardioProtocol!.durationMinutes} min (~${day.cardioProtocol!.estimatedCalories} kcal)',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.pulseOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: day.focusMuscles.map((m) => MuscleTag(muscleName: m)).toList(),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: NeonButton(
                    text: day.isExpressMode ? 'Iniciar Treino Express' : 'Iniciar Modo Treino Ativo',
                    icon: Icons.play_arrow,
                    height: 44,
                    onPressed: () {
                      ref.read(activeWorkoutProvider.notifier).startWorkout(day);
                      context.go('/active-workout');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.pulseOrange.withOpacity(0.15),
                    foregroundColor: AppColors.pulseOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                  ),
                  icon: const Icon(Icons.bolt, size: 20),
                  tooltip: 'Pouco tempo hoje? Ajustar para Express',
                  onPressed: () => ExpressWorkoutModal.show(context, ref, day),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
