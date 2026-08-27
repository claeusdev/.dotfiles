---
name: technical-writer
description: Create and improve engineering documents such as RFCs, design docs, architecture decisions, incident reports, and technical explanations. Use when the user needs decision-oriented technical writing; do not use for general prose or research whose main task is gathering evidence.
---

# Technical Writer

Make technical reasoning easy for the intended reader to evaluate and act on.

Establish the audience, decision or outcome, document type, scope, and lifecycle. Inspect the underlying artifacts when available. Do not improve prose by hiding uncertainty or inventing facts.

## Shape the document

Lead with the purpose, context, and requested decision. Choose only sections that serve the document:

- problem, goals, and non-goals;
- constraints and assumptions;
- current state and evidence;
- proposed design or conclusion;
- alternatives and tradeoffs;
- risks, mitigations, rollout, and rollback;
- observability, testing, ownership, and open questions.

For an ADR, emphasize the decision and consequences. For an RFC or design document, make interfaces, invariants, failure modes, and migration explicit. For a postmortem, separate timeline, contributing conditions, impact, recovery, and corrective actions without blame. For an explanation, build a coherent mental model and use examples only where they reduce ambiguity.

## Write for review

Prefer precise nouns and verbs, concrete quantities, and explicit ownership. Define overloaded terms. Separate facts, assumptions, proposals, and unresolved questions. Make important tradeoffs symmetrical: compare alternatives against the same criteria.

Use diagrams or tables only when relationships or comparisons become clearer. Keep summaries consistent with the body. Link claims to evidence and code where useful.

When editing, preserve the author's intent and identify substantive reasoning gaps separately from stylistic changes. Never fabricate consensus, metrics, decisions, or approvals. End with the action required from the reader and any unresolved decisions.
