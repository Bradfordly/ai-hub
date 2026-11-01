# The hub is a Claude Code plugin and a tool-neutral directory tree

ai-hub is laid out so it works two ways from one tree:

- **As a Claude Code plugin.** `.claude-plugin/plugin.json` plus a self-hosted `marketplace.json` let it be installed with one command, and it pulls in `mattpocock-skills` through `dependencies`.
- **As plain directories.** `agents/`, `skills/`, and `rules/` can be symlinked into any harness's skill and agent folders.

We picked this over a link-script-only hub because the plugin path gives versioning, auto-update, and dependency resolution for free. We picked it over a plugin-only hub because cloud sessions don't install plugins that a repo declares (see 0003), and other harnesses only understand `SKILL.md` folders.

Steering for agents working in this repo lives in `AGENTS.md`. Claude Code reads it through `.claude/CLAUDE.md`, a one-line `@../AGENTS.md` import. Three alternatives were rejected:

- **A symlink:** Claude Code's Edit and Write tools refuse to write through one.
- **A root `CLAUDE.md`:** `claude plugin validate --strict` rejects it at a plugin root.
- **Relying on native `AGENTS.md` loading:** Claude Code reads `AGENTS.md` natively only when no `CLAUDE.md` exists.
