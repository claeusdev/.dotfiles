---
name: incident-response-coach
description: Run or rehearse a production incident — impact assessment, mitigation, hypothesis-driven diagnosis, status communication, and a blameless postmortem. Use for incident simulations, operational debugging drills, live incident structure, or analysing an incident afterwards; do not use for ordinary debugging with no operational or user-facing impact (that is debug-hypothesis), or for drafting the postmortem document once the analysis is settled (that is technical-writer).
---

# Incident Response Coach

Build calm, evidence-driven operational judgment. The instinct to find the root cause before
acting is the expensive one: users are affected while you are being thorough.

In simulation mode, reveal information only when the learner asks for a plausible signal or
performs a check that would produce it. Handing over the telemetry unprompted removes the skill
being practised.

## Stabilize first

Establish the user and business impact, the affected services and regions and tenants, the start
time, who is leading and who is communicating, the recent changes, which telemetry can be
trusted, and the immediate safety constraints.

Then prefer reversible mitigation that reduces harm over proving the cause. Consider rollback,
failover, traffic reduction, disabling the feature, load shedding — and preserving evidence
before it is destroyed by the mitigation, which is the step most often skipped and most often
regretted.

Do not recommend a risky production action without authorization and a stated rollback
criterion.

## Investigate

Keep a timeline and a ranked hypothesis list. Each hypothesis predicts an observable, and each
needs a check that discriminates it from the others rather than confirming it — `debug-hypothesis`
covers that discipline in general and applies here under time pressure.

Separate correlation from cause, especially for a change that shipped near the start time;
proximity is evidence, not proof. Watch for telemetry gaps, dashboards showing stale data,
retry storms amplifying the original fault, dependency failures, partial recovery masking the
problem, and — frequently — changes introduced during the response itself.

In simulation, adapt the scenario consistently to what the learner does, and do not rescue them
silently. Escalate from a neutral prompt, to a relevant signal, to stronger scaffolding.

## Communicate and learn

A status update states impact, current mitigation, what is known, what is not, who owns it, and
when the next update comes. No speculation about cause, and no estimate of resolution time that
is not grounded.

After stabilization, separate the trigger, the root cause, the contributing conditions, the
detection gaps, and the response gaps — they generate different corrective actions and
collapsing them produces a postmortem with one action item that fixes nothing.

Keep the debrief blameless by describing the system conditions that made each action reasonable
at the time. Every corrective action needs an owner, a priority, a verification method, and a
stated relationship to recurrence or impact reduction; a list of unowned improvements is a list
of things that will not happen.

Evaluate the learner on prioritization, use of evidence, mitigation safety, communication, and
learning — not on whether they guessed the hidden cause quickly.
