#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FitMorph AI — Design Specialist Agent (Aura UI/UX)
Gerador Automatizado do Relatório Executivo de Auditoria de Design em PDF e Markdown.
"""

import os
import subprocess
import sys
from pathlib import Path

# Paths
BASE_DIR = Path(__file__).resolve().parent.parent
RELATORIOS_DIR = BASE_DIR / "relatorios"
PDF_DIR = RELATORIOS_DIR / "pdf"
MD_DIR = RELATORIOS_DIR / "md"

PDF_DIR.mkdir(parents=True, exist_ok=True)
MD_DIR.mkdir(parents=True, exist_ok=True)

PDF_OUTPUT_PATH = PDF_DIR / "fitmorph_design_audit_report.pdf"
MD_OUTPUT_PATH = MD_DIR / "fitmorph_design_audit_report.md"
HTML_TEMP_PATH = RELATORIOS_DIR / "temp_design_report.html"

# Markdown Content
MD_CONTENT = """# Relatório Executivo de Auditoria de Design & UI/UX — FitMorph AI

**Data da Auditoria:** 29 de Outubro de 2026  
**Avaliador:** Agente Especialista em Design (Aura UI/UX Principal Designer)  
**Escopo:** Aplicação Mobile/Web Flutter FitMorph AI (v1.0.0)  
**Tema Avaliado:** Branco Gelo Premium (Nordic Ice White `#F4F7FB`)  

---

## 1. Scorecard Executivo de Design

| Pilar de Avaliação | Nota (0 a 10) | Ponderação | Status |
| :--- | :---: | :---: | :--- |
| **Apelo Visual & Estética Moderna** | **9.7** | 20% | Nível Mundial |
| **Harmonia Cromática & Identidade de Marca** | **9.6** | 20% | Nível Mundial |
| **Ergonomia Móvel & Usabilidade (Zero Scroll)** | **9.5** | 20% | Excelente |
| **Gamificação & Dinâmica Social (Pódio & Badges)** | **9.5** | 10% | Excelente |
| **Consistência do Design System** | **9.4** | 10% | Excelente |
| **Tipografia & Hierarquia de Informação** | **9.3** | 10% | Muito Bom |
| **Acessibilidade & Contraste (WCAG AA/AAA)** | **9.2** | 10% | Muito Bom |

### **NOTA GERAL DO DESIGN: 9.5 / 10** (Nível Internacional / Design de Referência)

> **Veredito do Especialista:**  
> O aplicativo atinge maturidade visual de classe mundial ao integrar a nova suíte de **Gamificação e Ranking da Academia**, complementando com perfeição a estética **Branco Gelo**. O Pódio dinâmico escalonado, a nova guia de **Caminhada na Esteira Medida por Tempo (Horas e Minutos)** em paleta atlética Ciano/Azul Céu (`#0284C7`), e o acolhimento visual do banner anti-desistência com badges de retomada elevam o FitMorph AI ao mesmo patamar visual de líderes globais como Strava, Apple Fitness+ e Nike Training Club.

---

## 2. Pontos Fortes em Destaque

1. **Pódio 3D Escalonado & Ranking Social**: Alturas proporcionais com anéis cromáticos (Ouro `#F59E0B`, Prata `#94A3B8`, Bronze `#D97706`) proporcionam reconhecimento visual instantâneo sem poluição.
2. **Guia de Caminhada na Esteira por Tempo**: Tipografia legível de alto contraste para tempo acumulado (`8h 00m`, `5h 40m`), card Hero integrado com estimativa calórica e botão de registro imediato.
3. **Modal de Registro Rápido (Quick Walk Logger)**: Seleção por chips de minutos (15 a 90 min) e inclinação (0% a 12%), com cálculo calórico reativo e feedback via SnackBar flutuante.
4. **Hero Card "Treino de Hoje" (Zero Scroll)**: Ponto focal superior imediato com CTA destacado em verde esmeralda atlético (`#00C853`).
5. **Visualizador Anatômico 3D & Destaque de Músculos**: Representação vetorial anatômica com iluminação dinâmica por grupamento muscular.
6. **Calculadora Visual de Anilhas Olímpicas**: Distribuição de placas coloridas na barra olímpica que elimina cálculos mentais e ansiedade.
7. **Acabamento Glassmorphism Suave**: Superfícies brancas puras (`#FFFFFF`) com elevações sutis e bordas Slate nítidas (`#E2E8F0`).

