#!/usr/bin/env bash
# Instala git hooks (pre-commit + pre-push).
# Funciona em repos normais e worktrees.
# Rodar uma vez após clonar ou criar worktree: bash scripts/install-hooks.sh
set -e

# git-common-dir works in both repos (.git/) and worktrees (.git/worktrees/*)
HOOKS_DIR="$(git rev-parse --git-common-dir)/hooks"
mkdir -p "$HOOKS_DIR"

# ── Pre-commit ──
cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/usr/bin/env bash
# Pre-commit: delegates to versionado script.
# Logic lives in scripts/pre-commit.sh (tracked in repo).
set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
bash "$REPO_ROOT/content/aulas/scripts/pre-commit.sh"
EOF

chmod +x "$HOOKS_DIR/pre-commit"
echo "✓ pre-commit hook instalado em $HOOKS_DIR/pre-commit"

# ── Pre-push ──
cat > "$HOOKS_DIR/pre-push" << 'PUSHEOF'
#!/usr/bin/env bash
# Pre-push: runs done-gate --strict. Blocks push if any gate fails.
# Logic lives in scripts/pre-push.sh (versionado).
set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
SCRIPT="$REPO_ROOT/content/aulas/scripts/pre-push.sh"
[ -f "$SCRIPT" ] && bash "$SCRIPT" || echo "pre-push.sh not found, skipping"
PUSHEOF

chmod +x "$HOOKS_DIR/pre-push"
echo "✓ pre-push hook instalado em $HOOKS_DIR/pre-push"

# ── Post-merge ──
cat > "$HOOKS_DIR/post-merge" << 'MERGEEOF'
#!/usr/bin/env bash
set -e
REPO_ROOT="$(git rev-parse --show-toplevel)"
SCRIPT="$REPO_ROOT/content/aulas/scripts/post-merge.sh"
[ -f "$SCRIPT" ] && bash "$SCRIPT" || echo "post-merge.sh not found, skipping"
MERGEEOF

chmod +x "$HOOKS_DIR/post-merge"
echo "✓ post-merge hook instalado em $HOOKS_DIR/post-merge"
