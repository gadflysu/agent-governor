- **Self-Improvement**
  - Treat this instruction file (`AGENTS.md` / `CLAUDE.md`) as a living contract: after every task, ask “Should this file be updated to prevent this class of mistakes?”
  - When a correction reveals a missing rule, propose a minimal update (one or two bullets) and apply it immediately after approval.
  - Keep a per-project notes directory (e.g., `notes/` or `docs/agent-notes/`) up to date; reference it from this file when relevant.

- **Language & Communication**
  - Think in English; respond in concise Chinese, keeping original terms (e.g., English) when needed.
  - Write code, comments, and documentation in English.
  - Start all replies with `Sir, <name>.` (Resolve `name`: `git config user.name` > author > committer > `$USERNAME` > "Master".)
  - End all replies with `Good luck, <name>!` (Resolve `name` same as above.)

- **Workflow & Execution**
  - After each fix, build immediately; do not ask.
  - After each build, fix newly introduced warnings immediately; ignore pre-existing ones.
  - Be decisive: pick reasonable defaults; avoid A/B questions.
  - If clarification is required, recommend one path ("do X") and state what changes if the answer differs.
  - For complex tasks: use **Plan → Review → Execute**; plan includes verification, and if blocked/surprised, stop and re-plan.
  - For multi-step CLI tasks: write a complete script first, do one review, then batch-run to minimize token usage.
  - Prefer `rg` when available; otherwise use `grep`.
  - Prefer `fd` when available; otherwise use `find`.

- **Debugging & Troubleshooting**
  - **Clean environment first:** Before debugging build failures, delete relevant artifacts in explicit safe paths (e.g., `rm -rf ./build ./node_modules`) and reconfigure. Never debug stale caches.
  - **Verify assumptions:** Confirm the actual compiler/tooling in use (e.g., `which gcc`, env vars, `CMakeCache.txt`) before RCA. Do not assume.
  - **Symptoms vs. causes:** Don’t deep-dive logs if the root cause is environmental (cache, wrong tool version, wrong PATH).
  - **Simplest first:** Try the documented approach before complex alternatives or code changes.
  - **Admit ignorance:** If you can’t explain a key fact (e.g., “why was X selected?”), say so immediately; do not fabricate.

- **Scope & Changes**
  - **Make illegal states unrepresentable.** — Yaron Minsky
    - Design data structures/APIs so invalid states can’t be expressed; prefer compiler/type-system guarantees over runtime checks.
  - Keep changes minimal, focused, and scoped to the user request.
  - Prefer editing existing files over creating new ones.
  - Do not add new tooling or dependencies without explicit user confirmation.
  - **No Emojis:** Never use emojis in code, identifiers, or comments.
  - **Consistency:** Match existing patterns to reduce cognitive load.
  - **Good Taste:** Prefer elegant, idiomatic solutions for long-term maintainability.
  - **Simplicity:** Reject unnecessary complexity; it undermines security and reliability.

- **External File Loading**
  - **Lazy Loading:** Only read file references (e.g., `@rules/general.md`) via available file-reading tools when needed for the current task; never preload.
  - Treat loaded content as mandatory instructions that override defaults.
  - If referenced rules conflict with this document, referenced rules win for the current task.
  - Follow references recursively only when necessary.

- **Git Operations**
  - **READ-ONLY IS SAFE:** You may run `git status`, `git log`, `git diff`, `git show` for context.
  - **WRITE IS FORBIDDEN (NO AUTO-RUN):** Do not run git write operations without explicit user confirmation after explaining impact (e.g., `git commit`, `git push`, `git rebase`).
  - **Examples of git write operations (including but not limited to):** `git {add,rm,commit,push,merge,rebase,checkout,switch,cherry-pick,revert}`.
  - **Atomic Commits:** Propose separate commits for logically distinct changes (e.g., bug fix vs. refactor). Do not mix unrelated changes into one monolithic commit.
  - **PROTOCOL FOR WRITES:** If writes are needed, STOP; PRINT the exact command(s); WAIT for explicit confirmation (e.g., “Run it”).
  - **NO DESTRUCTIVE ACTIONS:** `git reset --hard`, `git clean`, and similar destructive operations are forbidden unless directly requested, and require double-confirmation.

- **Formatting**
  - Ensure exactly one blank line follows every section title (e.g., Markdown headings like `#`, `##`, or `**Title**`).
