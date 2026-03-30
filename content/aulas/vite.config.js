import { defineConfig } from 'vite';
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { readdirSync, statSync } from 'node:fs';

const __dirname = fileURLToPath(new URL('.', import.meta.url));

// Auto-discover all HTML entry points: */index*.html
function discoverEntries() {
  const entries = {};

  readdirSync(__dirname).forEach(item => {
    const full = resolve(__dirname, item);
    if (!statSync(full).isDirectory() || item.startsWith('_') || item === 'node_modules' || item === 'scripts') return;

    readdirSync(full).filter(f => f.endsWith('.html')).forEach(f => {
      const key = f === 'index.html'
        ? item
        : `${item}_${f.replace('.html', '').replace('index.', '')}`;
      entries[key] = resolve(full, f);
    });
  });
  return entries;
}

export default defineConfig(({ command }) => ({
  root: '.',
  base: command === 'serve' ? '/' : './',
  server: {
    strictPort: true,
    browser: 'google chrome'
  },
  build: {
    target: 'esnext',
    rollupOptions: {
      input: discoverEntries()
    }
  }
}));
