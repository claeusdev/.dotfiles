---
name: security-threat-modeler
description: Threat-model a system, feature, data flow, or architecture change — trust boundaries, abuse cases, attack paths, and proportionate mitigations. Use for design-level security analysis, abuse-case discovery, or deciding what controls a feature needs; do not use for scanning a diff for vulnerabilities (that is /security-review) or for offensive exploitation. This is design analysis, not a penetration test or a compliance certification.
---

# Security Threat Modeler

Find the credible attack paths and the defenses proportionate to them. A checklist walked to
completion produces false assurance, which is worse than no analysis, because it ends the
conversation.

For scanning the current diff or branch for vulnerabilities, use `/security-review`. This skill
is for the design-level question of what could go wrong and what the system should do about it.

## Model the system

Establish the scope, the assets worth protecting, the security objectives, the actors, the entry
points, the dependencies, the deployment context, and the trust boundaries. Trace the sensitive
data through collection, transit, storage, use, sharing, and deletion — deletion is the stage
that is usually undesigned.

Mark the assumptions and the things you could not determine. An assumption recorded as a fact
is how a threat model becomes wrong six months later without anyone noticing.

Consider the threat classes that plausibly apply here: identity spoofing, authorization bypass,
tampering, information disclosure, injection, confused deputy, replay, denial of service,
supply-chain compromise, insecure defaults, secret exposure, and abuse by legitimate accounts —
that last one is consistently underweighted. Include privacy and operational abuse where they
apply.

## Analyze the risk

Express each material threat as: the attacker's capability and precondition; the attack path
across a trust boundary; the affected asset or invariant; the likely impact and whether anyone
would notice; the existing controls and their actual limitations; the recommended prevention,
containment, detection, and recovery; the residual risk; and how the mitigation gets validated.

Prioritize by credible likelihood and impact in the real environment. Do not inflate severity
from theoretical possibility, and do not assume a control exists because it should — check.
Verify version-sensitive vulnerability claims against authoritative current sources rather than
recalling them.

Give enough detail to make the risk actionable and no more; a working exploit is not a
deliverable here.

## Improve the design

Prefer eliminating the dangerous flow to defending it, and reducing privilege to detecting
misuse of it. Detection is the last resort, not the first control. Apply least privilege, secure
defaults, explicit authorization at the point of data access, isolation, bounded resource use,
careful secret handling, dependency integrity, and auditable events where each is warranted.

Close with the highest-risk scenarios, the design decisions that must be made, the concrete
security tests that would validate the mitigations, and the assumptions still unresolved. For a
threat model others will review, offer to publish it as an Artifact.
