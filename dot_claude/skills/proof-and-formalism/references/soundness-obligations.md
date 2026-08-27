# Soundness obligations, case by case

Load this when working a progress or preservation proof case by case, or when one case is
stuck. It assumes the statement and the rule set are already fixed.

## The two theorems

**Progress.** If `⊢ e : τ` then `e` is a value or there exists `e'` with `e → e'`.
Closed terms only — the empty context is doing real work, and the proof breaks immediately for
open terms.

**Preservation.** If `Γ ⊢ e : τ` and `e → e'` then `Γ ⊢ e' : τ`.
Note the type is preserved exactly, not up to subtyping, unless the system has subtyping — in
which case the statement weakens to `Γ ⊢ e' : τ'` with `τ' <: τ`, and every downstream use of
preservation must tolerate that.

Together: a well-typed term never reaches a stuck state. "Stuck" is defined by the rules, so
enumerate what stuck means in *this* system before claiming the pair suffices — a runtime error
modelled as a value, or an exception modelled outside the reduction relation, silently
invalidates the corollary.

## Prerequisite lemmas

Prove these first, in this order. Preservation depends on substitution; substitution depends on
weakening.

- **Inversion** — for each type former, what the derivation of `Γ ⊢ e : τ` must have been.
  Mechanical, tedious, and used in nearly every case.
- **Canonical forms** — a value of type `τ₁ → τ₂` is a lambda; of `bool` is `true`/`false`; of
  `∀α. τ` is a type abstraction. This is what makes progress's application case work.
- **Weakening** — `Γ ⊢ e : τ` implies `Γ, x:σ ⊢ e : τ` when `x` is fresh for `Γ`.
- **Exchange** and **contraction**, if the context is an ordered structure rather than a set.
- **Substitution** — if `Γ, x:σ ⊢ e : τ` and `Γ ⊢ v : σ` then `Γ ⊢ e[v/x] : τ`.
  Proved by induction on the derivation of `e`, not on `e` itself.
- **Type substitution**, for polymorphic systems: `Γ ⊢ e : τ` implies `Γ[σ/α] ⊢ e[σ/α] : τ[σ/α]`.

## Progress, per case

- **Variable** — vacuous in the empty context. If it is not vacuous, the statement was wrong.
- **Value forms** (lambda, literals, type abstraction) — immediate.
- **Application `e₁ e₂`** — by IH, `e₁` steps or is a value; if a value, canonical forms gives a
  lambda; then `e₂` steps or is a value, and beta applies. The order of these subcases *is* the
  evaluation order, and getting it wrong here proves progress for a different language.
- **Conditional** — IH on the scrutinee, then canonical forms for `bool`.
- **Let / binding forms** — IH on the bound expression, then the let-reduction.
- **Constructors and pattern matching** — canonical forms per datatype, plus exhaustiveness of
  the match; a non-exhaustive match is a genuine stuck term and progress is *false* unless the
  type system rejects it.
- **References** — requires the statement to be extended with a store and a store typing;
  progress alone is false without `Σ ⊨ μ`.

## Preservation, per case

Induct on the typing derivation, then case on the reduction rule that applied.

- **Congruence / evaluation-context rules** — direct IH. Mechanical.
- **Beta `(λx:σ. e) v → e[v/x]`** — inversion on the application and on the lambda, then the
  substitution lemma. This is the case the substitution lemma exists for.
- **Let** — same shape as beta.
- **Conditional** — inversion gives both branches at `τ`; either reduct is fine.
- **Type application `(Λα. e) [σ] → e[σ/α]`** — the type substitution lemma.
- **Fixpoint / recursion** — unrolling must be type-preserving; check the recursive type's
  equi- or iso-recursive treatment, since `fold`/`unfold` change the obligation.
- **Store operations** — preservation must be restated to thread the store typing and to allow
  the store typing to *grow* (`Σ' ⊇ Σ`) on allocation. Forgetting monotonicity here is the
  standard error.

## Where it usually breaks

- **A missing case.** Check exhaustiveness against the rule set as written, not as remembered.
- **Substitution capturing a variable.** Handle alpha-equivalence explicitly or state the
  Barendregt convention; do not leave it implicit.
- **IH applied at a non-smaller subject.** Common after strengthening the statement.
- **Generalization plus mutable state.** The value restriction is the fix; a proof of soundness
  for HM plus `ref` without it is proving a false theorem.
- **Subtyping plus mutability.** Invariant reference types are required; a covariant `ref` makes
  preservation false.
- **Effects, exceptions, or non-termination** left outside the reduction relation, so "stuck"
  no longer means what the corollary assumes.

## Before claiming completeness

Every case discharged or explicitly listed as outstanding; every lemma proved rather than
assumed; the statement checked once more against a counterexample attempt for the cases that
needed the IH strengthened. "The remaining cases are similar" is acceptable in a write-up only
for cases that are genuinely mechanical congruences — and it is not acceptable while checking
someone else's proof.
