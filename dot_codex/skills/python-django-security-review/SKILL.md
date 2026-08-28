---
name: python-django-security-review
description: Review Python and Django application code, configuration, data flows, and deployments for credible security and privacy failures. Use for implementation-level security assessment or hardening; do not use for a general code review, formal compliance certification, or offensive exploitation.
---

# Python/Django Security Review

Find reachable attack paths and proportionate defenses in the application's real deployment context. Review without modifying the code unless the user separately asks for fixes.

## Establish the security contract

Identify the exposed feature, actors, tenant or ownership model, sensitive assets, entry points, trust boundaries, deployment topology, and security assumptions. Trace sensitive data through collection, validation, authorization, storage, rendering, logging, sharing, and deletion.

Inspect the exact Python and Django versions, middleware order, authentication backends, settings, routes, forms or serializers, model constraints, templates, uploads, background jobs, caches, proxies, and tests relevant to the path. Framework defaults are controls only when the application has not bypassed or misconfigured them.

Read [references/django-security-controls.md](references/django-security-controls.md) for Django-specific review targets and authoritative sources. Use the documentation for the repository's installed version. Treat OWASP ASVS as a coverage aid, not evidence of compliance.

## Review attack paths

Prioritize evidence-backed paths in this order:

1. Authentication, session lifecycle, recovery, and authorization at object, action, role, and tenant boundaries.
2. Data integrity and workflow abuse: mass assignment, invalid state transitions, races, replay, duplicate work, and side effects that escape rollback.
3. Injection and unsafe interpretation across SQL, shell commands, templates, redirects, file paths, deserialization, markup, and outbound requests.
4. Browser and API controls: CSRF, CORS, host validation, cookie attributes, HTTPS, CSP, cache behavior, and response data exposure.
5. Secrets, personal data, logging, error handling, backups, retention, and environment separation.
6. Availability and abuse resistance: unbounded bodies, uploads, fan-out, queries, recursion, concurrency, retries, and expensive unauthenticated work.
7. Dependency, artifact, migration, administration, and deployment risks.

For each suspected issue, prove the user-controlled input, reachable path, missing or bypassable control, and affected asset. Check call sites and middleware before concluding that a local-looking defect is exploitable. Do not inflate severity from a checklist match alone.

## Produce actionable findings

Each finding must include:

- severity, confidence, and precise location;
- attacker capability and required preconditions;
- the request, task, or data path that reaches the weakness;
- impact and affected users or data;
- existing controls and why they are insufficient;
- the smallest sound mitigation and any defense-in-depth follow-up;
- a test or operational check that verifies the mitigation.

Prefer eliminating dangerous authority or data flow before adding detection. Favor centralized authorization, safe framework primitives, least privilege, secure defaults, bounded resource use, durable audit events, and supported dependency versions.

Lead with findings ordered by risk. If no actionable vulnerability is established, say so and list residual coverage gaps or assumptions. Avoid unnecessary exploit detail, do not expose real secrets, and do not describe the result as a penetration test or certification.
