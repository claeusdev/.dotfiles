---
name: project-planner
description: Turn an ambitious multi-week goal into dependency-aware milestones, risks, and validation gates — a project roadmap, a learning track, or a portfolio plan. Use when the horizon is weeks or months and the scope is uncertain; do not use for planning the implementation of a single change (use plan mode) or for a task list that needs no sequencing.
---

# Project Planner

Plan to reduce uncertainty early and to produce verifiable progress. A plan whose first
evidence arrives in week six is not a plan, it is a bet.

For designing the implementation of one code change, use plan mode instead — that is what it is
for. This skill is for work with milestones, dependencies, and enough unknowns that the plan
will need revising.

## Frame it

Clarify the desired outcome, the users, the constraints, the deadline if there is one, the time
actually available, the assets that already exist, and the definition of done. Separate
requirements from preferences, and write the non-goals down explicitly — an unstated non-goal
is a scope creep waiting for a justification.

Where the scope is genuinely uncertain, plan a discovery milestone rather than inventing
detailed tasks for work nobody understands yet. False precision in week one is why plans get
abandoned in week three.

## Structure the work

Break the project into thin, end-to-end milestones that each deliver evidence or usable
capability. Order by dependency, risk retirement, and feedback value — not by architectural
layer. Building all of the data layer before anything is testable end to end guarantees the
first integration surprise arrives at the worst moment.

Each milestone names its observable outcome and acceptance criteria, its key tasks and
dependencies, its highest uncertainty, how it will be validated, the artifact it leaves behind,
and its exit condition.

Give estimates as ranges when the uncertainty is material, and identify the critical path, the
genuinely parallel work, the integration points, and the decisions that are expensive to
reverse. Include testing, documentation, deployment, and operational concerns only to the
extent this project actually has them.

## Keep it adaptive

Put in explicit checkpoints for re-examining the assumptions and the scope. Offer a smallest
viable path plus optional extensions, so that running out of time degrades the plan instead of
failing it. Do not load the plan with speculative future work or turn every detail into a task
— a plan nobody can hold in their head does not get followed.

For a learning project, tie milestones to demonstrated capabilities rather than hours spent or
material covered; the sprint and checkpoint structure under
`~/workspace/research/research-foundations/progress/` is the existing shape for that. For a
portfolio project, make sure the result can show engineering decisions, verification, and
operational thinking, not just a feature count.

Close with the first concrete action, the near-term milestone, the principal risks, and the
conditions under which the plan should be revised. Do not create tickets or modify external
project systems unless asked. For a roadmap someone else will read, offer to publish it as an
Artifact.
