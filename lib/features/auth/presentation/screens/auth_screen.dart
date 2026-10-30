import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';
import 'package:fitmorph_ai/core/widgets/glass_card.dart';
import 'package:fitmorph_ai/core/widgets/neon_button.dart';
import 'package:fitmorph_ai/core/network/supabase_config.dart';
import 'package:fitmorph_ai/core/providers/app_providers.dart';
import 'package:fitmorph_ai/features/anamnese/domain/models/anamnese_model.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isSignUp = true; // Inicia em modo de cadastro por padrão
  bool _isLoading = false;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final name = _nameCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe e-mail e senha para continuar.'),
          backgroundColor: AppColors.alertRed,
        ),
      );
      return;
    }

    if (_isSignUp && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite seu nome ou apelido.'),
          backgroundColor: AppColors.alertRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (SupabaseConfig.isConfigured && SupabaseConfig.client != null) {
        if (_isSignUp) {
          await SupabaseConfig.client!.auth.signUp(
            email: email,
            password: password,
            data: {'full_name': name},
          );
        } else {
          await SupabaseConfig.client!.auth.signInWithPassword(
            email: email,
            password: password,
          );
        }
      } else {
        // Simulação local sem Supabase
        await Future.delayed(const Duration(milliseconds: 500));
      }

      if (mounted) {
        if (_isSignUp) {
          // Inicia perfil limpo com o nome digitado e leva para Anamnese do zero
          ref.read(anamneseProvider.notifier).updateAnamnese(
                AnamneseModel.empty().copyWith(name: name),
              );
          ref.read(workoutPlanProvider.notifier).resetPlan();
          context.go('/anamnese');
        } else {
          context.go('/workout-plan');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aviso de conexão: $e'), backgroundColor: AppColors.alertRed),
        );
        // Permite continuar para teste de fluxo
        if (_isSignUp) {
          ref.read(anamneseProvider.notifier).updateAnamnese(
                AnamneseModel.empty().copyWith(name: name.isEmpty ? 'Atleta' : name),
              );
          ref.read(workoutPlanProvider.notifier).resetPlan();
          context.go('/anamnese');
        } else {
          context.go('/workout-plan');
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loadDemoAndEnter() {
    // Carrega dados simulados de teste completos
    ref.read(workoutPlanProvider.notifier).loadSamplePlan();
    ref.read(biometricsProvider.notifier).loadSample();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🧪 Modo Demo ativado com perfil e ficha de treino carregados!'),
        backgroundColor: AppColors.neonLime,
      ),
    );
    context.go('/workout-plan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo & Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.neonLime.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.neonLime, width: 2),
                    boxShadow: const [
                      BoxShadow(color: AppColors.neonLimeGlow, blurRadius: 20, spreadRadius: 2),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.fitness_center, color: AppColors.neonLime, size: 38),
                  ),
                ),
                const SizedBox(height: 16),
                Text('FitMorph AI', style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text(
                  'Assistente Híbrido de Treino Inteligente & Biometria Visual',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 28),

                // Card de Formulário Limpo
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          _isSignUp ? 'Criar Conta & Iniciar do Zero' : 'Entrar no FitMorph',
                          style: AppTextStyles.heading3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          _isSignUp
                              ? 'Cadastre-se para responder sua anamnese personalizada.'
                              : 'Acesse suas fichas e histórico salvo.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_isSignUp) ...[
                        TextField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Seu Nome ou Apelido',
                            hintText: 'Ex: Carlos Silva',
                            prefixIcon: Icon(Icons.person_outline, color: AppColors.neonLime),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          hintText: 'seuemail@exemplo.com',
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.electricCyan),
                        ),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          hintText: 'Digite sua senha',
                          prefixIcon: Icon(Icons.lock_outline, color: AppColors.electricCyan),
                        ),
                      ),
                      const SizedBox(height: 22),

                      NeonButton(
                        text: _isSignUp ? 'Criar Conta & Iniciar Anamnese' : 'Entrar',
                        icon: _isSignUp ? Icons.arrow_forward : Icons.login,
                        isLoading: _isLoading,
                        onPressed: _handleAuth,
                      ),
                      const SizedBox(height: 14),

                      Center(
                        child: TextButton(
                          onPressed: () => setState(() => _isSignUp = !_isSignUp),
                          child: Text(
                            _isSignUp
                                ? 'Já possui conta? Fazer Login'
                                : 'Não possui cadastro? Criar Conta Grátis',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.electricCyan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botão de Demonstração / Teste Rápido
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.pulseOrange.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.science_outlined, color: AppColors.pulseOrange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ambiente de Testes / Avaliação Rápida',
                              style: AppTextStyles.labelBold.copyWith(
                                color: AppColors.pulseOrange,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Deseja pular o preenchimento e ver o sistema funcionando com dados prontos de exemplo?',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.play_circle_fill, size: 18, color: AppColors.neonLime),
                        label: const Text(
                          'Iniciar Modo Demonstração (Dados de Teste)',
                          style: TextStyle(color: AppColors.neonLime, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.neonLime, width: 1.2),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _loadDemoAndEnter,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
