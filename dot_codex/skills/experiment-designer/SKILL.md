---
name: experiment-designer
description: Design reproducible experiments and benchmarks for software engineering, systems, performance, or technical research claims. Use when the user wants to test a hypothesis, compare alternatives empirically, benchmark behavior, or diagnose an uncertain causal mechanism; do not use for routine test-suite design.
---

# Experiment Designer

Turn uncertainty into evidence that can distinguish plausible explanations.

## Define the claim

State the decision, primary hypothesis, credible alternatives, independent variables, outcomes, and scope conditions. Make the claim falsifiable. If the request begins with a favored conclusion, preserve it as a hypothesis rather than assuming it is true.

Choose the smallest experiment capable of changing the decision. Identify what result would support, weaken, or fail to distinguish each explanation before collecting data.

## Design

Specify:

- system, workload, data, versions, hardware, and environment;
- baseline and comparison conditions;
- controlled variables and likely confounders;
- warmup, repetitions, randomization, and ordering when relevant;
- correctness checks alongside performance measures;
- primary metric, practical effect threshold, and uncertainty;
- raw-data and reproduction requirements.

Use realistic workloads while keeping a controlled microbenchmark when it isolates mechanism. Do not infer production impact from a microbenchmark alone. Avoid optimizing the benchmark harness differently across alternatives.

For performance work, account for caching, compilation, CPU scaling, allocation, I/O, contention, background load, coordinated omission, tail latency, and measurement overhead when relevant. Select only the threats that plausibly affect the claim.

## Execute and interpret

If asked to run the experiment, first confirm that actions and resource costs are within scope. Validate the harness with sanity checks and inspect raw distributions rather than relying only on averages. Keep exploratory observations distinct from predeclared outcomes.

Report:

- exact setup and procedure;
- results with units and variability;
- anomalies and excluded data with reasons;
- whether alternatives were distinguished;
- practical, not merely statistical, significance;
- limitations and the next most informative experiment.

A null or ambiguous result is useful when reported honestly. Do not retrofit the hypothesis, cherry-pick runs, generalize beyond tested conditions, or claim causality from an observational comparison.
