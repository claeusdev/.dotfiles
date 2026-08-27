---
name: ocaml-pl-engineering
description: Build and structure OCaml (or SML/Racket) code for language work — interpreters, type checkers, unification, parsers — including dune layout, .mli boundaries, Alcotest and QCheck testing, and keeping the implementation checkable against written rules. Use for implementation work in the type-systems tracks; do not use for proving properties about the formal system (that is proof-and-formalism) or for teaching a PL concept (that is learn-concept).
---

# OCaml PL Engineering

The point of implementing a formal system is that the implementation can disagree with the
rules, and finding that disagreement is the work. Structure everything so a disagreement is
cheap to find and impossible to hide.

Read the repository's own conventions before applying anything here. Under
`~/workspace/research/type-systems`, `dune-project` declares `(lang dune 3.18)`, the library is
`miniml` in `src/` with modules `syntax`, `types`, `unify`, `check`, `eval`, `infer`, and tests
live in `test/`. The rules those modules implement are written out in `notes/01`–`notes/14`.

## Structure

Keep the module boundaries at the joints of the formal system, because that is what makes the
correspondence checkable: syntax, types, the constraint or unification layer, the typing
judgment, and evaluation, each independently testable. A single `main.ml` containing all of it
can still be correct, but nothing about it can be checked in isolation.

Write `.mli` files for the modules with real invariants. The interface is where you say which
representations are abstract — a `Type.t` that cannot be constructed except through a smart
constructor is enforcing well-formedness the way the type system is supposed to. An `.mli` that
just re-lists everything in the `.ml` is overhead; skip it there.

Model the object language with variants and let the compiler enforce exhaustiveness. Do not add
a catch-all `| _ ->` case in a match over terms or types: the missing-case warning is the single
most valuable signal you get when the language grows, and a wildcard discards it permanently.
Compile with warnings as errors in the dev profile so it actually stops you.

Make illegal states unrepresentable where the effort is proportionate — separate the type of
surface syntax from the type of core syntax after elaboration, and separate open from closed
terms if the distinction matters to the invariants.

## Keep it checkable against the rules

Every inference rule should correspond to something identifiable in the code — a match case, a
function, a named clause. When the rule and the code have drifted, you want that to be obvious
by reading them side by side.

Where a note in `notes/` states a rule, cite it near the implementing case, and keep the
metavariable names from the rule rather than renaming them. Two vocabularies for the same
system doubles the cost of every future comparison.

When the implementation and the rules disagree, do not silently fix the code. Determine which
one is wrong first — often it is the rule, and that is a genuine finding.

## Test

Alcotest for the specific cases: the examples from the notes, the derivations worked by hand,
and every bug ever found. QCheck for the laws, which is where the real defects surface.

The properties worth generating for: a well-typed term does not get stuck; inference and
checking agree; unification returns a most general unifier, and applying the substitution makes
both sides equal; substitution avoids capture; a round trip through printing and parsing is the
identity; generalization respects the value restriction.

Writing the term generator is the actual work. A naive generator produces overwhelmingly
ill-typed or trivial terms and finds nothing — generate well-typed terms by construction,
growing a term from a target type and a context, when the property is about well-typed terms.
Check what the generator is emitting before trusting a passing property. Keep shrinking
working, because an unshrunk counterexample is a 300-node term nobody will read.

`test-strategy` covers the general question of what to test; this is the PL-specific part.

## Verify

Capture a green baseline before changing anything: `dune build`, `dune test`, and note any
pre-existing failures. Run `dune build @all` for the whole project rather than a single target,
and use `dune utop` for exploring the library interactively — a five-line utop session settles
questions that would take twenty lines of speculation.

Do not report a change as working on the strength of a compile. It typechecks is not it is
correct, and in this domain the gap between the two is the entire subject.