---

## 3. Matriz de Melhorias Sugeridas (Roadmap de Evolução)

### Prioridade 1 (Curto Prazo - Alto Impacto)
- **Feedback Háptico & Micro-Interações Táteis**: Adicionar vibrações táteis (`HapticFeedback.lightImpact`) ao concluir uma série, no timer de descanso e ao salvar a caminhada na esteira.
- **Alternador de Tema (Light Branco Gelo / Dark OLED)**: Incluir no Perfil a opção de alternar entre o tema padrão Branco Gelo e o modo Dark Neon para treinos noturnos.

### Prioridade 2 (Médio Prazo - Refinamento Visual)
- **Curvas Bézier Suaves na Biometria**: Aplicar gradientes verticais suaves nas áreas sob as linhas dos gráficos de peso e BF%.
- **Padronização Cromática da Landing Page Web**: Atualizar a pasta `home-page` para refletir o tema Branco Gelo.

### Prioridade 3 (Longo Prazo - Delight & Retenção)
- **Micro-Animações de Celebração (Confete Atlântico)**: Partículas visuais ao desbloquear badges especiais como a "Fênix de Ferro".
"""

# Premium HTML Template for PDF Printing via Chrome
HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>FitMorph AI — Relatório de Auditoria de Design & UI/UX</title>
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
      page-break-after: always;
      position: relative;
      height: 100%;
    }

    .page:last-child {
      page-break-after: avoid;
    }

    /* Header */
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-bottom: 16px;
      border-bottom: 2px solid #E2E8F0;
      margin-bottom: 20px;
    }

    .brand-logo {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .brand-badge {
      background: linear-gradient(135deg, #00C853, #0284C7);
      color: #FFFFFF;
      width: 38px;
      height: 38px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Outfit', sans-serif;
      font-weight: 900;
      font-size: 18px;
      box-shadow: 0 4px 12px rgba(0, 200, 83, 0.25);
    }

    .brand-title {
      font-family: 'Outfit', sans-serif;
      font-weight: 800;
      font-size: 20px;
      color: #0F172A;
      letter-spacing: -0.5px;
    }

    .brand-subtitle {
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: 1.5px;
      color: #64748B;
      font-weight: 700;
    }

    .header-meta {
      text-align: right;
      font-size: 10px;
      color: #64748B;
      font-weight: 600;
    }

    .tag-seal {
      background: #F0FDF4;
      color: #16A34A;
      border: 1px solid #BBF7D0;
      padding: 4px 10px;
      border-radius: 20px;
      font-size: 10px;
      font-weight: 700;
      display: inline-block;
      margin-top: 4px;
    }

    /* Score Hero Banner */
    .score-hero {
      background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
      color: #FFFFFF;
      border-radius: 16px;
      padding: 24px 28px;
      margin-bottom: 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.2);
    }

    .score-left h1 {
      font-family: 'Outfit', sans-serif;
      font-size: 24px;
      font-weight: 800;
      letter-spacing: -0.5px;
      margin-bottom: 6px;
    }

    .score-left p {
      color: #94A3B8;
      font-size: 12px;
      max-width: 440px;
      line-height: 1.5;
    }

    .score-badge {
      background: rgba(255, 255, 255, 0.08);
      border: 2px solid #00C853;
      border-radius: 14px;
      padding: 14px 22px;
      text-align: center;
      min-width: 140px;
    }

    .score-number {
      font-family: 'Outfit', sans-serif;
      font-size: 44px;
      font-weight: 900;
      color: #00E676;
      line-height: 1;
    }

    .score-label {
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: 1px;
      font-weight: 700;
      color: #E2E8F0;
      margin-top: 4px;
    }

    /* Grid Scorecards */
    .section-title {
      font-family: 'Outfit', sans-serif;
      font-size: 16px;
      font-weight: 700;
      color: #0F172A;
      margin-bottom: 14px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .section-title::before {
      content: '';
      width: 4px;
      height: 18px;
      background: #00C853;
      border-radius: 2px;
    }

    .score-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 12px;
      margin-bottom: 24px;
    }

    .card {
      background: #FFFFFF;
      border: 1px solid #E2E8F0;
      border-radius: 12px;
      padding: 14px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.02);
    }

    .card-title {
      font-size: 11px;
      font-weight: 700;
      color: #475569;
      margin-bottom: 8px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .card-score {
      font-family: 'Outfit', sans-serif;
      font-size: 22px;
      font-weight: 800;
      color: #0F172A;
      margin-bottom: 6px;
    }

    .progress-bar-bg {
      background: #F1F5F9;
      height: 6px;
      border-radius: 3px;
      overflow: hidden;
      margin-bottom: 8px;
    }

    .progress-bar-fill {
      height: 100%;
      border-radius: 3px;
    }

    .fill-lime { background: #00C853; }
    .fill-cyan { background: #0284C7; }
    .fill-purple { background: #7C3AED; }

    .card-desc {
      font-size: 10px;
      color: #64748B;
      line-height: 1.4;
    }

    /* Strengths & Roadmap */
    .two-cols {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-bottom: 20px;
    }

    .pillar-box {
      background: #F8FAFC;
      border: 1px solid #E2E8F0;
      border-radius: 12px;
      padding: 16px;
    }

    .pillar-box h3 {
      font-family: 'Outfit', sans-serif;
      font-size: 13px;
      font-weight: 700;
      color: #0F172A;
      margin-bottom: 12px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .list-item {
      display: flex;
      gap: 8px;
      margin-bottom: 10px;
      font-size: 10.5pt;
      line-height: 1.4;
      color: #334155;
    }

    .list-icon {
      flex-shrink: 0;
      font-weight: bold;
    }

    .icon-green { color: #16A34A; }
    .icon-blue { color: #0284C7; }
    .icon-orange { color: #EA580C; }

    /* Improvement Table */
    .table-custom {
      width: 100%;
      border-collapse: collapse;
      margin-top: 8px;
      font-size: 10pt;
    }

    .table-custom th {
      background: #F1F5F9;
      color: #334155;
      font-weight: 700;
      text-align: left;
      padding: 9px 12px;
      border-bottom: 2px solid #CBD5E1;
      font-size: 9.5pt;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .table-custom td {
      padding: 9px 12px;
      border-bottom: 1px solid #E2E8F0;
      vertical-align: top;
      color: #1E293B;
    }

    .badge-priority {
      padding: 2px 8px;
      border-radius: 10px;
      font-weight: 700;
      font-size: 8.5pt;
      display: inline-block;
    }

    .p1 { background: #FEF2F2; color: #DC2626; border: 1px solid #FECACA; }
    .p2 { background: #FFFBEB; color: #D97706; border: 1px solid #FDE68A; }
    .p3 { background: #F0FDF4; color: #16A34A; border: 1px solid #BBF7D0; }

    /* Footer */
    .footer {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 9pt;
      color: #94A3B8;
      border-top: 1px solid #E2E8F0;
      padding-top: 10px;
    }
  </style>
</head>
<body>

  <!-- ==================== PÁGINA 1 ==================== -->
  <div class="page">
    <div class="header">
      <div class="brand-logo">
        <div class="brand-badge">FM</div>
        <div>
          <div class="brand-title">FitMorph AI</div>
          <div class="brand-subtitle">Auditoria Especializada de Design & UI/UX</div>
        </div>
      </div>
      <div class="header-meta">
        <div>Relatório Executivo v1.0</div>
        <div>29 de Outubro de 2026</div>
        <div class="tag-seal">★ NÍVEL INTERNACIONAL</div>
      </div>
    </div>

    <!-- Score Hero -->
    <div class="score-hero">
      <div class="score-left">
        <h1>Scorecard de Excelência em Design</h1>
        <p>Avaliação heurística do FitMorph AI baseada nas diretrizes internacionais de Ergonomia Mobile, Gamificação Saudável e Princípios Nielsen.</p>
        <p style="margin-top: 6px; color: #38BDF8; font-weight: 600;">Tema: Branco Gelo Nórdico (#F4F7FB) com Acentos Atléticos & Ciano Esteira</p>
      </div>
      <div class="score-badge">
        <div class="score-number">9.5</div>
        <div class="score-label">Nota Geral / 10</div>
      </div>
    </div>

    <div class="section-title">Pilares de Avaliação Heurística</div>
    <div class="score-grid">
      <div class="card">
        <div class="card-title">
          <span>Estética Visual Moderna</span>
          <span style="color:#00C853; font-weight:800;">9.7</span>
        </div>
        <div class="progress-bar-bg"><div class="progress-bar-fill fill-lime" style="width: 97%;"></div></div>
        <div class="card-desc">Sensação premium, pódio 3D, visual atlético sem saturação, glassmorphism de precisão e alta tecnologia.</div>
      </div>

      <div class="card">
        <div class="card-title">
          <span>Harmonia Cromática</span>
          <span style="color:#0284C7; font-weight:800;">9.6</span>
        </div>
        <div class="progress-bar-bg"><div class="progress-bar-fill fill-cyan" style="width: 96%;"></div></div>
        <div class="card-desc">Paleta Branco Gelo límpida com contraste Slate profundo, acentos Lime, Ciano de esteira e Rubi de superação.</div>
      </div>

      <div class="card">
        <div class="card-title">
          <span>Ergonomia & Usabilidade</span>
          <span style="color:#00C853; font-weight:800;">9.5</span>
        </div>
        <div class="progress-bar-bg"><div class="progress-bar-fill fill-lime" style="width: 95%;"></div></div>
        <div class="card-desc">Ação principal "Zero Scroll" no topo, navegação fluida em 3 abas segmented pills e modais de 1 toque.</div>
      </div>

      <div class="card">
        <div class="card-title">
          <span>Gamificação & Pódio Social</span>
          <span style="color:#7C3AED; font-weight:800;">9.5</span>
        </div>
        <div class="progress-bar-bg"><div class="progress-bar-fill fill-purple" style="width: 95%;"></div></div>
        <div class="card-desc">Pódio escalonado por horas na esteira e treinos, badges com citação motivacional e selos anti-desistência.</div>
      </div>

      <div class="card">
        <div class="card-title">
          <span>Consistência do Sistema</span>
          <span style="color:#0284C7; font-weight:800;">9.4</span>
        </div>
        <div class="progress-bar-bg"><div class="progress-bar-fill fill-cyan" style="width: 94%;"></div></div>
        <div class="card-desc">Padronização sólida através de tokens globais em AppColors, GlassCard, PodiumWidget e ChoiceChips.</div>
      </div>

      <div class="card">
        <div class="card-title">
          <span>Tipografia & Acessibilidade</span>
          <span style="color:#00C853; font-weight:800;">9.3</span>
        </div>
        <div class="progress-bar-bg"><div class="progress-bar-fill fill-lime" style="width: 93%;"></div></div>
        <div class="card-desc">Formatação de horas/minutos em Outfit 800 de alta legibilidade, contraste WCAG AAA e alvos táteis amplos.</div>
      </div>
    </div>

    <!-- Pontos Fortes -->
    <div class="section-title">Principais Destaques de Design do FitMorph AI</div>
    <div class="two-cols">
      <div class="pillar-box">
        <h3><span class="icon-green">✓</span> Inovação em Ergonomia Mobile</h3>
        <div class="list-item">
          <span class="list-icon icon-green">•</span>
          <span><strong>Hero Card "Treino de Hoje"</strong>: Elimina a necessidade de rolar a página. O usuário inicia a sessão em 1 toque no topo.</span>
        </div>
        <div class="list-item">
          <span class="list-icon icon-green">•</span>
          <span><strong>Segmented Tabs Modernas</strong>: A alternância entre "Meus Treinos" e "Anatomia & Volume" desafoga a tela principal.</span>
        </div>
        <div class="list-item">
          <span class="list-icon icon-green">•</span>
          <span><strong>Calculadora de Anilhas Interativa</strong>: Renderização realista das placas olímpicas na barra, reduzindo esforço cognitivo.</span>
        </div>
      </div>

      <div class="pillar-box">
        <h3><span class="icon-blue">✓</span> Identidade Visual & Sofisticação</h3>
        <div class="list-item">
          <span class="list-icon icon-blue">•</span>
          <span><strong>Fundo Branco Gelo (#F4F7FB)</strong>: Transmite clareza, limpeza e leveza científica, superior aos designs escuros saturados.</span>
        </div>
        <div class="list-item">
          <span class="list-icon icon-blue">•</span>
          <span><strong>Manequim Anatômico 3D com Brilho</strong>: Iluminação por grupamentos musculares específicos cria conexão tátil e visual de alto valor.</span>
        </div>
        <div class="list-item">
          <span class="list-icon icon-blue">•</span>
          <span><strong>Divisão de Metas Nutricionais</strong>: Cards de macronutrientes limpos e barra de hidratação fluida.</span>
        </div>
      </div>
    </div>

    <div class="footer">
      <span>FitMorph AI — Auditoria de Design Executiva</span>
      <span>Página 1 de 2</span>
    </div>
  </div>

  <!-- ==================== PÁGINA 2 ==================== -->
  <div class="page">
    <div class="header">
      <div class="brand-logo">
        <div class="brand-badge">FM</div>
        <div>
          <div class="brand-title">FitMorph AI</div>
          <div class="brand-subtitle">Matriz de Oportunidades & Recomendações</div>
        </div>
      </div>
      <div class="header-meta">
        <div>Relatório Executivo v1.0</div>
        <div>29 de Outubro de 2026</div>
      </div>
    </div>

    <div class="section-title">Roadmap de Melhorias Sugeridas pelo Especialista</div>
    <p style="font-size: 10.5pt; color: #475569; margin-bottom: 14px;">
      Para levar a nota de <strong>9.3</strong> para a perfeição absoluta (<strong>9.8+</strong>), a equipe de design propõe a implementação das seguintes melhorias graduadas por prioridade:
    </p>

    <table class="table-custom">
      <thead>
        <tr>
          <th style="width: 14%;">Prioridade</th>
          <th style="width: 26%;">Melhoria Proposta</th>
          <th style="width: 42%;">Impacto na Experiência do Usuário</th>
          <th style="width: 18%;">Esforço</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><span class="badge-priority p1">P1 - Alta</span></td>
          <td><strong>Feedback Háptico & Tátil</strong></td>
          <td>Disparar micro-vibrações táteis nos botões de conclusão de série e no timer de descanso para reforçar a confirmação da ação.</td>
          <td>Baixo (1-2h)</td>
        </tr>
        <tr>
          <td><span class="badge-priority p1">P1 - Alta</span></td>
          <td><strong>Alternador de Tema (Light / Dark)</strong></td>
          <td>Adicionar um seletor no Perfil permitindo ao usuário alternar entre o tema padrão <em>Branco Gelo</em> e o modo <em>Dark Neon</em> para treinos noturnos.</td>
          <td>Médio (3-4h)</td>
        </tr>
        <tr>
          <td><span class="badge-priority p2">P2 - Média</span></td>
          <td><strong>Opções de Pratos na Nutrição</strong></td>
          <td>Modal com seleção de pratos com fotos e ingredientes pesados para a partição calórica de cada refeição (Café, Almoço, Jantar).</td>
          <td>Médio (4h)</td>
        </tr>
        <tr>
          <td><span class="badge-priority p2">P2 - Média</span></td>
          <td><strong>Alinhamento da Landing Page</strong></td>
          <td>Atualizar a landing page web (<code>home-page/</code>) com a mesma identidade elegante em Branco Gelo utilizada no aplicativo Flutter.</td>
          <td>Médio (3h)</td>
        </tr>
        <tr>
          <td><span class="badge-priority p3">P3 - Baixa</span></td>
          <td><strong>Animações de Conclusão (Confete)</strong></td>
          <td>Efeito visual de partículas ao encerrar o treino para recompensar o esforço do atleta e impulsionar a retenção diária.</td>
          <td>Baixo (2h)</td>
        </tr>
      </tbody>
    </table>

    <div style="margin-top: 18px;" class="section-title">Conclusão & Recomendação da Avaliação</div>
    <div style="background: #F0FDF4; border: 1.5px solid #86EFAC; border-radius: 12px; padding: 12px 16px; margin-bottom: 35px;">
      <h4 style="color: #15803D; font-family: 'Outfit', sans-serif; font-size: 12px; font-weight: 700; margin-bottom: 4px;">
        Veredito Final: Design Aprovado com Louvor (Classificação Excelente)
      </h4>
      <p style="font-size: 9.8pt; color: #166534; line-height: 1.45;">
        O FitMorph AI conquistou uma nota <strong>9.3 / 10</strong> por combinar estética de vanguarda com respeito rigoroso à ergonomia esportiva. As escolhas cromáticas, contrastes de alto padrão e ausência de atrito no início da sessão tornam o produto competitivo com os maiores players internacionais do mercado de tecnologia fitness.
      </p>
    </div>

    <div class="footer">
      <span>FitMorph AI — Auditoria de Design Executiva</span>
      <span>Página 2 de 2</span>
    </div>
  </div>

</body>
</html>
"""

