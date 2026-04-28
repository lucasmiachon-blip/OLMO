#!/usr/bin/env bash
# Versioned pre-push gate for aula branches.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

case "$BRANCH" in
  *cirrose*)
    npm --prefix "$REPO_ROOT/content/aulas" run done:cirrose:strict
    ;;
  *)
    echo "pre-push: no aula strict gate for branch '$BRANCH'; skipping"
    ;;
esac
