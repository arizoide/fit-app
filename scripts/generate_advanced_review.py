#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FitMorph AI — Agente Lifter Avançado (Rodrigo Alencar, 31 anos)
Gerador do Relatório de Avaliação do Membro Avançado de Academia em PDF e Markdown.
"""

import os
import subprocess
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
RELATORIOS_DIR = BASE_DIR / "relatorios"
PDF_DIR = RELATORIOS_DIR / "pdf"
MD_DIR = RELATORIOS_DIR / "md"

PDF_DIR.mkdir(parents=True, exist_ok=True)
MD_DIR.mkdir(parents=True, exist_ok=True)

PDF_OUTPUT_PATH = PDF_DIR / "fitmorph_advanced_review.pdf"
MD_OUTPUT_PATH = MD_DIR / "fitmorph_advanced_review.md"
HTML_TEMP_PATH = RELATORIOS_DIR / "temp_advanced_review.html"

MD_CONTENT = """# Relatório de Avaliação do Atleta Avançado — FitMorph AI

**Avaliador:** Rodrigo Alencar, 31 anos (Atleta Amador & Praticante de Musculação Há 8 Anos)  
**Data:** 29 de Outubro de 2026  
**Perfil:** 86kg, 11% de Gordura Corporal, Treino Frequência 4-5x/semana, Foco em Hipertrofia & Sobrecarga Progressiva  

---

## 1. Scorecard do Usuário Avançado

| Pilar Técnico Avaliado | Nota (0 a 10) | Veredito do Atleta Experiente |
| :--- | :---: | :--- |
| **Cardio LISS Zona 2 na Esteira (Hipertrofia)** | **9.8** | Padrão ouro! Cardio medido por tempo e inclinação preserva massa magra e poupa o SNC e joelhos. |
| **Periodização & Séries Semanais (MEV/MRV)** | **9.6** | Distribuição perfeita de 12 a 16 séries diretas/músculo por semana. Sem lixo de volume. |
| **Leaderboard da Academia & Volume Load** | **9.6** | O ranking comunitário motiva a constância atlética e compara presença e tonelagem total movida. |
| **Sequenciamento Biomecânico** | **9.5** | Ordem correta: Compostos multiarticulares pesados no início, seguidos de isolados. |
| **Nutrição com Massa Magra (Katch-McArdle)** | **9.5** | Considerou meu %BF de 11% para massa livre de gordura. Proteína em 2.2g/kg e opções de pratos. |
| **Cálculo de Tonelagem (Volume Load)** | **9.4** | O rastreamento de tonelagem total em kg (`calculateTotalVolumeKg`) comprova a sobrecarga real. |
| **Modo Express (Super-séries & Densidade)** | **9.2** | Converte isoladores em bi-sets mantendo o mesmo estímulo quando o tempo é curto. |
| **Histórico Comparativo em Tempo Real** | **8.5** | Falta mostrar a carga da semana passada como "fantasma" dentro do campo de digitação. |

### **NOTA GERAL DO ATLETA AVANÇADO: 9.5 / 10** (Nível de Excelência Científica)

> **Depoimento de Rodrigo:**  
> *"Eu treino há 8 anos e sou extremamente crítico com apps de treino porque a maioria empurra rotinas genéricas cheias de exercícios redundantes. O FitMorph AI me surpreendeu de verdade. A inclusão da nova guia de Caminhada na Esteira Medida por Tempo foi uma tacada de mestre da equipe: quem estuda hipertrofia sabe que corrida intensa (HIIT) desgasta o menisco e concorre com a via mTOR, enquanto a caminhada inclinada LISS em Zona 2 (60-70% FCM) é o cardio perfeito para queimar gordura poupando glicogênio muscular e articulações para agachamentos pesados. O ranking da comunidade também gerou uma competição saudável entre os atletas da academia. Com isso, o app subiu para 9.5/10."*

---

## 2. O Que o Atleta Avançado Mais Elogiou

1. **Cardio LISS na Esteira por Tempo & Inclinação**: *"O app mediu o cardio de forma inteligente: minutos acumulados em inclinação, sem tiros que estragariam o leg day seguinte."*
2. **Ranking & Gamificação de Presença**: *"Ver o volume de treinos e os líderes de constância no pódio ativa o espírito competitivo atlético."*
3. **Volume Semanal Calibrado (12 a 16 séries)**: *"O algoritmo não inventa 30 séries por músculo num dia só. O split divide o volume em alta frequência e recuperação inteligente de 48-72h."*
4. **Registro de RPE & RIR Real**: *"Mede a proximidade da falha concêntrica (RPE 8 / RIR 2), essencial para quem treina de verdade."*
5. **Métrica de Tonelagem Total (Volume Load)**: *"Multiplicar peso × reps concluídas em cada série e somar os milhares de kg movidos é indispensável para comprovar sobrecarga progressiva."*

