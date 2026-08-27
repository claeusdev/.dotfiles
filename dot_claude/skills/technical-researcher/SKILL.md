---
name: technical-researcher
description: Answer a technical question from primary sources with explicit evidence, source ranking, and calibrated confidence — technology comparisons, standards and documentation research, unfamiliar mechanisms, and claims that need verification. Use for literature reviews and "which of these is actually true / which should I use" questions; do not use for a simple factual lookup, for teaching a concept (that is learn-concept), or for reading one specific paper closely (that is paper-reading).
---

# Technical Researcher

Produce decision-relevant understanding, not a collection of links. The output is judged on
whether someone could act on it and on whether the uncertainty is stated honestly.

## Frame the inquiry

Turn the request into a precise question, the decision it feeds, the scope, and a stopping
criterion decided in advance. Without a stopping criterion research expands until the context
runs out.

Identify the terms whose meaning shifts with version, platform, workload, or date — those are
where confident wrong answers come from. Ask only for context that would materially change the
research; otherwise state the assumption and proceed.

## Gather evidence

Search broadly enough to see the source landscape, then rely on the strongest evidence that
actually applies, in this order:

1. Standards, specifications, official documentation, and source code, for defined behavior.
2. Peer-reviewed papers and original technical reports, for research claims.
3. Maintainer material, issue trackers, changelogs, and release notes, for real implementation
   behavior — often the only place where documented and actual behavior are reconciled.
4. Reproducible benchmarks with published method, for empirical comparison.
5. Secondary explanations, for orientation and for finding the competing interpretations.

Prefer current sources where behavior is version-sensitive and original sources over summaries.
Read the source before citing it. Popularity, search rank, and confident wording are not
evidence, and a confident blog post that cites nothing is worth less than an open issue.

For questions about Claude, Anthropic models, or the Claude API, use the `claude-api` skill
rather than researching from memory or the open web.

## Reason from the sources

For every material claim, separate what a source directly establishes, what follows by
inference, what remains disputed, and the conditions under which it holds. Collapsing those
four into one confident sentence is the characteristic failure of this work.

Reconcile disagreement by comparing definitions, versions, workloads, methodology, and
incentives — not by averaging incompatible numbers. Examine baselines, hardware, datasets,
measurement method, missing controls, and practical effect size before accepting a benchmark.

When a local artifact or a small experiment could settle a claim more cheaply than more
reading, propose or run it within the user's authorization, and keep what you observed strictly
separate from what you read. `experiment-design` covers designing that check properly.

## Deliver

Lead with the answer and what it implies for the decision. Then: scope and assumptions;
findings tied tightly to citations; an evidence table when several sources or alternatives must
be compared on the same criteria; conflicts and limitations; confidence; and the smallest next
experiment or unresolved question.

Quote only where exact wording carries the weight. Never fabricate a citation, a bibliographic
detail, a consensus, or a confidence level. If the evidence is inadequate, say so and say what
evidence would change the conclusion.

For a long comparison with an audience beyond this session, offer to publish it as an Artifact.
