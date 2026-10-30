# Diretrizes do Agente & Padrões de Engenharia — FitMorph AI

Este repositório adota uma abordagem orientada à **Qualidade Total (Zero-Defect Quality Gates)**. Todo agente ou desenvolvedor que interagir com esta base de código deve respeitar os seguintes princípios e regras de garantia da qualidade:

---

## 1. Regras do Agente de QA (Quality Assurance)

- **Auditoria Obrigatória**: Antes de concluir qualquer tarefa ou implementação de feature, execute os testes e o linter com `flutter test` e `flutter analyze`.
- **Zero Quebras**: Nenhuma alteração pode deixar o código com avisos no analisador estático ou quebrar testes existentes.
- **Validação Biomecânica**: Ao mexer na geração de treinos (`GeminiService` ou `WorkoutPlan`), garanta que os filtros de dor articular (ombro, joelho, coluna) e local de treino (Home Gym vs Commercial Gym) continuem sendo rigorosamente respeitados.
- **Validação de Nutrição**: O cálculo de calorias e distribuição de macros deve sempre seguir as fórmulas científicas validadas em `TdeeCalculator`.

---

## 2. Padrões de Design & UI

- **Tema Padrão**: **Branco Gelo** (`AppColors.background = 0xFFF4F7FB`, superfícies brancas e bordas `AppColors.cardBorder = 0xFFE2E8F0`).
- **Contraste**: Textos principais devem usar tons Slate de alta legibilidade (`AppColors.textPrimary = 0xFF0F172A`).
- **Acessibilidade**: Elementos clicáveis devem ter área mínima de toque de 48x48 dp.
- **Zero Scroll para Ação Principal**: Na tela de treinos, o botão de iniciar o treino do dia deve estar imediatamente acessível no topo.

---

## 3. Comandos de Validação Rápida

| Ação | Comando |
| :--- | :--- |
| **Auditoria Completa QA** | `powershell -ExecutionPolicy Bypass -File .\scripts\run_qa_audit.ps1` |
| **Suíte de Testes** | `flutter test` |
| **Análise Estática** | `flutter analyze` |
| **Executar Web no Chrome** | `flutter run -d chrome --web-port 8080` |
