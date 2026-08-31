---
name: feature-implementation
description: Implement a product feature or cross-cutting engineering ticket as a repository-native, tested vertical slice. Use when coding spans meaningful behavior and no more specific implementation skill fully covers it; do not use for discovery-only, review-only, or trivial edits.
---

# Feature Implementation

Deliver the smallest coherent change that satisfies the product contract without erasing repository conventions or unrelated work.

## Ground the change

Read all applicable repository instructions. Inspect status, manifests, entry points, nearby implementation, tests, schemas, configuration, and relevant history before editing. Translate the request into observable acceptance criteria and identify the user path, invariants, trust boundaries, compatibility surface, and operational effects.

Capture the smallest relevant green baseline. Distinguish failures that already existed from failures introduced by the change. Do not add production dependencies, alter external systems, or broaden the ticket without explicit approval.

## Implement the vertical slice

- Follow the repository's architecture, naming, package manager, and test conventions unless evidence supports a scoped change.
- Keep business invariants in authoritative boundaries rather than duplicating them across adapters or UI paths.
- Validate untrusted input and enforce authorization at the boundary that owns the resource.
- Include the states necessary for usable behavior: success, invalid input, empty or missing data, permission denial, dependency failure, retry, and recovery when relevant.
- Make schema, API, event, and configuration changes compatible across the deployment window. Separate expansion, migration, enforcement, and cleanup when required.
- Add observability where operators need to distinguish success, expected rejection, dependency failure, and defects.
- Keep edits focused. Preserve user changes and avoid opportunistic refactors that do not reduce delivery risk.

Work in small coherent increments. After each risky boundary change, run the narrowest check that could falsify it. Prefer behavior-level tests for the acceptance criteria and focused tests for failure paths and invariants.

## Validate the finished change

Run the smallest relevant test, formatting, lint, type, build, migration, and security checks required by repository instructions and proportional to risk. Inspect the final diff and status for accidental files, generated artifacts, secrets, debug code, stale comments, and unrelated edits.

Hand off with: behavior delivered, key design choice, files or boundaries changed, commands run and exact outcomes, acceptance criteria evidence, migration or rollout steps, and residual uncertainty. Do not commit, push, or open a PR unless the user requested that later workflow and the required authorization is present.
