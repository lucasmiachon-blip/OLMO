"""Database bootstrap - Inicializa SQLite para o ecossistema."""

from __future__ import annotations

import logging
import sqlite3
from pathlib import Path

logger = logging.getLogger("core.database")

DEFAULT_DB_PATH = Path("data/knowledge.db")


def get_connection(db_path: Path | None = None) -> sqlite3.Connection:
    """Retorna conexao SQLite, criando o banco e tabelas se necessario."""
    path = db_path or DEFAULT_DB_PATH
    path.parent.mkdir(parents=True, exist_ok=True)

    conn = sqlite3.connect(str(path))
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA foreign_keys=ON")

    _bootstrap_tables(conn)
    return conn


def _bootstrap_tables(conn: sqlite3.Connection) -> None:
    """Cria tabelas se nao existirem."""
    conn.executescript("""
        -- Snapshots de operacoes MCP (anti-perda)
        CREATE TABLE IF NOT EXISTS mcp_snapshots (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT NOT NULL DEFAULT (datetime('now')),
            mcp_server TEXT NOT NULL,
            operation TEXT NOT NULL,
            resource_id TEXT,
            state_before TEXT,
            state_after TEXT,
            success INTEGER DEFAULT 1,
            error_message TEXT
        );

        -- Checkpoints de workflow (resumable)
        CREATE TABLE IF NOT EXISTS workflow_checkpoints (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            workflow_id TEXT NOT NULL,
            step_number INTEGER NOT NULL,
            step_name TEXT NOT NULL,
            state TEXT,
            timestamp TEXT NOT NULL DEFAULT (datetime('now')),
            resumable INTEGER DEFAULT 1,
            UNIQUE(workflow_id, step_number)
        );

        -- Budget log (rastreamento de custos)
        CREATE TABLE IF NOT EXISTS budget_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT NOT NULL DEFAULT (datetime('now')),
            agent TEXT NOT NULL,
            model TEXT,
            operation TEXT,
            mcp_server TEXT,
            cost_usd REAL DEFAULT 0.0,
            tokens_used INTEGER DEFAULT 0
        );

        -- Notion page cache (anti-retrabalho)
        CREATE TABLE IF NOT EXISTS notion_cache (
            page_id TEXT PRIMARY KEY,
            title TEXT,
            database_name TEXT,
            content_hash TEXT,
            properties TEXT,
            last_synced TEXT NOT NULL DEFAULT (datetime('now')),
            snapshot_json TEXT
        );

        -- Indice para queries frequentes
        CREATE INDEX IF NOT EXISTS idx_budget_agent ON budget_log(agent);
        CREATE INDEX IF NOT EXISTS idx_budget_date ON budget_log(timestamp);
        CREATE INDEX IF NOT EXISTS idx_mcp_server ON mcp_snapshots(mcp_server);
        CREATE INDEX IF NOT EXISTS idx_notion_hash ON notion_cache(content_hash);
    """)
    conn.commit()
    logger.debug("Database tables bootstrapped")


def log_mcp_operation(
    conn: sqlite3.Connection,
    mcp_server: str,
    operation: str,
    resource_id: str,
    state_before: str | None = None,
    state_after: str | None = None,
    success: bool = True,
    error_message: str | None = None,
) -> None:
    """Registra uma operacao MCP no banco (anti-perda)."""
    conn.execute(
        """INSERT INTO mcp_snapshots
           (mcp_server, operation, resource_id, state_before, state_after, success, error_message)
           VALUES (?, ?, ?, ?, ?, ?, ?)""",
        (mcp_server, operation, resource_id, state_before, state_after, int(success), error_message),
    )
    conn.commit()


def log_cost(
    conn: sqlite3.Connection,
    agent: str,
    model: str,
    operation: str,
    cost_usd: float = 0.0,
    tokens_used: int = 0,
    mcp_server: str | None = None,
) -> None:
    """Registra custo de uma operacao no budget log."""
    conn.execute(
        """INSERT INTO budget_log
           (agent, model, operation, mcp_server, cost_usd, tokens_used)
           VALUES (?, ?, ?, ?, ?, ?)""",
        (agent, model, operation, mcp_server, cost_usd, tokens_used),
    )
    conn.commit()
