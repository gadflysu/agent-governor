# CLAUDE.md — User-Level Claude Code Configuration

A battle-tested `CLAUDE.md` for your `~/.claude/` directory that gives Claude Code consistent, disciplined behavior across every project.

## Features

- Enforces a **Supervised Mode by default** — Claude pauses at destructive or irreversible actions and waits for your confirmation.
- Installs a **Clarify → Plan → Execute → Verify** pipeline for complex tasks, with a Circuit Breaker that halts autonomous loops after 3 consecutive failures.
- Sets **safety baselines** that cannot be overridden by any project-level config: no bulk deletions without confirmation, no operations outside the project workspace.
- Establishes a **docs/agent/** convention for AI-generated artifacts so agent files never pollute your project root.
- Defines **git discipline**: atomic commits, no force-pushes without explicit instruction, workspace-centric trial-and-error.

Design principles documented in `PRINCIPLES.md`.

## Installation

Back up any existing `~/.claude/CLAUDE.md` before overwriting.

```bash
curl -fsSL https://raw.githubusercontent.com/gadflysu/CLAUDE.md/master/CLAUDE.md \
  -o ~/.claude/CLAUDE.md
```

## Project-level overrides

Place a `CLAUDE.md` at project root to override non-safety rules. The `<safety>` block is immutable — project files cannot weaken it.

## License

MIT
