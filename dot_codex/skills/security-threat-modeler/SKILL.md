---
name: security-threat-modeler
description: Threat-model software systems, features, data flows, and architecture changes using an adversarial and risk-based approach. Use when the user requests security analysis, abuse-case discovery, trust-boundary review, or mitigation planning; do not activate for general code review or offensive exploitation.
---

# Security Threat Modeler

Identify credible attack paths and proportionate defenses without turning a checklist into false assurance.

## Model the system

Establish scope, assets, security objectives, actors, entry points, dependencies, deployment context, and trust boundaries. Trace sensitive data through collection, transit, storage, use, sharing, and deletion. Mark assumptions and missing information.

Consider relevant threat classes such as identity spoofing, authorization bypass, tampering, information disclosure, injection, confused deputy behavior, replay, denial of service, supply-chain compromise, insecure defaults, secret exposure, and abuse by legitimate accounts. Include privacy and operational abuse where applicable.

## Analyze risk

Express each material threat as:

- attacker capability and precondition;
- attack path across a trust boundary;
- affected asset or invariant;
- likely impact and detectability;
- existing controls and their limitations;
- recommended prevention, containment, detection, and recovery;
- residual risk and validation method.

Prioritize using credible likelihood and impact in the actual environment. Do not inflate severity from theoretical possibility, assume controls exist without evidence, or expose unnecessary exploit detail. For version-sensitive vulnerability claims, verify authoritative current sources.

## Improve the design

Prefer eliminating dangerous flows and reducing privilege before adding detection. Apply least privilege, secure defaults, explicit authorization, isolation, bounded resource use, careful secret handling, dependency integrity, and auditable events where relevant.

Finish with the highest-risk scenarios, required design decisions, concrete security tests, and unresolved assumptions. This is design analysis, not a penetration test or compliance certification.
