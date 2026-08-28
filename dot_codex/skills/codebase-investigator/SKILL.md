---
name: codebase-investigator
description: Build a staff-level, evidence-based understanding of an unfamiliar codebase, subsystem, execution path, or change surface. Use for repository orientation, architecture mapping, change-impact discovery, or learning how existing code works; do not use when the user primarily requests implementation or a formal code review.
---

# Codebase Investigator

Create the smallest accurate model needed for the user's decision. A staff-level reading explains not just where code lives, but which product behavior, invariants, ownership boundaries, and operational constraints shaped it. Treat executable behavior as authoritative over names, comments, diagrams, or architectural guesses.

## Set the investigation boundary

Define what the user needs to explain, decide, debug, or change. Read repository instructions first. Then inspect the highest-signal artifacts for that question: manifests and lockfiles, entry points, top-level structure, public interfaces, schemas and migrations, deployment configuration, tests, and recent relevant history.

Do not read the repository uniformly. Maintain an evidence ledger with important conclusions marked as observed, inferred, or unverified, plus the artifact or experiment that could resolve each uncertainty.

## Build a layered system model

Map only the layers needed for the question:

- product: users, workflows, externally visible contracts, and failure experience;
- execution: entry points, control flow, process boundaries, concurrency, and background work;
- domain: state ownership, invariants, transitions, policies, and authorization;
- data: schemas, transactions, caches, derived state, retention, and migration history;
- integrations: protocols, trust boundaries, retries, timeouts, idempotency, and degraded behavior;
- delivery: configuration, build artifacts, environments, observability, rollout, and recovery.

Look for system pressure revealed by the code: compatibility shims, duplicated policy, hot paths, ownership ambiguity, high-churn modules, escape hatches, and tests guarding old incidents. Use version history when it can explain why a surprising boundary exists, not as a substitute for reading current behavior.

## Trace representative behavior

Follow at least one concrete scenario end to end. Record inputs, transformations, authorization, state reads and writes, external effects, outputs, and failure handling. Follow registrations, dependency injection, callbacks, signals, middleware, configuration, and generated code that can hide control flow.

Triangulate important claims across implementation, call sites, tests, configuration, runtime evidence, and history. Use a focused test, log, debugger trace, or safe local probe when static reading cannot settle a material question. State explicitly when an apparent invariant is convention-only rather than enforced.

For change impact, inspect both directions: callers and consumers that depend on the behavior, and dependencies or state the behavior relies on. Identify compatibility surfaces, migration sequencing, operational dashboards, and the team or component that appears to own each boundary when evidence exists.

## Communicate the model

Choose the smallest representation that makes the system legible: a component and ownership map, a request or data-flow trace, a state machine, a dependency and blast-radius map, or a table of invariants and enforcement points.

Cite local files and precise locations for key claims. End with:

- the direct answer to the original question;
- the system's critical path and enforced invariants;
- why the current boundaries likely exist, clearly labeled when inferred;
- hotspots, change seams, and likely blast radius;
- the minimal reading path another engineer should follow;
- unresolved uncertainties and the safest next investigation.

When teaching, ask the learner to predict the next hop, owner, or state transition before revealing it. Do not silently mutate the codebase during an investigation-only request.
