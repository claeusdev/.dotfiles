---
name: typescript-application-engineering
description: Architect, harden, optimize, or assess production TypeScript applications — boundary validation, state ownership, trust boundaries, measured performance, and compiler-enforced invariants. Use for cross-cutting TypeScript application work where architectural judgment is needed; do not activate for a small isolated edit, or for reviewing a diff (that is engineering-review or /code-review).
---

# TypeScript Application Engineering

Improve the system without erasing the product decisions already encoded in it. Establish the
runtime, framework, deployment model, data ownership, and critical request paths from the
repository itself before choosing any pattern — the same code means different things behind a
single process and behind an autoscaled fleet.

## Working method

1. Read the repository's own instructions and the documentation for the exact framework version
   installed. Framework APIs and deployment behavior are versioned facts, not recalled ones.
2. Map the trust boundaries, the expensive paths, the state ownership, and any process-local
   coordination. Confirm which invariants must survive multiple instances, retries,
   disconnects, and partial failure.
3. Capture a green baseline with the project's existing typecheck, lint, tests, build,
   migrations, and dependency audit. Distinguish pre-existing failures from introduced ones
   before touching anything.
4. Change in coherent stages with a validation gate after each. Prefer one authoritative
   implementation of a policy over the same check copied across routes.
5. Report residual risk and rollout needs. Never claim a performance improvement without a
   reproducible before-and-after measurement.

## Type-level design

Parse `unknown` at every external boundary — HTTP bodies, form data, environment variables,
database JSON, queues, files, and model or tool output. Infer the static type from the runtime
schema rather than declaring it twice.

Keep domain types independent of transport and persistence shapes, converting at the boundary
instead of spreading casts through business logic. Model finite states and events as
discriminated unions so invalid transitions are hard to express and variants are handled
exhaustively.

Use `satisfies` for configuration conformance without widening literals, prefer type-only
imports, and keep assertions narrow and local — an assertion is never a substitute for
validation. Enable strict compiler flags incrementally while keeping the repository green; a
flag enabled and then buried under broad assertions or exclusions is worse than the flag off,
because it looks handled.

Preserve causal errors internally while exposing stable, non-sensitive codes at public
boundaries.

## Architecture

Authentication establishes the actor once per request. Authorization loads the owned resource
with that actor and returns the data downstream code already needs, so there is no second,
divergent ownership check.

Keep route handlers thin — parse, authorize, call an application operation, map the response.
Transaction boundaries and cross-resource invariants belong in the application layer, not in
the handler.

Process memory is a cache, never the source of truth for budgets, locks, rate limits, leases,
idempotency, or work claims in a horizontally scaled service. For expensive work, atomically
reserve capacity and budget before opening a stream or calling a provider; give claims
expirations and heartbeats, and settle actual usage durably. Design for the disconnect: a
client that vanishes mid-request must not corrupt already-paid work, and a stale claim must be
reclaimable.

## Security, privacy, performance

Threat-model authenticated writes, not only public routes — cookie-authenticated mutations need
same-origin or CSRF defenses, and an ownership failure that returns a distinguishable error
becomes an enumeration oracle. Bound request bytes, decoded and expanded bytes, nesting depth,
collection sizes, and text lengths before expensive parsing. Treat uploaded documents, retrieved
text, and user content in prompts as untrusted data: delimit it and state that instructions
inside it carry no authority. Redact secrets from structured logs and telemetry, including
exception messages, URLs, query parameters, and nested error metadata.

Define the user-visible metric before optimizing anything, and instrument at the boundary that
owns it. Remove redundant authentication and duplicated request-local reads before adding a
cross-request cache, and cache only data with an explicit owner, lifetime, invalidation rule,
and tenant key. Add indexes from demonstrated query predicates and ordering, checking migration
safety against existing data — especially before adding uniqueness.

Read `references/review-checklists.md` for a systematic architecture, security, performance, or
release-readiness pass; load only the section the request needs.
