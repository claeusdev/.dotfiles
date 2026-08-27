---
name: test-strategy
description: Decide what to test, at which level, and what not to test — including property-based tests, boundaries, failure injection, and diagnosing a suite that is slow, flaky, or passing while broken. Use when designing a test suite, deciding coverage for a change, adding tests to untested code, or fixing a suite that has stopped being useful; do not use for debugging one specific failure (that is debug-hypothesis).
---

# Test Strategy

A test suite exists to let you change the code confidently. Judge every test by one question:
what change would this catch that nothing else would? A test that cannot fail, or that fails
whenever anything is refactored, is a liability with the appearance of an asset.

Coverage percentage measures which lines ran, not which behaviors are protected. Do not use it
as the target.

## Decide the level

Push each test to the cheapest level that can actually catch the defect.

- **Unit** — logic with real branching, edge cases, and a stable interface. Fast enough to run
  constantly. Not for code whose only behavior is delegation.
- **Integration** — the seams: serialization, schema and migration, transactions, the actual
  database or filesystem or HTTP client. Most real defects live at a boundary, and mocking the
  boundary is precisely how they escape.
- **End-to-end** — a small number of critical user paths. Expensive and flaky in proportion to
  their number, so spend them deliberately.
- **Property-based** — where a law holds over a whole input space rather than at chosen points.

Mock to control what is genuinely uncontrollable — time, randomness, network, external services,
money. Mocking your own code mostly tests that your mocks match your beliefs about your code.

## Property-based testing

For parsers, evaluators, type checkers, serializers, data structures, and numeric code, chosen
examples cover a vanishing fraction of the input space. Generate the input instead and assert
the law: round-trip (`parse ∘ print = id`), invariance under an operation, agreement with a
slow but obviously-correct reference implementation, idempotence, and preservation of an
invariant.

The generator is the design work, not the assertion. A generator that never produces the
interesting shape tests nothing, so check what it actually emits. Shrinking is what turns a
1,200-node failing term into a three-node one you can read, so keep it working.

For the OCaml work under `~/workspace/research/type-systems`, this is QCheck over generated
terms — well-typed terms should evaluate without getting stuck, inference should agree with
checking, and unification should produce a most general unifier. See `ocaml-pl-engineering`.

## What to test

Behavior at the boundary of the specification: empty, one, many, maximum, just-over-maximum,
duplicate, out-of-order, and absent. Error paths, which are where untested code concentrates
because they are tedious to reach. Invariants that must hold across operations. Anything a bug
has already been found in — every fixed bug earns a test that fails without the fix.

What not to test: framework and library behavior, getters and delegation, implementation detail
that is expected to change, and anything whose test would have to be rewritten in lockstep with
the code it covers.

## Diagnose a suite that has stopped working

**Flaky** — find the cause; do not retry it away. It is shared state, ordering dependence,
timing, or a real race, and the last one is a bug being suppressed.
**Slow** — usually the level is wrong; find the tests that reach the network or the disk for no
reason.
**Green but broken** — assertions that cannot fail, over-mocking, or a whole layer untested.
Verify with mutation: break the code deliberately and check the suite notices.

Every new test must be shown to fail before the fix and pass after. A test written after the
code, that has never failed, is unverified.
