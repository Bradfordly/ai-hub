# Authoring agents

This page is the checklist for adding or editing a profile in `agents/`. The Claude Code [subagent reference](https://code.claude.com/docs/en/sub-agents) is the source of truth for fields. This page records the choices this hub makes.

## Frontmatter

| Field | Hub convention |
|---|---|
| `name` | Kebab-case, matching the filename. Installed as a plugin, it appears as `ai-hub:<name>`. |
| `description` | Lead with what the agent does, then name each distinct trigger once. Say what it doesn't cover and which agent does. This line is always loaded, so prune it hard. |
| `tools` | List only the tools the agent needs. Add `Write` and `Edit` only to agents that author files. |
| `disallowedTools` | Reviewers set `Write, Edit, NotebookEdit`. This is the only enforcement that survives plugin install. |
| `model` | `opus` for design and judgement-heavy agents. `sonnet` for review, docs, and other high-volume work. `inherit` only when the caller's choice matters. |
| `effort` | `high` for `architect`. Leave it unset elsewhere unless a run shows it's needed. |
| `maxTurns` | Set it on agents that run in CI, so a stuck run fails fast. |
| `skills` | Preload the rule skills and upstream skills the agent always needs. Preloading costs context on every run, so list only what every run uses. Load on-demand material through the Skill tool. |
| `permissionMode`, `hooks`, `mcpServers` | **Ignored for plugin-installed agents.** Put guardrails a plugin agent needs in `tools` and `disallowedTools`. |

## Body

- **Open with the agent's role in one sentence.** It is project-agnostic: project facts come from the consumer repo's `AGENTS.md` (or `CLAUDE.md`), `GLOSSARY.md`, and `docs/adr/`, which the agent reads first.
- **Give the procedure as steps, each ending on a checkable completion criterion.**
- **Fix the output contract.** Give exact formats for anything CI or a calling agent parses, and cap the length of what is returned to the caller.
- **Put shared standards in rule skills** under `rules/`, preloaded by name, rather than restating them.
- **Plan for a headless run, where no human answers questions.** Say what the agent does instead: record open questions, with a recommended answer for each, in its output.

## Checks

```bash
scripts/validate.sh
claude --plugin-dir . -p "Use the ai-hub:<name> agent to <smallest realistic task>"
```
