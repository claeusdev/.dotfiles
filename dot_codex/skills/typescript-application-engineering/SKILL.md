---
name: typescript-application-engineering
description: Architect, harden, optimize, or review production TypeScript applications using explicit boundaries, measurable performance, and compiler-backed invariants. Use for cross-cutting TypeScript application work; do not activate for a small isolated edit that does not need architectural judgment.
---

# TypeScript Application Engineering

Improve the system without erasing the product decisions already encoded in it. Establish the runtime, framework, deployment model, data ownership, and critical request paths from repository evidence before choosing patterns.

## Working method

1. Read repository instructions and the installed framework documentation for the exact version in use. Treat framework APIs and deployment behavior as versioned facts.
2. Map trust boundaries, expensive paths, state ownership, and process-local coordination. Confirm which invariants must survive multiple instances, retries, disconnects, and partial failure.
3. Capture a green baseline with the project's existing typecheck, lint, tests, build, migrations, and dependency audit. Distinguish existing failures from introduced ones.
4. Make changes in coherent stages with a validation gate after each stage. Prefer one authoritative implementation of each policy over route-by-route copies.
5. Report residual risk and rollout needs explicitly. Do not claim performance improvement without a reproducible before/after measurement.

## TypeScript design constraints

- Parse `unknown` at every external boundary: HTTP bodies, form data, environment variables, database JSON, queues, files, and model/tool output. Infer types from the runtime schema when possible.
- Keep domain types independent of transport and persistence shapes. Convert at boundaries rather than spreading casts through business logic.
- Model finite states and events as discriminated unions. Make invalid transitions hard to express and exhaustively handle variants.
- Use `satisfies` for configuration conformance without widening literals. Prefer type-only imports and narrow, local assertions; an assertion never substitutes for validation.
- Enable strict compiler flags incrementally while keeping the repository green. Do not enable a flag and bury the resulting errors with broad assertions or exclusions.
- Preserve causal errors internally while exposing stable, non-sensitive error codes and messages at public boundaries.

## Architecture constraints

- Authentication establishes an actor once per request. Authorization guards load owned resources with that actor and return the data downstream code already needs.
- Keep route handlers thin: parse, authorize, call an application operation, map the response. Transaction boundaries and cross-resource invariants belong in the application/data layer.
- Process memory is a cache, never the source of truth for budgets, locks, rate limits, leases, idempotency, or work claims in a horizontally scaled service.
- For expensive work, atomically reserve capacity and budget before opening a stream or calling a provider. Give claims expirations and heartbeats, and settle actual usage durably.
- Design retries and disconnects deliberately. A client disconnect should not corrupt already-paid work; stale claims must be reclaimable.

## Security and privacy constraints

- Threat-model authenticated writes as well as public routes. Cookie-authenticated mutations need same-origin/CSRF defenses; ownership failures should not become enumeration oracles.
- Bound request bytes, decoded/expanded bytes, nesting, collection sizes, text lengths, history length, and model-token envelopes before expensive parsing or generation.
- Treat uploaded documents, retrieved text, and learner content as untrusted data in prompts. Delimit it and state that embedded instructions have no authority.
- Redact secrets and sensitive database values from both structured logs and telemetry events, including exception messages, URLs, query parameters, and nested error metadata.
- Deploy browser policies such as CSP using the framework's supported nonce mechanism. Validate runtime behavior, third-party connections, and streaming after tightening the policy.

## Performance constraints

- Define the learner-visible metric first: admission latency, time to first useful event, total generation time, tokens, cost, or database round trips. Instrument at the boundary that owns it.
- Remove redundant authentication and duplicate request-local reads before adding cross-request caches. Cache only data with an explicit owner, lifetime, invalidation rule, and tenant key.
- Bound prompts before optimizing models. Keep output limits, duration limits, reservations, and concurrency in one phase specification so they cannot drift.
- Add indexes from demonstrated query predicates and ordering. Check migration safety against existing data, especially before adding uniqueness.
- Benchmark realistic cold and warm paths with recorded concurrency, dataset, configuration, and percentile summaries. Compare against the captured baseline.

Read [references/review-checklists.md](references/review-checklists.md) for deep architecture, security, performance, or readiness reviews. Load only the sections relevant to the request.
