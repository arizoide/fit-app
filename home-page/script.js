/**
 * FitMorph AI - Interactive Scripts
 * Powers live Plate Calculator, TDEE & Macro Calculator,
 * AI Workout Generator Demo, FAQ Accordion, and Navigation.
 */

document.addEventListener('DOMContentLoaded', () => {
  initNavigation();
  initPlateCalculator();
  initTdeeCalculator();
  initWorkoutGeneratorDemo();
  initFaqAccordion();
  initStatCounters();
});

/* ==========================================================================
   Navigation & Scroll Effects
   ========================================================================== */
function initNavigation() {
  const header = document.getElementById('header');
  const mobileToggle = document.getElementById('mobile-toggle');
  const navMenu = document.getElementById('nav-menu');
  const navLinks = document.querySelectorAll('.nav-link');

  // Sticky header on scroll
  window.addEventListener('scroll', () => {
    if (window.scrollY > 40) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  });

  // Mobile menu toggle
  if (mobileToggle && navMenu) {
    mobileToggle.addEventListener('click', () => {
      navMenu.classList.toggle('open');
      const isOpen = navMenu.classList.contains('open');
      mobileToggle.setAttribute('aria-expanded', isOpen);
    });

    // Close menu when clicking link
    navLinks.forEach(link => {
      link.addEventListener('click', () => {
        navMenu.classList.remove('open');
      });
    });
  }

  // Simulator tab switching
  const tabBtns = document.querySelectorAll('.tab-btn');
  const tabPanels = document.querySelectorAll('.simulator-panel');

  tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      tabBtns.forEach(b => b.classList.remove('active'));
      tabPanels.forEach(p => p.classList.remove('active'));

      btn.classList.add('active');
      const targetId = btn.getAttribute('data-tab');
      const targetPanel = document.getElementById(targetId);
      if (targetPanel) {
        targetPanel.classList.add('active');
      }
    });
  });
}

/* ==========================================================================
   Feature 1: Interactive Plate Calculator (Anilhas)
   ========================================================================== */
