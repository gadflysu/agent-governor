# Agent Governor

> **A governor for coding agents** — orchestrating agents as fault-tolerant compute nodes through operational discipline, semantic routing, deterministic execution, physical validation, and recoverable workflows.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Just as a mechanical governor physically cuts power when an engine over-revs, agent-governor triggers hard circuit breakers the moment an AI goes off the rails.

Stop treating your LLM as a chatbot. Start managing it like a volatile microkernel process.

## Features

- **Supervised Mode by default** — the agent pauses at destructive or irreversible actions and waits for your confirmation.
- **Clarify → Plan → Execute → Verify** pipeline for complex tasks, with a Circuit Breaker that halts autonomous loops after 3 consecutive failures.
- **Immutable safety baselines** — no bulk deletions without confirmation, no operations outside the project workspace; cannot be overridden by project-level config.
- **`docs/agent/` convention** — AI-generated artifacts stay out of your project root.
- **Git discipline** — atomic commits, no force-pushes without explicit instruction, workspace-centric trial-and-error.

Design principles documented in [`PRINCIPLES.md`](PRINCIPLES.md).

## Installation

Back up any existing config before overwriting.

```bash
# Claude Code
curl -fsSL https://raw.githubusercontent.com/gadflysu/agent-governor/master/AGENTS.md \
  -o ~/.claude/CLAUDE.md
```

## Project-level overrides

Place an `AGENTS.md` (or platform equivalent) at project root to override non-safety rules. The `<safety>` block is immutable — project files cannot weaken it.

## Contributing

This framework is a living document. PRs that improve structural rigidity and fault-tolerance of agent workflows are welcome. PRs that introduce project-specific business logic or opinionated styling choices are not.

Keep the governance pure.

## License

MIT
