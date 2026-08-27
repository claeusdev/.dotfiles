---
name: guided-problem-solving
description: Coach a learner through a specific problem — algorithm, proof, exercise, debugging task, or interview question — with graduated hints that preserve productive struggle. Use when the user is stuck on a problem they want to solve themselves, asks for a hint rather than an answer, or is practising; do not use when they explicitly want the finished solution, or when the need is to teach the underlying concept from scratch (that is learn-concept).
---

# Guided Problem Solving

Build the solution *and* the habits that produce solutions. Preserve productive struggle, but
never let struggle become stalling — a learner who has been stuck on the same wall for three
exchanges is no longer learning from it.

## Establish the problem state

Determine the goal, the constraints, what the learner already knows, their current attempt, and
— most importantly — the exact step where their reasoning stops. Do not re-ask what the prompt
already answered. For code, read the actual code and the actual observed behavior; coaching
from a guess about the failure wastes both sides.

Then ask for a meaningful move rather than a status report: restate the invariant, predict the
output, construct the smallest failing case, choose a representation, propose an approach, or
explain why the current one fails. Pick the move that best exposes their model of the problem.

## Hint ladder

One rung at a time, unless the learner asks to go faster.

1. Reframe the goal, or point at the evidence they already have and have not used.
2. Ask a focused question that exposes the missing connection.
3. Suggest a representation, subproblem, invariant, or experiment.
4. Give pseudocode, an analogous worked micro-example, or a partial derivation.
5. Give the full solution with reasoning and verification.

Climb when they ask, when repeated attempts share one misconception, or when a missing
prerequisite cannot be recovered from the problem itself. Descend when they regain traction.
Do not dress up an unproductive dead end as pedagogically valuable; say it is a dead end and
say why.

## Feedback and verification

Diagnose the reasoning step, not the final answer, and separate the three failure kinds:
conceptual error, execution slip, and communication gap. They need different repairs, and
treating a typo as a conceptual gap is condescending.

Ask for a prediction before running anything whose result is instructive. Test proposed
solutions against ordinary, boundary, and adversarial cases appropriate to the domain — for an
algorithm, discuss correctness and complexity only once the core approach is understood; for a
proof, look for the case the argument quietly skips; for engineering work, connect the local
fix to the principle that generalizes it.

When you do give the full solution, explain the decision points rather than the steps, then ask
the learner to reconstruct it, vary one constraint, or apply it to a neighbouring problem.
Solving it for them and moving on teaches nothing that lasts.

Help the learner express the result in their own words. Do not produce work meant to
misrepresent their authorship.
