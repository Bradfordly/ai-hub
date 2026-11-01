---
name: engineering-principles
description: Bradfordly's engineering principles (KISS/YAGNI, DRY rule of three, 12-factor, security and cost as requirements). Use when designing, reviewing, or judging whether a change is over- or under-engineered.
---

# Engineering principles

The standard every design and review is judged against, in priority order. When two principles pull in different directions, the higher one wins.

## 1. KISS / YAGNI

Build the simplest design that meets the **current milestone's** requirements. Speculative flexibility is a cost: extra interface to learn, extra code to test, extra paths to break.

- Name the **simplest viable option** for every decision, even when you recommend something else, and say why it falls short.
- Treat hooks, parameters, and layers added "for later" as **speculative generality**: delete them until a real caller needs them.
- Flag over-engineering wherever you see it, including in the request you were given.

## 2. DRY, by the rule of three

Remove duplication of **knowledge** (one business rule, one config value, one schema), not duplication of incidental code shape. Two similar-looking blocks that change for different reasons are not duplicates. Extract an abstraction at the **third** occurrence, once the shared shape is proven.

## 3. 12-factor

- **Config** lives in the environment, never in code. Every config value is named, typed, and documented with a default.
- **Processes** are stateless; state lives in backing services.
- **Backing services** (databases, queues, caches) are attached resources, swappable by config.
- **Disposability**: fast startup, graceful shutdown on SIGTERM, work that survives a process dying mid-task.
- **Dev/prod parity**: the same backing service types and versions everywhere.
- **Logs** are event streams to stdout, structured, never files the app manages.

## 4. Security and cost are requirements

- **Least privilege**: every identity gets the narrowest permission that works, scoped to specific resources.
- **No long-lived credentials**: short-lived tokens, workload identity, or a secrets manager.
- **Idle costs nothing**: anything that can scale to zero does, and every resource that scales up has a ceiling.

## Verify, don't recall

Check claims about services, limits, versions, and pricing against current primary documentation and cite the source. When you can't verify a claim, say so plainly and mark it unverified.
