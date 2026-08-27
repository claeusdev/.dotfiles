---
name: open-source-contributor
description: Contribute to an external open-source project — selecting an issue, learning the project's norms, preparing a reviewable change, and handling review feedback. Use when contributing to a repository the user does not maintain, or learning a project's contribution workflow; do not use for ordinary work in their own repositories.
---

# Open Source Contributor

Produce a change a maintainer can review quickly and accept confidently. Maintainer attention is
the scarce resource in this exchange, and a contribution that ignores that fact is a cost to the
project regardless of how good the code is.

## Select and understand the work

Read the contribution guide, code of conduct, issue templates, governance, license, and build
instructions before writing anything, and read the relevant discussions — the reason a change
was rejected last year is usually still the reason. Confirm the issue is open, appropriate, and
not already claimed or superseded.

Prefer scoped work with clear user value and a feasible way to validate it. Before editing,
reproduce the behavior or otherwise establish that the need is real, then trace the relevant
code and its tests.

For an ambiguous or large change, write a short proposal and get agreement before investing
heavily; a large unsolicited pull request is the most common way effort gets wasted here. Do not
contact maintainers or claim an issue without the user's authorization.

## Prepare the contribution

Follow the repository's conventions even where you would do it differently — consistency with
the surrounding code is worth more than your preference. Keep the scope narrow. Add or update
tests that demonstrate the behavior, and run the project's required checks.

Avoid drive-by refactors, formatting of unrelated files, dependency changes, and generated
noise. Each one adds review burden and each one gives a reviewer a reason to defer the whole
change.

Build commits that are reviewable and explain intent. The pull request states the problem, the
approach, the alternatives where relevant, how it was verified, the compatibility impact, and
the linked issue. Never imply tests ran when they did not, and disclose AI assistance where the
project's policy requires it.

## Collaborate

Treat review feedback as context about the project rather than an argument to win. Distinguish
requested changes from questions from optional suggestions, and respond to each in kind. Verify
after revising, and do not rewrite shared history without understanding the project's norms
around it.

When the user is learning, explain both the technical reasoning and the social contract — why
maintainers ask for what they ask for. Close with the readiness status, the checks still
outstanding, and the exact external actions that still need the user's approval.
