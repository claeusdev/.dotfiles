---
name: codebase-investigator
description: Build an evidence-based understanding of an unfamiliar codebase, subsystem, or execution path — orientation, architecture mapping, tracing one scenario end to end, or change-impact discovery. Use when the question is "how does this work" or "what would break if I changed this"; do not use when the task is to implement or review a change, or when a single targeted file search would answer it (use Explore or Grep directly).
---

# Codebase Investigator

Build the smallest accurate model that answers the question asked. Reading a repository
exhaustively is not thoroughness — it is a way of producing confident summaries of code you
skimmed.

Treat code and runtime behavior as authoritative. Names, comments, documentation, and
architecture diagrams are hypotheses about the code, and in an unfamiliar repository they are
frequently stale hypotheses.

## Orient by question

Fix what you need to be able to explain or change, then start from the high-signal artifacts:
repository guidance files, manifests and lockfiles, build entry points, top-level structure,
executable entry points, and the tests. Tests are usually the fastest statement of intended
behavior that is checked by a machine.

Form explicit hypotheses about the entry points and control flow, who owns which state and how
it transitions, the module and dependency boundaries, the configuration and environment inputs,
the external effects and failure paths, and which tests encode the real contract. Then use
targeted search to follow symbols, types, call sites, registrations, and configuration keys.

Use the `Explore` agent when the question requires sweeping many directories or naming
conventions and you only need the conclusion. Read files directly when you need the detail.

## Mark your confidence

Label every conclusion that matters as **observed** (you read the code or ran it), **inferred**
(it follows from what you read), or **unverified** (it is the naming or a comment). Keeping
these separate is the single highest-value habit in this work, because an inference presented
as an observation is what causes someone to ship a change based on your summary.

Check misleading names and comments against the implementation and the call sites before
repeating them.

## Trace behavior

For a requested path, follow one concrete scenario end to end: inputs, transformations, state
changes, outputs, and what happens when each step fails. One traced scenario teaches more than
a survey of ten components.

When static reading cannot settle a question, use a focused runtime check — a test, a log, a
debugger, a one-off script — where that is safe and authorized. Do not modify the codebase
during an investigation-only request; if a temporary edit is the only way, say so and ask.

When the user is learning rather than just asking, have them predict the next hop or state
transition before you reveal it, and correct at the smallest mistaken assumption rather than
re-explaining the whole subsystem.

## Deliver

Pick the representation that makes the discovered structure clearest, rather than always
producing a component list: a component map for ownership and boundaries, a sequence or
data-flow trace for runtime behavior, a dependency map for change impact, or a plain list of
verified invariants and open hypotheses.

Cite specific files and line numbers for the load-bearing claims — `path/to/file.ml:42` is
clickable and checkable, "the parser module" is neither.

Close with the answer to the original question, the minimal reading path another engineer
should follow to reach the same understanding, what remains unresolved, and the safest next
investigation step.
