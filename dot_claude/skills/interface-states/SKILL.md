---
name: interface-states
description: Design every state a screen actually has — empty, first-run, loading, streaming, partial, error, offline, stale, and overflow — not just the one where the data arrived. Use when building a screen or component, reviewing one for missing states, or deciding what a surface shows before its data exists; do not use for visual direction (that is frontend-design) or for screen-reader announcement of those states (that is accessibility).
---

# Interface States

Most interface bugs are not wrong pixels in the happy path. They are states nobody designed: the
empty list that renders as a bare heading, the error that shows a spinner forever, the first-run
screen built for a user who already has data.

Design the states before the layout. A component whose loading and empty cases are decided
afterwards ends up with them bolted on as conditionals, and the result reads as an afterthought
because it is one.

## Enumerate before building

For each surface, decide which of these genuinely exist — several usually do not, and inventing
states a screen cannot reach is its own waste:

- **First run** — the user is new. Different from empty: there is nothing *and* they do not yet
  know what this screen is for. Needs orientation and one obvious action.
- **Empty** — they know the screen, there is just nothing in it yet. Needs the action, not the
  explanation. Distinguish "nothing yet" from "nothing matches your filter", which needs a way
  back out.
- **Loading** — first paint with no data. Skeletons that match the real layout beat a centred
  spinner, because they do not move the page when data lands.
- **Streaming / partial** — some data is here and more is coming. The dominant state in an
  LLM-backed app and the one most often skipped.
- **Error** — say what failed, whether it is retryable, and what the user can do. An error that
  only apologizes is a dead end.
- **Stale / refetching** — showing old data while new data loads. Decide whether to dim, mark,
  or say nothing; silently swapping content under someone's cursor is the failure.
- **Offline** — reachable in a PWA or a flaky connection; usually not worth building otherwise.
- **Overflow** — more items, longer strings, or bigger numbers than the design assumed. Test
  with a 200-character name and a 10,000-row list.
- **Permission denied** — visible but not allowed, which is different from not found.

## Design them properly

Give every state the layout stability of the loaded one. A screen that shifts height between
loading, empty, and loaded feels broken even when each state looks fine alone.

An empty state is an invitation, not a notice. It carries one primary action and enough context
to make it obvious; a centred "No data" is a shrug. First-run earns more explanation than empty,
and only first-run does.

Errors are the highest-value state to get right and the least often designed. Distinguish what
the user can fix (bad input, expired session) from what they cannot (a 500), and only offer
retry where retrying could plausibly work. Preserve their input across the failure — losing a
half-written form to a network blip is the most avoidable damage in web UI.

For streaming, decide what the container does before the first token, between tokens, and on a
mid-stream failure. Partial output plus a failure needs to keep what arrived and say the rest
did not. `aria-busy` and a settled-result announcement are the accessibility half; see
`accessibility`.

## In this stack

App Router gives `loading.tsx` per route segment for the initial load — use it rather than
hand-rolling a top-level spinner, and keep the skeleton shaped like the page it replaces.
`error.tsx` catches the boundary case, but a route-level error page is a blunt instrument; catch
recoverable failures closer to the component that can explain them. Where the app already has
`skeleton`, `spinner`, and `status` primitives under `ui/`, extend those rather than
introducing a fourth convention.

## Review

Walk a screen against the list and name which states it handles, which it silently falls through,
and which it genuinely cannot reach. "Falls through" is the finding: an unhandled empty case
renders as something, and that something was not designed.