---

## 3. Próximo Passo para a Nota 10/10

1. **Placeholder "Ghost Set" com a Carga Anterior**: Exibir a carga e reps da última semana (ex: *"Última vez: 90kg × 8"*) como marca d'água no campo de peso e reps da série ativa.
2. **Diferenciação de Séries de Aquecimento (Warm-up vs Working Set)**: Permitir marcar uma série como aquecimento (W) para não inflar o volume load de trabalho hipertrófico efetivo.
"""

HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>FitMorph AI — Avaliação do Atleta Avançado</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');

    @page {
      size: A4;
      margin: 12mm 15mm 14mm 15mm;
    }

    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }

    body {
      font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
      background-color: #FFFFFF;
      color: #0F172A;
      line-height: 1.45;
      font-size: 10.5pt;
      -webkit-print-color-adjust: exact;
      print-color-adjust: exact;
    }

    .page {
      position: relative;
      height: 100%;
    }

    /* Header */
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-bottom: 10px;
      border-bottom: 2px solid #E2E8F0;
      margin-bottom: 12px;
    }

    .brand-logo {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .user-avatar {
      background: linear-gradient(135deg, #0F172A, #00C853);
      color: #00E676;
      width: 38px;
      height: 38px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Outfit', sans-serif;
      font-weight: 900;
      font-size: 15px;
      border: 1.5px solid #00C853;
      box-shadow: 0 4px 10px rgba(0, 200, 83, 0.25);
    }

    .brand-title {
      font-family: 'Outfit', sans-serif;
      font-weight: 800;
      font-size: 17px;
      color: #0F172A;
    }

    .brand-subtitle {
      font-size: 9.5px;
      text-transform: uppercase;
      letter-spacing: 1.2px;
      color: #00C853;
      font-weight: 700;
    }

    .header-meta {
      text-align: right;
      font-size: 9.5px;
      color: #64748B;
      font-weight: 600;
    }

    .badge-persona {
      background: #F0FDF4;
      color: #15803D;
      border: 1px solid #BBF7D0;
      padding: 3px 8px;
      border-radius: 20px;
      font-size: 8.5pt;
      font-weight: 700;
      display: inline-block;
      margin-top: 2px;
    }

    /* Hero Banner */
    .hero-banner {
      background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
      color: #FFFFFF;
      border-radius: 14px;
      padding: 13px 18px;
      margin-bottom: 10px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 8px 20px -5px rgba(15, 23, 42, 0.25);
    }

    .hero-left h1 {
      font-family: 'Outfit', sans-serif;
      font-size: 18px;
      font-weight: 800;
      margin-bottom: 2px;
    }

    .hero-left p {
      color: #94A3B8;
      font-size: 9.2pt;
      max-width: 440px;
      line-height: 1.35;
    }

    .hero-score {
      background: rgba(255, 255, 255, 0.08);
      border: 2px solid #00C853;
      border-radius: 12px;
      padding: 6px 14px;
      text-align: center;
      min-width: 120px;
    }

    .hero-score-num {
      font-family: 'Outfit', sans-serif;
      font-size: 36px;
      font-weight: 900;
      color: #00E676;
      line-height: 1;
    }

    .hero-score-lbl {
      font-size: 8pt;
      text-transform: uppercase;
      letter-spacing: 0.8px;
      font-weight: 700;
      color: #E2E8F0;
      margin-top: 2px;
    }

    /* Depoimento Box */
    .quote-box {
      background: #F8FAFC;
      border-left: 3.5px solid #0284C7;
      border-radius: 0 10px 10px 0;
      padding: 7px 12px;
      margin-bottom: 8px;
      font-style: italic;
      color: #334155;
      font-size: 8.4pt;
      line-height: 1.35;
    }

    .quote-author {
      font-style: normal;
      font-weight: 700;
      color: #0F172A;
      margin-top: 2px;
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 8pt;
    }

    /* Scorecards Grid */
    .section-title {
      font-family: 'Outfit', sans-serif;
      font-size: 13px;
      font-weight: 700;
      color: #0F172A;
      margin-bottom: 6px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .section-title::before {
      content: '';
      width: 4px;
      height: 13px;
      background: #00C853;
      border-radius: 2px;
    }

    .grid-cards {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 8px;
      margin-bottom: 8px;
    }

    .card {
      background: #FFFFFF;
      border: 1px solid #E2E8F0;
      border-radius: 10px;
      padding: 9px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
    }

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      margin-bottom: 4px;
    }

    .card-title {
      font-size: 10px;
      font-weight: 700;
      color: #475569;
    }

    .card-score {
      font-family: 'Outfit', sans-serif;
      font-size: 18px;
      font-weight: 800;
      color: #0F172A;
    }

    .progress-bg {
      background: #F1F5F9;
      height: 5px;
      border-radius: 2.5px;
      overflow: hidden;
      margin-bottom: 6px;
    }

    .progress-fill {
      height: 100%;
      border-radius: 2.5px;
    }

    .fill-green { background: #00C853; }
    .fill-blue { background: #0284C7; }
    .fill-purple { background: #7C3AED; }

    .card-text {
      font-size: 8.8pt;
      color: #64748B;
      line-height: 1.3;
    }

    /* Highlights & Requests */
    .two-cols {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      margin-bottom: 12px;
    }

    .box-container {
      background: #FFFFFF;
      border: 1px solid #E2E8F0;
      border-radius: 10px;
      padding: 11px;
    }

    .box-container h3 {
      font-family: 'Outfit', sans-serif;
      font-size: 12px;
      font-weight: 700;
      color: #0F172A;
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .list-item {
      display: flex;
      gap: 6px;
      margin-bottom: 6px;
      font-size: 8.8pt;
      line-height: 1.35;
      color: #334155;
    }

    .icon-check { color: #16A34A; font-weight: bold; }
    .icon-warn { color: #0284C7; font-weight: bold; }

    /* Footer */
    .footer {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 8.5pt;
      color: #94A3B8;
      border-top: 1px solid #E2E8F0;
      padding-top: 6px;
    }
  </style>
</head>
<body>

  <div class="page">
    <div class="header">
      <div class="brand-logo">
        <div class="user-avatar">RA</div>
        <div>
          <div class="brand-title">Rodrigo Alencar (31 anos)</div>
          <div class="brand-subtitle">Atleta Avançado & Lifter Experiente — Avaliação Técnica</div>
        </div>
      </div>
      <div class="header-meta">
        <div>8 Anos de Treino Sério</div>
        <div>29 de Outubro de 2026</div>
        <div class="badge-persona">ATLETA AVANÇADO (11% BF)</div>
      </div>
    </div>

    <!-- Hero Score -->
    <div class="hero-banner">
      <div class="hero-left">
        <h1>"Cardio LISS Zona 2 e Periodização de Elite!"</h1>
        <p>Auditoria técnica e biomecânica do FitMorph AI através do olhar de quem estuda hipertrofia, periodização de mesociclos e progressão de sobrecarga há quase uma década.</p>
        <p style="margin-top: 5px; color: #38BDF8; font-weight: 600; font-size: 9.5pt;">
          Perfil: 86kg, 11% BF, Treino 4-5x/semana, Foco em Hipertrofia & Preservação Muscular.
        </p>
      </div>
      <div class="hero-score">
        <div class="hero-score-num">9.5</div>
        <div class="hero-score-lbl">Nota do Lifter / 10</div>
      </div>
    </div>

    <!-- Depoimento -->
    <div class="quote-box">
      "A nova guia de Caminhada na Esteira Medida por Tempo foi uma tacada de mestre da equipe: quem estuda hipertrofia sabe que corrida intensa concorre com a via mTOR e estressa o menisco, enquanto a caminhada inclinada LISS Zona 2 (60-70% FCM) é o cardio perfeito para queimar gordura preservando o glicogênio e as articulações para agachamentos pesados. O ranking da academia também gerou uma competição saudável entre os atletas. O app subiu para 9.5/10!"
      <div class="quote-author">
        <span>— Rodrigo Alencar, atleta e revisor técnico do FitMorph AI</span>
      </div>
    </div>

    <!-- Pilares de Avaliação -->
    <div class="section-title">Scorecard Técnico do Atleta Avançado</div>
    <div class="grid-cards">
      <div class="card">
        <div class="card-header">
          <span class="card-title">Cardio LISS na Esteira</span>
          <span class="card-score" style="color:#00C853;">9.8</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-green" style="width: 98%;"></div></div>
        <div class="card-text">Padrão ouro: cardio medido por tempo e inclinação preserva massa magra e poupa o SNC.</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Volume Semanal (MEV/MRV)</span>
          <span class="card-score" style="color:#00C853;">9.6</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-green" style="width: 96%;"></div></div>
        <div class="card-text">Volume calibrado de 12 a 16 séries diretas/semana por músculo. Sem junk volume.</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Ranking & Tonelagem</span>
          <span class="card-score" style="color:#00C853;">9.6</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-green" style="width: 96%;"></div></div>
        <div class="card-text">O leaderboard social motiva a constância atlética e calcula a tonelagem total movida.</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Sequenciamento Biomecânico</span>
          <span class="card-score" style="color:#00C853;">9.5</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-green" style="width: 95%;"></div></div>
        <div class="card-text">Compostos multiarticulares pesados no início, seguidos de isolados biomecânicos.</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Cálculo de Massa Magra</span>
          <span class="card-score" style="color:#0284C7;">9.5</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-blue" style="width: 95%;"></div></div>
        <div class="card-text">Katch-McArdle calcula TMB sobre massa magra. Proteína em 2.2g/kg com pratos sugeridos.</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Histórico de Carga Ativa</span>
          <span class="card-score" style="color:#7C3AED;">8.5</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-purple" style="width: 85%;"></div></div>
        <div class="card-text">Ponto a melhorar: falta exibir a carga da semana anterior como 'fantasma' no input da série.</div>
      </div>
    </div>

    <!-- Destaques e Pedidos -->
    <div class="two-cols">
      <div class="box-container">
        <h3><span class="icon-check">✓</span> O que torna o app de Alto Rendimento</h3>
        <div class="list-item">
          <span class="icon-check">•</span>
          <span><strong>RPE / RIR em cada série</strong>: Permite calibrar a intensidade exata de reserva (RIR 1-2) para evitar fadiga do SNC.</span>
        </div>
        <div class="list-item">
          <span class="icon-check">•</span>
          <span><strong>Substitutos Biomecânicos</strong>: Se a polia ou banco estiver ocupado, a troca rápida mantém o mesmo grupo e mecânica.</span>
        </div>
        <div class="list-item">
          <span class="icon-check">•</span>
          <span><strong>Manequim Anatômico Multi-Foco</strong>: Visualização clara da periodização Agonista/Antagonista e grupos secundários.</span>
        </div>
      </div>

      <div class="box-container">
        <h3><span class="icon-warn">!</span> O que falta para a Nota 10 Absoluta</h3>
        <div class="list-item">
          <span class="icon-warn">•</span>
          <span><strong>Ghost Set (Carga da Semana Anterior)</strong>: Mostrar "Última: 90kg × 8" de forma translúcida no campo de digitação da série.</span>
        </div>
        <div class="list-item">
          <span class="icon-warn">•</span>
          <span><strong>Diferenciar Séries de Aquecimento</strong>: Poder marcar séries como aquecimento (W) para não inflar a tonelagem de trabalho.</span>
        </div>
        <div class="list-item">
          <span class="icon-warn">•</span>
          <span><strong>Alerta de Semana de Deload</strong>: Sugerir descarga programada (-50% volume) após 5-6 semanas de sobrecarga contínua.</span>
        </div>
      </div>
    </div>

    <div class="footer">
      <span>FitMorph AI — Avaliação de Atleta Avançado (Rodrigo Alencar, 8 anos de treino)</span>
      <span>Página 1 de 1</span>
    </div>
  </div>

</body>
</html>
"""

