# ==============================================================================
# FitMorph AI - Sentinel QA Product Tester Automation Script
# Executa a auditoria completa de qualidade e certificacao tecnica do produto.
# ==============================================================================

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "[QA TESTER] FITMORPH AI - AUDITORIA DE GARANTIA DA QUALIDADE" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "Iniciando verificacao dos Portões de Qualidade..." -ForegroundColor Yellow
Write-Host ""

$qaPassed = $true

# ------------------------------------------------------------------------------
# 1. Portao de Analise Estatística (Lint & Tipos)
# ------------------------------------------------------------------------------
Write-Host "[Portao 1/3] Executando Analise Estatistica (flutter analyze)..." -ForegroundColor Cyan
$analyzeOutput = & flutter analyze 2>&1 | Out-String

if ($analyzeOutput -match "No issues found!") {
    Write-Host "  [OK] Analise Estatistica Aprovada: 0 erros, 0 avisos." -ForegroundColor Green
} else {
    Write-Host "  [FALHA] Analise Estatistica Reprovada!" -ForegroundColor Red
    Write-Host $analyzeOutput -ForegroundColor DarkGray
    $qaPassed = $false
}

Write-Host ""

# ------------------------------------------------------------------------------
# 2. Portao de Testes Automatizados & E2E Biomecanicos
# ------------------------------------------------------------------------------
Write-Host "[Portao 2/3] Executando Suite Completa de Testes Automatizados..." -ForegroundColor Cyan
$testOutput = & flutter test 2>&1 | Out-String

if ($testOutput -match "All tests passed!") {
    Write-Host "  [OK] Suite de Testes Aprovada: 100% dos testes executados com sucesso!" -ForegroundColor Green
} else {
    Write-Host "  [FALHA] Falha na Suite de Testes!" -ForegroundColor Red
    Write-Host $testOutput -ForegroundColor DarkGray
    $qaPassed = $false
}

Write-Host ""

# ------------------------------------------------------------------------------
# 3. Portao de Integridade da Estrutura de Arquivos
# ------------------------------------------------------------------------------
Write-Host "[Portao 3/3] Verificando Integridade dos Componentes Criticos..." -ForegroundColor Cyan
$criticalFiles = @(
    "lib/core/constants/app_colors.dart",
    "lib/core/network/gemini_service.dart",
    "lib/features/workout_generator/presentation/screens/workout_plan_screen.dart",
    "lib/features/active_workout/presentation/screens/active_workout_screen.dart",
    "lib/features/diet_calories/presentation/screens/diet_calories_screen.dart",
    "lib/features/anamnese/presentation/screens/anamnese_wizard_screen.dart",
    "test/qa_product_e2e_test.dart",
    ".agents/skills/qa-product-tester/SKILL.md",
    "AGENTS.md"
)

$missingFiles = @()
foreach ($file in $criticalFiles) {
    if (-not (Test-Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -eq 0) {
    Write-Host "  [OK] Todos os componentes criticos e documentacoes estao integros." -ForegroundColor Green
} else {
    Write-Host "  [FALHA] Arquivos criticos ausentes: $($missingFiles -join ', ')" -ForegroundColor Red
    $qaPassed = $false
}

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
if ($qaPassed) {
    Write-Host "[SUCESSO] CERTIFICACAO CONCLUIDA: O PRODUTO ESTA 100% APROVADO PELO QA TESTER!" -ForegroundColor Green
    Write-Host "Qualidade garantida: Biomecanica, Nutricao, UI Branco Gelo e Zero Regressoes." -ForegroundColor White
} else {
    Write-Host "[ATENCAO] CERTIFICACAO REPROVADA: Correcoes necessarias antes do envio." -ForegroundColor Red
}
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

if (-not $qaPassed) {
    exit 1
} else {
    exit 0
}
