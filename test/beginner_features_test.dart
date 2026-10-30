import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitmorph_ai/core/utils/first_day_weight_helper.dart';
import 'package:fitmorph_ai/core/widgets/rpe_dictionary_dialog.dart';
import 'package:fitmorph_ai/features/diet_calories/domain/models/brazilian_dish_options.dart';

void main() {
  group('🔰 Beginner Features Quality Suite', () {
    test('FirstDayWeightHelper returns accurate safe loads for first day', () {
      // 1. Olympic Barbell exercise
      final benchPress = FirstDayWeightHelper.getAdvice(
        exerciseName: 'Supino Reto com Barra',
        equipment: 'Barra',
        muscle: 'Peito',
      );
      expect(benchPress.startingWeight, contains('Barra livre (20kg)'));
      expect(benchPress.targetZone, 'Apenas a barra (0 anilhas)');
      expect(benchPress.safetyTip, contains('equilíbrio'));

      // 2. Dumbbell isolation exercise (Elevação Lateral)
      final lateralRaise = FirstDayWeightHelper.getAdvice(
        exerciseName: 'Elevação Lateral',
        equipment: 'Halteres',
        muscle: 'Ombros',
      );
      expect(lateralRaise.startingWeight, contains('2kg a 4kg'));
      expect(lateralRaise.safetyTip, contains('controle'));

      // 3. Dumbbell compound / biceps exercise
      final dumbbellCurl = FirstDayWeightHelper.getAdvice(
        exerciseName: 'Rosca Direta com Halteres',
        equipment: 'Halteres',
        muscle: 'Bíceps',
      );
      expect(dumbbellCurl.startingWeight, contains('4kg a 6kg'));

      // 4. Machine exercise
      final machineLatPulldown = FirstDayWeightHelper.getAdvice(
        exerciseName: 'Puxada Frontal na Polia',
        equipment: 'Máquina / Polia',
        muscle: 'Costas',
      );
      expect(machineLatPulldown.startingWeight, contains('2 a 3 placas'));

      // 5. Bodyweight exercise
      final pushup = FirstDayWeightHelper.getAdvice(
        exerciseName: 'Flexão de Braços',
        equipment: 'Peso Corporal',
        muscle: 'Peito',
      );
      expect(pushup.startingWeight, contains('corpo com apoio'));
      expect(pushup.safetyTip, contains('joelhos no chão'));
    });

    test('BrazilianDishesCatalog contains curated home-cooked options for 4 daily meals', () {
      // Verify all 4 daily meals are present
      final meals = ['cafe', 'almoco', 'lanche', 'jantar'];
      for (final meal in meals) {
        final dishes = BrazilianDishesCatalog.getDishesForMeal(meal);
        expect(dishes.isNotEmpty, true, reason: 'Deveria conter pratos para $meal');
        for (final dish in dishes) {
          expect(dish.name.isNotEmpty, true);
          expect(dish.calories, greaterThan(100));
          expect(dish.proteinGrams, greaterThan(5));
          expect(dish.ingredients.isNotEmpty, true);
        }
      }

      // Check specific traditional Brazilian dishes
      final lunchDishes = BrazilianDishesCatalog.getDishesForMeal('almoco');
      final hasRiceAndBeansChicken = lunchDishes.any((d) => d.name.contains('Arroz') && d.name.contains('Feijão'));
      expect(hasRiceAndBeansChicken, true, reason: 'Almoço brasileiro deve incluir Arroz e Feijão');

      final breakfastDishes = BrazilianDishesCatalog.getDishesForMeal('cafe');
      final hasTapiocaOrEggs = breakfastDishes.any((d) => d.name.contains('Ovos') || d.name.contains('Tapioca') || d.name.contains('Cuscuz'));
      expect(hasTapiocaOrEggs, true, reason: 'Café da manhã brasileiro deve incluir ovos, tapioca ou cuscuz');
    });

    testWidgets('RpeDictionaryDialog displays "Pare quando sentir que aguentaria só mais 2 reps"', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => RpeDictionaryDialog.show(context),
                child: const Text('Abrir RPE'),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Abrir RPE'));
      await tester.pumpAndSettle();

      // Check the exact beginner balloon text
      expect(find.text('Dicionário Rápido de Esforço'), findsOneWidget);
      expect(find.textContaining('Pare a série quando sentir que aguentaria só mais 2 repetições'), findsOneWidget);
      expect(find.textContaining('RPE 8'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Dismiss dialog via close icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Dicionário Rápido de Esforço'), findsNothing);
    });
  });
}
