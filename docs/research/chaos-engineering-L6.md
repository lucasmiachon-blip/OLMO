# L6 Chaos Engineering — Design Document

> Antifragile Layer 6 | Created S93 | Status: BASIC (4/6 vectors)

## Philosophy

**Hormesis**: controlled stress makes biological systems stronger, not weaker.
The same applies to software. L1-L5 and L7 are defense layers — L6 validates they actually fire.

Without chaos testing, we only *assume* defenses work. L6 converts assumptions into evidence.

## Architecture

```
CHAOS_MODE=1 (env var, opt-in)
    |
    v
chaos-inject-post.sh (PostToolUse on Agent|Bash)
    |
    +--> Roll dice (CHAOS_PROBABILITY%, default 5%)
    |
    +--> Pick random vector
    |
    +--> Write to shared /tmp state files
    |        |
    |        +--> /tmp/cc-model-failures.log  --> L2 model-fallback reads this
    |        +--> /tmp/cc-calls-*.txt         --> L3 cost-circuit-breaker reads this
    |
    +--> Log to /tmp/cc-chaos-log.jsonl
    |
    v
[Normal hook chain continues]
    |
    v
model-fallback-advisory.sh reads /tmp --> fires if threshold met
cost-circuit-breaker.sh reads /tmp    --> fires if threshold met
    |
    v
stop-chaos-report.sh (Stop hook)
    +--> Reads chaos log + defense logs
    +--> Reports: injections, activations, gaps
```

**Key design decision**: zero changes to existing L1-L3 hooks. Chaos writes to the *same state files* defenses already read. This tests real code paths, not mocks.

## Failure Injection Matrix

| # | Vector | Injection | Defense | Status |
|---|--------|-----------|---------|--------|
| 1 | HTTP 429 rate limit | Write `epoch\|opus\|rate_limit` to model-failures.log | L2 circuit breaker (2 failures/5min) | S93 |
| 2 | Socket timeout | Write `epoch\|unknown\|overloaded` to model-failures.log | L2 circuit breaker | S93 |
| 3 | Model unavailable | Write `epoch\|opus\|model_not_available` to model-failures.log | L2 circuit breaker | S93 |
| 4 | Rapid tool calls | Inflate counter in `/tmp/cc-calls-*.txt` by +50 | L3 cost breaker (warn@100, block@400) | S93 |
| 5 | Slide/manifest desync | Edit HTML without manifest update | L5 stop-detect-issues | DEFERRED |
| 6 | Stale memory TTL | Backdate review_by field | L7 /dream TTL check | DEFERRED |

Vectors 5-6 deferred: require file manipulation in live workspace, risk of data corruption.

## Activation

```bash
# Enable chaos (off by default)
export CHAOS_MODE=1

# Probability per tool call (default 5%)
export CHAOS_PROBABILITY=5

# For testing: 100% injection rate
export CHAOS_PROBABILITY=100

# Disable
export CHAOS_MODE=0   # or unset
```

## Observation

**Runtime logs:**
- `/tmp/cc-chaos-log.jsonl` — one JSON line per injection attempt
- `/tmp/cc-model-failures.log` — shared with L2 (existing)
- `/tmp/cc-calls-*.txt` — shared with L3 (existing)

**Stop report**: `stop-chaos-report.sh` prints summary at session end.

**Format of chaos log entry:**
```json
{"ts":"2026-04-06T15:30:00Z","vector":"http_429","model":"opus","injected":true,"probability":5}
```

## Files

| File | Type | New/Modified |
|------|------|--------------|
| `.claude/hooks/lib/chaos-inject.sh` | Library | NEW |
| `.claude/hooks/chaos-inject-post.sh` | PostToolUse hook | NEW |
| `hooks/stop-chaos-report.sh` | Stop hook | NEW |
| `.claude/settings.local.json` | Hook registration | MODIFIED |

## Future Phases

- **Phase B**: Add vectors 5-6 (file-based injection with rollback)
- **Phase C**: Auto-append gap analysis to failure-registry.json
- **Phase D**: Langfuse chaos dashboard (ClickHouse query)
- **Phase E**: Scheduled chaos runs via /schedule skill

---

Coautoria: Lucas + Opus 4.6 | S93
