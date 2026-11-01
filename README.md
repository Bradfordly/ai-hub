# ai-hub

Bradfordly's single source of truth for AI agent profiles, skills, and rules, for spec-driven, AI-assisted development.

Clone this repo into any environment, whether a laptop, a CI runner, or a headless Claude Code session in the cloud, run one script, and the agent there works with the same reviewers, architect, standards, and workflow skills every time. The repo follows tool-neutral conventions (`AGENTS.md`, Agent Skills `SKILL.md`). It's also a Claude Code plugin and marketplace, so Claude installs it in one command and pulls in [mattpocock/skills](https://github.com/mattpocock/skills) as a dependency.

## Contents

| Path | What's there |
|---|---|
| [`agents/`](agents/) | Project-agnostic subagent profiles |
| [`rules/`](rules/) | Standards, written as reference skills that agents preload ([why](docs/adr/0002-rules-are-reference-skills.md)) |
| [`skills/`](skills/) | Workflow skills (none yet; upstream skills cover the flow) |
| [`templates/project/`](templates/project/) | Starter `AGENTS.md` and Claude settings for a new repo |
| [`scripts/`](scripts/) | `bootstrap.sh`, `new-project.sh`, `validate.sh` |
| [`docs/`](docs/) | [ADRs](docs/adr/), [agent authoring guide](docs/authoring-agents.md), [roadmap](docs/roadmap.md) |

### Agents

| Agent | Does | Preloads |
|---|---|---|
| `architect` | Design decisions, recorded as lean ADRs in `docs/adr/` | `engineering-principles`, `domain-modeling`, `codebase-design` |
| `code-reviewer` | Two-axis (Standards and Spec) diff review, ending in `LGTM` or `CHANGES REQUESTED`. Read-only | `code-review`, `engineering-principles`, `resiliency` |
| `security-reviewer` | Scanner-first CVE pass plus a CWE review. Read-only | `security-baseline` (and `security-aws` on demand) |
| `docs-writer` | Diátaxis- and Google-style docs, verified against the code | `writing-for-agents` |

### Rules

- `engineering-principles`: KISS/YAGNI, DRY by the rule of three, 12-factor, and security and cost as requirements.
- `resiliency`: timeouts, bounded retries, idempotency, cleanup, graceful shutdown, and concurrency ceilings.
- `security-baseline`: scanner-first CVEs, CWE checklist, redaction, and finding format.
- `security-aws`: opt-in AWS checks (IAM, exposure, encryption, cost-based DoS).

## Install

### Claude Code on your machine

Run this in a shell:

```bash
claude plugin install ai-hub --marketplace Bradfordly/ai-hub
```

The plugin declares `mattpocock-skills` as a dependency and installs it too. Agents appear as `ai-hub:<name>`. Alternatively, run the script from a clone:

```bash
git clone https://github.com/Bradfordly/ai-hub ~/code/ai-hub && ~/code/ai-hub/scripts/bootstrap.sh
```

### Claude Code headless (`claude -p`, CI)

Install once per machine or runner image, then run headless as usual:

```bash
git clone --depth 1 https://github.com/Bradfordly/ai-hub /tmp/ai-hub && /tmp/ai-hub/scripts/bootstrap.sh
```

Then, for example:

```bash
claude -p "Use the ai-hub:code-reviewer agent to review the diff against main"
```

A consumer repo's committed `.claude/settings.json` declares the plugins too. It doesn't install them, though, and a `-p` run in a folder you haven't trusted ignores it. Run `bootstrap.sh` wherever you need the hub installed.

### Claude Code cloud sessions

Cloud sessions don't install plugins that a repo declares, and they don't see your local `~/.claude` ([ADR 0003](docs/adr/0003-cloud-sessions-bootstrap-by-setup-script.md)). Instead, add this to the cloud environment's **setup script** (on claude.ai/code, edit the environment and open **Setup script**):

```bash
git clone --depth 1 https://github.com/Bradfordly/ai-hub "$HOME/.ai-hub"
"$HOME/.ai-hub/scripts/bootstrap.sh" || "$HOME/.ai-hub/scripts/bootstrap.sh" --link
```

The environment cache keeps the result, so later sessions start with the hub already installed. The cache is rebuilt about every 7 days, or when you edit the script, which picks up hub updates.

### Other harnesses (Codex, Gemini CLI, Cursor, and others)

```bash
scripts/bootstrap.sh --link
```

This symlinks agents into `~/.claude/agents`. It symlinks the hub's rules and skills, plus the upstream mattpocock skills (cloned into `~/.cache/ai-hub`), into `~/.claude/skills` and `~/.agents/skills`. A `git pull` keeps them current. The `SKILL.md` files follow the Agent Skills format, so any harness that reads skill folders can use them. The agent profiles use Claude Code's subagent format.

## Bootstrap a new project

```bash
scripts/new-project.sh ~/code/my-new-project
```

This copies the [project templates](templates/project/), skipping any file that already exists:

- `AGENTS.md`, with the project facts agents read: stack, commands, intentionally public surface, and which security rules to apply.
- `.claude/CLAUDE.md`, which imports `AGENTS.md`.
- `.claude/settings.json`, which enables `ai-hub` and `mattpocock-skills`.

Fill in the TODOs, open Claude Code in the folder, trust it, and run `/setup-matt-pocock-skills` once to configure the issue tracker and domain docs.

## Recommended flow

The hub's agents slot into the upstream [mattpocock/skills](https://github.com/mattpocock/skills) flow. `/ask-matt` maps the whole flow.

1. `/grill-with-docs` sharpens the idea, and records `GLOSSARY.md` terms and ADRs as you go. For decisions that are hard to reverse, delegate to `ai-hub:architect`.
2. `/to-spec`, then `/to-tickets`, turn it into a spec and tracer-bullet tickets.
3. `/implement` (one ticket) or `/implement-spec` (the whole graph) builds it test-first with `/tdd`.
4. `ai-hub:code-reviewer` and `ai-hub:security-reviewer` review the diff before the PR. `/pr` writes the body.
5. `/retro` turns what went wrong into changes to this hub: a new rule, a sharper agent, or an automated check.

## Contributing

Agents working in this repo follow [`AGENTS.md`](AGENTS.md). Before committing, run:

```bash
scripts/validate.sh
```

To try changes without installing, run `claude --plugin-dir .`.

## License

[MIT](LICENSE)
