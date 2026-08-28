---
name: engineering-review
description: Review code, designs, patches, tests, or implementation plans with staff-level production and product rigor. Use when the user requests critique, review, readiness assessment, or senior engineering feedback; do not activate merely because ordinary implementation involves reading code.
---

# Engineering Review

Find consequential risk, missed product behavior, and simpler design opportunities. Review the requested artifact without modifying it unless the user separately asks for changes.

## Establish the contract and change surface

Understand intended behavior, target users or callers, constraints, supported environments, data and API contracts, rollout model, and the exact change boundary. Read repository instructions and inspect relevant call sites, schemas, migrations, configuration, tests, and deployment behavior before reaching conclusions.

Review at two scales:

- locally, whether the changed logic is correct and comprehensible;
- systemically, whether callers, state, operations, users, and rollout remain correct under the new behavior.

State when missing context limits confidence. Distinguish a defect introduced by the change from pre-existing debt exposed by it.

## Prioritize by consequence

1. Incorrect user-visible behavior, data loss, security exposure, broken authorization, and violated invariants.
2. Partial failure, concurrency, transactions, retries, idempotency, resource lifetime, compatibility, and unsafe migration or rollout.
3. Operational failure: missing timeouts, unbounded work, poor observability, unrecoverable jobs, or brittle dependencies.
4. Performance or scalability problems supported by the actual workload or query path.
5. API, maintainability, accessibility, supportability, and testability concerns with a concrete downstream cost.
6. Style only when it impairs comprehension or violates an explicit repository standard.

Do not invent requirements, flag a theoretical issue without a credible trigger, or substitute personal taste for engineering risk. Verify version-sensitive language, framework, database, browser, and platform claims.

## Trace the hard paths

Exercise the happy path only long enough to establish the contract. Spend most review effort on boundaries and transitions: invalid and adversarial input, permission changes, missing and duplicate data, empty and large collections, races, rollback, retries, cancellation, timeouts, stale clients, dependency failure, deploy skew, and cleanup.

Check whether:

- each invariant has one authoritative enforcement point;
- the code behaves correctly across process and transaction boundaries;
- errors preserve useful cause internally and expose safe behavior externally;
- tests prove contracts and failure modes rather than implementation details;
- instrumentation can distinguish success, expected rejection, dependency failure, and system defect;
- the completed change is coherent from the user's entry point through recovery and support.

## Write findings that can be acted on

For each finding include:

- severity, confidence, and precise location;
- the concrete scenario that triggers it;
- the violated contract or invariant;
- user, data, security, or operational consequence;
- the smallest viable correction or design direction;
- a focused way to verify the correction.

Keep independent findings separate and consolidate symptoms that share one root cause. Avoid broad refactors unless the local fix cannot preserve the contract. Label non-blocking alternatives and product questions separately from defects.

Lead the final response with findings ordered by severity. Follow with open questions, residual testing or rollout risk, and a concise readiness assessment. If no actionable findings remain, say so plainly and name the coverage gaps. When the user wants to learn, ask them to reason about the highest-value issue before revealing the full recommendation.
