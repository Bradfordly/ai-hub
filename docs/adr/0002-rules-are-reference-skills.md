# Rules are reference skills, not Claude rules files

Each rule lives at `rules/<name>/SKILL.md`, as a model-invoked reference skill, rather than as a `.claude/rules/*.md` file or a plain doc.

Three constraints drove this:

- Plugins can't ship `.claude/rules` or `CLAUDE.md`.
- Subagents reach shared material only through `skills:` preloads or the Skill tool.
- A hard-coded file path breaks once the hub is installed into a plugin cache or symlinked elsewhere.

As skills, rules preload into agents by name, load on demand in any session, and stay portable to any Agent Skills harness. `plugin.json` adds `./rules/` to the skill scan, so `rules/` stays a separate bucket for humans.

**Simplest viable option, rejected:** inline the principles into each agent. That duplicates knowledge across agents, which is exactly what the first review of these agents found.
