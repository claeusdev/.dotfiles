---
name: experiment-design
description: Design, run, and record a reproducible experiment or benchmark that can distinguish rival explanations — hypothesis, baselines, confounders, measurement method, and an honest interpretation. Use when testing a claim empirically, comparing alternatives, benchmarking, investigating a performance question, or writing up a result; do not use for routine test-suite design (that is test-strategy) or for forming the question in the first place (that is research-question).
---

# Experiment Design

Turn uncertainty into evidence that can distinguish the plausible explanations from each other.
An experiment that only one outcome could have produced is a demonstration; an experiment whose
result you can already predict is a waste of a machine.

## Define the claim before touching the harness

State the decision at stake, the primary hypothesis, the credible alternatives, the independent
and dependent variables, and the scope of the intended claim. Make it falsifiable. If the
request arrives with a favored conclusion attached, demote it to a hypothesis — do not design
around it.

Then write down, in advance, what result would support each explanation, what would weaken it,
and what would fail to distinguish them. Doing this after seeing data is how a null result gets
retold as a positive one.

Choose the smallest experiment that could actually change the decision.

## Design

Specify the system, workload, dataset, versions, hardware, and environment; the baseline and
comparison conditions; the controlled variables and the likely confounders; warmup,
repetitions, seeds, randomization, and ordering where they matter; correctness checks alongside
any performance measure; the primary metric with a practical effect threshold and an
uncertainty estimate; and where raw data and the analysis script will live.

Use a realistic workload for the claim you intend to make, and keep a controlled microbenchmark
only where it isolates the mechanism. Do not infer production impact from a microbenchmark, and
do not let the harness be optimized differently across the alternatives — that asymmetry is the
single most common source of a fake speedup.

For performance work, select from the threats that plausibly affect *this* claim rather than
listing all of them: caching and warm state, JIT or compilation, CPU frequency scaling,
allocation and GC, I/O, contention, background load, coordinated omission, tail latency, and
measurement overhead comparable to the effect size.

## Record before running

Fill the reproduction metadata and the written prediction in
`~/workspace/research/research-foundations/shared/templates/experiment-record.md` *before*
execution: commit, environment, versions, seeds, exact commands, the expected outcome, the
proposed mechanism, and the stopping rule. A prediction written afterwards is not a prediction,
and a command reconstructed from memory a week later is not a reproduction.

## Execute and interpret

Confirm the actions and their resource cost are within scope before running anything expensive.
Validate the harness with a sanity check that should obviously pass and one that should
obviously fail — a harness that reports success on a broken build has been the real finding
more than once.

Inspect the raw distribution, not only the mean. Keep exploratory observations distinct from
the predeclared outcome. Retain failed and aborted runs and explain them rather than dropping
them silently.

Report the exact setup and procedure, results with units and variability, anomalies and any
excluded data with reasons, whether the alternatives were actually distinguished, practical
rather than merely statistical significance, the limitations, and the next most informative
experiment.

Label conclusions honestly as observation, correlation, causal claim, or hypothesis. A null or
ambiguous result reported clearly is a real contribution; `shared/06-baselines-ablations-and-negative-results.md`
covers writing one up. Do not retrofit the hypothesis, cherry-pick runs, generalize past the
tested conditions, or claim causality from an observational comparison.
