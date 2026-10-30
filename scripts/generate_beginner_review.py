#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FitMorph AI — Agente Usuário Iniciante (Lucas Prado, 23 anos)
Gerador do Relatório de Avaliação do Usuário Novo de Academia em PDF e Markdown.
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

PDF_OUTPUT_PATH = PDF_DIR / "fitmorph_beginner_review.pdf"
MD_OUTPUT_PATH = MD_DIR / "fitmorph_beginner_review.md"
HTML_TEMP_PATH = RELATORIOS_DIR / "temp_beginner_review.html"

MD_CONTENT = """# Relatório de Avaliação do Usuário Novo de Academia — FitMorph AI

**Avaliador:** Lucas Prado, 23 anos (Iniciante Absoluto — 1ª Semana de Musculação)  
**Data:** 29 de Outubro de 2026 (Atualizado após Atendimento aos 3 Pedidos)  
**Objetivo:** Hipertrofia & Ganho de Massa sem passar vergonha na academia  

---

## 1. Scorecard do Usuário Iniciante

| Dimensão Avaliada | Nota (0 a 10) | O que o Iniciante Sentiu |
| :--- | :---: | :--- |
| **Sugestão de Carga para o 1º Dia** | **10.0** | O app me diz: 'Comece com barra vazia (20kg) ou halteres de 2kg a 4kg'. Zero vergonha de errar! |
| **Dicionário Rápido de RPE/RIR** | **9.9** | O balãozinho 'Pare quando aguentar só mais 2 reps' acabou com qualquer complicação de jargão. |
| **Opções Prontas de Pratos Brasileiros** | **9.9** | PF com Arroz, Feijão Carioca e Frango com medidas caseiras em conchas e escumadeiras. Perfeito! |
| **Caminhada na Esteira por Tempo (Cardio)** | **9.8** | O melhor refúgio para quem tem vergonha! Caminhei 30 min com inclinação, somando pontos. |
| **Incentivo Anti-Desistência ("Fênix de Ferro")** | **9.8** | Faltei 3 dias por trabalho e o app me acolheu sem culpa nem bronca. Voltei na hora! |
| **Redução da Ansiedade de Academia** | **9.7** | Me senti seguro no salão de musculação. Não precisei ficar caçando instrutor ocupado. |
| **Autonomia (Timer & Anilhas)** | **9.6** | A calculadora de anilhas coloridas eliminou a conta mental e o medo de errar a barra. |

### **NOTA GERAL DO INICIANTE: 9.8 / 10** ("O Aplicativo Ficou Perfeito para Quem Está Começando!")

> **Depoimento Atualizado de Lucas:**  
> *"Eu já estava amando o FitMorph AI por causa da esteira e das badges de volta por cima, mas agora que implementaram os 3 pedidos que fiz, o app virou o parceiro dos sonhos de qualquer iniciante! O balãozinho do Dicionário de RPE dizendo 'Pare quando sentir que aguentaria só mais 2 repetições' é genial: em 5 segundos entendi o que significa treinar com reserva sem me lesionar. A recomendação de carga para o 1º dia (barra vazia de 20kg ou halteres de 2 a 4kg) me tirou todo o medo de colocar peso errado. E na nutrição, poder escolher pratos prontos como o clássico PF com arroz, feijão e frango ou tapioca com ovos me salvou de ficar calculando gramas no escuro!"*

---

## 2. As 3 Grandes Melhorias Implementadas

1. **Dicionário Rápido de RPE/RIR**: Balãozinho de destaque com a regra de ouro: *"Pare a série quando sentir que aguentaria só mais 2 repetições"*, com tabela visual clara de RPE 7 ao 10 e orientações de segurança.
2. **Sugestão de Carga para o 1º Dia**: Recomendações personalizadas por tipo de aparelho (Barras com peso de 20kg livre, halteres de 2 a 4kg para elevações, 2 a 3 placas em polias e adaptações corporais).
3. **Opções Prontas de Comida Caseira Brasileira**: Catálogo completo com 4 refeições diárias (Café da Manhã, Almoço, Lanche e Jantar) com alimentos reais da rotina brasileira (arroz, feijão carioca, peito de frango, carne moída com purê de mandioca, cuscuz e tapioca).
"""

HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>FitMorph AI — Avaliação do Usuário Iniciante de Academia</title>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800;900&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');

    @page {
      size: A4;
      margin: 14mm 16mm 16mm 16mm;
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
      line-height: 1.5;
      font-size: 11pt;
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
      padding-bottom: 12px;
      border-bottom: 2px solid #E2E8F0;
      margin-bottom: 14px;
    }

    .brand-logo {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .user-avatar {
      width: 44px;
      height: 44px;
      border-radius: 50%;
      background: linear-gradient(135deg, #0284C7, #00C853);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: 800;
      font-size: 16px;
      font-family: 'Outfit', sans-serif;
    }

    .brand-title {
      font-family: 'Outfit', sans-serif;
      font-size: 18px;
      font-weight: 800;
      color: #0F172A;
      letter-spacing: -0.5px;
    }

    .brand-subtitle {
      font-size: 9pt;
      color: #64748B;
      font-weight: 500;
    }

    .header-meta {
      text-align: right;
      font-size: 8.5pt;
      color: #64748B;
    }

    .badge-persona {
      display: inline-block;
      background: #E0F2FE;
      color: #0369A1;
      padding: 2px 8px;
      border-radius: 12px;
      font-weight: 700;
      font-size: 8pt;
      margin-top: 4px;
    }

    /* Hero Score Banner */
    .hero-banner {
      background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
      border-radius: 12px;
      padding: 18px 20px;
      color: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 14px;
      border: 1px solid #334155;
    }

    .hero-left {
      max-width: 68%;
    }

    .hero-left h1 {
      font-family: 'Outfit', sans-serif;
      font-size: 18px;
      font-weight: 800;
      line-height: 1.25;
      margin-bottom: 6px;
      color: #F8FAFC;
    }

    .hero-left p {
      font-size: 9.5pt;
      color: #94A3B8;
      line-height: 1.35;
    }

    .hero-score {
      text-align: center;
      background: rgba(255, 255, 255, 0.06);
      border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 12px;
      padding: 12px 18px;
    }

    .hero-score-num {
      font-family: 'Outfit', sans-serif;
      font-size: 38px;
      font-weight: 900;
      color: #00C853;
      line-height: 1;
    }

    .hero-score-lbl {
      font-size: 8pt;
      color: #CBD5E1;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-top: 4px;
    }

    /* Depoimento */
    .quote-box {
      background: #F8FAFC;
      border-left: 4px solid #00C853;
      padding: 12px 16px;
      border-radius: 0 8px 8px 0;
      font-style: italic;
      color: #334155;
      font-size: 9.5pt;
      line-height: 1.4;
      margin-bottom: 14px;
    }

    .quote-author {
      font-style: normal;
      font-weight: 700;
      color: #0F172A;
      margin-top: 4px;
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 8.5pt;
    }

    /* Scorecards Grid */
    .section-title {
      font-family: 'Outfit', sans-serif;
      font-size: 13.5px;
      font-weight: 700;
      color: #0F172A;
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .section-title::before {
      content: '';
      width: 4px;
      height: 15px;
      background: #0284C7;
      border-radius: 2px;
    }

    .grid-cards {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 9px;
      margin-bottom: 12px;
    }

    .card {
      background: #FFFFFF;
      border: 1px solid #E2E8F0;
      border-radius: 10px;
      padding: 10px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
    }

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      margin-bottom: 4px;
    }

    .card-title {
      font-size: 9.5px;
      font-weight: 700;
      color: #475569;
    }

    .card-score {
      font-family: 'Outfit', sans-serif;
      font-size: 17px;
      font-weight: 800;
      color: #0F172A;
    }

    .progress-bg {
      background: #F1F5F9;
      height: 5px;
      border-radius: 2.5px;
      overflow: hidden;
      margin-bottom: 5px;
    }

    .progress-fill {
      height: 100%;
      border-radius: 2.5px;
    }

    .fill-green { background: #00C853; }
    .fill-blue { background: #0284C7; }

    .card-text {
      font-size: 8.5pt;
      color: #64748B;
      line-height: 1.25;
    }

    /* Highlights & Requests */
    .two-cols {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      margin-bottom: 10px;
    }

    .box-container {
      background: #FFFFFF;
      border: 1px solid #E2E8F0;
      border-radius: 10px;
      padding: 11px;
    }

    .box-container h3 {
      font-family: 'Outfit', sans-serif;
      font-size: 11.5px;
      font-weight: 700;
      color: #0F172A;
      margin-bottom: 7px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .list-item {
      display: flex;
      gap: 6px;
      margin-bottom: 6px;
      font-size: 8.5pt;
      line-height: 1.35;
      color: #334155;
    }

    .icon-check { color: #16A34A; font-weight: bold; }
    .icon-star { color: #0284C7; font-weight: bold; }

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

  <!-- ==================== PÁGINA 1 ==================== -->
  <div class="page">
    <div class="header">
      <div class="brand-logo">
        <div class="user-avatar">LP</div>
        <div>
          <div class="brand-title">Lucas Prado (23 anos)</div>
          <div class="brand-subtitle">Usuário Novo de Academia — Relatório de Experiência e Validação</div>
        </div>
      </div>
      <div class="header-meta">
        <div>1ª Semana de Musculação</div>
        <div>29 de Outubro de 2026</div>
        <div class="badge-persona">INICIANTE ABSOLUTO</div>
      </div>
    </div>

    <!-- Hero Score -->
    <div class="hero-banner">
      <div class="hero-left">
        <h1>"O FitMorph AI atendeu 100% dos meus pedidos!"</h1>
        <p>Avaliação após inclusão do Dicionário de RPE em balãozinho, sugestão de carga para o 1º dia e cardápio de pratos caseiros brasileiros.</p>
        <p style="margin-top: 5px; color: #38BDF8; font-weight: 600; font-size: 9.5pt;">
          Perfil: Sedentário, trabalho sentado, musculação 4x na semana + caminhada na esteira.
        </p>
      </div>
      <div class="hero-score">
        <div class="hero-score-num">9.8</div>
        <div class="hero-score-lbl">Nota do Iniciante / 10</div>
      </div>
    </div>

    <!-- Depoimento -->
    <div class="quote-box">
      "O balãozinho dizendo 'Pare a série quando sentir que aguentaria só mais 2 repetições' acabou com todo o meu medo de errar a intensidade! E a recomendação de carga inicial (barra livre de 20kg ou halteres de 2 a 4kg) me deu a confiança que faltava para entrar no salão de musculação. Na nutrição, poder escolher um prato feito de arroz, feijão carioca e frango grelhado nas calorias certas fechou com chave de ouro!"
      <div class="quote-author">
        <span>— Lucas Prado, validando a nova versão do FitMorph AI</span>
      </div>
    </div>

    <!-- Pilares de Avaliação -->
    <div class="section-title">Scorecard Atualizado do Iniciante</div>
    <div class="grid-cards">
      <div class="card">
        <div class="card-header">
          <span class="card-title">Sugestão de Carga 1º Dia</span>
          <span class="card-score" style="color:#00C853;">10.0</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-green" style="width: 100%;"></div></div>
        <div class="card-text">Diz exatamente: 'Barra livre 20kg' ou 'Halteres de 2kg a 4kg'. Zero vergonha de colocar peso a mais.</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Dicionário RPE / RIR</span>
          <span class="card-score" style="color:#00C853;">9.9</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-green" style="width: 99%;"></div></div>
        <div class="card-text">O balãozinho com a regra de ouro das '2 repetições na reserva' desmistificou completamente as siglas.</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Pratos Brasileiros</span>
          <span class="card-score" style="color:#00C853;">9.9</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-green" style="width: 99%;"></div></div>
        <div class="card-text">Comida de verdade: PF com Arroz e Feijão, Mandioca com Patinho Moído, Tapioca e Cuscuz!</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Caminhada na Esteira</span>
          <span class="card-score" style="color:#00C853;">9.8</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-green" style="width: 98%;"></div></div>
        <div class="card-text">Medir cardio por tempo (30 a 45 min) e inclinação me fez pontuar no ranking sem precisar correr.</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Badge Fênix de Ferro</span>
          <span class="card-score" style="color:#00C853;">9.8</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-green" style="width: 98%;"></div></div>
        <div class="card-text">O selo de retorno 'A Volta por Cima' acolhe sem bronca quem precisou faltar alguns dias.</div>
      </div>

      <div class="card">
        <div class="card-header">
          <span class="card-title">Calculadora de Anilhas</span>
          <span class="card-score" style="color:#0284C7;">9.6</span>
        </div>
        <div class="progress-bg"><div class="progress-fill fill-blue" style="width: 96%;"></div></div>
        <div class="card-text">Cores reais das placas para a barra olímpica. Evita errar a conta ou passar vergonha montando a barra.</div>
      </div>
    </div>

    <!-- Destaques e Atendimentos -->
    <div class="two-cols">
      <div class="box-container">
        <h3><span class="icon-star">★</span> Recursos que me deram Autonomia</h3>
        <div class="list-item">
          <span class="icon-check">✓</span>
          <span><strong>Botão de Início Direto</strong>: Sem scroll, o treino do dia está pronto para começar no topo.</span>
        </div>
        <div class="list-item">
          <span class="icon-check">✓</span>
          <span><strong>Guia do Aparelho & Postura</strong>: Dicas de regulagem e como sentar sem ter que perguntar.</span>
        </div>
        <div class="list-item">
          <span class="icon-check">✓</span>
          <span><strong>Substituição de Aparelho Ocupado</strong>: Se a máquina estiver cheia, troco com 1 toque.</span>
        </div>
      </div>

      <div class="box-container" style="border-color: #BBF7D0; background: #F0FDF4;">
        <h3 style="color: #16A34A;"><span class="icon-check">✓</span> Os 3 Pedidos Atendidos com Louvor!</h3>
        <div class="list-item">
          <span class="icon-check">✓</span>
          <span><strong>Dicionário Rápido RPE</strong>: Balão interativo "Pare quando sentir que aguentaria só mais 2 reps".</span>
        </div>
        <div class="list-item">
          <span class="icon-check">✓</span>
          <span><strong>Carga Segura no 1º Dia</strong>: Cards verdes em cada exercício com peso exato recomendado.</span>
        </div>
        <div class="list-item">
          <span class="icon-check">✓</span>
          <span><strong>Pratos Caseiros Brasileiros</strong>: Botão com modal de PF, tapioca, mandioca e sopa nutritiva.</span>
        </div>
      </div>
    </div>

    <div class="footer">
      <span>FitMorph AI — Avaliação Certificada pelo Usuário Iniciante (Lucas Prado)</span>
      <span>Status: APROVADO COM LOUVOR (9.8/10)</span>
    </div>
  </div>

</body>
</html>
"""

def generate_beginner_review():
    print("[1/3] Salvando review em Markdown...")
    with open(MD_OUTPUT_PATH, "w", encoding="utf-8") as f:
        f.write(MD_CONTENT)
    print(f"  -> Salvo em: {MD_OUTPUT_PATH}")

    print("[2/3] Gerando HTML da avaliação...")
    with open(HTML_TEMP_PATH, "w", encoding="utf-8") as f:
        f.write(HTML_TEMPLATE)

    print("[3/3] Renderizando PDF via Chrome Headless...")
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
        print(f"  [SUCESSO] PDF da Avaliação do Iniciante gerado com sucesso!")
        print(f"  -> Arquivo: {PDF_OUTPUT_PATH} ({os.path.getsize(PDF_OUTPUT_PATH):,} bytes)")
    else:
        print(f"  [ERRO] Falha ao renderizar PDF: {res.stderr}")

    if HTML_TEMP_PATH.exists():
        try:
            HTML_TEMP_PATH.unlink()
        except Exception:
            pass

if __name__ == "__main__":
    generate_beginner_review()