function initPlateCalculator() {
  let barWeight = 20.0; // Padrão barra olímpica
  let targetWeight = 80.0;
  const availablePlates = [25.0, 20.0, 15.0, 10.0, 5.0, 2.5, 1.25];

  const plateColors = {
    25: { bg: '#D32F2F', height: 110, width: 14, text: '#FFF' },
    20: { bg: '#1976D2', height: 100, width: 14, text: '#FFF' },
    15: { bg: '#FBC02D', height: 88, width: 12, text: '#000' },
    10: { bg: '#388E3C', height: 75, width: 12, text: '#FFF' },
    5:  { bg: '#ECEFF1', height: 60, width: 10, text: '#000' },
    2.5:{ bg: '#78909C', height: 48, width: 8, text: '#FFF' },
    1.25:{ bg: '#455A64', height: 38, width: 6, text: '#FFF' }
  };

  const slider = document.getElementById('plate-slider');
  const targetDisplay = document.getElementById('plate-target-display');
  const weightPerSideEl = document.getElementById('weight-per-side');
  const totalBarbellEl = document.getElementById('total-barbell-weight');
  const leftStack = document.getElementById('plates-stack-left');
  const rightStack = document.getElementById('plates-stack-right');
  const breakdownList = document.getElementById('plates-breakdown-list');
  const barBtns = document.querySelectorAll('.bar-btn');
  const deltaChips = document.querySelectorAll('.adjust-chip');

  function calculatePlates(totalWeight, bar) {
    let remainingPerSide = (totalWeight - bar) / 2.0;
    if (remainingPerSide <= 0) return { plates: {}, perSide: 0 };

    const platesCount = {};
    for (const plate of availablePlates) {
      if (remainingPerSide >= plate) {
        const count = Math.floor(remainingPerSide / plate);
        platesCount[plate] = count;
        remainingPerSide = +(remainingPerSide - count * plate).toFixed(2);
      }
    }
    return { plates: platesCount, perSide: (totalWeight - bar) / 2.0 };
  }

  function updateView() {
    targetDisplay.textContent = `${targetWeight.toFixed(1)} kg`;
    totalBarbellEl.innerHTML = `${targetWeight.toFixed(1)} <small>kg</small>`;

    const { plates, perSide } = calculatePlates(targetWeight, barWeight);
    weightPerSideEl.innerHTML = `${Math.max(0, perSide).toFixed(1)} <small>kg/lado</small>`;

    // Render graphical plates inside left and right stack
    leftStack.innerHTML = '';
    rightStack.innerHTML = '';
    breakdownList.innerHTML = '';

    const plateKeys = Object.keys(plates).map(Number).sort((a, b) => b - a);

    if (plateKeys.length === 0) {
      breakdownList.innerHTML = `<span class="plate-summary-chip">Nenhuma anilha necessária (apenas barra de ${barWeight}kg)</span>`;
      return;
    }

    // Build stacks
    plateKeys.forEach(pVal => {
      const count = plates[pVal];
      const conf = plateColors[pVal] || { bg: '#607D8B', height: 50, width: 8, text: '#FFF' };

      for (let i = 0; i < count; i++) {
        // Left plate
        const lPlate = document.createElement('div');
        lPlate.className = 'rendered-plate';
        lPlate.style.backgroundColor = conf.bg;
        lPlate.style.height = `${conf.height}px`;
        lPlate.style.width = `${conf.width}px`;
        lPlate.title = `${pVal} kg`;
        leftStack.appendChild(lPlate);

        // Right plate
        const rPlate = document.createElement('div');
        rPlate.className = 'rendered-plate';
        rPlate.style.backgroundColor = conf.bg;
        rPlate.style.height = `${conf.height}px`;
        rPlate.style.width = `${conf.width}px`;
        rPlate.title = `${pVal} kg`;
        rightStack.appendChild(rPlate);
      }

      // Add to summary chips
      const chip = document.createElement('div');
      chip.className = 'plate-summary-chip';
      chip.innerHTML = `
        <span class="plate-badge" style="background:${conf.bg}; color:${conf.text}">${pVal}kg</span>
        <span>${count}x por lado</span>
      `;
      breakdownList.appendChild(chip);
    });
  }

  // Event Listeners
  if (slider) {
    slider.addEventListener('input', (e) => {
      targetWeight = parseFloat(e.target.value);
      updateView();
    });
  }

  barBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      barBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      barWeight = parseFloat(btn.getAttribute('data-bar'));
      if (targetWeight < barWeight) {
        targetWeight = barWeight;
        if (slider) slider.value = targetWeight;
      }
      updateView();
    });
  });

  deltaChips.forEach(chip => {
    chip.addEventListener('click', () => {
      const delta = parseFloat(chip.getAttribute('data-delta'));
      targetWeight = Math.max(barWeight, Math.min(260, targetWeight + delta));
      if (slider) slider.value = targetWeight;
      updateView();
    });
  });

  // Initial render
  updateView();
}

/* ==========================================================================
   Feature 2: Interactive TDEE & Macro Calculator
   ========================================================================== */
