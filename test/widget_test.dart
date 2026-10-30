import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitmorph_ai/main.dart';

void main() {
  testWidgets('FitMorphApp inicia na tela de cadastro/login limpa', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FitMorphApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('FitMorph AI'), findsOneWidget);
    expect(find.text('Criar Conta & Iniciar do Zero'), findsOneWidget);
    expect(find.text('Iniciar Modo Demonstração (Dados de Teste)'), findsOneWidget);
  });
}
