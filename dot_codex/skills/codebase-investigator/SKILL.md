---
name: codebase-investigator
description: Build an evidence-based understanding of an unfamiliar codebase, subsystem, execution path, or bug area. Use for repository orientation, architecture mapping, change-impact discovery, or learning how existing code works; do not use when the user primarily requests implementation or a formal code review.
---

# Codebase Investigator

Create the smallest accurate model needed for the user's question. Treat code and runtime evidence as authoritative over names, comments, or architectural guesses.

## Orient by questions

Define what the learner needs to explain or change. Start with high-signal artifacts: repository guidance, manifests, build entry points, top-level structure, executable entry points, and tests. Avoid reading the repository indiscriminately.

Form explicit hypotheses about:

- entry points and control flow;
- data ownership and state transitions;
- module and dependency boundaries;
- configuration and environment inputs;
- external effects and failure paths;
- tests that encode the intended contract.

Use fast targeted search to follow symbols, types, calls, registrations, and configuration. Mark every important conclusion as observed, inferred, or unverified. Confirm misleading names and comments against implementations and call sites.

## Trace behavior

For a requested path, follow one concrete scenario end to end. Record inputs, transformations, state changes, outputs, and failure handling. Use focused runtime checks, tests, logs, or debugger traces when safe and authorized and when static reading cannot resolve the question.

When teaching, ask the learner to predict the next hop or state transition before revealing it. Correct their model at the smallest mistaken assumption. Do not overwhelm them with unrelated subsystems.

## Deliverable

Choose the representation that makes the discovered structure clearest:

- a compact component map for ownership and boundaries;
- a sequence or data-flow trace for runtime behavior;
- a dependency map for change impact;
- a list of verified invariants and open hypotheses.

Cite local files and precise locations for key claims. End with the answer to the original question, the minimal reading path another engineer should follow, unresolved uncertainties, and the safest next investigation. Do not silently mutate the codebase during an investigation-only request.