function initTdeeCalculator() {
  const weightInput = document.getElementById('tdee-weight');
  const heightInput = document.getElementById('tdee-height');
  const ageInput = document.getElementById('tdee-age');
  const activitySelect = document.getElementById('tdee-activity');
  const genderBtns = document.querySelectorAll('#tab-tdee .seg-btn');
  const goalBtns = document.querySelectorAll('.goal-btn');

  const bmrDisplay = document.getElementById('bmr-display');
  const tdeeDisplay = document.getElementById('tdee-display');
  const targetCalDisplay = document.getElementById('target-cal-display');
  const waterDisplay = document.getElementById('water-display');
  
  const proteinGramsEl = document.getElementById('protein-grams');
  const carbsGramsEl = document.getElementById('carbs-grams');
  const fatsGramsEl = document.getElementById('fats-grams');

  const proteinBar = document.getElementById('protein-bar');
  const carbsBar = document.getElementById('carbs-bar');
  const fatsBar = document.getElementById('fats-bar');

  let gender = 'male';
  let goal = 'hypertrophy';

  function calculate() {
    const weight = parseFloat(weightInput.value) || 75;
    const height = parseFloat(heightInput.value) || 175;
    const age = parseInt(ageInput.value) || 25;
    const activityMult = parseFloat(activitySelect.value) || 1.55;

    // BMR via Mifflin-St Jeor (exatamente como em tdee_calculator.dart)
    let bmr = 0;
    if (gender === 'male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    const tdee = bmr * activityMult;

    // Goal parameters
    let targetCalories = 0;
    let targetProteinPerKg = 2.0;
    let fatRatio = 0.25;

    switch (goal) {
      case 'hypertrophy':
        targetCalories = Math.round(tdee + 300);
        targetProteinPerKg = 2.0;
        fatRatio = 0.25;
        break;
      case 'fatLoss':
        targetCalories = Math.round(Math.max(1200, Math.min(5000, tdee - 450)));
        targetProteinPerKg = 2.2;
        fatRatio = 0.25;
        break;
      case 'recomposition':
        targetCalories = Math.round(tdee - 100);
        targetProteinPerKg = 2.3;
        fatRatio = 0.25;
        break;
      default:
        targetCalories = Math.round(tdee);
    }

    const proteinGrams = Math.round(weight * targetProteinPerKg);
    const proteinCal = proteinGrams * 4;

    const fatCal = targetCalories * fatRatio;
    const fatsGrams = Math.round(fatCal / 9);

    const remainingCal = targetCalories - proteinCal - (fatsGrams * 9);
    const carbsGrams = Math.round(Math.max(30, remainingCal / 4));

    const recommendedWater = Math.round(weight * 38);

    // Update displays
    bmrDisplay.innerHTML = `${Math.round(bmr).toLocaleString('pt-BR')} <small>kcal</small>`;
    tdeeDisplay.innerHTML = `${Math.round(tdee).toLocaleString('pt-BR')} <small>kcal</small>`;
    targetCalDisplay.innerHTML = `${targetCalories.toLocaleString('pt-BR')} <small>kcal/dia</small>`;
    waterDisplay.textContent = `${recommendedWater.toLocaleString('pt-BR')} ml`;

    proteinGramsEl.textContent = `${proteinGrams} g (${Math.round((proteinCal / targetCalories) * 100)}%)`;
    carbsGramsEl.textContent = `${carbsGrams} g (${Math.round(((carbsGrams * 4) / targetCalories) * 100)}%)`;
    fatsGramsEl.textContent = `${fatsGrams} g (${Math.round(((fatsGrams * 9) / targetCalories) * 100)}%)`;

    // Bar percentages
    const totalMacroCal = (proteinGrams * 4) + (carbsGrams * 4) + (fatsGrams * 9);
    proteinBar.style.width = `${((proteinGrams * 4) / totalMacroCal) * 100}%`;
    carbsBar.style.width = `${((carbsGrams * 4) / totalMacroCal) * 100}%`;
    fatsBar.style.width = `${((fatsGrams * 9) / totalMacroCal) * 100}%`;
  }

  // Listeners
  [weightInput, heightInput, ageInput, activitySelect].forEach(input => {
    if (input) input.addEventListener('input', calculate);
  });

  genderBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      genderBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      gender = btn.getAttribute('data-gender');
      calculate();
    });
  });

  goalBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      goalBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      goal = btn.getAttribute('data-goal');
      calculate();
    });
  });

  calculate();
}

/* ==========================================================================
   Feature 3: AI Workout Generator Interactive Demo
   ========================================================================== */
