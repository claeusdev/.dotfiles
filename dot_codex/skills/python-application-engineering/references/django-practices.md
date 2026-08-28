# Django application practices

Use the documentation branch matching the repository's installed Django version. Inspect middleware, settings, database backend, server model, and third-party packages before applying framework guidance.

## Application and data boundaries

- Organize code around cohesive product capabilities and state ownership, not a mandatory project template. Keep views and consumers focused on protocol adaptation; keep reusable rules out of templates, admin actions, signals, or duplicated view branches.
- Use forms, serializers, or an equivalent explicit boundary to validate request data. Model validation is useful, but `save()` does not automatically call `full_clean()`.
- Encode durable data invariants with field choices, foreign keys, unique or check constraints, and transactions where the database can enforce them. Application validation should improve feedback, not pretend to prevent races.
- Treat signals as implicit control flow. Use them for truly cross-cutting reactions with clear ownership; prefer an explicit application operation when ordering, transaction scope, or discoverability matters.

## Transactions and side effects

- Django uses autocommit by default. Wrap the smallest consistency-critical unit in `transaction.atomic()` and keep transactions short.
- Catch database errors around an `atomic()` block rather than hiding them inside a broken transaction.
- Use `transaction.on_commit()` for notifications, tasks, cache invalidation, or other effects that must not happen after a rollback. If delivery must survive a process crash after commit, use a durable handoff such as an outbox rather than an in-memory callback alone.
- Make retry and idempotency behavior explicit for tasks, webhooks, payments, imports, and commands. A database transaction does not make a remote side effect atomic.

## ORM and performance

- Profile first and inspect actual queries. Use `QuerySet.explain()` and database evidence before adding indexes or caching.
- Prevent repeated related-object queries with the appropriate relation-loading strategy. Project only needed data on hot paths, but do not sacrifice clarity without a measured benefit.
- Keep queryset evaluation and laziness visible. Beware of evaluation in templates, iteration, serialization, logging, truth tests, and repeated access.
- Add indexes from demonstrated filter, join, uniqueness, and ordering patterns. Account for write cost, lock behavior, existing data, and the production database backend.

## Migrations and compatibility

- Review generated migrations as production code. Check operation order, defaults, locks, table rewrites, data volume, reverse behavior, and compatibility with old and new application processes during rollout.
- Use historical models inside data migrations, not imported current models. Keep data migrations deterministic and bounded; separate schema expansion, backfill, constraint enforcement, and cleanup when necessary.
- Preserve API, queue, task, and schema compatibility across the actual deployment strategy. A successful local migration does not prove an online rollout is safe.

## HTTP, async, and tests

- Keep authentication and authorization distinct. Load or mutate resources within the actor and tenant scope rather than checking ownership after an unrestricted lookup.
- Preserve Django's CSRF, escaping, host validation, and security middleware unless a documented alternative maintains the same security property.
- Use async views only when the server and downstream call path can benefit. Identify synchronous middleware and ORM or library boundaries; never disable async safety checks to conceal blocking access.
- Use Django-aware test cases for database behavior. Choose `TransactionTestCase` only when real commit or transaction behavior is the subject; test `on_commit()` callbacks deliberately.
- Test at the relevant boundary: domain rules directly, request and authorization behavior with the test client, and browser behavior with a browser-capable test when rendering or JavaScript is material.

## Deployment and operations

- Separate environment configuration and secrets while keeping settings reviewable. Never run the development server as the production server.
- Run Django's deployment checks against production settings and review HTTPS, cookies, hosts, error reporting, static and media serving, caches, email, logging, and database connectivity.
- Instrument request outcomes, task outcomes, dependency latency, database pressure, and business-critical failures. Avoid sensitive request bodies, tokens, and personal data in logs.

## Primary sources

- [Django database transactions](https://docs.djangoproject.com/en/stable/topics/db/transactions/)
- [Django migrations](https://docs.djangoproject.com/en/stable/topics/migrations/)
- [Django database optimization](https://docs.djangoproject.com/en/stable/topics/db/optimization/)
- [Django performance and optimization](https://docs.djangoproject.com/en/stable/topics/performance/)
- [Django asynchronous support](https://docs.djangoproject.com/en/stable/topics/async/)
- [Django testing overview](https://docs.djangoproject.com/en/stable/topics/testing/overview/)
- [Django testing tools](https://docs.djangoproject.com/en/stable/topics/testing/tools/)
- [Django deployment checklist](https://docs.djangoproject.com/en/stable/howto/deployment/checklist/)
- [Django security overview](https://docs.djangoproject.com/en/stable/topics/security/)
- [Django model constraints](https://docs.djangoproject.com/en/stable/ref/models/constraints/)
