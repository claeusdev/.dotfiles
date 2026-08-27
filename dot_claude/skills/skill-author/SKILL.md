---
name: skill-author
description: Write, review, or repair a Claude Code skill in this dotfiles setup — frontmatter, trigger descriptions, body structure, references/ overflow, and the chezmoi sync loop. Use when creating a new skill, diagnosing one that fires too often or never fires, or porting a skill from Codex; do not use for MCP servers, hooks, settings.json, or slash commands that are not skills.
---

# Skill Author

A skill is a stance plus a procedure that a session should adopt instead of its default
approach. If the model would do the same thing without the skill, the skill is noise —
delete it rather than padding it.

Two costs are always in tension. Every skill's `description` sits in context for every
session forever; only the body is paid for on invocation. So descriptions are budgeted in
words and bodies in screens.

## Where skills live here

`~/.claude/skills` is chezmoi-managed and generated. The source of truth is
`~/.local/share/chezmoi/dot_claude/skills/<name>/SKILL.md`. Never edit the copy under
`$HOME` — it will be silently reverted on the next apply.

```
<name>/
  SKILL.md            required; name must equal the directory name
  references/*.md     optional; loaded only when the body points at them
```

Loop, following the `dotfiles-sync` skill: check `chezmoi status` first and report drift you
did not cause, write in the source tree, `chezmoi apply ~/.claude/skills` (targeted path —
never a bare `chezmoi apply`), confirm `chezmoi status` is clean for those paths. Commit only
when asked. A new skill is not visible until the next session starts.

## Frontmatter

Exactly two keys, `name` and `description`. Add `disable-model-invocation: true` only for a
skill that should fire on `/name` and never on its own. Do not set `allowed-tools` — it
silently starves skills that need to run a build or a test suite, and the failure looks like
a model mistake rather than a config one.

`name` is kebab-case and must equal the directory name. Mismatch means the skill loads under
a name nobody types.

## Writing the description

The description does all the triggering. It is read cold, alongside forty others, with no
body. Follow the shape:

> *What it does.* Use when A, B, or C; do not use for D.

The negative clause is not decoration. Without it, five skills fire on one prompt and their
instructions fight. Write it against the *neighbours* — the skills most likely to be confused
with this one — and name them where it helps: "do not use for teaching a concept from scratch;
that is `learn-concept`." Check the whole set as one block before finishing: read every
description in sequence the way a session sees them and find the collisions.

Use the words the user will actually type. A skill about proofs should contain "prove",
"induction", "soundness" — not "formal reasoning support."

## Writing the body

Open with the stance in one or two sentences: the judgment this skill applies and the failure
it exists to prevent. No `## Overview` restating the frontmatter, no bullet list of what the
skill will do before it does it.

Prose by default. Lists earn their place only for genuinely enumerable things — a severity
ordering, a hint ladder, a per-case checklist. A page of bullets reads as a page of
suggestions; prose reads as instruction.

Name the failure mode, not just the practice. "Do not confuse familiarity with mastery" lands;
"assess thoroughly" does not. Most of a good skill's value is in what it forbids.

Budget 40–70 lines. Past about 80, move the depth into a file under `references/` and point at it
with an explicit condition — `proof-and-formalism` points at its soundness reference only when
a proof is actually being checked case by case. Unconditional pointers get followed every time
and save nothing.

State the handoff. Where a skill overlaps a built-in — `/code-review`, `/security-review`,
plan mode, the `Explore` agent, `design`, `dataviz` — say so in one line and route the
mechanical half there, keeping the judgment half here.

Never invent a tool name, flag, or path. Verify every referenced file exists before shipping.

## Porting from Codex

The originals in `~/.codex/skills` port cleanly: drop `agents/openai.yaml`, rewrite `$skill-name`
handoffs and "Codex", and re-derive the description so its negative clause names the Claude
neighbours. Read `references/porting-from-codex.md` when actually doing one.

## Diagnosing a broken skill

Almost every symptom — never fires, fires constantly, fires but gets ignored, fires and loses
to another skill — is a description problem, not a body problem. Read
`references/diagnosing.md` when repairing one.