function initWorkoutGeneratorDemo() {
  const focusSelect = document.getElementById('workout-focus');
  const levelBtns = document.querySelectorAll('#tab-workout [data-level]');
  const timeBtns = document.querySelectorAll('#tab-workout [data-time]');
  const generateBtn = document.getElementById('btn-generate-demo');
  
  const splitBadge = document.getElementById('sheet-split-badge');
  const sheetTitle = document.getElementById('sheet-title');
  const exerciseListContainer = document.getElementById('demo-exercise-list');
  const coachTip = document.getElementById('demo-coach-tip');

  let currentLevel = 'intermediario';
  let currentTime = '60';

  levelBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      levelBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      currentLevel = btn.getAttribute('data-level');
    });
  });

  timeBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      timeBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      currentTime = btn.getAttribute('data-time');
    });
  });

  const workoutDatabase = {
    agonist_antagonist: {
      badge: 'AGONISTA / ANTAGONISTA • ARNOLD SPLIT',
      title: 'Peitoral & Dorsal (Treino Multi-Músculo Oposto)',
      tip: 'Ao treinar Peito e Costas juntos, a inibição recíproca permite que o dorsal relaxe enquanto o peitoral contrai. O resultado é maior densidade, recuperação rápida entre séries e um pump vascular inigualável.',
      exercises: [
        { name: 'Supino Reto com Barra', muscle: 'Peitoral Maior', sets: '4x 8-10', rest: '90s' },
        { name: 'Puxada Frontal Aberta', muscle: 'Grande Dorsal', sets: '4x 8-10', rest: '90s' },
        { name: 'Supino Inclinado com Halteres', muscle: 'Peitoral Superior', sets: '3x 10-12', rest: '75s' },
        { name: 'Remada Curvada com Barra', muscle: 'Dorsais & Romboides', sets: '3x 8-10', rest: '75s' },
        { name: 'Crucifixo na Polia Média', muscle: 'Isolamento Peito', sets: '3x 12-15', rest: '60s' },
        { name: 'Remada Baixa no Triângulo', muscle: 'Espessura Dorsal', sets: '3x 10-12', rest: '60s' }
      ]
    },
    arms_shoulders: {
      badge: 'BRAÇOS & OMBROS • DENSIDADE TOTAL',
      title: 'Bíceps, Tríceps & Deltóides 3D',
      tip: 'Alterne uma série de bíceps com uma de tríceps (antagonistas de cotovelo) para manter fluxo sanguíneo contínuo e preservar energia neural para os deltoides.',
      exercises: [
        { name: 'Desenvolvimento Militar com Halteres', muscle: 'Deltoide Anterior', sets: '4x 8-10', rest: '75s' },
        { name: 'Rosca Direta com Barra W', muscle: 'Bíceps Braquial', sets: '3x 10-12', rest: '60s' },
        { name: 'Tríceps Testa com Halteres', muscle: 'Tríceps Cabeça Longa', sets: '3x 10-12', rest: '60s' },
        { name: 'Elevação Lateral na Polia', muscle: 'Deltoide Lateral', sets: '4x 12-15', rest: '45s' },
        { name: 'Rosca Martelo com Halteres', muscle: 'Braquial & Antebraço', sets: '3x 10-12', rest: '60s' },
        { name: 'Tríceps Corda na Polia Alta', muscle: 'Tríceps Cabeça Lateral', sets: '3x 12-15', rest: '45s' }
      ]
    },
    chest_triceps: {
      badge: 'PUSH A • HIPERTROFIA MÁXIMA',
      title: 'Peito, Ombros Frontais & Tríceps',
      tip: 'Mantenha RPE 8 nas primeiras 3 séries do Supino Reto e busque falha concêntrica técnica apenas na última série. Concentre-se na fase excêntrica de 2 a 3 segundos.',
      exercises: [
        { name: 'Supino Reto com Barra', muscle: 'Peitoral Maior', sets: '4x 8-10', rest: '90s' },
        { name: 'Supino Inclinado com Halteres', muscle: 'Peitoral Superior', sets: '3x 10-12', rest: '75s' },
        { name: 'Crucifixo na Polia Média', muscle: 'Isolamento Peito', sets: '3x 12-15', rest: '60s' },
        { name: 'Desenvolvimento Militar com Halteres', muscle: 'Deltoide Anterior', sets: '3x 8-10', rest: '75s' },
        { name: 'Elevação Lateral na Polia', muscle: 'Deltoide Lateral', sets: '4x 12-15', rest: '45s' },
        { name: 'Tríceps Corda na Polia Alta', muscle: 'Tríceps (Cabeça Lateral)', sets: '4x 10-12', rest: '60s' }
      ]
    },
    back_biceps: {
      badge: 'PULL A • EXPANSÃO DORSAL',
      title: 'Costas, Deltoide Posterior & Bíceps',
      tip: 'Inicie a remada com a retração escapular ativa antes de flexionar os cotovelos. Isso otimiza o recrutamento dos dorsais e reduz o estresse no antebraço.',
      exercises: [
        { name: 'Puxada Frontal Aberta', muscle: 'Grande Dorsal', sets: '4x 8-10', rest: '90s' },
        { name: 'Remada Curvada com Barra', muscle: 'Dorsais & Romboides', sets: '4x 8-10', rest: '90s' },
        { name: 'Remada Baixa no Triângulo', muscle: 'Espessura Dorsal', sets: '3x 10-12', rest: '60s' },
        { name: 'Crucifixo Invertido no Peck Deck', muscle: 'Deltoide Posterior', sets: '3x 12-15', rest: '45s' },
        { name: 'Rosca Direta com Barra W', muscle: 'Bíceps Braquial', sets: '3x 10-12', rest: '60s' },
        { name: 'Rosca Martelo com Halteres', muscle: 'Braquial & Braquiorradial', sets: '3x 10-12', rest: '60s' }
      ]
    },
    legs_core: {
      badge: 'LEGS COMPLETE • FORÇA & DENSIDADE',
      title: 'Quadríceps, Isquiotibiais & Panturrilhas',
      tip: 'No Agachamento Livre, garanta profundidade válida sem retroversão pélvica excessiva. Utilize a calculadora de anilhas para aquecimento progressivo.',
      exercises: [
        { name: 'Agachamento Livre com Barra', muscle: 'Quadríceps & Glúteos', sets: '4x 6-8', rest: '120s' },
        { name: 'Leg Press 45° Articulado', muscle: 'Membros Inferiores', sets: '3x 10-12', rest: '90s' },
        { name: 'Cadeira Extensora', muscle: 'Quadríceps Isolado', sets: '3x 12-15', rest: '60s' },
        { name: 'Mesa Flexora Deitada', muscle: 'Isquiotibiais', sets: '4x 10-12', rest: '60s' },
        { name: 'Gêmeos em Pé (Panturrilhas)', muscle: 'Gastrocnêmio', sets: '4x 15-20', rest: '45s' },
        { name: 'Prancha Abdominal com Carga', muscle: 'Core & Estabilidade', sets: '3x 45s', rest: '45s' }
      ]
    },
    upper_focus: {
      badge: 'UPPER BODY • POTÊNCIA & EQUILÍBRIO',
      title: 'Membros Superiores Completo',
      tip: 'Treino com excelente estímulo para quem tem frequência de 4 dias semanais (Upper/Lower). Mantenha intensidade alta e controle o tempo de descanso.',
      exercises: [
        { name: 'Supino Reto com Halteres', muscle: 'Peitoral Maior', sets: '4x 8-10', rest: '90s' },
        { name: 'Barra Fixa (Pull-ups) ou Graviton', muscle: 'Grande Dorsal', sets: '4x 6-10', rest: '90s' },
        { name: 'Desenvolvimento Máquina', muscle: 'Ombros', sets: '3x 10-12', rest: '60s' },
        { name: 'Remada Serrote com Halter', muscle: 'Dorsais Unilateral', sets: '3x 10-12', rest: '60s' },
        { name: 'Tríceps Testa com Barra W', muscle: 'Tríceps Cabeça Longa', sets: '3x 10-12', rest: '60s' },
        { name: 'Rosca Scott com Halter', muscle: 'Pico do Bíceps', sets: '3x 10-12', rest: '60s' }
      ]
    }
  };

  function renderWorkout() {
    const focusKey = focusSelect ? focusSelect.value : 'agonist_antagonist';
    const data = workoutDatabase[focusKey] || workoutDatabase['agonist_antagonist'];

    splitBadge.textContent = `${data.badge} • NÍVEL ${currentLevel.toUpperCase()}`;
    sheetTitle.textContent = data.title;
    coachTip.innerHTML = `<strong>Dica do FitMorph AI:</strong> ${data.tip}`;

    exerciseListContainer.innerHTML = '';
    data.exercises.forEach((ex, idx) => {
      const row = document.createElement('div');
      row.className = 'exercise-item-row';
      row.innerHTML = `
        <div class="ex-info-left">
          <span class="ex-num">${idx + 1}</span>
          <div>
            <h5 class="ex-name">${ex.name}</h5>
            <span class="ex-muscle">${ex.muscle}</span>
          </div>
        </div>
        <div class="ex-meta-right">
          <span class="ex-sets-reps">${ex.sets}</span>
          <span class="ex-rest">⏱️ ${ex.rest}</span>
        </div>
      `;
      exerciseListContainer.appendChild(row);
    });
  }

  if (generateBtn) {
    generateBtn.addEventListener('click', () => {
      generateBtn.disabled = true;
      generateBtn.innerHTML = `<span>⚡ Otimizando com Gemini AI...</span>`;

      setTimeout(() => {
        renderWorkout();
        generateBtn.disabled = false;
        generateBtn.innerHTML = `<span class="sparkle-icon">✨</span><span>Gerar Ficha com FitMorph AI</span>`;
      }, 400);
    });
  }

  if (focusSelect) {
    focusSelect.addEventListener('change', renderWorkout);
  }

  // Initial populate
  renderWorkout();
}

