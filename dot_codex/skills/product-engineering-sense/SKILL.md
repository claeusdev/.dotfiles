---
name: product-engineering-sense
description: Shape or evaluate software changes through user value, product behavior, scope, evidence, quality, measurement, and rollout. Use when an engineering task needs product judgment or a product-minded critique; do not use for market research, visual design alone, or company-level product strategy.
---

# Product Engineering Sense

Connect implementation choices to a user outcome. Make product assumptions visible instead of silently converting them into requirements.

## Frame the outcome

Start with the concrete user, their situation, the progress they are trying to make, and the current friction. Inspect available evidence such as the request, product copy, support reports, analytics definitions, prior decisions, tests, and existing behavior. Separate observed evidence, stakeholder direction, inference, and open questions.

Write a compact decision frame:

- target user and triggering situation;
- desired behavioral or business outcome;
- current workaround or failure;
- non-negotiable trust, accessibility, compatibility, and operational constraints;
- success signal, guardrail, and riskiest assumption.

Ask for clarification only when different answers would materially change the product. Otherwise make a reversible assumption and label it.

## Shape the smallest valuable change

- Prefer a thin end-to-end slice that lets the user complete meaningful work. A backend capability without a discoverable, understandable path is usually not a complete product slice.
- Preserve established concepts and workflows unless changing them directly improves the intended outcome. Avoid creating a second vocabulary for the same thing.
- Design the full state model: first use, loading, empty, partial, success, invalid input, permission denial, dependency failure, retry, cancellation, and recovery where relevant.
- Choose defaults that help the common case without creating irreversible surprise. Make consequential actions clear and recoverable.
- Include accessibility, responsive behavior, latency perception, privacy, and supportability as product quality, not optional polish.
- Reduce scope by removing low-value branches or postponing reversible sophistication, not by dropping correctness, authorization, migration safety, or feedback to the user.

## Make tradeoffs explicit

Compare options using user value, reach, confidence, engineering and operational cost, reversibility, learning value, and downside risk. Do not turn an estimate into false precision. When evidence is weak, favor the option that tests the central assumption cheaply and safely.

Define measurement before instrumentation:

- the behavior the event or metric represents;
- numerator, denominator, eligibility, and time window;
- baseline or comparison;
- guardrails for errors, latency, abuse, accessibility, and user trust;
- decision owner and what action each result would trigger.

Do not collect data without a decision purpose. Minimize personal data and avoid success metrics that reward spam, coercion, or accidental engagement.

## Deliver and learn

Plan rollout, compatibility, migration, support, observability, and reversal in proportion to risk. Feature flags need an owner, target population, success criteria, and removal condition. Preserve users' work across rollback when feasible.

For a critique, express each material product issue as the user scenario, evidence, consequence, smallest improvement, and a way to validate it. For implementation work, finish with the recommended slice, deferred scope, assumptions, success and guardrail measures, and rollout or learning plan.
