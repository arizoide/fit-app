# FitMorph AI - Home Page / Landing Page de Apresentação

Esta pasta contém a página de apresentação oficial (Landing Page) do **FitMorph AI**, desenvolvida de forma independente do projeto Flutter.

## 🌟 O que foi construído

- **Design Dark Cyberpunk / Neon**: Paleta idêntica ao aplicativo Flutter (`#0A0E17`, `#00E676` Neon Lime, `#00E5FF` Electric Cyan, `#FF9100`, `#7C4DFF`).
- **Simulador Interativo 3 em 1 no Navegador**:
  1. **Calculadora de Anilhas Olímpicas (Plate Calculator)**: Escolha de barra (20kg, 15kg, 10kg), slider de peso, renderização gráfica da barra com anilhas coloridas e contagem exata por lado.
  2. **Calculadora TDEE & Macronutrientes**: Fórmulas científicas Mifflin-St Jeor & Katch-McArdle, TMB, TDEE, metas de calorias por objetivo (Hipertrofia, Queima de Gordura, Recomposição), gramas de proteínas, carboidratos, gorduras e litros de água.
  3. **Gerador Neural de Treino Gemini AI**: Demonstração interativa de montagem de fichas personalizadas com RPE, séries, repetições, descanso e dicas da IA.
- **Showcase das 6 Engenharias do FitMorph AI**:
  - Anamnese & Biótipo Completo
  - Modo Treino Ativo & Registro de Cargas (1RM)
  - Substituição Inteligente de Exercícios (AI Swap)
  - Calculadora de Anilhas
  - Biometria & Evolução Fotográfica
  - Nutrição & Hidratação de Precisão
- **Showcase de Biometria Holográfica**: Telemetria visual com gráfico e composição corporal.
- **Tabela Comparativa**: FitMorph AI vs. Métodos tradicionais de treino.
- **Depoimentos de Atletas**, **FAQ Interativo com Accordion** e **Banners de Download**.

---

## 🚀 Como Visualizar a Home Page

### Opção 1: Abrir diretamente no Navegador
Basta dar duplo clique no arquivo [`index.html`](index.html) ou abrir através do seu navegador preferido (Chrome, Edge, Firefox, Safari).

### Opção 2: Servidor Local (ex: VS Code Live Server ou Python)
Se desejar rodar via HTTP local:
```bash
# Com Python 3:
cd home-page
python -m http.server 3000

# Ou com Node.js (npx serve):
npx serve home-page
```
Depois acesse `http://localhost:3000`.

---

## 📁 Estrutura de Arquivos

```
home-page/
├── assets/
│   ├── app_icon.jpg              # Ícone estilizado 3D do FitMorph AI
│   ├── hero_mockup.jpg           # Mockup 3D dos smartphones com o app
│   └── biometrics_showcase.jpg   # Telemetria holográfica de biometria
├── index.html                    # Estrutura semântica e SEO da Home Page
├── styles.css                    # Estilos modernos, responsivos, glassmorphism e neon
├── script.js                     # Simuladores interativos, tabs e animações
└── README.md                     # Documentação da landing page
```
