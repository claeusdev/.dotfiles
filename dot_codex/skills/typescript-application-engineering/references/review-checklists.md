# Review checklists

Use these as prompts for investigation, not as a requirement to change every item.

## Architecture

- Identify runtime entrypoints, deployment units, stateful dependencies, background work, and third-party providers.
- Trace one authenticated read, one mutation, one expensive operation, and one failure from entrypoint to persistence.
- Locate duplicate session reads, database round trips, policy copies, circular dependencies, and domain logic embedded in routes or components.
- Verify tenant ownership in the query that loads a resource, not after an unscoped load.
- Inspect transaction, idempotency, lease, retry, timeout, cancellation, and reconciliation behavior.
- Classify in-memory state: harmless request-local cache, disposable optimization, or incorrectly process-local coordination.

## Security

- Inventory public, authenticated, admin, cron, webhook, upload, export, and streaming surfaces.
- Verify runtime validation, byte/shape/decompression bounds, MIME signatures, authorization, CSRF/origin handling, and rate-limit scope.
- Trace secrets and personal data through errors, logs, telemetry, prompts, exports, and third-party SDK defaults.
- Check CSP, HSTS, framing, MIME sniffing, referrer, permissions, cookies, redirect targets, and outbound fetch allowlists.
- Treat model output as untrusted before persistence/rendering and retrieved content as untrusted before prompting.
- Check dependencies with the package manager's production audit and review risky parsers separately.

## Generation and performance

- Record preflight, provider time-to-first-token or first useful semantic event, total duration, input/output tokens, cache usage, retries, and cost.
- Verify concurrency and budget decisions are atomic across instances and include active reservations.
- Ensure claims expire, heartbeat, settle actual usage, and can be reconciled from an audit trail.
- Bound conversation history, retrieved context, serialized JSON, and requested output in a shared phase spec.
- Inspect query plans or at minimum match indexes to frequent tenant filters, foreign-key lookups, status predicates, and orderings.
- Benchmark with a warm-up policy, representative data, controlled concurrency, failure counts, and p50/p95 rather than a single timing.

## TypeScript and validation gate

- Prefer schema-inferred types, discriminated unions, exhaustive switches, `satisfies`, and narrow adapters.
- Search for `any`, double assertions, unchecked JSON casts, non-null assertions, and optional fields that really represent state variants.
- Keep strictness improvements green; document flags that need a separate migration instead of weakening code to silence them.
- Run typecheck, lint, unit tests, integration tests, migration-from-empty, production build, and focused security/performance tests.
- Review the final diff for generated artifacts, accidental user-file edits, secret material, migration hazards, and stale comments.
