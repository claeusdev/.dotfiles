---
name: engineering-review
description: Review code, a design, a patch, or an implementation plan with production-grade judgment, and explain the engineering reasoning behind each finding. Use when asked for critique, a readiness assessment, senior-level feedback, or a review you can learn from; do not activate merely because ordinary implementation involves reading code. For a mechanical scan of the current diff or a PR, use /code-review; for quality-only cleanups, /simplify; for a security-focused pass, /security-review or security-threat-modeler.
---

# Engineering Review

Find the risks that actually matter and teach the judgment that found them. The failure mode of
review is volume: a list of thirty observations in which three are serious reads as noise, and
the three get lost.

Review the artifact without modifying it unless the user separately asks for changes.

## Establish the contract

Understand the intended behavior, the constraints, the supported environments, and the boundary
of the change before judging any of it. Read the relevant code, tests, configuration, and call
sites — a finding derived from the diff alone, without the call sites, is a guess. Say
explicitly when missing context limits your confidence rather than lowering the bar silently.

Prioritize by impact and likelihood:

1. Correctness, data loss, security, undefined behavior, broken invariants.
2. Concurrency, ownership and lifetime, error handling, compatibility, operational failure.
3. Performance or scalability problems justified by the actual workload.
4. API design, maintainability, observability, and testability with a concrete downstream cost.
5. Style, only where it impedes comprehension or violates a stated project standard.

Do not invent requirements, raise hypotheticals with no credible path, or present taste as risk.
Verify language, framework, and platform claims when you are not certain — a confidently wrong
review finding costs more than a missed one, because it gets acted on.

## Review the reasoning

Trace the important paths and state transitions rather than reading top to bottom. Look at
boundary cases, partial failure, retries, cancellation, idempotency, resource cleanup, and
invalid input where they apply. Ask whether the tests exercise behavior and failure modes or
merely restate the implementation — a test that changes whenever the code changes is proving
nothing.

For each finding give: severity and precise location; the scenario that triggers it; the
contract or principle it violates; the likely consequence; the smallest viable correction; and
how to verify the correction. A finding without a triggering scenario is an opinion.

Keep distinct findings separate, and consolidate duplicates at their common cause — five
instances of one missing validation are one finding.

## Teaching mode

When the user wants to learn from the review rather than just receive it, ask them to reason
about the highest-value issue or propose a repair before you reveal the full recommendation,
and calibrate hints to how they respond. Connect the local defect to the reusable concept —
invariant, ownership, coupling, backpressure, failure atomicity — because that is what
transfers to the next review.

## Close

Lead with the findings ordered by severity, then the open questions, then a brief overall
assessment. If nothing actionable remains, say so plainly and name the residual uncertainty
rather than manufacturing findings to justify the review. Avoid praise not tied to something
observable in the artifact.
