# Python application practices

Use this reference for language, packaging, typing, concurrency, observability, and testing decisions. Repository evidence and documentation for the installed Python version take precedence.

## Environment and dependencies

- Declare the supported Python range and tool configuration in `pyproject.toml` when the existing project uses the standard format. Preserve the chosen environment and lock workflow; Python packaging deliberately supports multiple workflow tools.
- Use an isolated environment for third-party dependencies. Do not install into an externally managed system interpreter or replace the repository's dependency tool as incidental cleanup.
- For an application, make deployments reproducible with the repository's lock or constraints mechanism. For a reusable library, preserve a compatible dependency range instead of pinning every transitive dependency for consumers.
- Treat a dependency change as code: review provenance, supported versions, release notes, license or policy constraints when applicable, transitive impact, and rollback.

## Types and boundaries

- Add type information where it protects durable contracts: public APIs, domain values, integration adapters, configuration, serialization, and non-obvious return shapes. Do not annotate every local at the expense of clarity.
- Static annotations are not runtime validation. Parse untrusted values into domain types at boundaries, and avoid spreading `Any`, broad casts, or unchecked dictionaries past that point.
- Model meaningful finite states explicitly rather than using combinations of booleans or nullable fields that admit contradictory states.
- Prefer protocols or small interfaces at genuine substitution boundaries. Avoid abstractions created only to make one implementation look layered.

## Control flow and failure

- Catch the narrow exception that the current boundary can handle. Preserve the original cause when translating errors, and do not catch `BaseException` for ordinary recovery.
- Use context managers for resources with deterministic cleanup. Make ownership of files, sockets, cursors, sessions, tasks, and executors visible.
- Avoid mutable module-level state as cross-request authority. Multiple workers, restarts, tests, and task execution make process-local coordination unreliable.
- For subprocesses and SQL, use argument arrays and parameter binding. Do not interpolate untrusted values into shell commands or query text.

## Concurrency

- Choose sync, threads, processes, or async from the workload and dependency behavior. Async improves concurrency for cooperative I/O; it does not make CPU work faster and blocking calls can stall the event loop.
- Bound concurrency, queues, retries, timeouts, and result sizes. Define cancellation and cleanup behavior. Retain references to background tasks whose completion or failure matters.
- Reproduce concurrency claims with a focused workload or test. A function being declared `async` is not evidence of non-blocking behavior.

## Testing and observability

- Follow the repository's test runner and fixtures. Test public behavior, boundary validation, failure translation, state transitions, and integration contracts; use the narrowest layer that proves each risk.
- Keep tests independent of execution order and wall-clock coincidence. Inject time, randomness, identifiers, or external clients when deterministic control is material.
- Log operational events, not prose transcripts. Use lazy parameter formatting, stable event names or fields, appropriate levels, correlation context, and redaction. Never make sensitive values the easiest debugging path.
- Measure user- or operator-relevant behavior at the owning boundary. Performance work needs a stated workload, baseline, and comparable result.

## Primary sources

- [Python Packaging User Guide: `pyproject.toml`](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/)
- [Python Packaging User Guide: tool recommendations](https://packaging.python.org/en/latest/guides/tool-recommendations/)
- [Python Packaging User Guide: virtual environments](https://packaging.python.org/en/latest/specifications/virtual-environments/)
- [Python typing documentation](https://docs.python.org/3/library/typing.html)
- [Python exception tutorial](https://docs.python.org/3/tutorial/errors.html)
- [Python `contextlib` documentation](https://docs.python.org/3/library/contextlib.html)
- [Python asyncio development guidance](https://docs.python.org/3/library/asyncio-dev.html)
- [Python logging HOWTO](https://docs.python.org/3/howto/logging.html)
- [Python `unittest` documentation](https://docs.python.org/3/library/unittest.html)
- [PEP 8](https://peps.python.org/pep-0008/)
