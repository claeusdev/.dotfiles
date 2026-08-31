---
name: pr-review-handoff
description: Prepare a completed code change for engineer review, incorporate approved feedback, and open an accurate pull request after authorization. Use at the review-to-PR boundary; do not use for initial implementation or automatic merging.
---

# PR Review Handoff

Make the change cheap for a human engineer to evaluate, then publish exactly what they approved. Human review and external publication are separate gates.

## Establish the candidate

Read repository contribution instructions. Inspect branch, status, diff, commits, remotes, target branch, and available PR tooling. Identify unrelated working-tree changes and exclude them from commits and the PR. Never discard or silently include another person's work.

Confirm the candidate is self-reviewed and that relevant validations have run. If evidence is missing, run safe local checks in scope or label the gap; never fabricate results.

## Prepare the engineer review packet

Present a compact packet containing:

- ticket and user outcome;
- scope and explicit non-goals;
- behavior before and after;
- architecture and data-flow choices worth reviewing;
- diff and commit summary, with the highest-risk files or paths first;
- acceptance criteria mapped to tests or other evidence;
- migrations, compatibility, security, observability, rollout, and rollback implications;
- commands run with exact outcomes;
- known limitations, open questions, and focused reviewer prompts.

Include screenshots or reproducible steps when visual or interactive behavior changed. Keep the packet factual and sized to the change.

Pause for human review. Do not claim approval from silence. Apply only feedback the user approves or requests, preserve the original ticket boundaries, rerun checks affected by revisions, and self-review the final diff again. Present material scope or design changes for renewed review.

## Publish after approval

After the human approves the candidate, resolve the exact branch, remote, base branch, commits, and PR title/body with read-only checks. Ask for authorization immediately before pushing or creating the PR, even if local preparation was already requested. Do not force-push, merge, enable auto-merge, request external reviewers, or mutate labels/projects unless explicitly requested.

Create focused commits when needed, using repository conventions and including only approved files. Push the intended branch and open the PR with a body that mirrors the reviewed packet. Re-read the created PR to verify title, base/head, body, and link. Report any CI checks that are pending or unavailable rather than waiting indefinitely unless the user asked for monitoring.

Return the PR link, pushed commit range, validations, review decisions, and any remaining rollout or follow-up work. If publication is blocked, leave the local candidate intact and state the exact command, permission, or decision needed.
