# 🏋️ FitMorph AI — Ecossistema Inteligente de Treino & Nutrição

> **FitMorph AI** é uma plataforma moderna desenvolvida em **Flutter 3.x** e **Riverpod 2.x**, desenhada sob os mais rigorosos padrões de engenharia de software e princípios biomecânicos. O aplicativo elimina a ansiedade de academia para iniciantes e fornece ferramentas de alta precisão para atletas avançados.

---

## 🌟 Principais Recursos & Inovações

### 1. 🤖 Geração Inteligente de Treinos (Anamnese Adaptativa)
- **Adaptação Biomecânica a Lesões**: Filtra exercícios contraindicados para dores em ombros, joelhos e coluna lombar.
- **Alternância de Cenário**: Suporte completo a **Academia Comercial** (máquinas, polias e barras olímpicas) e **Home Gym** (halteres, elásticos e peso corporal).
- **Modo Treino Express ("Pouco Tempo")**: Compacta o treino do dia para 15 minutos em dias corridos, preservando os exercícios compostos essenciais.
- **Substituição Inteligente de Aparelhos**: Troque aparelhos ocupados ou indisponíveis com 1 toque por variações com a mesma curva de ativação muscular.

### 2. 🔰 Acolhimento & Segurança para Iniciantes
- **Dicionário Rápido de RPE & RIR**: Balão interativo que desmistifica jargões com a regra de ouro: *"Pare a série quando sentir que aguentaria só mais 2 repetições"*.
- **Sugestão de Carga para o 1º Dia**: Recomendações seguras em cada exercício (ex: barra olímpica vazia de 20kg, halteres de 2 a 4kg, 2 placas em polias).
- **Calculadora Visual de Anilhas**: Identificação colorida das anilhas para barras de 20kg, eliminando contas de cabeça e o medo de errar a carga.
- **Guia Postural & Execução**: Erros mais comuns, regulagem de banco e visualização do músculo-alvo.

### 3. 🍲 Nutrição Realista com Pratos Caseiros Brasileiros
- **Cálculo Científico de TDEE & Macros**: Fórmulas validadas para ganho de massa, manutenção ou definição.
- **Catálogo de Pratos Prontos**: Sugestões de refeições com comida de verdade brasileira (Arroz, Feijão Carioca, Frango Grelhado, Carne Moída de Patinho com Purê de Mandioca, Tapioca com Queijo Branco e Cuscuz Nordestino) com medidas práticas em conchas e escumadeiras.

### 4. 🏆 Gamificação & Incentivo Anti-Desistência
- **Ranking da Academia**: Classificação mensal, geral e streak de consistência.
- **Ranking Exclusivo de Caminhada na Esteira por Tempo**: Cardio inclusivo e acolhedor medido em minutos acumulados.
- **Badges de Retomada ("Fênix de Ferro" & "A Volta por Cima")**: Acolhimento sem culpa nem julgamentos para membros que faltam alguns dias e decidem retomar a rotina.

---

## 🎨 Design System: Nordic Ice White

O FitMorph AI adota uma estética limpa, moderna e energizante:
- **Background**: Branco Gelo (`#F4F7FB`) e superfícies brancas puras (`#FFFFFF`).
- **Tipografia**: Outfit & Plus Jakarta Sans em tons Slate (`#0F172A`).
- **Acentos Energéticos**: Verde Neon (`#00C853`) e Ciano Elétrico (`#0284C7`).
- **Acessibilidade**: Áreas de toque otimizadas (≥48x48dp) e ação principal no topo sem necessidade de scroll.

---

## 🛡️ Engenharia & Portões de Qualidade (Zero-Defect Quality Gates)

O projeto adota política de **defeito zero**:
- **Testes Automatizados**: 100% de cobertura nos fluxos críticos (34+ testes unitários e de widgets).
- **Análise Estática**: `flutter analyze` sem nenhum aviso (`0 issues`).
- **Auditoria de Qualidade**: Script PowerShell de certificação contínua.

### Comandos de Validação

```bash
# Executar a Suíte de Testes
flutter test

# Executar Análise Estática
flutter analyze

# Rodar Auditoria Completa de Qualidade (Windows)
powershell -ExecutionPolicy Bypass -File .\scripts\run_qa_audit.ps1

# Executar Web no Chrome
flutter run -d chrome --web-port 8080
```

---

## 📊 Relatórios de Avaliação Multi-Agente (PDF)

Disponíveis no diretório [`relatorios/pdf/`](file:///c:/Users/Ari/Documents/workspace/treino/relatorios/pdf/):
1. **Design Specialist Audit**: Avaliação visual e de usabilidade (**9.5 / 10**).
2. **Beginner User Review (Lucas Prado)**: Experiência de um iniciante absoluto (**9.8 / 10**).
3. **Advanced Lifter Review**: Auditoria de volume hipertrófico e biomecânica (**9.5 / 10**).

---

## 🚀 Como Executar

### Pré-requisitos
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>= 3.10.0)
- [Dart SDK](https://dart.dev/get-dart)
- Google Chrome instalado

### Instalação

```bash
# Clonar o repositório
git clone https://github.com/AriThomazini/fitmorph-ai.git

# Acessar a pasta
cd fitmorph-ai

# Baixar dependências
flutter pub get

# Rodar a aplicação Web
flutter run -d chrome --web-port 8080
```

---

## 📄 Licença

Distribuído sob licença proprietária FitMorph AI. Todos os direitos reservados.
