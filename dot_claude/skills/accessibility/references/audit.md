# Auditing a page

Run these in order. Each finds a different class of barrier, and the automated pass is last on
purpose — it is the floor, not the verdict.

## 1. Keyboard only

Put the mouse away and complete the real task, not a tour of the page.

- Can you reach every interactive element with Tab, and does the order match the visual layout?
- Is the focus indicator visible at every stop, including on dark surfaces and over images?
- Do Enter and Space both activate buttons? Does Escape close what it should?
- Do arrow keys work where a widget implies them — menus, tabs, radio groups, comboboxes?
- Open a dialog: does focus move in, stay trapped, and return to the trigger on close?
- After any content swap that is not a navigation, where did focus go? Landing on `<body>` is a
  failure — the user is silently returned to the top of the document.
- Is anything focusable that is visually hidden? Off-screen menus and `display: none` toggles are
  the usual culprits.

## 2. Screen reader

One flow, the one that matters most. VoiceOver is already installed on macOS: `Cmd+F5` to
toggle, `Ctrl+Option+arrows` to navigate, `Ctrl+Option+U` for the rotor.

- Does the rotor's heading list read as a sensible outline of the page?
- Is every control announced with a name that describes what it does — not "button", not
  "link", not the icon's file name?
- Are form fields announced with their label, their required state, and their error?
- Do async updates get announced at all? Do they get announced too much?
- Are decorative images silent (`alt=""`) and meaningful ones described?

## 3. Zoom and reflow

Zoom to 200%, then narrow to 320px.

- Does content reflow, or does it clip, overlap, or force horizontal scrolling?
- Do fixed heights cut text off? This is where `h-*` on a container containing prose breaks.
- Are sticky headers now eating the viewport?

## 4. Reduced motion

Turn on Reduce Motion in System Settings → Accessibility → Display.

- Are transforms, parallax, and autoplaying animation actually removed, not just shortened?
- Does anything still move that the user cannot stop?

## 5. Automated

Run the repo's own checks first — typically a contrast script plus `lint`, which in a Next.js app
picks up the `eslint-plugin-jsx-a11y` rules that ship with `eslint-config-next`. Add axe via the
browser extension or `@axe-core/playwright` for a DOM-level pass.

Treat the output as a list of candidates. A passing automated run means no *detectable* barriers,
which is a much weaker claim than an accessible page.

## Reporting

Say which passes you ran and what each one found. Distinguish a barrier that blocks the task
from a violation that is technically true but harmless in context, and rank accordingly. If you
did not run a pass, say so rather than implying coverage.
