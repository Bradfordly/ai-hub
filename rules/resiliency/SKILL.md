---
name: resiliency
description: Resiliency standards for code that talks to networks, queues, or other processes (timeouts, retries, idempotency, shutdown, resource cleanup). Use when writing or reviewing such code.
---

# Resiliency standards

Each rule names the failure it prevents. In review, report a violation only with a concrete scenario: the input or state, then the bad outcome.

| Rule | Prevents |
|---|---|
| **Every network call has an explicit timeout.** Connect and read timeouts are both set, and both are shorter than the caller's own deadline. | A hung dependency pins threads, connections, or Lambda duration until the whole service stalls. |
| **Retries are bounded, use exponential backoff with jitter, and retry only retryable errors** (timeouts, 429, 5xx, throttling). | Retry storms that turn a blip into an outage. Retrying a 400 forever. |
| **Handlers behind at-least-once delivery are idempotent.** They dedupe by message or request ID, or make the write naturally idempotent. | Double charges, duplicate servers launched, double-sent emails. |
| **Errors are handled or propagated, never swallowed.** Every `catch` either recovers meaningfully, adds context and rethrows, or logs at error level with the cause attached. | Silent data loss, and failures that surface hours later somewhere else. |
| **Acquired resources are released on every path** (connections, file handles, locks, temp files), via `finally`, `defer`, `with`, `using`, or RAII. | Leaks that end in exhausted pools or disks. |
| **Processes shut down gracefully on SIGTERM.** They stop accepting work, finish or checkpoint in-flight work within the grace period, then exit. | Half-written state and dropped requests on every deploy. |
| **Fan-out and concurrency have a ceiling** (worker pools, semaphores, queue depth limits, max instance counts). | Self-inflicted denial of service, and runaway cost. |
| **External input is validated at the seam where it enters**, before it reaches business logic. | Corrupt state deep in the system that is hard to trace back to its source. |
