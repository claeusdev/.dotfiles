---
name: product-ticket-delivery
description: Drive a product engineering ticket through product discovery, codebase investigation, system design, implementation, self-review, human review, and pull-request creation. Use for end-to-end ticket delivery; do not use for a single isolated phase or when the user only wants advice.
---

# Product Ticket Delivery

Turn a ticket into a reviewable, verified change while preserving one chain of evidence from user outcome to code and rollout. This skill coordinates specialized skills; it does not replace their judgment.

## Establish the delivery contract

Read repository instructions and inspect the working tree before making changes. Record the ticket, target repository, current branch, intended outcome, constraints, and definition of done. Preserve unrelated changes and identify any pre-existing validation failures.

Create a compact phase ledger with: current phase, evidence produced, decisions made, unresolved questions, validation state, and next gate. Keep it in the conversation unless the repository asks for a persistent artifact.

Ask only when an unresolved choice would materially change product behavior, architecture, destructive effects, cost, or external state. Otherwise make a reversible assumption and label it.

## Run the pipeline

Load and apply each installed skill in order. Read its complete `SKILL.md` before acting. Carry decisions and evidence forward; do not restart the analysis at every phase.

1. **Product discovery — `product-engineering-sense`**
   Frame the user, problem, desired outcome, smallest valuable slice, non-goals, success signal, guardrails, and riskiest assumption. Gate: the behavior and acceptance criteria are concrete enough to evaluate.

2. **Codebase discovery — `codebase-investigator`**
   Trace the current user or system path, invariants, ownership boundaries, tests, and likely blast radius. Gate: the change seam and affected contracts are supported by repository evidence.

3. **System design — `systems-design-coach`**
   Use collaborative-design or direct-instruction mode, not interview simulation. Design only to the depth warranted by the change. Capture interfaces, state ownership, data changes, failure behavior, compatibility, observability, rollout, and a simpler rejected alternative. Gate: the implementation path is coherent and material tradeoffs are explicit.

4. **Implementation**
   Route to the most specific installed implementation skill. Use `python-application-engineering` for cross-cutting Python or Django work, `typescript-application-engineering` for cross-cutting TypeScript work, and `feature-implementation` for stack-neutral work or when no specialist applies. For a mixed-stack slice, use `feature-implementation` as the delivery frame plus each relevant specialist. Gate: the smallest end-to-end slice works and the narrowest decisive validations pass.

5. **Self-review — `engineering-review`**
   Review the actual diff against the product contract and design, including callers, tests, migrations, operations, accessibility, security, and rollback where relevant. The original implementation request authorizes repairing in-scope findings; fix consequential findings, rerun affected checks, and review the resulting diff again. Gate: no known blocking finding remains, or the blocker is surfaced explicitly.

6. **Human review and PR — `pr-review-handoff`**
   Prepare a concise engineer review packet and pause for human review. Incorporate approved feedback, rerun affected checks, and re-review the final diff. Only after the human approves the packet should the skill request authorization for the external write and then push/open the PR. Gate: the PR exists with accurate evidence, or the workflow ends at a clearly reported approval or permission boundary.

Skip a phase only when it is genuinely irrelevant; record why. Re-enter an earlier phase when implementation or review invalidates its assumptions.

## Completion standard

Finish with the user outcome delivered, acceptance criteria mapped to evidence, tests and checks reported exactly, review findings resolved or disclosed, rollout and rollback needs stated, and the PR linked when created. Never claim human approval, test success, or production readiness without evidence. Do not add dependencies, push, or create a PR without the authorization required at that point.
