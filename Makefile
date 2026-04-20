.DEFAULT_GOAL := help

.PHONY: help lint format type-check clean aulas-install aulas-dev aulas-build-cirrose

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# --- Python scripts (remaining after S232 v6 Python orchestrator purge) ---

lint: ## Run ruff linter on remaining Python
	uv run ruff check scripts/

format: ## Format remaining Python with ruff
	uv run ruff format scripts/
	uv run ruff check --fix scripts/

type-check: ## Run mypy type checker on remaining Python
	uv run mypy scripts/

clean: ## Remove caches and build artifacts
	rm -rf __pycache__ .mypy_cache .ruff_cache .pytest_cache htmlcov .coverage
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true

# --- Aulas (Node.js, runs from content/aulas/) ---

aulas-install: ## Install aulas Node.js dependencies
	cd content/aulas && npm install

aulas-dev: ## Start Vite dev server for aulas
	cd content/aulas && npm run dev

aulas-build-cirrose: ## Build cirrose slides
	cd content/aulas && npm run build:cirrose
