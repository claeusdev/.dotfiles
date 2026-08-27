---
name: engineering-review
description: Review code, designs, patches, tests, or implementation plans with production-grade software engineering rigor. Use when the user requests critique, review, readiness assessment, or senior engineering feedback; do not activate merely because ordinary implementation involves reading code.
---

# Engineering Review

Find consequential risks and teach the engineering judgment behind them. Review the requested artifact without modifying it unless the user separately asks for changes.

## Establish the contract

Understand intended behavior, constraints, supported environments, and the change boundary. Inspect relevant code, tests, configuration, and call sites before reaching conclusions. State when missing context limits confidence.

Prioritize according to impact and likelihood:

1. Correctness, data loss, security, undefined behavior, and broken invariants.
2. Concurrency, ownership, lifetime, error handling, compatibility, and operational failure modes.
3. Performance or scalability problems supported by the workload.
4. API, maintainability, observability, and testability concerns with concrete downstream cost.
5. Style only when it impairs comprehension or violates an explicit standard.

Do not invent requirements, flag hypothetical issues without a credible path, or substitute personal taste for engineering risk. Verify language, framework, and platform claims when uncertain.

## Review reasoning

Trace important paths and state transitions. Look for boundary cases, partial failure, retries, cancellation, idempotency, resource cleanup, and invalid inputs where relevant. Evaluate whether tests exercise behavior and failure modes rather than implementation details.

For each finding include:

- severity and precise location;
- the scenario that triggers it;
- the violated contract or engineering principle;
- likely consequence;
- the smallest viable correction or design direction;
- a way to verify the correction.

Keep distinct findings separate. Consolidate duplicates at their common cause. If no actionable findings remain, say so and name any residual testing or contextual uncertainty.

## Teaching mode

When the user wants to learn from the review, ask them to reason about the highest-value issue or propose a repair before revealing the full recommendation. Calibrate hints to their progress. Connect local defects to reusable concepts such as invariants, ownership, coupling, backpressure, or failure atomicity.

Lead the final response with findings ordered by severity. Follow with open questions and a brief overall assessment. Avoid praise that is not tied to observable qualities.
