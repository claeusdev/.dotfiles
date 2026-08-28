---
name: python-application-engineering
description: Architect, implement, or optimize production Python applications, including Django systems, with explicit domain boundaries, data integrity, operability, and version-aware framework decisions. Use for cross-cutting application work; do not activate for a small isolated Python edit that needs no architectural judgment.
---

# Python Application Engineering

Ship the product change without erasing the decisions already encoded in the application. Prefer evidence from the repository and its exact dependency versions over a generic Python or Django convention.

## Establish the local contract

1. Read repository instructions, manifests and lockfiles, supported Python version, framework settings, executable entry points, deployment configuration, and tests near the affected behavior.
2. Trace one representative user or system flow through input validation, domain rules, persistence, side effects, and response handling. Name the invariants the change must preserve.
3. Capture a baseline with the project's existing test, type, lint, migration, and build commands. Distinguish pre-existing failures from introduced failures.
4. Keep the repository's package manager, layout, framework idioms, and validation stack unless the task gives a concrete reason to change them.

Read [references/python-practices.md](references/python-practices.md) when making language, packaging, typing, concurrency, or testing decisions. For Django work, also read [references/django-practices.md](references/django-practices.md). Match all version-sensitive claims to the versions installed by the repository.

## Design for production behavior

- Keep transport, domain, persistence, and integration concerns distinguishable. A view, command, consumer, or task should adapt inputs and outputs; it should not become the only place where a business invariant exists.
- Parse and validate external data at the boundary. Type hints improve static reasoning but do not validate HTTP bodies, environment values, queue messages, database JSON, or third-party responses at runtime.
- Put concurrency-sensitive invariants in the database when it can enforce them. Use application checks for helpful errors, not as the sole guard against races.
- Make the unit of consistency explicit. Keep database transactions short, and trigger irreversible external effects only after commit or through a durable handoff.
- Design retries deliberately. Work that can be redelivered needs an idempotency rule, ownership rule, bounded retry policy, and observable terminal failure.
- Treat async as an execution model, not a style preference. Confirm the full call path and dependencies are async-safe, and measure that concurrency solves an actual workload constraint.
- Preserve causal exceptions internally. At public boundaries, expose stable, non-sensitive errors and log enough context to diagnose the failed operation without leaking secrets or personal data.

## Implement a coherent vertical slice

- Prefer the smallest end-to-end slice that delivers usable behavior, including permissions, validation, empty and error states, persistence, and operational visibility.
- Evolve schemas and public interfaces compatibly across the deployment window. Separate state expansion, backfill, enforcement, and cleanup when one-step rollout would break old processes or existing rows.
- Keep background work durable when completion matters. Process memory is not authoritative for work ownership, quotas, locks, idempotency, or cross-instance coordination.
- Add observability at the boundary that owns the outcome: structured events, stable dimensions, meaningful latency or throughput measures, and actionable failure signals.
- Optimize demonstrated bottlenecks. Record the workload and before/after evidence; do not trade away clarity for an unmeasured gain.

## Validate and hand off

Start with the narrowest decisive tests, then run the broader repository gates proportionate to the change. Test observable contracts, authorization, invalid input, transaction rollback, retry behavior, and compatibility where relevant. For deployment-affecting Django changes, include the repository's production settings in system checks.

Report what changed, why the boundary is appropriate, commands run and their results, migration or rollout requirements, operational signals, and residual uncertainty. Do not claim a security, reliability, or performance property that was not verified.
