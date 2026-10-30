import 'package:flutter/material.dart';
import 'package:fitmorph_ai/core/constants/app_colors.dart';
import 'package:fitmorph_ai/core/constants/app_text_styles.dart';

class RpeDictionaryDialog extends StatelessWidget {
  const RpeDictionaryDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const RpeDictionaryDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 420,
        ),
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com botão fechar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.psychology, color: Color(0xFF0284C7), size: 22),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Dicionário Rápido de Esforço',
                            style: AppTextStyles.heading3.copyWith(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Balão de Destaque solicitado pelo usuário
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.chat_bubble_outline, color: AppColors.neonLime, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'REGRA DE OURO PARA INICIANTES',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: AppColors.neonLime,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '"Pare a série quando sentir que aguentaria só mais 2 repetições."',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Você NÃO precisa treinar até a falha total no começo. Deixar 2 repetições no tanque estimula o músculo com segurança e sem dor excessiva.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFFCBD5E1),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Tabela Simplificada RPE vs RIR
              Text('O que significam as siglas?', style: AppTextStyles.labelBold),
              const SizedBox(height: 10),
              _buildRpeCard(
                rpe: 'RPE 8 (ou RIR 2)',
                badgeColor: AppColors.neonLime,
                title: 'Esforço Ideal / Padrão Ouro',
                desc: 'Significa "2 repetições na reserva". Você termina a série cansado, mas ainda conseguiria fazer mais 2 reps com boa postura.',
                isRecommended: true,
              ),
              const SizedBox(height: 8),
              _buildRpeCard(
                rpe: 'RPE 7 (ou RIR 3)',
                badgeColor: const Color(0xFF0284C7),
                title: 'Moderado / Aquecimento',
                desc: 'Significa "3 repetições na reserva". Bom para aprender a postura no 1º dia ou aquecer as articulações antes de subir o peso.',
                isRecommended: false,
              ),
              const SizedBox(height: 8),
              _buildRpeCard(
                rpe: 'RPE 9 (ou RIR 1)',
                badgeColor: const Color(0xFFEA580C),
                title: 'Muito Intenso',
                desc: 'Apenas 1 repetição antes de falhar. Usado por atletas experientes na última série de um exercício.',
                isRecommended: false,
              ),
              const SizedBox(height: 8),
              _buildRpeCard(
                rpe: 'RPE 10 (ou RIR 0)',
                badgeColor: const Color(0xFFE11D48),
                title: 'Falha Total (Trava)',
                desc: 'Impossível fazer mais nenhuma repetição. Evite no primeiro mês para não machucar tendões e ligamentos.',
                isRecommended: false,
              ),
              const SizedBox(height: 18),

              // Botão de Confirmação
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonLime,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Entendi! Continuar Treino',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRpeCard({
    required String rpe,
    required Color badgeColor,
    required String title,
    required String desc,
    required bool isRecommended,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended ? badgeColor.withOpacity(0.6) : AppColors.cardBorder,
          width: isRecommended ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  rpe,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
              if (isRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'RECOMENDADO',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.35)),
        ],
      ),
    );
  }
}
