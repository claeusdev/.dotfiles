---
name: component-api
description: Design the interface of a reusable component — props versus slots, controlled versus uncontrolled, composition over configuration, and where variants belong. Use when building or refactoring a shared component, deciding how a component should be parameterised, or when a component's props list has grown past reason; do not use for visual direction (that is frontend-design), for its states (that is interface-states), or for app-level architecture (that is typescript-application-engineering).
---

# Component API

A component's props are its public interface, and they are far harder to change than its
internals — every caller is a migration. Spend design effort proportional to the number of call
sites, and be willing to leave a single-use component with a crude interface.

The characteristic failure is the boolean pile: a component that grew `isCompact`,
`hideHeader`, `showFooter`, `variant`, and `withBorder` one requirement at a time, where several
combinations are meaningless and none are documented. Each boolean doubles the state space; five
of them describe 32 components, of which perhaps six are real.

## Composition over configuration

When a prop exists to control *what renders inside*, it usually wants to be a slot instead.
`children`, or named element props, let the caller pass anything without the component
anticipating it — and they do not accumulate.

Configuration is right when the component must interpret the value: a `variant` that maps to
tokens, a `size` that must stay on scale, an `orientation` that changes keyboard behavior. Keep
those as closed unions, never `string`, so the compiler enumerates the real options and an
invalid one cannot be passed.

When a component needs coordinated parts, prefer a compound API — `Card` with `Card.Header` and
`Card.Footer`, as Radix does — over a flat component with a dozen optional element props. The
caller composes what they need and skips what they do not.

Escape hatches matter. Accept `className` and spread the remaining props onto the root element
so a caller can adjust one instance without a new prop or a fork. `cva` (already a dependency in
these apps) is the right place for variant-to-class mapping.

## Controlled and uncontrolled

Decide deliberately, and support both where the component has state a parent might need. The
standard shape is an optional `value` with `onChange`, falling back to internal state when
`value` is undefined, plus `defaultValue` for the uncontrolled case.

The bug to avoid is the half-controlled component that accepts `value` but also mutates its own
copy, so the parent's state and the component's silently diverge. If `value` is provided, it is
the only source of truth.

Do not lift state into a parent that has no use for it. A disclosure that nobody else needs to
observe should own its own open state.

## Boundaries in this stack

Decide whether a component is a Server or a Client Component before designing its props, because
it changes what can cross the boundary: a Server Component can accept data but not a function,
and pushing `"use client"` up the tree to satisfy one interactive leaf drags everything below it
into the bundle. Keep the client boundary as low as possible and pass server-rendered children
through it.

shadcn's copy-in model changes the tradeoff: the component lives in your repo, so you edit it
rather than configuring around it. Do not add a prop to a vendored primitive to avoid touching
it — that is the one case where forking is the intended move. Keep genuinely app-specific
components out of `ui/`, which should hold primitives only.

## When to refactor

Rework the interface when several props are never used together, when a boolean is only ever
passed as one value, when callers pass a prop just to disable behavior they did not want, or
when adding a feature means adding a prop to every layer between the caller and the leaf.

Removing a prop is cheaper than it looks — the type error lists every call site. Adding one you
cannot remove is the expensive direction.