def generate_advanced_review():
    print("[1/3] Salvando review do atleta avançado em Markdown...")
    with open(MD_OUTPUT_PATH, "w", encoding="utf-8") as f:
        f.write(MD_CONTENT)
    print(f"  -> Salvo em: {MD_OUTPUT_PATH}")

    print("[2/3] Gerando HTML otimizado para impressão...")
    with open(HTML_TEMP_PATH, "w", encoding="utf-8") as f:
        f.write(HTML_TEMPLATE)

    print("[3/3] Compilando PDF via Chrome Headless...")
    chrome_bin = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
    if not os.path.exists(chrome_bin):
        chrome_bin = r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

    cmd = [
        chrome_bin,
        "--headless=new",
        "--disable-gpu",
        "--no-pdf-header-footer",
        f"--print-to-pdf={PDF_OUTPUT_PATH}",
        str(HTML_TEMP_PATH)
    ]

    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode == 0 and PDF_OUTPUT_PATH.exists():
        print(f"  [SUCESSO] PDF da Avaliação do Atleta Avançado gerado com sucesso!")
        print(f"  -> Arquivo: {PDF_OUTPUT_PATH} ({os.path.getsize(PDF_OUTPUT_PATH):,} bytes)")
    else:
        print(f"  [ERRO] Falha ao renderizar PDF: {res.stderr}")

    if HTML_TEMP_PATH.exists():
        try:
            HTML_TEMP_PATH.unlink()
        except Exception:
            pass

if __name__ == "__main__":
    generate_advanced_review()
