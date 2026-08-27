---
name: research-question
description: Turn a vague interest or observation into a scoped, falsifiable research question with a novelty check, a stopping rule, and a first decisive experiment. Use when the user has a topic but no question, is choosing what to work on next, is preparing to talk to a supervisor, or is deciding whether an idea is worth pursuing; do not use for executing an already-formed question (that is technical-researcher or experiment-design).
---

# Research Question

A topic is not a question, and a question you cannot be wrong about is not a research question.
The job is to get from "I find X interesting" to something with a definite answer, a bounded
cost, and a reason the answer would matter to someone other than the asker.

## Extract the question

Start from what actually prompted this: a surprising result, a claim that seemed unjustified, a
gap between a formal model and an implementation, a tool that should exist and does not. That
origin usually contains the question in a more specific form than the user first states it.

Push through the levels until it stops being a topic:

- topic — "gradual typing"
- area — "how gradual typing affects runtime performance"
- question — "does the cast-insertion strategy in X account for the reported slowdown, or is it
  the boundary-crossing frequency?"
- **testable question** — with the system, workload, measurement, and the two rival explanations
  named.

At each level ask what would have to be true for the answer to be interesting either way. A
question whose only publishable answer is "yes" is a demonstration, not a question.

## Make it falsifiable and bounded

State the claim so it can fail, and name the observation that would make you abandon it. Name
the rival explanations up front — the discriminating evidence is the whole design, and adding
rivals afterwards is how confirmation happens.

Bound it: the scope of the intended claim, the systems and inputs it covers, and what it
deliberately says nothing about. Then set a stopping rule before starting — the result,
timebox, or dead end at which you stop and write up what you have. Research without a stopping
rule expands to fill all available time and produces nothing.

## Novelty and prior work

Check whether the question is already answered, and be genuinely willing to find that it is —
finding the answer in two hours of reading is a success, not a wasted effort. Search for the
result, the negative result, and the survey. Follow citations backwards from the closest paper
and forwards from its most-cited descendants.

Distinguish the four outcomes: answered and settled; answered but only under conditions that do
not apply here; asked and open; not asked. Only the last two are yours, and the third is
usually the better bet.

State the novelty claim in one sentence you would be willing to say to a supervisor. If it
needs a paragraph of hedging, it is not yet a claim.

## Deliver

Give the question in its testable form, the rival explanations, the falsifier, the scope, the
stopping rule, the closest prior work with what it did and did not settle, and the smallest
first experiment that discriminates between the rivals — which `experiment-design` then turns
into a protocol.

Offer two or three variants at different ambition levels when the top choice is risky, so there
is a fallback that still produces evidence. For work in the research tracks, a settled question
belongs in the sprint checkpoint at
`~/workspace/research/research-foundations/progress/templates/checkpoint-review.md`.
