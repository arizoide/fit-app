import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmorph_ai/features/ranking/domain/models/ranking_models.dart';
import 'package:fitmorph_ai/features/ranking/presentation/providers/ranking_providers.dart';
import 'package:fitmorph_ai/features/ranking/presentation/screens/ranking_screen.dart';
import 'package:fitmorph_ai/features/ranking/presentation/widgets/podium_widget.dart';
import 'package:fitmorph_ai/features/ranking/presentation/widgets/badge_card.dart';

void main() {
  group('🏆 Ranking & Gamification System Tests', () {

    test('Ordenação de Membros por Período (Mês, Geral e Streak)', () {
      final container = ProviderContainer();
      final notifier = container.read(rankingProvider.notifier);

      // Padrão: Mês Atual
      var state = container.read(rankingProvider);
      expect(state.selectedPeriod, equals(RankingPeriod.month));
      var sorted = state.sortedMembers;
      expect(sorted.first.workoutsMonth, greaterThanOrEqualTo(sorted[1].workoutsMonth));

      // Mudar para Geral Acumulado
      notifier.setPeriod(RankingPeriod.allTime);
      state = container.read(rankingProvider);
      expect(state.selectedPeriod, equals(RankingPeriod.allTime));
      sorted = state.sortedMembers;
      expect(sorted.first.totalWorkouts, greaterThanOrEqualTo(sorted[1].totalWorkouts));

      // Mudar para Ofensiva (Streak)
      notifier.setPeriod(RankingPeriod.streak);
      state = container.read(rankingProvider);
      expect(state.selectedPeriod, equals(RankingPeriod.streak));
      sorted = state.sortedMembers;
      expect(sorted.first.currentStreak, greaterThanOrEqualTo(sorted[1].currentStreak));
    });

    test('Verificação das Badges Especiais de Retomada e Anti-Desistência (A Volta Por Cima)', () {
      final container = ProviderContainer();
      final state = container.read(rankingProvider);

      final comebackBadges = state.allBadges.where((b) => b.isComebackSpecial).toList();

      expect(comebackBadges.isNotEmpty, isTrue);
      expect(comebackBadges.any((b) => b.id == 'comeback_fenix'), isTrue);
      expect(comebackBadges.any((b) => b.id == 'comeback_nunca_tarde'), isTrue);
      expect(comebackBadges.any((b) => b.id == 'comeback_segunda_chance'), isTrue);
      expect(comebackBadges.any((b) => b.id == 'comeback_zero_julgamentos'), isTrue);

      final fenix = comebackBadges.firstWhere((b) => b.id == 'comeback_fenix');
      expect(fenix.title, contains('Fênix de Ferro'));
      expect(fenix.category, equals(BadgeCategory.comeback));
      expect(fenix.motivationalQuote.isNotEmpty, isTrue);
    });

    test('Registrar Check-in de Novo Treino atualiza estatísticas do Usuário Atual', () {
      final container = ProviderContainer();
      final notifier = container.read(rankingProvider.notifier);

      final initialUser = container.read(rankingProvider).currentUser;
      expect(initialUser, isNotNull);
      final initialMonth = initialUser!.workoutsMonth;
      final initialStreak = initialUser.currentStreak;

      notifier.registerNewWorkoutCheckin();

      final updatedUser = container.read(rankingProvider).currentUser;
      expect(updatedUser!.workoutsMonth, equals(initialMonth + 1));
      expect(updatedUser.currentStreak, equals(initialStreak + 1));
    });

    testWidgets('RankingScreen renderiza Pódio, Abas e Galeria de Badges', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verifica título e abas
      expect(find.text('Ranking & Conquistas'), findsOneWidget);
      expect(find.text('Ranking da Academia'), findsOneWidget);
      expect(find.text('Badges & Superação'), findsOneWidget);

      // Pódio do Top 3
      expect(find.byType(PodiumWidget), findsOneWidget);
      expect(find.text('1º'), findsOneWidget);
      expect(find.text('2º'), findsOneWidget);
      expect(find.text('3º'), findsOneWidget);

      // Alternar para aba de Badges
      await tester.tap(find.text('Badges & Superação'));
      await tester.pumpAndSettle();

      // Verifica Galeria de Conquistas
      expect(find.byType(BadgeCard), findsWidgets);
      expect(find.text('Fênix de Ferro'), findsOneWidget);
      expect(find.text('Primeiro Passo'), findsOneWidget);
    });

    test('Ranking de Esteira por Tempo (Minutos/Horas) e Registro de Caminhada', () {
      final container = ProviderContainer();
      final notifier = container.read(rankingProvider.notifier);

      final state = container.read(rankingProvider);
      final treadmillMembers = state.sortedTreadmillMembers;

      // Verifica ordenação decrescente por tempo de esteira
      expect(treadmillMembers.first.treadmillMinutesMonth, greaterThanOrEqualTo(treadmillMembers[1].treadmillMinutesMonth));
      expect(treadmillMembers[1].treadmillMinutesMonth, greaterThanOrEqualTo(treadmillMembers[2].treadmillMinutesMonth));

      // Verifica formato legível de horas e minutos (ex: 8h 00m)
      expect(treadmillMembers.first.treadmillFormattedTime, contains('h'));

      // Usuário atual registra caminhada
      final initialUser = container.read(rankingProvider).currentUser!;
      final initialMinutes = initialUser.treadmillMinutesMonth;
      final initialCalories = initialUser.treadmillCalories;

      notifier.logTreadmillWalk(45, calories: 360);

      final updatedUser = container.read(rankingProvider).currentUser!;
      expect(updatedUser.treadmillMinutesMonth, equals(initialMinutes + 45));
      expect(updatedUser.totalTreadmillMinutes, equals(initialUser.totalTreadmillMinutes + 45));
      expect(updatedUser.treadmillCalories, equals(initialCalories + 360));
    });

    testWidgets('RankingScreen renderiza Aba de Caminhada na Esteira e permite interação', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RankingScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verifica a nova aba 'Esteira por Tempo'
      expect(find.text('Esteira por Tempo'), findsOneWidget);

      // Clica na aba de Esteira
      await tester.tap(find.text('Esteira por Tempo'));
      await tester.pumpAndSettle();

      // Verifica elementos da aba de esteira
      expect(find.text('Ranking por Tempo na Esteira (Horas & Minutos)'), findsOneWidget);
      expect(find.text('Registrar Caminhada na Esteira'), findsOneWidget);
      expect(find.textContaining('Caminhada LISS & Zona 2'), findsOneWidget);

      // Garante que o botão está visível no scroll antes de clicar
      await tester.ensureVisible(find.text('Registrar Caminhada na Esteira'));
      await tester.pumpAndSettle();

      // Clica no botão de registrar caminhada para abrir o modal
      await tester.tap(find.text('Registrar Caminhada na Esteira'));
      await tester.pumpAndSettle();

      // Verifica elementos dentro do modal
      expect(find.text('Registrar Caminhada'), findsOneWidget);
      expect(find.text('Duração da Caminhada'), findsOneWidget);
      expect(find.text('Inclinação da Esteira (%)'), findsOneWidget);
      expect(find.text('Salvar Caminhada (+30 min)'), findsOneWidget);

      // Clica em salvar
      await tester.tap(find.text('Salvar Caminhada (+30 min)'));
      await tester.pumpAndSettle();

      // Confirma que o modal fechou e o snackbar apareceu
      expect(find.textContaining('Caminhada de 30 min somada com sucesso'), findsOneWidget);
    });

  });
}
