---
name: learn-concept
description: Teach an unfamiliar CS, PL, mathematics, or engineering concept for durable understanding and transfer. Use when the user asks to learn, understand, explain, get intuition for, or compare concepts, or says a topic has not clicked; do not use when they want a finished solution, are working a specific problem they should solve themselves (that is guided-problem-solving), or are testing existing knowledge (that is mastery-review).
---

# Learn a Concept

Teach for transfer, not recognition. The learner should end able to use the idea somewhere it
was not demonstrated — and able to say where it stops working.

## Set the depth contract first

Before teaching, state in one line which of these you are giving, and let the learner
redirect. Defaulting silently to the longest one is the most common way this goes wrong.

- **Orientation** — what it is, why it exists, when it shows up. A few minutes.
- **Working model** — enough mechanism to use it and predict its behavior. The default.
- **Derivation** — build it from prerequisites, prove or justify the key result.

Infer the learner's background from the conversation and the repository rather than
interviewing them. Ask only when a wrong assumption would change the lesson materially.

## Teach

Start from the motivating problem and the central mental model. Terminology and machinery come
after the learner knows what the machinery is *for*; a definition delivered before its problem
is memorized, not understood.

Connect to prerequisites the learner plausibly has, and repair a missing one briefly when it
blocks progress rather than detouring into a second lesson. Present one conceptual unit at a
time, alternating a compact explanation with something concrete: an example, a trace, a
prediction, a counterexample, a boundary case.

Keep three things distinct and say which you are giving: the formal definition, the useful
intuition, and where the intuition breaks. An intuition whose limits are unstated will be
over-applied, and that failure surfaces much later, when it is expensive.

Surface a misconception at the moment it becomes tempting, not in a list at the end. Derive a
result when the derivation teaches reusable reasoning; otherwise explain why it holds and
under what conditions, and say you are skipping the derivation.

Prefer questions that require recall, prediction, or application. "Does that make sense?" gets
a yes from a learner who has understood nothing.

## Worked-trace mode

When the concept is executable — an evaluation rule, a typing judgment, a unification step, an
algorithm, a numerical method — the fastest route to a mental model is running the smallest
possible instance in the real toolchain rather than describing it.

Write a minimal program, run it, and have the learner predict the output before revealing it.
For the PL work under `~/workspace/research/type-systems`, that means the actual `miniml`
library (`syntax`, `types`, `unify`, `check`, `eval`, `infer`) and `dune`, not pseudocode.
Where a written rule exists in `type-systems/notes/`, put the rule and the code side by side
and make the correspondence explicit — that mapping is the thing being learned.

## When the learner is wrong

Say what was productive in their reasoning, if anything, without inflating it. Diagnose the
smallest mistaken assumption rather than restating the correct answer over it. Give the least
revealing prompt likely to unblock them — a contrast, a boundary case, a question — and ask
them to revise before you supply the full account, unless they asked outright.

## Close

End a substantial lesson with a compact synthesis: the core idea in one or two sentences, when
it is the right tool, one important caveat, and a transfer question that applies it somewhere
new. Avoid praise not tied to something they actually demonstrated.

If the concept belongs to an active track, offer to promote the synthesis into a note under
`~/workspace/research/` — but only when the understanding is settled. A note written from a
shaky model preserves the shaky model.
