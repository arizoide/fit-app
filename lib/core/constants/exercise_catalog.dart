class ExerciseDefinition {
  final String id;
  final String name;
  final String muscleGroup;
  final List<String> secondaryMuscles;
  final String equipment;
  final String mechanics; // Composto / Isolado
  final String instructions;
  final List<String> commonMistakes;
  final List<String> substituteIds;
  final String iconPlaceholder;

  const ExerciseDefinition({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.secondaryMuscles,
    required this.equipment,
    required this.mechanics,
    required this.instructions,
    required this.commonMistakes,
    required this.substituteIds,
    this.iconPlaceholder = 'dumbbell',
  });
}

class ExerciseCatalog {
  static const List<ExerciseDefinition> allExercises = [
    // ==========================================
    // PEITO
    // ==========================================
    ExerciseDefinition(
      id: 'chest_bench_press_barbell',
      name: 'Supino Reto com Barra',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Tríceps', 'Deltóide Anterior'],
      equipment: 'Barra',
      mechanics: 'Composto',
      instructions: 'Deite-se no banco, aduza as escápulas, desça a barra controladamente até o terço inferior do esterno e empurre com força.',
      commonMistakes: ['Abrir cotovelos a 90 graus', 'Retirar escápulas do banco', 'Bater a barra no peito'],
      substituteIds: ['chest_bench_press_dumbbell', 'chest_machine_press', 'chest_pushup'],
    ),
    ExerciseDefinition(
      id: 'chest_bench_press_dumbbell',
      name: 'Supino Reto com Halteres',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Tríceps', 'Deltóide Anterior'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Mantenha os cotovelos a cerca de 60 graus do tronco e faça uma amplitude completa de movimento com controle.',
      commonMistakes: ['Bater os halteres no topo', 'Descer rápido demais'],
      substituteIds: ['chest_bench_press_barbell', 'chest_machine_press', 'chest_dumbbell_fly', 'chest_pushup'],
    ),
    ExerciseDefinition(
      id: 'chest_incline_dumbbell_press',
      name: 'Supino Inclinado com Halteres',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Deltóide Anterior', 'Tríceps'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Ajuste o banco em 30 a 45 graus. Concentre o empurrão na porção clavicular do peitoral.',
      commonMistakes: ['Inclinar o banco em excesso (mais de 45°)', 'Hiperestender a lombar'],
      substituteIds: ['chest_incline_smith_press', 'chest_pushup_feet_elevated', 'chest_dumbbell_fly'],
    ),
    ExerciseDefinition(
      id: 'chest_dumbbell_floor_press',
      name: 'Supino no Chão com Halteres (Floor Press)',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Tríceps', 'Deltóide Anterior'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Deite-se no chão, joelhos flexionados. Desça os halteres até os cotovelos tocarem suavemente o solo e empurre.',
      commonMistakes: ['Bater os cotovelos com força no chão'],
      substituteIds: ['chest_pushup', 'chest_bench_press_dumbbell'],
    ),
    ExerciseDefinition(
      id: 'chest_dumbbell_fly',
      name: 'Crucifixo com Halteres no Banco',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Deltóide Anterior'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Cotovelos levemente flexionados, abra os braços em arco sentindo o alongamento peitoral e feche apertando no topo.',
      commonMistakes: ['Flexionar e estender os braços como se fosse supino'],
      substituteIds: ['chest_cable_crossover', 'chest_peck_deck', 'chest_pushup'],
    ),
    ExerciseDefinition(
      id: 'chest_pushup',
      name: 'Flexão de Braços (Push-up)',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Tríceps', 'Core', 'Deltóide Anterior'],
      equipment: 'Peso Corporal',
      mechanics: 'Composto',
      instructions: 'Corpo em linha reta da cabeça aos calcanhares. Desça até o peito quase tocar o chão e empurre com força.',
      commonMistakes: ['Deixar o quadril cair', 'Cotovelos abertos a 90 graus'],
      substituteIds: ['chest_bench_press_dumbbell', 'chest_dumbbell_floor_press'],
    ),
    ExerciseDefinition(
      id: 'chest_pushup_feet_elevated',
      name: 'Flexão Declinada (Pés Elevados no Banco/Cadeira)',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Deltóide Anterior', 'Tríceps'],
      equipment: 'Peso Corporal',
      mechanics: 'Composto',
      instructions: 'Pés apoiados em um banco ou cadeira. Foco intenso na porção superior do peitoral.',
      commonMistakes: ['Arquear excessivamente a lombar'],
      substituteIds: ['chest_incline_dumbbell_press', 'chest_pushup'],
    ),
    ExerciseDefinition(
      id: 'chest_machine_press',
      name: 'Supino na Máquina (Chest Press)',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Tríceps', 'Deltóide Anterior'],
      equipment: 'Máquina',
      mechanics: 'Composto',
      instructions: 'Ajuste o assento para que os apoios fiquem na linha do peitoral médio.',
      commonMistakes: ['Projetar os ombros para frente no final do movimento'],
      substituteIds: ['chest_bench_press_dumbbell', 'chest_bench_press_barbell', 'chest_pushup'],
    ),
    ExerciseDefinition(
      id: 'chest_cable_crossover',
      name: 'Crucifixo no Crossover (Cabos)',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Deltóide Anterior'],
      equipment: 'Cabos',
      mechanics: 'Isolado',
      instructions: 'Mantenha leve flexão nos cotovelos e una as mãos à frente do peito.',
      commonMistakes: ['Usar impulso do tronco'],
      substituteIds: ['chest_peck_deck', 'chest_dumbbell_fly'],
    ),
    ExerciseDefinition(
      id: 'chest_peck_deck',
      name: 'Peck Deck / Voador',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Deltóide Anterior'],
      equipment: 'Máquina',
      mechanics: 'Isolado',
      instructions: 'Mantenha os ombros deprimidos e sinta o alongamento completo no peitoral.',
      commonMistakes: ['Elevar os ombros durante a contração'],
      substituteIds: ['chest_dumbbell_fly', 'chest_cable_crossover'],
    ),
    ExerciseDefinition(
      id: 'chest_incline_smith_press',
      name: 'Supino Inclinado no Smith Machine',
      muscleGroup: 'Peito',
      secondaryMuscles: ['Deltóide Anterior', 'Tríceps'],
      equipment: 'Máquina',
      mechanics: 'Composto',
      instructions: 'Excelente para focar na clavícula com estabilidade guiada.',
      commonMistakes: ['Posicionar o banco muito à frente'],
      substituteIds: ['chest_incline_dumbbell_press', 'chest_bench_press_dumbbell'],
    ),

    // ==========================================
    // COSTAS
    // ==========================================
    ExerciseDefinition(
      id: 'back_dumbbell_row',
      name: 'Remada Unilateral com Halter (Serrote)',
      muscleGroup: 'Costas',
      secondaryMuscles: ['Bíceps', 'Rombóides', 'Deltóide Posterior'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Apoie um joelho e mão no banco/cadeira e puxe o halter rente ao quadril espremendo a dorsal.',
      commonMistakes: ['Girar excessivamente o tronco'],
      substituteIds: ['back_barbell_bent_over_row', 'back_seated_cable_row'],
    ),
    ExerciseDefinition(
      id: 'back_dumbbell_bent_over_row',
      name: 'Remada Curvada com Halteres (Pegada Pronada ou Neutra)',
      muscleGroup: 'Costas',
      secondaryMuscles: ['Bíceps', 'Trapézio', 'Lombar'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Incline o tronco a 45° mantendo coluna reta e puxe os dois halteres em direção ao abdômen.',
      commonMistakes: ['Arredondar a coluna lombar'],
      substituteIds: ['back_dumbbell_row', 'back_barbell_bent_over_row'],
    ),
    ExerciseDefinition(
      id: 'back_pullup',
      name: 'Barra Fixa (Pull-up / Chin-up)',
      muscleGroup: 'Costas',
      secondaryMuscles: ['Bíceps', 'Core', 'Deltóide Posterior'],
      equipment: 'Peso Corporal',
      mechanics: 'Composto',
      instructions: 'Pendure-se na barra e puxe o corpo até o queixo ultrapassar a barra.',
      commonMistakes: ['Balançar o corpo com as pernas'],
      substituteIds: ['back_lat_pulldown', 'back_dumbbell_row'],
    ),
    ExerciseDefinition(
      id: 'back_dumbbell_pullover',
      name: 'Pullover com Halter no Banco',
      muscleGroup: 'Costas',
      secondaryMuscles: ['Peitoral', 'Tríceps Cabeça Longa'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Deitado no banco, segure um halter com ambas as mãos e desça atrás da cabeça alongando a grande dorsal.',
      commonMistakes: ['Dobrar os cotovelos em excesso'],
      substituteIds: ['back_lat_pulldown', 'back_dumbbell_row'],
    ),
    ExerciseDefinition(
      id: 'back_barbell_bent_over_row',
      name: 'Remada Curvada com Barra',
      muscleGroup: 'Costas',
      secondaryMuscles: ['Bíceps', 'Lombar', 'Trapézio'],
      equipment: 'Barra',
      mechanics: 'Composto',
      instructions: 'Incline o tronco a 45°, coluna neutra, e puxe a barra em direção ao umbigo.',
      commonMistakes: ['Arredondar a coluna lombar'],
      substituteIds: ['back_dumbbell_bent_over_row', 'back_seated_cable_row'],
    ),
    ExerciseDefinition(
      id: 'back_lat_pulldown',
      name: 'Puxada Frontal na Polia (Lat Pulldown)',
      muscleGroup: 'Costas',
      secondaryMuscles: ['Bíceps', 'Deltóide Posterior'],
      equipment: 'Cabos',
      mechanics: 'Composto',
      instructions: 'Puxe a barra em direção à parte superior do tórax enquanto retrai as escápulas.',
      commonMistakes: ['Inclinar o tronco excessivamente para trás'],
      substituteIds: ['back_pullup', 'back_dumbbell_row'],
    ),
    ExerciseDefinition(
      id: 'back_seated_cable_row',
      name: 'Remada Baixa no Cabo (Seated Row)',
      muscleGroup: 'Costas',
      secondaryMuscles: ['Bíceps', 'Rombóides', 'Trapézio'],
      equipment: 'Cabos',
      mechanics: 'Composto',
      instructions: 'Mantenha o peito aberto e puxe o triângulo contra o abdômen.',
      commonMistakes: ['Balançar o tronco'],
      substituteIds: ['back_dumbbell_row', 'back_dumbbell_bent_over_row'],
    ),
    ExerciseDefinition(
      id: 'back_facepull',
      name: 'Face Pull na Polia',
      muscleGroup: 'Costas',
      secondaryMuscles: ['Deltóide Posterior', 'Manguito Rotador'],
      equipment: 'Cabos',
      mechanics: 'Isolado',
      instructions: 'Puxe a corda em direção à testa realizando rotação externa dos ombros.',
      commonMistakes: ['Usar carga excessiva'],
      substituteIds: ['shoulders_rear_delt_dumbbell_fly', 'shoulders_reverse_pec_deck'],
    ),

    // ==========================================
    // PERNAS & QUADRÍCEPS
    // ==========================================
    ExerciseDefinition(
      id: 'legs_bulgarian_split_squat',
      name: 'Agachamento Búlgaro com Halteres',
      muscleGroup: 'Pernas',
      secondaryMuscles: ['Glúteos', 'Core'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Um pé apoiado atrás em um banco ou cadeira. Desça até a coxa da frente ficar paralela ao chão e suba empurrando pelo calcanhar.',
      commonMistakes: ['Passada muito curta ou muito longa'],
      substituteIds: ['legs_dumbbell_lunges', 'legs_goblet_squat', 'legs_barbell_squat'],
    ),
    ExerciseDefinition(
      id: 'legs_goblet_squat',
      name: 'Agachamento Goblet com Halter',
      muscleGroup: 'Pernas',
      secondaryMuscles: ['Glúteos', 'Core'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Segure um halter junto ao peito. Agache com os joelhos acompanhando a ponta dos pés mantendo a coluna ereta.',
      commonMistakes: ['Deixar o tronco despencar para frente'],
      substituteIds: ['legs_barbell_squat', 'legs_bulgarian_split_squat', 'legs_bodyweight_squat'],
    ),
    ExerciseDefinition(
      id: 'legs_dumbbell_lunges',
      name: 'Passada / Afundo com Halteres',
      muscleGroup: 'Pernas',
      secondaryMuscles: ['Glúteos', 'Isquiotibiais'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Dê um passo à frente e flexione ambos os joelhos a 90°. Retorne à posição inicial.',
      commonMistakes: ['Bater o joelho de trás no chão'],
      substituteIds: ['legs_bulgarian_split_squat', 'legs_goblet_squat'],
    ),
    ExerciseDefinition(
      id: 'legs_bodyweight_squat',
      name: 'Agachamento Livre com Peso do Corpo (Air Squat)',
      muscleGroup: 'Pernas',
      secondaryMuscles: ['Glúteos', 'Core'],
      equipment: 'Peso Corporal',
      mechanics: 'Composto',
      instructions: 'Pés na largura dos ombros, agache empurrando os joelhos para fora com controle e suba contraindo as pernas.',
      commonMistakes: ['Tirar os calcanhares do chão'],
      substituteIds: ['legs_goblet_squat', 'legs_bulgarian_split_squat'],
    ),
    ExerciseDefinition(
      id: 'legs_barbell_squat',
      name: 'Agachamento Livre com Barra',
      muscleGroup: 'Pernas',
      secondaryMuscles: ['Glúteos', 'Core'],
      equipment: 'Barra',
      mechanics: 'Composto',
      instructions: 'Barra no trapézio, desça com coluna alinhada e empurre pelo meio do pé.',
      commonMistakes: ['Valgo dinâmico dos joelhos', 'Arredondar a lombar'],
      substituteIds: ['legs_goblet_squat', 'legs_bulgarian_split_squat', 'legs_leg_press_45'],
    ),
    ExerciseDefinition(
      id: 'legs_leg_press_45',
      name: 'Leg Press 45°',
      muscleGroup: 'Pernas',
      secondaryMuscles: ['Glúteos'],
      equipment: 'Máquina',
      mechanics: 'Composto',
      instructions: 'Pés no centro da plataforma. Desça até 90° sem levantar a lombar do apoio.',
      commonMistakes: ['Travar joelhos no topo'],
      substituteIds: ['legs_goblet_squat', 'legs_bulgarian_split_squat'],
    ),
    ExerciseDefinition(
      id: 'legs_hack_squat',
      name: 'Agachamento Hack Machine',
      muscleGroup: 'Pernas',
      secondaryMuscles: ['Glúteos'],
      equipment: 'Máquina',
      mechanics: 'Composto',
      instructions: 'Costas apoiadas no encosto para isolamento de quadríceps.',
      commonMistakes: ['Descolar o quadril do encosto'],
      substituteIds: ['legs_goblet_squat', 'legs_bulgarian_split_squat'],
    ),
    ExerciseDefinition(
      id: 'legs_leg_extension',
      name: 'Cadeira Extensora',
      muscleGroup: 'Pernas',
      secondaryMuscles: ['Reto Femoral'],
      equipment: 'Máquina',
      mechanics: 'Isolado',
      instructions: 'Estenda os joelhos até a contração máxima e pause 1 segundo no topo.',
      commonMistakes: ['Chutar o peso sem controle'],
      substituteIds: ['legs_goblet_squat', 'legs_bulgarian_split_squat'],
    ),

    // ==========================================
    // ISQUIOTIBIAIS & GLÚTEOS
    // ==========================================
    ExerciseDefinition(
      id: 'legs_dumbbell_romanian_deadlift',
      name: 'Stiff com Halteres (RDL)',
      muscleGroup: 'Isquiotibiais',
      secondaryMuscles: ['Glúteos', 'Lombar'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Joelhos levemente destravados, empurre o quadril para trás mantendo halteres colados nas pernas até sentir o alongamento da posterior.',
      commonMistakes: ['Curvar a coluna dorsal/lombar'],
      substituteIds: ['legs_romanian_deadlift', 'legs_single_leg_dumbbell_rdl'],
    ),
    ExerciseDefinition(
      id: 'legs_single_leg_dumbbell_rdl',
      name: 'Stiff Unilateral com Halter (Single Leg RDL)',
      muscleGroup: 'Isquiotibiais',
      secondaryMuscles: ['Glúteos', 'Equilíbrio'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Em apoio sobre uma perna, projete a outra perna para trás alinhada ao tronco e desça o halter.',
      commonMistakes: ['Girar a bacia para o lado'],
      substituteIds: ['legs_dumbbell_romanian_deadlift'],
    ),
    ExerciseDefinition(
      id: 'legs_dumbbell_hip_thrust',
      name: 'Elevação Pélvica com Halter no Banco ou Chão',
      muscleGroup: 'Glúteos',
      secondaryMuscles: ['Isquiotibiais'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Escápulas no banco ou deitado no chão, halter sobre a bacia, empurre pelos calcanhares apertando os glúteos no topo.',
      commonMistakes: ['Hiperestender a lombar'],
      substituteIds: ['legs_hip_thrust', 'legs_dumbbell_romanian_deadlift'],
    ),
    ExerciseDefinition(
      id: 'legs_romanian_deadlift',
      name: 'Stiff / RDL com Barra',
      muscleGroup: 'Isquiotibiais',
      secondaryMuscles: ['Glúteos', 'Lombar'],
      equipment: 'Barra',
      mechanics: 'Composto',
      instructions: 'Flexione levemente os joelhos e empurre o quadril para trás com a barra rente às pernas.',
      commonMistakes: ['Curvar as costas'],
      substituteIds: ['legs_dumbbell_romanian_deadlift', 'legs_seated_leg_curl'],
    ),
    ExerciseDefinition(
      id: 'legs_lying_leg_curl',
      name: 'Mesa Flexora',
      muscleGroup: 'Isquiotibiais',
      secondaryMuscles: [],
      equipment: 'Máquina',
      mechanics: 'Isolado',
      instructions: 'Deitado de bruços, flexione as pernas trazendo a almofada em direção aos glúteos.',
      commonMistakes: ['Elevar o quadril da mesa'],
      substituteIds: ['legs_dumbbell_romanian_deadlift', 'legs_seated_leg_curl'],
    ),
    ExerciseDefinition(
      id: 'legs_seated_leg_curl',
      name: 'Cadeira Flexora',
      muscleGroup: 'Isquiotibiais',
      secondaryMuscles: [],
      equipment: 'Máquina',
      mechanics: 'Isolado',
      instructions: 'Excelente tensão em posição de alongamento dos isquiotibiais.',
      commonMistakes: ['Não travar o apoio sobre as coxas'],
      substituteIds: ['legs_dumbbell_romanian_deadlift', 'legs_lying_leg_curl'],
    ),
    ExerciseDefinition(
      id: 'legs_hip_thrust',
      name: 'Elevação Pélvica com Barra',
      muscleGroup: 'Glúteos',
      secondaryMuscles: ['Isquiotibiais'],
      equipment: 'Barra',
      mechanics: 'Composto',
      instructions: 'Costas apoiadas no banco, barra sobre o quadril, empurre pelo calcanhar contraindo os glúteos no topo.',
      commonMistakes: ['Hiperextender a lombar'],
      substituteIds: ['legs_dumbbell_hip_thrust', 'legs_dumbbell_romanian_deadlift'],
    ),

    // ==========================================
    // OMBROS
    // ==========================================
    ExerciseDefinition(
      id: 'shoulders_overhead_dumbbell_press',
      name: 'Desenvolvimento com Halteres Sentado ou em Pé',
      muscleGroup: 'Ombros',
      secondaryMuscles: ['Tríceps', 'Trapézio'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Empurre os halteres para cima sem bater no topo e desça controlando até a linha do queixo.',
      commonMistakes: ['Descer com os cotovelos muito para trás', 'Arquear a lombar'],
      substituteIds: ['shoulders_arnold_press', 'shoulders_lateral_raise_dumbbell'],
    ),
    ExerciseDefinition(
      id: 'shoulders_arnold_press',
      name: 'Desenvolvimento Arnold com Halteres',
      muscleGroup: 'Ombros',
      secondaryMuscles: ['Tríceps', 'Deltóide Anterior/Lateral'],
      equipment: 'Halteres',
      mechanics: 'Composto',
      instructions: 'Inicie com as palmas voltadas para o rosto e vá rotacionando os braços para fora enquanto empurra para cima.',
      commonMistakes: ['Movimento brusco sem rotação suave'],
      substituteIds: ['shoulders_overhead_dumbbell_press', 'shoulders_lateral_raise_dumbbell'],
    ),
    ExerciseDefinition(
      id: 'shoulders_lateral_raise_dumbbell',
      name: 'Elevação Lateral com Halteres',
      muscleGroup: 'Ombros',
      secondaryMuscles: ['Trapézio'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Incline o tronco minimamente à frente e eleve os braços no plano escapular até a altura dos ombros.',
      commonMistakes: ['Usar impulso das pernas', 'Encolher os ombros'],
      substituteIds: ['shoulders_cable_lateral_raise', 'shoulders_overhead_dumbbell_press'],
    ),
    ExerciseDefinition(
      id: 'shoulders_rear_delt_dumbbell_fly',
      name: 'Crucifixo Invertido com Halteres Curvado',
      muscleGroup: 'Ombros',
      secondaryMuscles: ['Rombóides', 'Trapézio'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Tronco inclinado para frente a 45°, abra os braços para os lados focando na porção posterior dos ombros.',
      commonMistakes: ['Usar impulso da coluna'],
      substituteIds: ['back_facepull', 'shoulders_reverse_pec_deck'],
    ),
    ExerciseDefinition(
      id: 'shoulders_cable_lateral_raise',
      name: 'Elevação Lateral na Polia Baixa',
      muscleGroup: 'Ombros',
      secondaryMuscles: ['Trapézio'],
      equipment: 'Cabos',
      mechanics: 'Isolado',
      instructions: 'Tensão constante em toda a amplitude de movimento.',
      commonMistakes: ['Girar o tronco'],
      substituteIds: ['shoulders_lateral_raise_dumbbell'],
    ),
    ExerciseDefinition(
      id: 'shoulders_reverse_pec_deck',
      name: 'Crucifixo Invertido no Voador (Deltóide Posterior)',
      muscleGroup: 'Ombros',
      secondaryMuscles: ['Rombóides', 'Trapézio'],
      equipment: 'Máquina',
      mechanics: 'Isolado',
      instructions: 'Peito apoiado no encosto, abra os braços mantendo leve flexão nos cotovelos.',
      commonMistakes: ['Aduzir escápulas antes de ativar o ombro'],
      substituteIds: ['shoulders_rear_delt_dumbbell_fly', 'back_facepull'],
    ),

    // ==========================================
    // BÍCEPS & BRAÇOS
    // ==========================================
    ExerciseDefinition(
      id: 'arms_dumbbell_biceps_curl',
      name: 'Rosca Direta Alternada com Halteres',
      muscleGroup: 'Bíceps',
      secondaryMuscles: ['Braquial', 'Antebraço'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Em pé ou sentado, flexione os antebraços supinando os punhos e contraindo o bíceps no topo.',
      commonMistakes: ['Balançar o corpo'],
      substituteIds: ['arms_dumbbell_hammer_curl', 'arms_concentration_curl', 'arms_barbell_biceps_curl'],
    ),
    ExerciseDefinition(
      id: 'arms_dumbbell_hammer_curl',
      name: 'Rosca Martelo com Halteres',
      muscleGroup: 'Bíceps',
      secondaryMuscles: ['Braquial', 'Braquiorradial'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Palmas das mãos voltadas uma para a outra. Excelente para espessura do braço e antebraço.',
      commonMistakes: ['Girar os punhos'],
      substituteIds: ['arms_dumbbell_biceps_curl', 'arms_concentration_curl'],
    ),
    ExerciseDefinition(
      id: 'arms_concentration_curl',
      name: 'Rosca Concentrada com Halter',
      muscleGroup: 'Bíceps',
      secondaryMuscles: ['Braquial'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Sentado, cotovelo apoiado na parte interna da coxa, flexione o braço com isolamento absoluto.',
      commonMistakes: ['Mover o tronco durante a subida'],
      substituteIds: ['arms_dumbbell_biceps_curl', 'arms_dumbbell_incline_curl'],
    ),
    ExerciseDefinition(
      id: 'arms_dumbbell_incline_curl',
      name: 'Rosca Inclinada com Halteres no Banco 45°',
      muscleGroup: 'Bíceps',
      secondaryMuscles: ['Braquial'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Alongamento máximo da cabeça longa do bíceps no início do movimento.',
      commonMistakes: ['Tirar os ombros do banco'],
      substituteIds: ['arms_dumbbell_biceps_curl', 'arms_barbell_biceps_curl'],
    ),
    ExerciseDefinition(
      id: 'arms_barbell_biceps_curl',
      name: 'Rosca Direta com Barra',
      muscleGroup: 'Bíceps',
      secondaryMuscles: ['Braquiorradial'],
      equipment: 'Barra',
      mechanics: 'Isolado',
      instructions: 'Cotovelos fixos ao lado do corpo, flexione os antebraços e desça controlando.',
      commonMistakes: ['Balançar o tronco'],
      substituteIds: ['arms_dumbbell_biceps_curl', 'arms_dumbbell_hammer_curl'],
    ),

    // ==========================================
    // TRÍCEPS
    // ==========================================
    ExerciseDefinition(
      id: 'arms_overhead_dumbbell_extension',
      name: 'Tríceps Francês com Halter (Unilateral ou Bilateral)',
      muscleGroup: 'Tríceps',
      secondaryMuscles: ['Ombros'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Braço estendido para cima, desça o halter atrás da cabeça alongando a cabeça longa do tríceps e estenda.',
      commonMistakes: ['Abrir excessivamente o cotovelo'],
      substituteIds: ['arms_bench_dips', 'arms_skull_crusher_dumbbell', 'arms_cable_triceps_pushdown'],
    ),
    ExerciseDefinition(
      id: 'arms_skull_crusher_dumbbell',
      name: 'Tríceps Testa com Halteres no Banco ou Chão',
      muscleGroup: 'Tríceps',
      secondaryMuscles: ['Ombros'],
      equipment: 'Halteres',
      mechanics: 'Isolado',
      instructions: 'Deitado, segure os halteres com palmas neutras, flexione os cotovelos trazendo até a linha das orelhas e estenda.',
      commonMistakes: ['Mover o braço para frente e trás'],
      substituteIds: ['arms_overhead_dumbbell_extension', 'arms_bench_dips'],
    ),
    ExerciseDefinition(
      id: 'arms_bench_dips',
      name: 'Tríceps Mergulho no Banco ou Cadeira (Bench Dips)',
      muscleGroup: 'Tríceps',
      secondaryMuscles: ['Peitoral', 'Deltóide Anterior'],
      equipment: 'Peso Corporal',
      mechanics: 'Composto',
      instructions: 'Mãos apoiadas na borda do banco/cadeira atrás de você, pernas estendidas à frente. Desça até 90° e empurre.',
      commonMistakes: ['Afastar o corpo excessivamente do banco'],
      substituteIds: ['arms_overhead_dumbbell_extension', 'arms_skull_crusher_dumbbell'],
    ),
    ExerciseDefinition(
      id: 'arms_cable_triceps_pushdown',
      name: 'Tríceps na Polia com Barra ou Corda',
      muscleGroup: 'Tríceps',
      secondaryMuscles: [],
      equipment: 'Cabos',
      mechanics: 'Isolado',
      instructions: 'Cotovelos grudados na lateral do corpo, estenda totalmente os antebraços para baixo.',
      commonMistakes: ['Deixar os cotovelos subirem junto'],
      substituteIds: ['arms_overhead_dumbbell_extension', 'arms_bench_dips'],
    ),

    // ==========================================
    // PANTURRILHA & ABDÔMEN
    // ==========================================
    ExerciseDefinition(
      id: 'calves_single_leg_calf_raise_step',
      name: 'Panturrilha Unilateral em Degrau (com Halter ou Peso do Corpo)',
      muscleGroup: 'Panturrilhas',
      secondaryMuscles: [],
      equipment: 'Peso Corporal',
      mechanics: 'Isolado',
      instructions: 'Na ponta de um degrau, desça o calcanhar alongando profundamente e suba até a ponta do pé segurando 1s no pico.',
      commonMistakes: ['Movimento rápido sem pausa'],
      substituteIds: ['calves_standing_calf_raise'],
    ),
    ExerciseDefinition(
      id: 'calves_standing_calf_raise',
      name: 'Panturrilha em Pé na Máquina / Smith',
      muscleGroup: 'Panturrilhas',
      secondaryMuscles: [],
      equipment: 'Máquina',
      mechanics: 'Isolado',
      instructions: 'Alongamento profundo embaixo, pause 1 segundo e suba na ponta dos pés.',
      commonMistakes: ['Pular sem controlar'],
      substituteIds: ['calves_single_leg_calf_raise_step'],
    ),
    ExerciseDefinition(
      id: 'shoulders_pike_pushup',
      name: 'Flexão Pike no Solo (Pike Push-up)',
      muscleGroup: 'Ombros',
      secondaryMuscles: ['Tríceps', 'Trapézio'],
      equipment: 'Peso Corporal',
      mechanics: 'Composto',
      instructions: 'Em posição de V invertido com o quadril elevado, desça a cabeça em direção ao chão e empurre com os ombros.',
      commonMistakes: ['Abrir os cotovelos em excesso'],
      substituteIds: ['shoulders_overhead_dumbbell_press', 'chest_pushup'],
    ),
    ExerciseDefinition(
      id: 'back_inverted_row',
      name: 'Remada Invertida (Australian Pull-up)',
      muscleGroup: 'Costas',
      secondaryMuscles: ['Bíceps', 'Deltóide Posterior'],
      equipment: 'Peso Corporal',
      mechanics: 'Composto',
      instructions: 'Sob uma barra baixa ou mesa firme, puxe o peito contra o apoio mantendo o corpo reto.',
      commonMistakes: ['Deixar o quadril ceder'],
      substituteIds: ['back_pullup', 'back_dumbbell_row'],
    ),
    ExerciseDefinition(
      id: 'legs_bodyweight_single_leg_glute_bridge',
      name: 'Elevação Pélvica Unilateral no Solo',
      muscleGroup: 'Glúteos',
      secondaryMuscles: ['Isquiotibiais'],
      equipment: 'Peso Corporal',
      mechanics: 'Isolado',
      instructions: 'Deitado no chão, uma perna estendida para cima, empurre com o calcanhar da perna de apoio contraindo glúteos.',
      commonMistakes: ['Hiperestender a lombar'],
      substituteIds: ['legs_dumbbell_hip_thrust', 'legs_bodyweight_squat'],
    ),
    ExerciseDefinition(
      id: 'arms_chinup',
      name: 'Barra Fixa Supinada (Chin-up)',
      muscleGroup: 'Bíceps',
      secondaryMuscles: ['Costas'],
      equipment: 'Peso Corporal',
      mechanics: 'Composto',
      instructions: 'Pegada com as palmas voltadas para você, puxe até o queixo passar da barra com foco no bíceps.',
      commonMistakes: ['Balançar com as pernas'],
      substituteIds: ['arms_dumbbell_biceps_curl', 'back_pullup'],
    ),
    ExerciseDefinition(
      id: 'core_plank',
      name: 'Prancha Abdominal Isométrica (Plank)',
      muscleGroup: 'Abdômen',
      secondaryMuscles: ['Core', 'Ombros', 'Glúteos'],
      equipment: 'Peso Corporal',
      mechanics: 'Isolado',
      instructions: 'Apoie os antebraços e pontas dos pés no chão. Mantenha o abdômen e glúteos travados em linha reta.',
      commonMistakes: ['Deixar o quadril cair ou empinar'],
      substituteIds: ['core_crunch', 'core_lying_leg_raise'],
    ),
    ExerciseDefinition(
      id: 'core_crunch',
      name: 'Abdominal Supra no Solo (Crunch)',
      muscleGroup: 'Abdômen',
      secondaryMuscles: [],
      equipment: 'Peso Corporal',
      mechanics: 'Isolado',
      instructions: 'Deite-se no chão com joelhos flexionados, eleve as escápulas do solo contraindo o abdômen superior.',
      commonMistakes: ['Puxar a cabeça com as mãos forçando o pescoço'],
      substituteIds: ['core_plank', 'core_lying_leg_raise'],
    ),
    ExerciseDefinition(
      id: 'core_lying_leg_raise',
      name: 'Elevação de Pernas no Solo (Leg Raise)',
      muscleGroup: 'Abdômen',
      secondaryMuscles: ['Flexores do Quadril'],
      equipment: 'Peso Corporal',
      mechanics: 'Isolado',
      instructions: 'Deitado de costas, mãos sob os glúteos, eleve as pernas estendidas até 90° e desça controladamente.',
      commonMistakes: ['Descolar a lombar do solo'],
      substituteIds: ['core_plank', 'core_crunch'],
    ),
    ExerciseDefinition(
      id: 'core_hanging_leg_raise',
      name: 'Elevação de Pernas na Barra Fixa',
      muscleGroup: 'Abdômen',
      secondaryMuscles: ['Flexores de Quadril'],
      equipment: 'Peso Corporal',
      mechanics: 'Isolado',
      instructions: 'Eleve os joelhos ou pernas estendidas enrolando a pelve.',
      commonMistakes: ['Balançar o corpo'],
      substituteIds: ['core_lying_leg_raise', 'core_crunch'],
    ),
    // ==========================================
    // CARDIO & AERÓBICO
    // ==========================================
    ExerciseDefinition(
      id: 'cardio_incline_treadmill',
      name: 'Esteira Inclinada (LISS Zona 2)',
      muscleGroup: 'Cardiovascular',
      secondaryMuscles: ['Panturrilha', 'Glúteos', 'Quadríceps'],
      equipment: 'Esteira',
      mechanics: 'Composto',
      instructions: 'Caminhe com inclinação de 4% a 8% e velocidade de 5.0 a 6.0 km/h. Mantenha os batimentos em Zona 2 (120-135 bpm) sem segurar nas barras laterais.',
      commonMistakes: ['Segurar com força no painel reduzindo o gasto energético', 'Passadas pesadas com impacto no calcanhar', 'Postura curvada para frente'],
      substituteIds: ['cardio_stairmaster', 'cardio_stationary_bike', 'cardio_elliptical', 'cardio_outdoor_walk'],
      iconPlaceholder: 'treadmill',
    ),
    ExerciseDefinition(
      id: 'cardio_stairmaster',
      name: 'Simulador de Escada (Stairmaster)',
      muscleGroup: 'Cardiovascular',
      secondaryMuscles: ['Glúteos', 'Quadríceps', 'Panturrilhas'],
      equipment: 'Simulador de Escada',
      mechanics: 'Composto',
      instructions: 'Suba os degraus em ritmo contínuo (50-70 passos/min). Pise com o pé inteiro no degrau e mantenha o tronco ereto.',
      commonMistakes: ['Debruçar os cotovelos sobre o painel', 'Pisar apenas com a ponta dos pés sobrecarregando a fáscia plantar'],
      substituteIds: ['cardio_incline_treadmill', 'cardio_stationary_bike', 'cardio_elliptical'],
      iconPlaceholder: 'stairs',
    ),
    ExerciseDefinition(
      id: 'cardio_stationary_bike',
      name: 'Bicicleta Ergométrica / Spinning',
      muscleGroup: 'Cardiovascular',
      secondaryMuscles: ['Quadríceps', 'Isquiotibiais'],
      equipment: 'Bicicleta Ergométrica',
      mechanics: 'Composto',
      instructions: 'Ajuste o selim na altura do quadril. Mantenha cadência de 75 a 90 RPM com resistência moderada para fluidez cardiovascular.',
      commonMistakes: ['Banco muito baixo provocando dor femoropatelar', 'Tensionar os ombros e pescoço no guidão'],
      substituteIds: ['cardio_incline_treadmill', 'cardio_elliptical', 'cardio_stairmaster'],
      iconPlaceholder: 'bike',
    ),
    ExerciseDefinition(
      id: 'cardio_elliptical',
      name: 'Elíptico / Transport',
      muscleGroup: 'Cardiovascular',
      secondaryMuscles: ['Dorsal', 'Peitoral', 'Pernas'],
      equipment: 'Elíptico',
      mechanics: 'Composto',
      instructions: 'Movimente pés e manoplas em sincronia fluida. Excelente opção de zero impacto articular nos joelhos e quadris.',
      commonMistakes: ['Girar os pés para fora', 'Não engajar os braços'],
      substituteIds: ['cardio_incline_treadmill', 'cardio_stationary_bike'],
      iconPlaceholder: 'elliptical',
    ),
    ExerciseDefinition(
      id: 'cardio_jump_rope',
      name: 'Pular Corda (Speed Rope)',
      muscleGroup: 'Cardiovascular',
      secondaryMuscles: ['Panturrilhas', 'Ombros', 'Core'],
      equipment: 'Corda de Pular',
      mechanics: 'Composto',
      instructions: 'Pule suavemente sobre as pontas dos pés, mantendo joelhos relaxados e girando a corda primariamente com os punhos.',
      commonMistakes: ['Pular alto demais gerando impacto desnecessário', 'Girar com o braço inteiro ao invés do punho'],
      substituteIds: ['cardio_outdoor_walk', 'cardio_incline_treadmill'],
      iconPlaceholder: 'rope',
    ),
    ExerciseDefinition(
      id: 'cardio_outdoor_walk',
      name: 'Caminhada Rápida / Trote ao Ar Livre',
      muscleGroup: 'Cardiovascular',
      secondaryMuscles: ['Panturrilhas', 'Glúteos', 'Core'],
      equipment: 'Peso Corporal',
      mechanics: 'Composto',
      instructions: 'Mantenha ritmo acelerado contínuo (5.5 a 6.5 km/h) com respiração ritmada e postura alinhada.',
      commonMistakes: ['Passadas irregulares', 'Olhar para o chão curvando a cervical'],
      substituteIds: ['cardio_jump_rope', 'cardio_incline_treadmill'],
      iconPlaceholder: 'walk',
    ),
  ];

  static ExerciseDefinition? findById(String id) {
    try {
      return allExercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  static bool isHomeEquipment(String equipment) {
    return equipment == 'Halteres' || equipment == 'Peso Corporal';
  }

  static bool isBodyweightEquipment(String equipment) {
    return equipment == 'Peso Corporal';
  }

  static ExerciseDefinition getHomeFallbackExercise(String muscleGroup, {bool bodyweightOnly = false}) {
    final filtered = allExercises.where((e) {
      if (bodyweightOnly) {
        return e.muscleGroup.toLowerCase() == muscleGroup.toLowerCase() && isBodyweightEquipment(e.equipment);
      }
      return e.muscleGroup.toLowerCase() == muscleGroup.toLowerCase() && isHomeEquipment(e.equipment);
    }).toList();

    if (filtered.isNotEmpty) {
      return filtered.first;
    }

    // Default universal home fallback
    return bodyweightOnly
        ? (findById('chest_pushup') ?? allExercises.first)
        : (findById('chest_bench_press_dumbbell') ?? allExercises.first);
  }

  static List<ExerciseDefinition> getSubstitutes(String exerciseId, {String? locationFilter}) {
    final original = findById(exerciseId);
    if (original == null) return [];

    List<ExerciseDefinition> results = [];
    for (final subId in original.substituteIds) {
      final sub = findById(subId);
      if (sub != null) {
        if (locationFilter == 'homeGym' && !isHomeEquipment(sub.equipment)) {
          continue;
        }
        if (locationFilter == 'bodyweightOnly' && !isBodyweightEquipment(sub.equipment)) {
          continue;
        }
        results.add(sub);
      }
    }

    if (results.length < 3) {
      for (final e in allExercises) {
        if (e.muscleGroup.toLowerCase() == original.muscleGroup.toLowerCase() &&
            e.id != original.id &&
            !results.any((r) => r.id == e.id)) {
          if (locationFilter == 'homeGym' && !isHomeEquipment(e.equipment)) {
            continue;
          }
          if (locationFilter == 'bodyweightOnly' && !isBodyweightEquipment(e.equipment)) {
            continue;
          }
          results.add(e);
          if (results.length >= 4) break;
        }
      }
    }
    return results;
  }

  static List<ExerciseDefinition> getExercisesForMuscle(String muscleName, {String? locationFilter}) {
    final query = muscleName.toLowerCase().trim();
    
    // Normalization mapping
    final synonyms = <String, List<String>>{
      'peito': ['peito', 'peitoral', 'chest'],
      'ombros': ['ombros', 'ombro', 'deltóide', 'deltóides', 'deltoides', 'shoulders'],
      'costas': ['costas', 'dorsal', 'dorsais', 'lats', 'costa', 'lombar'],
      'bíceps': ['bíceps', 'biceps', 'braquial'],
      'tríceps': ['tríceps', 'triceps'],
      'pernas': ['pernas', 'quadríceps', 'quadriceps', 'coxa', 'coxas', 'legs'],
      'quadríceps': ['quadríceps', 'quadriceps', 'pernas', 'coxa', 'legs'],
      'isquiotibiais': ['isquiotibiais', 'posterior de coxa', 'posterior', 'hamstrings'],
      'glúteos': ['glúteos', 'gluteos', 'glúteo', 'gluteo', 'glutes'],
      'panturrilhas': ['panturrilhas', 'panturrilha', 'gêmeos', 'calves'],
      'abdômen': ['abdômen', 'abdomen', 'abdominal', 'core', 'abs'],
      'trapézio': ['trapézio', 'trapezio', 'traps'],
      'antebraços': ['antebraços', 'antebraco', 'antebraço', 'forearms'],
    };

    List<String> targetTerms = [query];
    for (final entry in synonyms.entries) {
      if (entry.key == query || entry.value.contains(query)) {
        targetTerms = entry.value;
        break;
      }
    }

    final matches = allExercises.where((e) {
      final mg = e.muscleGroup.toLowerCase();
      final sec = e.secondaryMuscles.map((m) => m.toLowerCase()).toList();
      
      bool isMatch = targetTerms.any((term) => mg.contains(term) || term.contains(mg));
      if (!isMatch) {
        isMatch = targetTerms.any((term) => sec.any((s) => s.contains(term) || term.contains(s)));
      }

      if (!isMatch) return false;

      if (locationFilter == 'homeGym' && !isHomeEquipment(e.equipment)) {
        return false;
      }
      if (locationFilter == 'bodyweightOnly' && !isBodyweightEquipment(e.equipment)) {
        return false;
      }
      return true;
    }).toList();

    return matches;
  }
}
