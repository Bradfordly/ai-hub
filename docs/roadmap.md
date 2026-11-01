# Roadmap

Planned additions, ranked by value to headless and cloud runs. Each new agent follows [authoring-agents.md](authoring-agents.md) and preloads upstream skills by name.

## New agents

| Agent | Purpose | Preloads | Notes |
|---|---|---|---|
| `implementer` | Builds one ticket or spec test-first, writes the PR body, then invokes `code-reviewer` | `tdd`, `pr`, `engineering-principles`, `resiliency` | Set `isolation: worktree`. This is the cloud workhorse. |
| `researcher` | Answers a question from primary sources and writes cited notes to `docs/research/` | `research` | `architect` delegates fact-finding to it. |
| `debugger` | Drives a hard bug to a fix with a regression test | `diagnosing-bugs` | Done when one command goes red on the bug, then green after the fix. |
| `test-reviewer` | Reviews tests for implementation coupling, tautologies, and horizontal slicing | `tdd` | Could become a third axis of `code-reviewer` instead. Decide after the first runs. |
| `retro-curator` | Runs `retro` over session logs and opens PRs against this hub | `retro`, `writing-for-agents` | Closes the loop that keeps agents improving. |

## Enhancements

- **Evals per agent.** Add `evals/` cases (`claude plugin eval`) with a fixture diff or repo and graders for the output contract, so prompt edits are measured, not guessed.
- **Release tags.** Run `claude plugin tag` on each version bump, so consumers can pin `ai-hub` with a semver range.
- **`memory: project` for `architect`.** This would let it accumulate decisions and context across sessions. Check how that interacts with plugin install first.
- **Project-level hooks.** Plugin agents ignore `hooks`, so ship optional hook snippets in `templates/project/.claude/settings.json`. Examples: block writes outside `docs/adr/` for `architect`, and run `validate.sh` before commits in this repo.
- **CI for the hub.** Add a GitHub Actions job that runs `scripts/validate.sh`. After that, run each agent against a fixture with `claude -p`.
- **Cross-harness agent export.** If another harness becomes a daily driver, generate its agent format (for example, Codex `agents/openai.yaml`) from `agents/*.md` instead of hand-maintaining copies.
- **Workflow skills in `skills/`.** Create one only when a gap shows up that upstream skills don't cover, for example a `cdk-deploy` runbook or a `release` checklist.
