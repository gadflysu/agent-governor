# The CLAUDE.md Manifesto: Meta-Framework for Advanced AI Agents

This framework transcends the common "wishlist" approach to AI prompts. It treats the Large Language Model (LLM) not as a conversational assistant, but as a volatile, high-compute distributed node. This document is a guide for developers on how to architect a fault-tolerant, strictly privileged "microkernel" operating system (via `CLAUDE.md`) to govern the LLM within complex codebases.

## 1. Instruction Fidelity (Maximizing Execution Consistency)

*   **Imperative-First (Action-Driven):** When writing rules, reject static noun labels or descriptive adjectives (e.g., ban `**Good Taste:**` or `**Lazy Loading:**`). Structure every guideline to initiate with a strong imperative verb (`Treat`, `Confine`, `Prefer`, `Never`), transforming your prompts into directly executable machine instructions.
*   **Actionable Alternatives (Constructive Prohibition):** When your prompt forbids a behavior, never leave the agent in a deadlock of "what not to do." Always engineer an immediate escape hatch. *Example: "Never auto-run git write operations... Instead, STOP, PRINT the exact command, and WAIT."*
*   **High Information Density:** Refactor your prompts exactly as you would refactor code. Deduplicate logic, strip away rhetorical fluff, and never waste token limits teaching the agent basic syntax. Reserve your context window exclusively for enforcing engineering discipline and safety boundaries.

## 2. Orthogonality & Boundaries (Architectural Decoupling)

*   **XML Shell + Markdown Core:** Leverage the LLM's inherent training bias toward XML. Design your configuration using root tags (e.g., `<workflow>`, `<safety>`) to establish absolute cognitive boundaries. Within these tags, use standard Markdown lists (`-`) to enforce sequential, line-by-line readability for the parser.
*   **Strict Separation of Concerns:**
    *   Designate a `<workflow>` block to govern the "brain's" state transitions (planning, verification).
    *   Designate a `<git_operations>` block to govern the "hands'" read/write protocols.
    *   Ensure your prompt structure never entangles the two, preventing cognitive cross-contamination.
*   **Global vs. Local Decoupling:** Use the global `CLAUDE.md` solely for meta-rules, safety baselines, and execution protocols. Never hardcode project-specific business logic or strict linter rules into the global prompt. Build a file routing mechanism that delegates domain specifics to local files (e.g., `docs/agent/notes-*.md`).
*   **Role-Aware Contexting (Multi-Agent Readiness):** Design your rules to support distributed intelligence. Write conditional directives that adapt to the agent's current role. *Example: "If invoked as PLANNER, `<git_operations>` are strictly forbidden; if invoked as EXECUTOR, treat `plan-*.md` as a read-only supreme directive."*

## 3. State Machine Mindset (Combating Context Rot)

*   **Deterministic State Transitions (Explicit CLI Hooks):** Do not design workflows that rely on the LLM's implicit ability to "infer intent." Define hardcoded triggers in your prompt (e.g., slash commands like `/plan`, or the detection of a `.lock` file) to force the LLM into specific pipeline stages, preventing workflow drift.
*   **Externalized Memory (Context Rehydration):** To combat context degradation over long sessions, establish a Type-first file taxonomy (`plan-*`, `status-*`). Mandate a "Rehydrate context" step in your prompt, forcing the agent to read its state from the disk rather than relying on conversation history before taking action.
*   **End-to-End Ownership:** When defining execution modes (like Autonomous), configure the agent to close the loop. Use explicit language (e.g., `own the task end-to-end`, `self-recover from blockers`) to prevent premature handoffs at the first sign of friction.

## 4. Engineering Taste (Infusing Senior Developer Intuition)

*   **Test-Driven Hard Gates (TDD as Law):** Embed testing as a physical barrier in your instructions. Require the agent to write or modify tests and explicitly *watch them fail* before writing any implementation code. This ensures its execution loop has a grounded truth metric.
*   **Failures are Signals, Not Noise:** Write explicit rules forbidding the agent from silently hiding errors (e.g., secretly switching to `grep` if `rg` fails). Mandate that every tool failure must be reported and treated as a critical diagnostic signal.
*   **The Circuit Breaker Protocol:** Define strict termination conditions in your prompt to prevent high-compute nodes from burning tokens in infinite loops. *Example: "If a linter error persists after 3 repair attempts, ABORT the autonomous loop, trigger a Circuit Break, and mandate human intervention."*
*   **Ratchet Loops (Workspace-Centric Experimentation):** When designing autonomous loops, enforce a strict "Modify → Evaluate → Retain/Discard" local sandbox. 
    *   *Define Workspace Rollbacks:* Explicitly instruct the agent to use workspace-level commands (e.g., `git restore` or `git reset`) for discarding failed local experiments.
    *   *Protect Commit History:* Explicitly ban the use of history-altering commands (e.g., `git revert` or `git commit --amend`) as casual 'undo' mechanisms for draft code, reserving them strictly for intentional history repairs.
*   **Surgical Execution:** Draft rules that demand surgical precision. Instruct the agent to keep modifications minimal, isolated, and strictly scoped to the objective, penalizing unnecessary refactoring.
*   **Proactive Recommendation:** Ban the agent from asking open-ended A/B questions that shift decision fatigue back to the human. Force the agent to `recommend one path ("do X")`, acting as an opinionated consultant.
*   **Distill Philosophy:** Push the agent beyond solving the immediate ticket. Instruct it to extract transferable lessons from trade-off discussions by appending a `### Engineering Philosophy` section, allowing the project's architectural wisdom to self-propagate.
