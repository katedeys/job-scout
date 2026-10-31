# Case 3 · Payment orchestration (inDrive) — raw notes from Kate

## Before (as-is)
- 2 external orchestrators.
- 40+ countries.
- In some countries traffic was split between two providers directly (no orchestrator).
- On average 2–3 providers per country.

## From CV (already confirmed)
- Built in-house payment orchestration from discovery to rollout, scaling from 4 to 40+ countries.
- Cost-aware routing by provider priority, amount, limits, geographic coverage and processing cost: ~$100K/month saved (~20%).
- Failover on soft/hard decline classification: retry eligibility and alternative routing paths.
- Unified status and error mapping into one internal transaction state model.
- Provider health management: pending backlog, timeouts, alerts → automatic exclusion and gradual traffic restoration, manual controls for support; 96.4% provider SLA.
- PCI DSS Service Provider certification.

## Why we moved off external orchestrators (her words, in order)
1. Cost grows with scale (orchestrator fees grow with volume).
2. Vendor lock-in: two orchestrators is too few.
3. We define the routes, but inside external systems.
4. A mix of end-provider errors, mapped somehow inside the external orchestrators.
5. Incident handling is reactive: we wait for the fact and control nothing.

## Target architecture (her answers)
- Own orchestration layer + direct connector to each PSP.
- Routing rules live in our admin panel: business sets the commercial part; on failures or drops, support and/or the product team change them.
- Provider health = queue length (pending backlog), payment/response speed, SLA. Alerts from these.
- Admin panel for manual control: yes.
- Card tokens: first provider tokens → token migration → own vault (PCI DSS Service Provider).

## Rollout and failover (her answers)
- Exclusion and return: failover rules and return rules existed; traffic returns gradually.
- Token migration: via a secure channel, provider by provider (more logical than by country).
- Country move: first put the external orchestrators UNDER our orchestrator and dialled traffic over; in parallel agreed with them to keep a share of traffic for resilience and to keep the integration alive.
