---
name: accessibility
description: Make an interface usable without a mouse, without sight, and without steady attention — semantics before ARIA, keyboard and focus management, live regions for streaming content, contrast and motion. Use when building or auditing UI for accessibility, fixing keyboard traps or screen-reader behavior, or announcing async and streamed updates; do not use for visual direction (that is frontend-design) or for which states a screen needs (that is interface-states).
---

# Accessibility

Accessibility is a correctness property, not a polish pass. The question is never "does it meet
the guideline" but "can someone actually complete this task with a keyboard, with a screen
reader, at 200% zoom, with reduced motion on." A page can satisfy every automated check and be
unusable.

Automated tooling misses the barriers that actually block people — focus order, announcement
timing, whether a label describes the real action. Never report an interface as accessible
because a checker passed.

## Semantics before ARIA

The first rule of ARIA is not to use it. A `<button>` is focusable, activates on Enter and
Space, announces its role, and works with voice control for free; a `<div role="button">` with
a click handler reproduces none of that until you write it, and you will miss a case.

Reach for a native element first: `<button>`, `<a href>`, `<label>` bound to its control,
`<fieldset>`/`<legend>`, `<dialog>`, `<table>` with real headers, `<nav>`/`<main>`/`<h1>`–`<h6>`
in a sensible outline. Use ARIA only to express what HTML cannot — a live region, a
`aria-current` on the active page, a relationship between separated elements.

Bad ARIA is worse than none: a wrong role silently overrides correct native semantics. Before
adding an attribute, be able to say what a screen reader will announce because of it.

Prefer a headless primitive that already solved this — Radix, as used in the `ui/` primitives —
over hand-rolling a menu, dialog, combobox, or tabs, which is where hand-rolled implementations
reliably break.

## Keyboard and focus

Every interactive element must be reachable and operable by keyboard, in an order that matches
the visual layout, with a visible focus indicator. Test it by unplugging the mouse and doing
the task — that takes two minutes and finds more than any audit tool.

Focus is state, and it must be managed deliberately at three moments: when a dialog or sheet
opens, focus moves into it and is trapped until it closes; when it closes, focus returns to the
element that opened it; when content changes without navigation, focus goes somewhere sensible
rather than being lost to `<body>`. A lost focus point sends a keyboard user back to the top of
the document.

Never remove a focus outline without replacing it with something at least as visible;
`:focus-visible` gives the mouse-click behavior people want without costing keyboard users
anything. Provide a skip link past repeated navigation, and make sure nothing visually hidden is
still keyboard-reachable.

## Announcing change

Anything that updates without a page navigation is invisible to a screen reader unless you
announce it — validation errors, toasts, results counts, and streamed content.

Use `aria-live="polite"` for status that can wait and `assertive` only for genuine
interruptions. The region must exist in the DOM *before* the content arrives; injecting a live
region and its text together announces nothing. `role="status"` and `role="alert"` are the
shorthand for the common cases.

Streaming needs care rather than a live region on the stream. Token-by-token SSE output wrapped
in `aria-live` produces continuous unintelligible chatter. Announce the transition instead —
that a response started, and that it finished — and let the user read the settled result on
demand. `aria-busy` on the container during generation is the right signal for the in-between.

Bind every input to a label, associate errors with `aria-describedby`, and mark invalid fields
`aria-invalid` — where the app already uses all three, match that convention rather than
inventing another.

## Visual and motion

Meet contrast on text and on the non-text things that carry meaning: focus rings, icons used as
the only label, chart series, form borders. Run the repo's own contrast checker rather than
eyeballing it. Never encode meaning in color alone.

Respect `prefers-reduced-motion` by removing transforms and parallax, not by shortening them.
Keep the layout usable at 200% zoom and at 320px wide, where fixed heights and absolute
positioning break first.

## Verify

A keyboard-only pass through the real task, then a screen reader on the flow that matters most,
then 200% zoom and reduced motion. Run the automated check last, as a floor rather than a
verdict. Read `references/audit.md` when auditing an existing page rather than building one.

Report what you actually exercised — "ran the linter" and "completed signup with the keyboard"
are different claims, and only one is evidence.
