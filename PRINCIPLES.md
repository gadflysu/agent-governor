# Agent Governance Principles: Governing the LLM as a Fault-Tolerant Node

This framework treats the Large Language Model (LLM) as a volatile, high-compute distributed node. It provides system architects with the underlying design patterns to build a fault-tolerant, strictly privileged "microkernel" operating system (via System Prompts or Agent Configurations) for any autonomous AI agent.

## 1. Instruction Fidelity (Maximizing Execution Consistency)

*   **Imperative-First (Action-Driven):** Reject static noun labels or descriptive adjectives. Structure every guideline to initiate with a strong imperative verb (`Treat`, `Confine`, `Prefer`, `Never`), transforming prompts into executable machine instructions.
*   **Anchored Imperatives (Key-Value Prompting):** Prefix imperative commands with a bolded noun phrase acting as a semantic anchor (e.g., `**Ground Truth**: Verify against...`). This provides the LLM with a high-dimensional index key for its attention mechanism without sacrificing actionability.
*   **Actionable Alternatives (Constructive Prohibition):** When forbidding a behavior, never leave the agent in a deadlock. Always engineer an immediate escape hatch (e.g., "Never do X... Instead, STOP and WAIT").
*   **High Information Density:** Deduplicate logic and strip away rhetorical fluff. **Reserve your context window exclusively for enforcing operational discipline, state machine rules, and safety boundaries.** Do not waste tokens teaching basic syntax.

## 2. Orthogonality & Boundaries (Architectural Decoupling)

*   **XML Shell + Markdown Core:** Leverage the LLM's inherent training bias toward XML. Design your configuration using root tags (e.g., `<workflow>`, `<safety>`) to establish absolute cognitive boundaries. Use Markdown lists (`-`) within tags for sequential readability.
*   **Strict Separation of Concerns:** Fiercely guard tag responsibilities. Never pollute the core `<workflow>` state machine with one-off tool preferences or environment configurations. Ensure auxiliary blocks (e.g., `<toolchain>`) remain completely orthogonal to execution logic.
*   **Global vs. Local Decoupling:** Reserve the global configuration file for meta-rules, safety baselines, execution protocols, and universal project conventions intended to standardize behavior across all projects (e.g., file taxonomies, agent memory layouts). Delegate project-specific context (business logic, concrete architecture) to local files via a file routing mechanism.
*   **Hierarchical Precedence (Constitutional Immutability):** When deploying layered configurations (e.g., a global user file vs. local project files), explicitly define the conflict resolution doctrine. Treat the global configuration as a "Constitution": explicitly declare which blocks are absolutely immutable (e.g., `<safety>` baselines) and which are deliberately overridable by local project "laws" (e.g., `<toolchain>` preferences).
*   **Stage-Aware Permissions (Pipeline Sandboxing):** Discard anthropomorphic "Role-Playing" (e.g., Planner vs. Coder). Treat agent orchestration purely as pipeline stages. Enforce strict I/O boundaries tied to the current pipeline state. *Example: "During the PLAN phase, git write operations are strictly forbidden; during the EXECUTE phase, treat `plan-*.md` as a read-only supreme directive."*

## 3. State Machine Mindset (Combating Context Rot)

*   **Intent-Based Routing & Explicit Acknowledgment:** Leverage the LLM's reasoning to classify tasks (e.g., Trivial vs. Complex). To prevent state blurring, explicitly define the criteria for each pipeline and mandate that the agent **explicitly announces its inferred path** before taking action.
*   **Safe Defaults & Explicit Escalation:** Establish a strict safe default mode (e.g., `Supervised/Interactive`) in your prompt. Require explicit criteria to escalate to `Autonomous` execution, preventing the agent from blindly escalating based on conversational "tone."
*   **Externalized Memory (Context Rehydration):** Establish a Type-first file taxonomy (`plan-*`, `status-*`) to combat context degradation. Mandate a "Rehydrate context" step, forcing the agent to read its state from disk rather than relying on conversation history.
*   **End-to-End Ownership:** When autonomous modes are activated, configure the agent to close the loop. Use explicit language to force self-recovery from blockers, preventing premature handoffs.

## 4. Execution Sandbox & Validation (Safety & Quality Guarantees)

*   **Physical Execution Gates:** Do not rely on the LLM's self-evaluation. Embed physical verification barriers in your instructions. Require the agent to trigger external truth metrics (e.g., compiling, running tests, or executing linters) and observe the output before proceeding to the next state.
*   **The Circuit Breaker Protocol:** Define strict termination conditions to prevent infinite loops. Establish a hard threshold (e.g., 3 consecutive failures on the same error) that forces the agent to abort the autonomous loop and mandate human intervention.
*   **Failures as Diagnostic Signals:** Write explicit rules forbidding the agent from silently hiding or working around tool failures. Mandate that every error must be reported and treated as a critical diagnostic signal.
*   **Workspace-Centric Experimentation (Ratchet Loops):** Enforce a strict "Modify → Evaluate → Retain/Discard" local sandbox.
    *   *Define Workspace Rollbacks:* Explicitly instruct the agent to use workspace-level primitives (e.g., `git restore`) for discarding failed local experiments.
    *   *Protect Version History:* Explicitly ban the use of history-altering commands (e.g., `git revert`, `amend`) as casual 'undo' mechanisms for draft work.