/* ==========================================================================
   FAQ Accordion
   ========================================================================== */
function initFaqAccordion() {
  const faqItems = document.querySelectorAll('.faq-item');

  faqItems.forEach(item => {
    const questionBtn = item.querySelector('.faq-question');
    const answer = item.querySelector('.faq-answer');

    if (questionBtn && answer) {
      questionBtn.addEventListener('click', () => {
        const isActive = item.classList.contains('active');

        // Close others
        faqItems.forEach(other => {
          other.classList.remove('active');
          const otherAns = other.querySelector('.faq-answer');
          if (otherAns) otherAns.style.maxHeight = null;
        });

        if (!isActive) {
          item.classList.add('active');
          answer.style.maxHeight = `${answer.scrollHeight}px`;
        }
      });
    }
  });
}

/* ==========================================================================
   Stat Number Counters Animation
   ========================================================================== */
function initStatCounters() {
  const statNumbers = document.querySelectorAll('.stat-number[data-target]');
  if (!statNumbers.length) return;

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const el = entry.target;
        const target = parseInt(el.getAttribute('data-target'), 10);
        let count = 0;
        const speed = 20;
        const increment = Math.ceil(target / (1000 / speed));

        const timer = setInterval(() => {
          count += increment;
          if (count >= target) {
            el.textContent = `${target}+`;
            clearInterval(timer);
          } else {
            el.textContent = `${count}+`;
          }
        }, speed);

        observer.unobserve(el);
      }
    });
  }, { threshold: 0.5 });

  statNumbers.forEach(num => observer.observe(num));
}
