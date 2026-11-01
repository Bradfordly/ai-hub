# ai-hub

Bradfordly's single source of truth for agent profiles, skills, and rules. People and headless agents clone it to bootstrap any harness. See `README.md` for install paths.

## Layout

- `agents/`: subagent profiles. Read `docs/authoring-agents.md` before adding or editing one.
- `skills/<name>/SKILL.md`: workflow skills (Agent Skills format).
- `rules/<name>/SKILL.md`: standards, written as reference skills that agents preload. See `docs/adr/0002-rules-are-reference-skills.md`.
- `templates/project/`: starter files that `scripts/new-project.sh` copies into a consumer repo.
- `scripts/`: `bootstrap.sh` (install), `new-project.sh` (scaffold a consumer), `validate.sh` (run before every commit).
- `docs/adr/`: decisions about the hub itself, in the lean format from the `domain-modeling` skill.
- `docs/roadmap.md`: planned agents and enhancements.

## Conventions

- Load the `writing-for-agents` skill before writing or editing any agent, skill, rule, or this file.
- Keep agents **project-agnostic**. Project facts (stack, cloud, public ports, CI workflow names) belong in the consumer repo's `AGENTS.md`. An agent reads them from there at runtime.
- Give every meaning **one home**. A principle used by two agents becomes a rule skill that both preload.
- Steer **positively**. State the target behavior, and keep a prohibition only as a hard guardrail paired with its positive.
- Make every skill and rule `name` match its directory name.
- Reuse upstream skills from `mattpocock-skills` by name. Copy one into `skills/` only to change its behavior, and record why in an ADR.
- Plugin-installed agents ignore `permissionMode`, `hooks`, and `mcpServers`. Enforce restrictions with `tools` and `disallowedTools`.
- Run `scripts/validate.sh` before committing. It must exit 0.
