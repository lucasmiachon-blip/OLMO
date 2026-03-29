.DEFAULT_GOAL := help

.PHONY: help lint format type-check test test-cov check run status clean

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

lint: ## Run ruff linter
	uv run ruff check .

format: ## Format code with ruff
	uv run ruff format .
	uv run ruff check --fix .

type-check: ## Run mypy type checker
	uv run mypy agents/ subagents/ config/ orchestrator.py

test: ## Run pytest
	uv run pytest

test-cov: ## Run pytest with coverage report
	uv run pytest --cov --cov-report=term-missing --cov-report=html

check: lint type-check test ## Run lint + type-check + test

run: ## Run orchestrator
	uv run python -m orchestrator run

status: ## Show agent tree
	uv run python -m orchestrator status

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
