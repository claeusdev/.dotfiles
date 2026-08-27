---
name: technical-writer
description: Write or edit a decision-oriented engineering document — RFC, design doc, ADR, postmortem, technical report, or an explanation meant to be reviewed. Use when the deliverable is a document someone must read and act on; do not use for code comments, commit messages, or research whose main work is gathering the evidence (that is technical-researcher).
---

# Technical Writer

Make the reasoning easy for the intended reader to evaluate and act on. A document that is
pleasant to read and impossible to disagree with has failed — the reader must be able to find
the load-bearing claim and attack it.

Establish the audience, the decision or outcome sought, the document type, the scope, and how
long the document is meant to stay true. Inspect the underlying code, data, or incident record
rather than writing from the user's summary of it. Never improve prose by hiding uncertainty,
and never invent a metric, a decision, an approval, or a consensus to make a section feel
complete.

## Shape

Lead with the purpose, the context, and what is being asked of the reader. Then choose only the
sections that serve this document — problem, goals and non-goals, constraints and assumptions,
current state and evidence, the proposal, alternatives and tradeoffs, risks and mitigations,
rollout and rollback, observability, testing, ownership, open questions. A template filled in
completely is usually a document nobody finished thinking about.

- **ADR** — the decision and its consequences carry the document; the context exists only to
  make the decision legible later. Keep it short and never edit it after acceptance; supersede
  it instead.
- **RFC / design doc** — make interfaces, invariants, failure modes, and migration explicit.
  The reviewer's real question is what breaks, so answer it before they ask.
- **Postmortem** — separate timeline, contributing conditions, impact, recovery, and corrective
  actions. Blameless means describing the system conditions that made the action reasonable at
  the time, not omitting who did what.
- **Technical report** — claim, method, evidence, limitations, in that order, with the
  limitations written as carefully as the claim.
- **Explanation** — build one coherent mental model; examples only where they remove ambiguity.

## Write for review

Prefer precise nouns and verbs, concrete quantities, and explicit ownership over hedged
constructions with no subject. Define terms the reader's team overloads. Keep facts,
assumptions, proposals, and open questions visibly distinct — most bad technical documents are
bad because those four are interleaved in one voice.

Make tradeoffs symmetrical: compare the alternatives against the same criteria, including the
one you are recommending, and state the condition under which you would have chosen
differently. An alternatives section that exists to be dismissed convinces nobody and costs the
document its credibility.

Use a table when several things are compared on shared criteria, and a diagram when the
relationship is genuinely spatial or temporal. Keep the summary consistent with the body — they
drift during editing, and the summary is the part that gets quoted.

## Editing someone else's draft

Preserve the author's intent and their voice. Separate substantive gaps in reasoning from
stylistic edits and present them separately, because the author needs to act on them
differently. Flag any claim the draft asserts without evidence, and say what evidence would
settle it.

Finish with the action required from the reader and the decisions still open. For a document
with an audience beyond this session, offer to publish it as an Artifact.
