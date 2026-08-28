# Django security review controls

Use this as a routing aid after establishing the actual actors, data, deployment, and framework version. It is not a universal checklist and does not establish compliance.

## Identity and authorization

- Confirm the authentication backend, session or token lifecycle, password and recovery flows, multi-factor assumptions, impersonation, and privileged administration paths.
- For every sensitive read or write, locate the authoritative authorization decision. Check object ownership, tenant isolation, role and state requirements, bulk operations, indirect references, exports, tasks, admin actions, and caches.
- Prefer actor-scoped queries or centralized policy functions that return the authorized object. Test horizontal and vertical access using two distinct users or tenants.
- Check state-changing cookie-authenticated endpoints for CSRF protection, including JSON, uploads, callbacks initiated by browsers, and exemptions. CORS does not replace CSRF protection.

## Input, interpretation, and output

- Trace all user-controlled data through forms or serializers, model fields, templates, redirects, headers, filenames, parsers, outbound URLs, subprocesses, SQL, email, and logs.
- Check raw SQL for parameter binding; subprocesses for shell avoidance and bounded arguments; templates for `safe`, `mark_safe`, disabled autoescape, unquoted attributes, and untrusted stored HTML.
- Validate redirects and callback URLs against an explicit policy. For server-side fetches, constrain schemes, destinations, redirects, DNS changes, credentials, response size, and timeout to the feature's needs.
- Treat uploads as hostile. Bound request and expanded size, content and extension handling, filenames, storage location, serving origin and headers, permissions, processing time, and deletion. Web-server body limits may be required before Django parses the request.
- Avoid unsafe deserialization and dynamic code loading. Treat signed data as authenticated, not confidential, and plan key rotation where long-lived signatures exist.

## Browser, API, and deployment controls

- Verify proxy and scheme configuration before relying on HTTPS redirects or secure cookies. Review `ALLOWED_HOSTS`, HSTS, secure and HTTP-only cookies, SameSite behavior, clickjacking protection, referrer policy, and trusted origins.
- Use CSP as defense in depth after removing unsafe rendering paths. Match the mechanism to the installed Django version and test third-party assets, nonces, reports, and all routes.
- Check `DEBUG`, secret key handling and rotation, error responses, admin exposure, default accounts, storage and cache isolation, database privilege, email, and static/media serving.
- Run `manage.py check --deploy` against production settings, then manually review controls the system check cannot understand.

## State, side effects, and abuse

- Identify invariants that must survive races. Check uniqueness, balances, quotas, inventory, invitations, permissions, token use, and workflow transitions for database enforcement and appropriate locking or atomic updates.
- Ensure external effects do not happen before a transaction commits. For retryable work, verify idempotency, deduplication scope, attempt limits, dead-letter or terminal failure handling, and operator visibility.
- Bound request bytes, collection length, pagination, query complexity, upload processing, decompression, recursion, fan-out, concurrency, task creation, and retries before expensive work.
- Review authentication throttling, enumeration, scraping, notification abuse, exports, search, and resource creation according to realistic attackers and product risk.

## Data protection and supply chain

- Classify secrets, credentials, personal data, financial data, user content, and audit events. Check collection, encryption needs, access, logs, analytics, backups, exports, retention, deletion, and incident usefulness.
- Redact headers, cookies, tokens, query strings, request bodies, exception text, task payloads, and nested integration errors where sensitive values can appear.
- Verify supported Python, Django, database, server, and dependency versions. Review lock or constraints files, artifact provenance, dependency changes, CI permissions, build secrets, and migration or management-command authority.

## Finding calibration

Use reachability, required privilege, affected asset, blast radius, exploit reliability, existing controls, detectability, and recovery cost to set severity. A secure framework default reduces risk only when enabled and used correctly. A missing defense-in-depth control is not automatically a vulnerability.

## Primary sources

- [Django security overview](https://docs.djangoproject.com/en/stable/topics/security/)
- [Django deployment checklist](https://docs.djangoproject.com/en/stable/howto/deployment/checklist/)
- [Django system checks](https://docs.djangoproject.com/en/stable/ref/checks/)
- [Django CSRF protection](https://docs.djangoproject.com/en/stable/howto/csrf/)
- [Django authentication customization](https://docs.djangoproject.com/en/stable/topics/auth/customizing/)
- [Django password management](https://docs.djangoproject.com/en/stable/topics/auth/passwords/)
- [Django file uploads](https://docs.djangoproject.com/en/stable/topics/http/file-uploads/)
- [Django signing](https://docs.djangoproject.com/en/stable/topics/signing/)
- [Django security policies and supported versions](https://docs.djangoproject.com/en/stable/internals/security/)
- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
