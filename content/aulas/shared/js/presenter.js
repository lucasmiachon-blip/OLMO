/**
 * presenter.js — Presenter view via BroadcastChannel
 *
 * Usage: press 'p' during presentation to open presenter window.
 * Shows: current slide, next slide preview, speaker notes, timer, progress.
 * Communication: BroadcastChannel 'deck-presenter' (no server needed).
 *
 * The presenter window can also control navigation (arrows/click).
 * Works with any deck.js instance — zero coupling, event-driven.
 */

let channel = null;
let presenterWindow = null;
let startTime = null;

/**
 * Initialize presenter support. Call after initDeck().
 * Adds 'p' keypress listener to open presenter view.
 */
export function initPresenter() {
  channel = new BroadcastChannel('deck-presenter');

  // Listen for navigation commands from presenter window
  channel.onmessage = (e) => {
    if (e.data.type === 'navigate') {
      import('./deck.js').then(({ navigate }) => navigate(e.data.delta));
    }
  };

  // Broadcast slide changes to presenter window
  document.addEventListener('slide:changed', (e) => {
    broadcastState(e.detail.currentSlide, e.detail.indexh);
  });

  // Add 'p' key to open presenter view
  document.addEventListener('keydown', (e) => {
    if (e.key === 'p' || e.key === 'P') {
      if (e.ctrlKey || e.altKey || e.metaKey) return;
      openPresenter();
    }
  });
}

function broadcastState(slide, index) {
  if (!channel) return;

  const sections = document.querySelectorAll('#slide-viewport > section');
  const total = sections.length;
  const nextSlide = sections[index + 1];

  channel.postMessage({
    type: 'slide-update',
    index,
    total,
    slideId: slide?.id || '',
    notes: extractNotes(slide),
    nextNotes: extractNotes(nextSlide),
    nextId: nextSlide?.id || '',
    elapsed: startTime ? Date.now() - startTime : 0,
  });
}

function extractNotes(section) {
  if (!section) return '';
  const aside = section.querySelector('aside.notes, .notes');
  return aside ? aside.textContent : '';
}

function openPresenter() {
  if (presenterWindow && !presenterWindow.closed) {
    presenterWindow.focus();
    return;
  }

  startTime = Date.now();

  presenterWindow = window.open('', 'deck-presenter', 'width=960,height=700');
  if (!presenterWindow) return;

  presenterWindow.document.write(presenterHTML());
  presenterWindow.document.close();

  // Send initial state
  const sections = document.querySelectorAll('#slide-viewport > section');
  const active = document.querySelector('#slide-viewport > section.slide-active');
  const index = Array.from(sections).indexOf(active);
  if (active) broadcastState(active, index);
}

function presenterHTML() {
  return `<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Presenter View</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    font-family: 'DM Sans', system-ui, sans-serif;
    background: #0f0f0f; color: #e0e0e0;
    display: grid;
    grid-template: "header header" auto "notes next" 1fr "footer footer" auto / 1fr 300px;
    height: 100vh; gap: 12px; padding: 12px;
  }
  .header {
    grid-area: header;
    display: flex; justify-content: space-between; align-items: center;
    padding: 8px 16px;
    background: #1a1a1a; border-radius: 8px;
  }
  .slide-id { font-size: 18px; font-weight: 700; color: #7aa2f7; }
  .progress { font-size: 14px; color: #888; }
  .timer { font-family: 'JetBrains Mono', monospace; font-size: 24px; color: #9ece6a; }
  .notes-panel {
    grid-area: notes;
    background: #1a1a1a; border-radius: 8px;
    padding: 20px; overflow-y: auto;
    font-size: 16px; line-height: 1.6;
  }
  .notes-panel h3 { color: #7aa2f7; margin-bottom: 12px; font-size: 13px; text-transform: uppercase; letter-spacing: 0.1em; }
  .notes-panel .content { color: #ccc; }
  .notes-panel .content br { margin-bottom: 4px; }
  .next-panel {
    grid-area: next;
    background: #1a1a1a; border-radius: 8px;
    padding: 16px; display: flex; flex-direction: column; gap: 8px;
  }
  .next-panel h3 { color: #888; font-size: 13px; text-transform: uppercase; letter-spacing: 0.1em; }
  .next-id { color: #bb9af7; font-size: 14px; font-weight: 600; }
  .next-notes { font-size: 13px; color: #666; line-height: 1.5; overflow-y: auto; flex: 1; }
  .footer {
    grid-area: footer;
    display: flex; justify-content: center; gap: 12px; padding: 8px;
  }
  .footer button {
    background: #2a2a2a; color: #ccc; border: 1px solid #333;
    padding: 8px 24px; border-radius: 6px; cursor: pointer;
    font-size: 14px; font-family: inherit;
  }
  .footer button:hover { background: #333; color: #fff; }
</style>
</head>
<body>
  <div class="header">
    <span class="slide-id" id="p-slide-id">—</span>
    <span class="progress" id="p-progress">— / —</span>
    <span class="timer" id="p-timer">00:00</span>
  </div>
  <div class="notes-panel">
    <h3>Speaker Notes</h3>
    <div class="content" id="p-notes">Press 'p' on the presentation window to start.</div>
  </div>
  <div class="next-panel">
    <h3>Next</h3>
    <div class="next-id" id="p-next-id">—</div>
    <div class="next-notes" id="p-next-notes"></div>
  </div>
  <div class="footer">
    <button onclick="send(-1)">← Prev</button>
    <button onclick="send(+1)">Next →</button>
    <button onclick="resetTimer()">Reset Timer</button>
  </div>
<script>
  const ch = new BroadcastChannel('deck-presenter');
  let timerOffset = 0;

  ch.onmessage = (e) => {
    if (e.data.type !== 'slide-update') return;
    const d = e.data;
    document.getElementById('p-slide-id').textContent = d.slideId;
    document.getElementById('p-progress').textContent = (d.index + 1) + ' / ' + d.total;
    document.getElementById('p-notes').textContent = d.notes || 'No notes';
    document.getElementById('p-next-id').textContent = d.nextId || 'End';
    document.getElementById('p-next-notes').textContent = d.nextNotes || '';
    timerOffset = d.elapsed;
  };

  function send(delta) { ch.postMessage({ type: 'navigate', delta }); }

  function resetTimer() { timerOffset = 0; ch.postMessage({ type: 'reset-timer' }); }

  setInterval(() => {
    const s = Math.floor(timerOffset / 1000);
    const m = Math.floor(s / 60);
    const sec = s % 60;
    document.getElementById('p-timer').textContent =
      String(m).padStart(2, '0') + ':' + String(sec).padStart(2, '0');
    timerOffset += 1000;
  }, 1000);

  document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowRight' || e.key === ' ') send(+1);
    if (e.key === 'ArrowLeft') send(-1);
  });
</script>
</body>
</html>`;
}
