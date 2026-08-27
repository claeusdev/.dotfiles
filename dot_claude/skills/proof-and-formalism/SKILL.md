---
name: proof-and-formalism
description: Write, check, or repair a proof about a formal system — induction on derivations, invariants, progress and preservation, substitution lemmas, and the counterexample hunt that comes first. Use when proving type soundness or termination, checking a proof for a missing case, strengthening an induction hypothesis, formalising a judgment, or asking whether a property actually holds; do not use for informal correctness arguments about production code (that is engineering-review), for teaching the underlying theory (that is learn-concept), or when the user wants hints toward a proof they are writing themselves (that is guided-problem-solving).
---

# Proof and Formalism

Try to break the theorem before proving it. Most failed proofs fail because the statement was
false, and the fastest route to a correct statement is a serious attempt at a counterexample.
Only once the attempt fails in an informative way is the proof worth writing.

## Hunt the counterexample first

Take the statement and attack the cases where the machinery is thinnest: empty and singleton
contexts, shadowed and captured variables, non-terminating terms, values that are not closed,
recursive and polymorphic types, effects, mutable references, exceptions, and anywhere a rule
has a side condition. Reach for the standard breakers — the value restriction exists because
`ref` plus naive generalization is unsound; subtyping plus mutable state breaks naive variance;
recursive types break naive termination.

If a counterexample appears, that is the result. Report it, and say whether the fix is a
restricted statement, a stronger premise, or a changed rule.

If the attack fails, note *why* each attempted break was blocked — those blocking reasons are
usually the load-bearing lemmas of the proof you are about to write.

## State it precisely

Write the judgments, the syntax, the metavariable conventions, and the exact statement of the
theorem before any argument. Quantifier order and where the context is universally quantified
decide whether the proof works at all; an ambiguity here surfaces three cases in as a stuck
case that looks like a hard sublemma.

Be explicit about what is being inducted on and what is arbitrary at each point.

## Choose the induction

Pick deliberately and say which you chose:

- **Structural induction on the term** — when the property follows the shape of syntax.
- **Induction on the typing derivation** — the default for type soundness; it gives the
  inversion facts about premises that structural induction on terms does not.
- **Induction on the evaluation derivation** — for properties of reduction sequences.
- **Well-founded / measure induction** — for termination and normalization, where the
  measure is the real content of the proof.
- **Logical relations** — when the induction hypothesis is too weak no matter how it is
  stated; strong normalization for STLC is the canonical case where nothing simpler works.

Strengthen the induction hypothesis when the natural statement does not survive its own
inductive step. A stuck case usually means the IH is too weak, not that the theorem is false —
but check the counterexample direction once more before strengthening, because the two look
identical from inside a stuck case.

## Soundness obligations

Progress and preservation each decompose into obligations per rule, and the cases that matter
are the ones people skim: application, substitution, and anything with a binding form. Read
`references/soundness-obligations.md` when working a soundness proof case by case, or when a
specific case is stuck.

Substitution lemmas are where the real difficulty lives. Weakening, exchange, and the
substitution lemma itself must be stated and proved before preservation, and capture-avoidance
must be handled explicitly rather than waved at.

## Check a proof

Go case by case against the rules and confirm the case analysis is exhaustive — a missing case
is by far the most common defect, and a proof that says "the other cases are similar" is
claiming exhaustiveness without demonstrating it. Then check that each appeal to the IH is at a
strictly smaller subject, that inversion is justified by the rule set as written, and that no
step quietly assumes something the statement did not give.

Name each gap as one of: missing case, unjustified inversion, IH applied at a non-smaller
subject, unstated lemma, or false statement. The last one changes what happens next entirely.

## Connect to code

Where a mechanised or executable version exists, use it. Under
`~/workspace/research/type-systems`, the `miniml` library (`syntax`, `types`, `unify`, `check`,
`eval`, `infer`) and the notes in `notes/` are the ground truth for the rules being reasoned
about; a property test over generated terms (see `ocaml-pl-engineering`) will find a
counterexample far faster than a proof attempt will, when one exists.

Never claim a proof is complete when a case is unfinished. Say which cases hold, which are
outstanding, and which are the hard ones.
