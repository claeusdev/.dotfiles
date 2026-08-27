# Porting a skill from Codex

The originals live in `~/.codex/skills`. They are not chezmoi-managed, so they exist on this
machine only; the Claude copies in the dotfiles tree are the durable ones.

A port is a rewrite. A copy that still says `$technical-researcher` is a bug.

## Mechanical changes

- Drop `agents/openai.yaml` — Codex interface metadata (`display_name`, `short_description`,
  `default_prompt`) with no Claude analogue. Nothing is lost: `description` already does the
  triggering and the skill name already does the addressing.
- `$skill-name` was the Codex handoff syntax. Rewrite as a plain skill name in prose, or
  `/skill-name` where the user is meant to type it.
- "Codex" → "Claude", including in descriptions.
- Copy `references/*.md` across unchanged if they are tool-neutral; check them for `$` handoffs
  first.

## Editorial changes

Re-derive the `description` rather than keeping the Codex one. The Codex set is strong on the
"use when / do not use for" shape — keep that — but the negative clause must now name the
*Claude* neighbours, including the built-ins, which the original could not know about.

Add the Claude affordances that genuinely earn their place, and only those:

- plan mode, for a skill that designs before editing;
- the `Explore` agent, for fan-out search across many files;
- `/code-review`, `/simplify`, `/security-review`, for the mechanical half of a review skill;
- Artifacts, for a deliverable with an audience beyond the session — a report, a roadmap, a
  threat model;
- the project memory directory, for facts worth surviving the session.

Do not sprinkle these in for the sake of looking native. A skill that gains nothing from any of
them is a fine skill.

## Check afterwards

Grep the ported file for `\$[a-z-]+` and `Codex`. Confirm the new description does not collide
with an existing skill's trigger. Confirm every path the skill now cites actually exists.
