# Agent Governor

> **A governor for coding agents** — orchestrating agents as fault-tolerant compute nodes through operational discipline, semantic routing, deterministic execution, physical validation, and recoverable workflows.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Just as a mechanical governor physically cuts power when an engine over-revs, agent-governor triggers hard circuit breakers the moment an AI goes off the rails.

Stop treating your LLM as a chatbot. Start managing it like a volatile microkernel process.

## Core Principles

Each principle below emerged from a specific failure mode observed in autonomous agent loops.

**Metaphor is a behavioral prior, not rhetoric.** The metaphors embedded in a prompt activate corresponding cognitive biases in the LLM. "Role-Based" framing (Planner, Executor) triggers anthropomorphic role-play, causing the agent to *perform a character* rather than enforce a stage boundary. Replace it with **Pipeline Sandboxing** — treat orchestration as stateless stage transitions with strict I/O fences. The agent does not *play* a planner; it *is in* the PLAN phase, and the phase boundary is enforced by what it can read and write.

**Never trust self-evaluation; embed physical gates.** An LLM that says "tests passed" has not necessarily run the tests. Require the agent to trigger external truth metrics — compiling, testing, linting — and *observe the output* before advancing. Verification lives in tool output, not in the agent's assertion.

**Every prohibition must include an escape hatch.** A "never do X" without an alternative creates a deadlock — the agent reaches a goal that requires X and has nowhere to go. Pair every prohibition with an actionable alternative: "Never do X. Instead, do Y." Constructive Prohibition closes the loop instead of breaking it.

**Externalize state; never trust conversation memory.** Context degrades over long sessions. Establish a Type-first file taxonomy (`plan-*`, `status-*`, `notes-*`) and mandate a "rehydrate context" step at the start of each task — force the agent to read its state from disk, not from its degraded recollection of earlier messages.

**Safety is constitutional; preference is legislative.** In layered configurations (global vs. local), safety baselines are immutable — no project-level file can weaken them. Tool preferences, workflow rules, and environment configs are freely overridable. Adopt any project convention without risking the safety floor.

## Features

- **Supervised Mode by default** — the agent pauses at destructive or irreversible actions and waits for your confirmation.
- **Clarify → Plan → Execute → Verify** pipeline for complex tasks, with a Circuit Breaker that halts autonomous loops after 3 consecutive failures.
- **`docs/agent/` convention** — AI-generated artifacts stay out of your project root.

Reference configuration: [`AGENTS.md`](AGENTS.md?plain=1). Extended design rationale: [`PRINCIPLES.md`](PRINCIPLES.md).

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
