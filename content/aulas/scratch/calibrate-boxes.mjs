import { chromium } from 'playwright';
import path from 'path';

/**
 * Calibrate Boxes (Scratch QA Script)
 * Uso: node scratch/calibrate-boxes.mjs --aula metanalise --slide s-forest2
 * 
 * Abre o slide específico, injeta caixas de calibração semi-transparentes
 * sobre o grid e imprime as coordenadas absolutas (top, left, width, height)
 * em % no console para que agentes de código (como Claude)
 * possam usar dados precisos em vez de 'chutar' coordenadas CSS.
 */

const args = process.argv.slice(2);
let aula = 'metanalise';
let slideId = 's-forest2';

for (let i = 0; i < args.length; i++) {
  if (args[i] === '--aula') aula = args[i + 1];
  if (args[i] === '--slide') slideId = args[i + 1];
}

(async () => {
  console.log(`[Calibrate] Iniciando Playwright para aula '${aula}' no slide '${slideId}'...`);
  const browser = await chromium.launch({ headless: true }); // Pode mudar para false pra testar visualmente
  const page = await browser.newPage();
  
  await page.goto(`http://localhost:4102/${aula}/index.html`);
  
  // Avança até o slide desejado
  await page.evaluate(async (id) => {
    while (!document.querySelector(`section.active#${id}`)) {
      if (!window.deck || !window.deck.next) break;
      window.deck.next();
      await new Promise(r => setTimeout(r, 100)); // wait for transition
    }
  }, slideId);

  console.log(`[Calibrate] Extraindo bounding boxes (wrapper vs imagem vs zones)...`);

  const metrics = await page.evaluate((id) => {
    const slide = document.getElementById(id);
    if (!slide) return { error: "Slide not found" };

    const wrapper = slide.querySelector('.forest-annotated') || slide.querySelector('.slide-inner');
    if (!wrapper) return { error: "Wrapper container not found" };

    const wrapRect = wrapper.getBoundingClientRect();
    const result = {
      wrapperSize: { width: wrapRect.width, height: wrapRect.height },
      zones: {}
    };

    const zones = slide.querySelectorAll('.forest-zone, .forest-zone--rob');
    zones.forEach((z, idx) => {
      const zRect = z.getBoundingClientRect();
      const className = Array.from(z.classList).find(c => c.startsWith('forest-zone--')) || `zone-${idx}`;
      
      // Calculate percentages relative to wrapper!
      const topPct = ((zRect.top - wrapRect.top) / wrapRect.height) * 100;
      const leftPct = ((zRect.left - wrapRect.left) / wrapRect.width) * 100;
      const widthPct = (zRect.width / wrapRect.width) * 100;
      const heightPct = (zRect.height / wrapRect.height) * 100;

      result.zones[className] = {
        top: `${topPct.toFixed(2)}%`,
        left: `${leftPct.toFixed(2)}%`,
        width: `${widthPct.toFixed(2)}%`,
        height: `${heightPct.toFixed(2)}%`
      };
    });

    return result;
  }, slideId);

  console.log("\n=============================================");
  console.log("CALIBRAÇÃO DE COORDENADAS (Anti-Chute Claude)");
  console.log("=============================================\n");
  console.log(JSON.stringify(metrics, null, 2));

  await browser.close();
})();
