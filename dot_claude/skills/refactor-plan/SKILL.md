---
name: refactor-plan
description: Sequence a behavior-preserving restructuring into small steps, each with a verification gate and a stop point — extracting a module, changing a data representation, untangling a dependency, or making room for a feature. Use when restructuring existing code without changing what it does; do not use for designing new functionality (that is project-planner) or for finding what needs improving (that is engineering-review or /simplify).
---

# Refactor Plan

Refactoring means the observable behavior does not change. The moment behavior changes, it is
no longer a refactor and cannot be verified as one — so if a change is needed too, sequence it
as a separate step and say which steps are which.

The characteristic failure is the large restructuring that is 80% done, cannot be tested, and
cannot be abandoned. Every rule here is aimed at keeping the tree green and abandonable at
every point.

## Establish the safety net first

Before restructuring anything, find out what actually protects the current behavior. Run the
existing tests and record the baseline — which pass, which fail already, how long it takes.
Pre-existing failures must be distinguished from ones you introduce, and discovering them
mid-refactor is how a refactor turns into a debugging session.

Where the covered surface is thin, add characterization tests first: tests that assert what the
code *currently* does, correct or not. They are the only thing that makes the restructuring
verifiable, and they are throwaway if the behavior is later intended to change.

Where no test can reach the code, say so plainly and treat the refactor as higher risk rather
than proceeding as if it were safe.

## Sequence the steps

Each step is independently committable, leaves the tree green, and is small enough to review as
a unit. Prefer many boring steps to one clever one — the clever one cannot be bisected.

Order the sequence so risk is retired early and each step makes the next one mechanical:

1. Add the new thing alongside the old. Nothing calls it yet.
2. Move callers over incrementally, keeping both paths working.
3. Verify at each move.
4. Delete the old path once nothing references it.
5. Simplify what the old path's absence now permits.

For a data representation change, add the new representation, write both, read from the old,
verify agreement between them, switch reads, then drop the old — with the agreement check as a
temporary assertion rather than a hope. For an interface extraction, extract without changing
callers first. For a dependency untangle, introduce the boundary before moving anything across
it.

State the verification gate for each step in the terms the project actually uses — its test
command, typecheck, build, lint — and state the stop condition: what makes you abandon the
sequence and revert rather than push through.

Keep mechanical steps and semantic steps in separate commits. A rename mixed with a logic
change is unreviewable, and the reviewer will approve it anyway, which is worse.

## Bound it

Say what is explicitly out of scope, and hold that line — refactors expand because every
adjacent flaw becomes visible once you are in the file. Note them as follow-ups instead.

Name the point of no return, if there is one, and what is irreversible after it.

Do not claim behavior is preserved without having run something that would have noticed. If
verification for a step was not possible, say which step and why.
