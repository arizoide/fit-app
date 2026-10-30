import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/glass_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico & Progressão', style: AppTextStyles.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Volume Progression Chart
            Text('Evolução do Volume de Carga (kg)', style: AppTextStyles.labelBold),
            const SizedBox(height: 6),
            Text('Sobrecarga progressiva ao longo das semanas de treino:', style: AppTextStyles.bodySmall),
            const SizedBox(height: 16),
            GlassCard(
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: AppColors.cardBorder.withOpacity(0.5),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (val, meta) => Text(
                            '${(val / 1000).toInt()}k',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            switch (val.toInt()) {
                              case 1:
                                return const Text('Sem 1', style: TextStyle(color: AppColors.textMuted, fontSize: 10));
                              case 2:
                                return const Text('Sem 2', style: TextStyle(color: AppColors.textMuted, fontSize: 10));
                              case 3:
                                return const Text('Sem 3', style: TextStyle(color: AppColors.textMuted, fontSize: 10));
                              case 4:
                                return const Text('Sem 4', style: TextStyle(color: AppColors.textMuted, fontSize: 10));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 1,
                    maxX: 4,
                    minY: 8000,
                    maxY: 16000,
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(1, 9800),
                          FlSpot(2, 11200),
                          FlSpot(3, 12600),
                          FlSpot(4, 14280),
                        ],
                        isCurved: true,
                        color: AppColors.neonLime,
                        barWidth: 3.5,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.neonLime.withOpacity(0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Past Workout Sessions List
            Text('Sessões de Treino Recentes', style: AppTextStyles.labelBold),
            const SizedBox(height: 12),
            _buildSessionCard(
              title: 'Treino A - Push (Peito, Ombro e Tríceps)',
              date: 'Ontem às 18:30',
              durationMin: 54,
              volumeKg: 14280,
              setsCount: 18,
            ),
            const SizedBox(height: 10),
            _buildSessionCard(
              title: 'Treino B - Pull (Costas e Bíceps)',
              date: '3 dias atrás',
              durationMin: 48,
              volumeKg: 12600,
              setsCount: 16,
            ),
            const SizedBox(height: 10),
            _buildSessionCard(
              title: 'Treino C - Legs (Pernas Completo)',
              date: '5 dias atrás',
              durationMin: 62,
              volumeKg: 15400,
              setsCount: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard({
    required String title,
    required String date,
    required int durationMin,
    required int volumeKg,
    required int setsCount,
  }) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: AppTextStyles.bodySmall.copyWith(color: AppColors.electricCyan)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.neonLime.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Concluído',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.neonLime, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Tempo', '$durationMin min'),
              _buildStat('Volume', '$volumeKg kg'),
              _buildStat('Séries', '$setsCount séries'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.labelBold.copyWith(fontSize: 13, color: AppColors.textPrimary)),
      ],
    );
  }
}
