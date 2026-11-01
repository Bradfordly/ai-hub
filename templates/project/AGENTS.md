# TODO: project name

TODO: one line on what this project is and who uses it.

## Project facts for agents

The ai-hub agents (`architect`, `code-reviewer`, `docs-writer`, `security-reviewer`) are project-agnostic. They read the facts below at runtime.

- **Stack:** TODO (languages, frameworks, cloud, IaC tool)
- **Commands:** TODO (`test`, `lint`, `typecheck`, `build`; exact invocations)
- **Intentionally public surface:** TODO (ports, endpoints, upload paths). The `security-reviewer` treats anything not listed here as unintended.
- **Security rules to apply:** `security-baseline`. TODO: add `security-aws` if the project runs on AWS.
- **CI workflows:** TODO (names of the workflows that run tests and security scans)

## Where things live

- `GLOSSARY.md`: domain language. Created by the `domain-modeling` skill on first use.
- `docs/adr/`: architecture decisions, written by the `architect` agent.
- `docs/agents/`: issue tracker and triage config, written by `/setup-matt-pocock-skills`.
