class BrazilianDishOption {
  final String id;
  final String name;
  final String mealType; // 'cafe', 'almoco', 'lanche', 'jantar'
  final String description;
  final List<String> ingredients;
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatsGrams;
  final String practicalTip;

  const BrazilianDishOption({
    required this.id,
    required this.name,
    required this.mealType,
    required this.description,
    required this.ingredients,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.practicalTip,
  });
}

class BrazilianDishesCatalog {
  static const List<BrazilianDishOption> allDishes = [
    // ==========================================
    // CAFÉ DA MANHÃ (BREAKFAST)
    // ==========================================
    BrazilianDishOption(
      id: 'cafe_1',
      name: 'Pão Francês com Ovos Mexidos & Café com Leite',
      mealType: 'cafe',
      description: 'O clássico café da manhã de padaria brasileira, nutritivo e saciante.',
      ingredients: [
        '1 Pão francês crocante (50g)',
        '2 Ovos inteiros mexidos com pouco azeite/manteiga',
        '200ml de Café com leite desnatado (ou sem lactose)',
        '1 Maçã ou banana pequena',
      ],
      calories: 380,
      proteinGrams: 22,
      carbsGrams: 44,
      fatsGrams: 13,
      practicalTip: 'Peça o pão sem miolo se quiser economizar carboidratos, ou com miolo se for dia de pernas!',
    ),
    BrazilianDishOption(
      id: 'cafe_2',
      name: 'Crepioca com Queijo Minas & Fruta com Aveia',
      mealType: 'cafe',
      description: 'Opção leve, sem glúten e perfeita para digestão rápida antes do dia começar.',
      ingredients: [
        '1 Ovo + 2 colheres de sopa de goma de tapioca (40g)',
        '1 Fatia média de Queijo Minas Frescal (30g)',
        '1 Banana fatiada com 1 colher de farelo de aveia e canela em pó',
        'Café preto à vontade',
      ],
      calories: 410,
      proteinGrams: 20,
      carbsGrams: 52,
      fatsGrams: 14,
      practicalTip: 'A crepioca não gruda se você misturar bem o ovo na tapioca antes de ir para a frigideira.',
    ),
    BrazilianDishOption(
      id: 'cafe_3',
      name: 'Cuscuz Nordestino com Ovos Poché & Queijo Coalho',
      mealType: 'cafe',
      description: 'A força do milho nordestino com proteína completa de ovos e queijo.',
      ingredients: [
        '1 Porção de Cuscuz de milho cozido no vapor (80g floco)',
        '2 Ovos preparados a gosto (fritos na água ou mexidos)',
        '1 Fatia pequena de Queijo Coalho grelhado (25g)',
        'Café com ou sem leite',
      ],
      calories: 390,
      proteinGrams: 23,
      carbsGrams: 48,
      fatsGrams: 12,
      practicalTip: 'O cuscuz é uma fonte limpa de carboidratos complexos de excelente saciedade.',
    ),

    // ==========================================
    // ALMOÇO (LUNCH)
    // ==========================================
    BrazilianDishOption(
      id: 'almoco_1',
      name: 'O Lendário PF Brasileiro (Arroz, Feijão, Frango & Salada)',
      mealType: 'almoco',
      description: 'A base da alimentação brasileira. A combinação perfeita de aminoácidos com o feijão.',
      ingredients: [
        '150g de Arroz branco ou integral (~1 escumadeira e meia)',
        '100g de Feijão carioca com caldo temperado (~1 concha)',
        '160g de Peito de frango grelhado em tiras ou filé',
        'Salada à vontade (alface, tomate, cenoura ralada) com 1 colher de azeite extra virgem',
      ],
      calories: 640,
      proteinGrams: 52,
      carbsGrams: 66,
      fatsGrams: 15,
      practicalTip: 'Não precisa pesar todo dia: a palma da mão equivale a 150g de filé de frango.',
    ),
    BrazilianDishOption(
      id: 'almoco_2',
      name: 'PF com Carne Moída (Patinho), Purê de Mandioca & Feijão Preto',
      mealType: 'almoco',
      description: 'Prato reconfortante, rico em ferro, zinco e carboidratos de alta biodisponibilidade.',
      ingredients: [
        '160g de Carne moída magra (patinho refogado com alho, cebola e cheiro verde)',
        '150g de Purê de mandioca (aipim) ou batata inglesa caseira',
        '90g de Feijão preto temperado com louro (~1 concha rasa)',
        'Legumes cozidos no vapor (brócolis e cenoura) à vontade',
      ],
      calories: 610,
      proteinGrams: 48,
      carbsGrams: 62,
      fatsGrams: 16,
      practicalTip: 'O patinho moído é a carne bovina mais magra e rápida para o dia a dia.',
    ),
    BrazilianDishOption(
      id: 'almoco_3',
      name: 'Macarronada com Frango Desfiado & Molho Caseiro de Tomate',
      mealType: 'almoco',
      description: 'Aquele almoço de domingo que pode ser comido na semana para dar energia aos treinos pesados.',
      ingredients: [
        '180g de Macarrão cozido (espaguete ou penne)',
        '150g de Peito de frango cozido e desfiado no molho de tomate natural',
        '1 Colher de sobremesa de queijo parmesão ralado por cima (10g)',
        'Salada verde de rúcula com tomate cereja',
      ],
      calories: 650,
      proteinGrams: 49,
      carbsGrams: 75,
      fatsGrams: 13,
      practicalTip: 'Excelente opção de almoço para 2 a 3 horas antes de um treino de pernas ou costas.',
    ),
    BrazilianDishOption(
      id: 'almoco_4',
      name: 'Filé de Tilápia com Arroz Branco, Pirão Leve & Salada',
      mealType: 'almoco',
      description: 'Digestão levíssima, excelente para quem não quer ficar com sensação pesada à tarde.',
      ingredients: [
        '180g de Filé de tilápia ou pescada grelhada com limão e ervas',
        '160g de Arroz branco',
        '80g de Pirão caseiro ou feijão de caldo leve',
        'Salada colorida de alface, tomate, palmito e pepino',
      ],
      calories: 560,
      proteinGrams: 47,
      carbsGrams: 58,
      fatsGrams: 11,
      practicalTip: 'O peixe branco é rico em proteína limpa e digere em menos de 2 horas.',
    ),

    // ==========================================
    // LANCHE DA TARDE (AFTERNOON SNACK)
    // ==========================================
    BrazilianDishOption(
      id: 'lanche_1',
      name: 'Vitamina de Banana com Leite, Aveia & Canela',
      mealType: 'lanche',
      description: 'Rápida, doce e energética, elimina a vontade de beliscar doces à tarde.',
      ingredients: [
        '1 Banana prata média',
        '250ml de Leite desnatado gelado',
        '2 Colheres de sopa de farelo de aveia (30g)',
        '1 Scoop de proteína em pó (ou 2 ovos cozidos com sal à parte)',
      ],
      calories: 340,
      proteinGrams: 27,
      carbsGrams: 46,
      fatsGrams: 5,
      practicalTip: 'Adicione canela para ajudar a controlar a glicemia e dar sabor especial.',
    ),
    BrazilianDishOption(
      id: 'lanche_2',
      name: 'Sanduíche Natural de Frango com Pão Integral',
      mealType: 'lanche',
      description: 'Fácil de levar para o trabalho ou faculdade em um pote.',
      ingredients: [
        '2 Fatias de pão 100% integral',
        '110g de Frango desfiado temperado',
        '1 Colher de sopa de ricota cremosa ou requeijão light (20g)',
        'Folhas de alface americana e cenoura ralada',
      ],
      calories: 310,
      proteinGrams: 29,
      carbsGrams: 31,
      fatsGrams: 6,
      practicalTip: 'Deixe o frango desfiado congelado em porções para a semana inteira.',
    ),
    BrazilianDishOption(
      id: 'lanche_3',
      name: 'Tapioca com Ovos Mexidos & Fruta Fresca',
      mealType: 'lanche',
      description: 'Energia limpa para quem treina no final do dia.',
      ingredients: [
        '40g de Goma de tapioca hidratada',
        '2 Ovos inteiros mexidos com pitada de sal e orégano',
        '1 Fatia de melancia ou mamão papaia',
      ],
      calories: 320,
      proteinGrams: 17,
      carbsGrams: 40,
      fatsGrams: 10,
      practicalTip: 'Coma 1h antes do treino para treinar com os estoques de energia cheios.',
    ),

    // ==========================================
    // JANTAR (DINNER)
    // ==========================================
    BrazilianDishOption(
      id: 'jantar_1',
      name: 'PF Noturno Leve (Arroz, Feijão, Frango & Salada Verde)',
      mealType: 'jantar',
      description: 'Sim, você PODE comer arroz e feijão à noite! Excelente para o sono e recuperação.',
      ingredients: [
        '120g de Arroz branco',
        '80g de Feijão carioca (~1 concha média)',
        '150g de Peito de frango grelhado ou sobrecoxa desossada sem pele',
        'Prato farto de salada de alface e tomate com limão e azeite',
      ],
      calories: 520,
      proteinGrams: 47,
      carbsGrams: 52,
      fatsGrams: 13,
      practicalTip: 'O carboidrato do arroz estimula o triptofano, melhorando a qualidade do sono profundo.',
    ),
    BrazilianDishOption(
      id: 'jantar_2',
      name: 'Omelete Recheado de Frigideira com Queijo Branco & Salada',
      mealType: 'jantar',
      description: 'Prato rápido para dias em que você chega cansado da academia e não quer cozinhar.',
      ingredients: [
        '3 Ovos inteiros batidos com orégano e sal',
        '40g de Queijo Minas Frescal ou Ricota picada',
        'Tomate picado e espinafre refogado dentro do omelete',
        '2 Torradas integrais ou 1 porção de abóbora cozida (120g)',
      ],
      calories: 450,
      proteinGrams: 32,
      carbsGrams: 26,
      fatsGrams: 22,
      practicalTip: 'Pronto em 5 minutos! Rico em colina e gorduras boas que auxiliam na produção hormonal.',
    ),
    BrazilianDishOption(
      id: 'jantar_3',
      name: 'Sopa Reconfortante de Legumes com Carne Magra em Cubos',
      mealType: 'jantar',
      description: 'Aconchego e hidratação com alto teor proteico para encerrar o dia.',
      ingredients: [
        '1 Prato fundo de sopa de legumes (abóbora, chuchu, mandioquinha e cenoura)',
        '150g de Carne bovina magra (músculo ou patinho desfiado/cubos)',
        'Cheiro verde e cebolinha picados à vontade',
      ],
      calories: 440,
      proteinGrams: 44,
      carbsGrams: 38,
      fatsGrams: 12,
      practicalTip: 'Ideal para noites frias ou quando você quer uma digestão leve antes de dormir.',
    ),
  ];

  static List<BrazilianDishOption> getDishesForMeal(String mealType) {
    return allDishes.where((d) => d.mealType == mealType).toList();
  }
}