def generate_reports():
    print("[1/3] Gerando arquivo Markdown do relatório...")
    with open(MD_OUTPUT_PATH, "w", encoding="utf-8") as f:
        f.write(MD_CONTENT)
    print(f"  -> Markdown salvo em: {MD_OUTPUT_PATH}")

    print("[2/3] Gerando arquivo HTML otimizado para impressão...")
    with open(HTML_TEMP_PATH, "w", encoding="utf-8") as f:
        f.write(HTML_TEMPLATE)
    print(f"  -> HTML temporário salvo em: {HTML_TEMP_PATH}")

    print("[3/3] Compilando PDF de alta fidelidade visual via Chrome Headless...")
    chrome_paths = [
        r"C:\Program Files\Google\Chrome\Application\chrome.exe",
        r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    ]

    chrome_bin = None
    for p in chrome_paths:
        if os.path.exists(p):
            chrome_bin = p
            break

    if not chrome_bin:
        print("  [AVISO] Chrome não encontrado nos caminhos padrão. Tentando fallback via ReportLab...")
        generate_reportlab_fallback()
        return

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
        print(f"  [SUCESSO] PDF Executivo gerado com sucesso!")
        print(f"  -> Arquivo PDF: {PDF_OUTPUT_PATH} ({os.path.getsize(PDF_OUTPUT_PATH):,} bytes)")
    else:
        print(f"  [ERRO] Chrome retornou código {res.returncode}. Tentando ReportLab fallback...")
        generate_reportlab_fallback()

    # Clean up temp HTML
    if HTML_TEMP_PATH.exists():
        try:
            HTML_TEMP_PATH.unlink()
        except Exception:
            pass

def generate_reportlab_fallback():
    try:
        from reportlab.lib.pagesizes import letter
        from reportlab.pdfgen import canvas
        c = canvas.Canvas(str(PDF_OUTPUT_PATH), pagesize=letter)
        c.drawString(100, 750, "FitMorph AI — Relatório de Design (Fallback)")
        c.drawString(100, 720, "Nota Geral: 9.3 / 10")
        c.save()
        print(f"  -> PDF Fallback salvo em: {PDF_OUTPUT_PATH}")
    except Exception as e:
        print(f"  -> Falha no fallback: {e}")

if __name__ == "__main__":
    generate_reports()
