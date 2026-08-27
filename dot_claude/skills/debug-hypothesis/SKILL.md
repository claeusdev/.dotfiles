---
name: debug-hypothesis
description: Find the cause of a specific failure by differential diagnosis — reproduce it, rank hypotheses, and run the check that discriminates between them. Use when something is broken, flaky, or behaving unexpectedly and the cause is not yet known; do not use for reviewing code for latent defects (that is engineering-review) or for understanding working code (that is codebase-investigator).
---

# Debug by Hypothesis

Debugging fails in one characteristic way: fixing the first plausible cause without evidence
that it is the actual cause, then declaring victory because the symptom moved. Every step here
exists to prevent that.

The unit of progress is not a change to the code. It is an observation that eliminates a
hypothesis.

## Reproduce and bound

Get a reliable reproduction before theorising. If it cannot be reproduced, that is the first
problem to solve — collect the conditions, inputs, timing, environment, and concurrency under
which it appears, and make the smallest reliable trigger you can.

Then bound it. What is the last known-good state — commit, version, config, input? What changed
between then and now? Which layer is definitely fine, and how do you know? Bisecting over
commits, inputs, or configuration retires more hypotheses per unit of effort than reading does.

Separate the symptom from the failure from the cause. The stack trace tells you where the
program noticed, which is usually not where it went wrong.

## Rank hypotheses

Write down more than one — a single hypothesis is a commitment, not a diagnosis. Rank by prior
probability given what changed recently, and for each one state the observation that would be
true if it held and, critically, the observation that would be true only if it held.

Then run the check that **discriminates** — that splits the remaining hypotheses rather than
confirming the favorite. A check whose expected result is the same under two hypotheses has
cost you a cycle and taught you nothing.

Predict the result before running it. A prediction that turns out wrong is more informative
than the observation alone, because it locates the flaw in your model rather than in the code.

Standard candidates worth having in the ranking: state left over from a previous run, an
ordering or timing dependence, a boundary or empty case, an error swallowed somewhere up the
stack, a version or dependency mismatch, a config or environment difference between where it
works and where it does not, a shared mutable resource, and a wrong assumption about what a
library actually does.

## Confirm before fixing

Before changing anything, be able to explain the whole path from cause to symptom. If a step is
"and then somehow", the diagnosis is not finished, and the fix will be a coincidence.

Confirm the cause by making the failure appear and disappear on demand by manipulating the
suspected cause alone. Then fix the cause rather than the symptom — and where the fix is a
symptom fix made deliberately, say so explicitly rather than letting it be discovered later.

Add a regression test that fails before the fix and passes after; run it in that order to
confirm it actually catches this bug. Then ask what else shares the cause, since defects of a
kind rarely occur once.

For an intermittent failure, do not accept "it passes now" as evidence — establish the failure
rate before and after, or the fix is unverified.

Record what the cause turned out to be, especially when the initial hypothesis was wrong. That
correction is the reusable part.
