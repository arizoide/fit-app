import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/network/gemini_service.dart';
import 'package:fitmorph_ai/core/network/supabase_config.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';
import 'package:fitmorph_ai/features/profile_history/presentation/widgets/edit_profile_modal.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _apiKeyCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiKeyCtrl.text = GeminiService.apiKey;
  }

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  void _showApiKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.key, color: AppColors.neonLime),
            const SizedBox(width: 8),
            Text('Chave Google Gemini API', style: AppTextStyles.heading3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insira sua chave da API do Gemini para gerar treinos avançados e habilitar o scanner visual por fotos.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyCtrl,
              decoration: const InputDecoration(
                labelText: 'API Key (AIzaSy...)',
                hintText: 'Cole sua chave aqui',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonLime, foregroundColor: Colors.white),
            onPressed: () {
              GeminiService.setApiKey(_apiKeyCtrl.text.trim());
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chave do Gemini configurada com sucesso!'),
                  backgroundColor: AppColors.neonLime,
                ),
              );
              setState(() {});
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final anamnese = ref.watch(anamneseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil & Configurações', style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Avatar Card
            GlassCard(
              borderColor: AppColors.neonLime.withOpacity(0.4),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.neonLime.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 36, color: AppColors.neonLime),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(anamnese.name.isEmpty ? 'Novo Atleta' : anamnese.name, style: AppTextStyles.heading2),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.electricCyan.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    anamnese.experienceLevel.name.toUpperCase(),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.electricCyan,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  anamnese.weightKg > 0
                                      ? '${anamnese.weightKg} kg • ${anamnese.heightCm.toInt()} cm'
                                      : 'Anamnese pendente',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.neonLime),
                        tooltip: 'Editar Perfil & Metas',
                        onPressed: () => EditProfileModal.show(context, ref, anamnese),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          anamnese.location == WorkoutLocation.homeGym
                              ? Icons.home_work_outlined
                              : anamnese.location == WorkoutLocation.bodyweightOnly
                                  ? Icons.accessibility_new
                                  : Icons.domain,
                          size: 18,
                          color: AppColors.neonLime,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            anamnese.location == WorkoutLocation.homeGym
                                ? 'Ambiente: Treino em Casa (Halteres / Banco)'
                                : anamnese.location == WorkoutLocation.bodyweightOnly
                                    ? 'Ambiente: Calistenia (100% Peso Corporal)'
                                    : 'Ambiente: Academia Comercial Completa',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => EditProfileModal.show(context, ref, anamnese),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.neonLime.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.neonLime.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.tune, size: 16, color: AppColors.neonLime),
                          const SizedBox(width: 6),
                          Text(
                            'Editar Dados & Metas do Perfil',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.neonLime,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Selector de Ambiente de Treino
            Text('Alterar Ambiente de Treino', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: [
                  _buildLocationOption(
                    title: 'Academia Comercial',
                    subtitle: 'Aparelhos, máquinas articuladas, cabos e barras',
                    icon: Icons.domain,
                    isSelected: anamnese.location == WorkoutLocation.commercialGym,
                    onTap: () => _updateLocation(WorkoutLocation.commercialGym, 'Academia Comercial'),
                  ),
                  const Divider(color: AppColors.cardBorder),
                  _buildLocationOption(
                    title: 'Treino em Casa (Home Gym)',
                    subtitle: 'Halteres, banco, chão e degrau (Zero máquinas)',
                    icon: Icons.home_work_outlined,
                    isSelected: anamnese.location == WorkoutLocation.homeGym,
                    onTap: () => _updateLocation(WorkoutLocation.homeGym, 'Treino em Casa (Halteres)'),
                  ),
                  const Divider(color: AppColors.cardBorder),
                  _buildLocationOption(
                    title: 'Calistenia / Peso do Corpo',
                    subtitle: 'Flexões, barras e agachamentos (100% corporal)',
                    icon: Icons.accessibility_new,
                    isSelected: anamnese.location == WorkoutLocation.bodyweightOnly,
                    onTap: () => _updateLocation(WorkoutLocation.bodyweightOnly, 'Calistenia'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // AI & Backend Engine Status
            Text('Motores de Inteligência Artificial & Cloud', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: GeminiService.hasApiKey ? AppColors.neonLime.withOpacity(0.2) : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.auto_awesome,
                        color: GeminiService.hasApiKey ? AppColors.neonLime : AppColors.textMuted,
                      ),
                    ),
                    title: Text('Google Gemini API', style: AppTextStyles.bodyLarge),
                    subtitle: Text(
                      GeminiService.hasApiKey ? 'Ativo (Flash & Vision)' : 'Modo Científico Local (Clique para inserir Key)',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: GeminiService.hasApiKey ? AppColors.neonLime : AppColors.textMuted,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: _showApiKeyDialog,
                  ),
                  const Divider(color: AppColors.cardBorder),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: SupabaseConfig.isConfigured ? AppColors.electricCyan.withOpacity(0.2) : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.cloud_outlined,
                        color: SupabaseConfig.isConfigured ? AppColors.electricCyan : AppColors.textMuted,
                      ),
                    ),
                    title: Text('Supabase Cloud Sync', style: AppTextStyles.bodyLarge),
                    subtitle: Text(
                      SupabaseConfig.isConfigured ? 'Conectado (PostgreSQL & Storage Privado)' : 'Armazenamento Local Seguro',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: SupabaseConfig.isConfigured ? AppColors.electricCyan : AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action List
            Text('Gerenciamento da Rotina', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.tune, color: AppColors.neonLime),
                    title: Text('Editar Dados & Metas do Perfil', style: AppTextStyles.bodyLarge),
                    subtitle: Text('Ajuste peso, altura, frequência, cardio e metas com recalculo de treino', style: AppTextStyles.bodySmall),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: () => EditProfileModal.show(context, ref, anamnese),
                  ),
                  const Divider(color: AppColors.cardBorder),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.edit_note, color: AppColors.neonLime),
                    title: Text('Refazer Anamnese Completa', style: AppTextStyles.bodyLarge),
                    subtitle: Text('Reajuste dores, dias de treino e objetivos', style: AppTextStyles.bodySmall),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: () => context.push('/anamnese'),
                  ),
                  const Divider(color: AppColors.cardBorder),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.emoji_events, color: Color(0xFFEAB308)),
                    title: Text('Ranking & Conquistas', style: AppTextStyles.bodyLarge),
                    subtitle: Text('Pódio da academia, badges e incentivos de retorno', style: AppTextStyles.bodySmall),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: () => context.push('/ranking'),
                  ),
                  const Divider(color: AppColors.cardBorder),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.history, color: AppColors.electricCyan),
                    title: Text('Histórico de Treinos e Cargas', style: AppTextStyles.bodyLarge),
                    subtitle: Text('Registro de sessões passadas e progressão', style: AppTextStyles.bodySmall),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                    onTap: () => context.push('/history'),
                  ),
                  const Divider(color: AppColors.cardBorder),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.refresh, color: AppColors.alertRed),
                    title: Text('Regenerar Ficha com IA', style: AppTextStyles.bodyLarge),
                    subtitle: Text('Cria uma nova periodização adaptada ao seu perfil', style: AppTextStyles.bodySmall),
                    onTap: () async {
                      final currentAnamnese = ref.read(anamneseProvider);
                      await ref.read(workoutPlanProvider.notifier).generateNewPlan(currentAnamnese);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nova ficha gerada com sucesso!'),
                            backgroundColor: AppColors.neonLime,
                          ),
                        );
                        context.go('/workout-plan');
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'FitMorph AI v1.0.0 • Clean Architecture & Gemini Multimodal',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateLocation(WorkoutLocation newLocation, String label) async {
    final current = ref.read(anamneseProvider);
    if (current.location == newLocation) return;

    final updated = current.copyWith(location: newLocation);
    ref.read(anamneseProvider.notifier).updateAnamnese(updated);

    await ref.read(workoutPlanProvider.notifier).generateNewPlan(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚡ Ambiente atualizado para "$label"! Ficha adaptada.'),
          backgroundColor: AppColors.neonLime,
        ),
      );
    }
  }

  Widget _buildLocationOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.neonLime.withOpacity(0.2) : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isSelected ? AppColors.neonLime : AppColors.textMuted, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.neonLime : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.neonLime, size: 20)
            else
              const Icon(Icons.radio_button_unchecked, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
