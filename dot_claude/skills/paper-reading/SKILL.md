---
name: paper-reading
description: Read a specific paper closely — three passes, then reconstruct the proof, algorithm, or experiment — and produce a paper note with claim discipline. Use when the user shares a paper, asks what a paper actually shows, wants to reproduce or stress-test its result, or is writing a paper note; do not use for surveying the literature to answer a question (that is technical-researcher) or for teaching the underlying concept (that is learn-concept).
---

# Paper Reading

A paper is a claim plus the evidence its authors chose to show. Read to reconstruct both, and
to locate the gap between what was demonstrated and what the abstract says was demonstrated.

Never fabricate a citation, venue, year, author, or result. If a field is unknown, leave it
empty and say so — a paper note with invented metadata is worse than no note.

## Three passes

**Pass 1 — map.** Title, abstract, intro, section headings, conclusion, figures. Come out with
the problem, why it matters, the main claim, the core idea, and the headline result. Decide
here whether the paper deserves passes 2 and 3; most do not, and saying so is a valid outcome.

**Pass 2 — interrogate.** Read the body, skip the proofs and derivations. Extract the
assumptions (including the unstated ones), the formal machinery or method, the baselines, the
evidence offered for each claim, and the threats to validity or the boundaries of the proof.
Mark the related work worth following.

The interrogation questions that pay: which assumption is doing the real work; is the baseline
the honest competitor or a weak one; does the evaluation measure the thing the claim is about;
what would the negative result have looked like, and would it have been publishable.

**Pass 3 — reconstruct.** This is where understanding actually happens, and it is the pass
people skip. Rebuild something: re-derive the key lemma, implement the algorithm on a toy
input, or reproduce the smallest experiment. Record the inputs, the steps, the result, and —
most valuable of all — where your reconstruction diverged from the paper. Divergence is either
your misunderstanding or an underspecified paper, and both are worth knowing.

For a PL or type-systems paper, reconstruction usually means writing the rules out and checking
one interesting case by hand, or coding the judgment against the existing `miniml` library
under `~/workspace/research/type-systems`. `proof-and-formalism` covers checking a proof case
by case. For an empirical paper, `experiment-design` covers judging its method.

## Assess

Separate the genuinely new contribution from the packaging, and name the strongest evidence and
the weakest point. State what would invalidate or narrow the conclusion — if nothing would, the
claim is not falsifiable and that is the finding. Then the two forward-looking items: the
smallest reproduction worth doing, and one controlled extension.

## Claim discipline

Label every takeaway as one of: **observation**, **correlation**, **causal claim**, **proof**,
or **hypothesis**. Apply the label to the paper's claims and to your own conclusions about the
paper. Most misreading is a correlation promoted to a causal claim somewhere between the
results section and the reader's memory.

## The note

Write to the existing template at
`~/workspace/research/research-foundations/shared/templates/paper-note.md`, keeping its
sections and headings so notes stay comparable. The long-form method lives in
`shared/07-three-pass-reading-and-reconstruction.md`; read it only if the user asks about the
method itself rather than about a paper.

Do not fill a section with restated abstract text to make it look complete. An empty
"Reconstruct" section honestly records that pass 3 has not happened yet.
