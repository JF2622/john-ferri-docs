# Ticket Note Examples (Tier 1 SOC)

## Purpose
Provide copy/paste-ready examples of Tier 1 investigation notes that are clear, repeatable, and escalation-ready.

## Standard Fields
**Alert / Report:**  
**User / Host:**  
**Time Range:**  
**Source IP / Geo:**  
**Device / User Agent:**  
**What I Checked:**  
-  
-  
**Findings (facts):**  
-  
-  
**Assessment (TP/FP + confidence):**  
**Action Taken / Next Step:**  
**Escalation (if any):**  

---

## Example 1A — Suspicious Login (Likely False Positive)

**Alert / Report:** Impossible travel / risky sign-in  
**User / Host:** jdoe@example.com  
**Time Range:** 2026-01-26 13:05–13:20 ET  
**Source IP / Geo:** 198.51.100.10 (Ashburn, VA) → 203.0.113.22 (New York, NY)  
**Device / User Agent:** Known device ID present; Chrome on Windows 11

**What I Checked:**
- IdP sign-in logs for the user (same time window)
- MFA outcomes and device context
- Ticket system for travel/remote work notes
- Known corporate/VPN egress IP list

**Findings (facts):**
- Both sign-ins originated from known corporate/VPN egress ranges.
- MFA was completed successfully using the user’s registered method.
- Device context matches historical logins (known device; no new device registration).
- No additional anomalous sign-ins observed in ±2 hours.

**Assessment (TP/FP + confidence):** FP (high). Geo discrepancy consistent with VPN egress routing.  
**Action Taken / Next Step:** Closed as FP. Added note to tune rule to recognize VPN egress ranges if supported.

---

## Example 1B — Suspicious Login (Escalate)

**Alert / Report:** Impossible travel / concurrent sessions  
**User / Host:** jdoe@example.com  
**Time Range:** 2026-01-26 02:10–02:25 ET  
**Source IP / Geo:** 203.0.113.88 (Berlin, DE) and 198.51.100.77 (Chicago, IL) within 6 minutes  
**Device / User Agent:** New user agent observed; device not previously seen

**What I Checked:**
- IdP sign-in logs (successes/failures, MFA results)
- Session/concurrent sign-in indicators
- Recent password reset or access request tickets
- Privilege level / group membership

**Findings (facts):**
- Successful sign-in from unfamiliar geo/device preceded by multiple failed attempts.
- MFA challenges observed; outcome unclear (mixed denies/timeouts).
- Concurrent activity from two distant geos within minutes.
- No travel/exception record found in tickets.

**Assessment (TP/FP + confidence):** Suspected TP (medium-high). Pattern consistent with credential compromise attempts.  
**Action Taken / Next Step:** Prepared escalation with evidence summary and recommended containment.  
**Escalation (if any):** Escalated to Tier 2/Lead per SOP Escalation Criteria. Recommended: revoke sessions/refresh tokens, force password reset, review conditional access for geo/device.

---

## Example 2A — MFA Fatigue (Attempted Compromise; user denied prompts)

**Alert / Report:** User report: repeated MFA prompts not initiated  
**User / Host:** jsmith@example.com  
**Time Range:** 2026-01-26 18:40–19:05 ET  
**Source IP / Geo:** 192.0.2.44 (unknown ISP, out-of-state)  
**Device / User Agent:** New device; mobile push prompts

**What I Checked:**
- IdP sign-in/MFA challenge events (counts and outcomes)
- Source IP reputation/internal allowlists
- Concurrent sign-ins and follow-on success events
- Privilege level (admin/VIP) indicators

**Findings (facts):**
- 17 MFA push prompts generated in 25 minutes.
- User reports denying/ignoring prompts; no explicit approval reported.
- Multiple failed sign-in attempts; no confirmed successful sign-in observed.
- Source IP not in known corporate/VPN egress list.

**Assessment (TP/FP + confidence):** Likely attempted compromise (medium). Push fatigue pattern present; success not confirmed.  
**Action Taken / Next Step:** Escalated with evidence and recommended protective steps.  
**Escalation (if any):** Escalated to Tier 2/Lead. Recommended: password reset, enforce phishing-resistant MFA if available, block source IP/geo if policy allows, monitor for follow-on attempts.

---

## Example 2B — MFA Fatigue (High-confidence compromise; user approved prompt)

**Alert / Report:** User report: approved an MFA prompt by mistake  
**User / Host:** jsmith@example.com  
**Time Range:** 2026-01-26 09:10–09:25 ET  
**Source IP / Geo:** 203.0.113.19 (unfamiliar geo)  
**Device / User Agent:** New device; browser sign-in

**What I Checked:**
- IdP sign-in logs for successful sign-in and session creation
- MFA outcomes and device registration changes
- Any mailbox/email rule creation indicators (if applicable)
- Privilege level and access scope

**Findings (facts):**
- User approved an unexpected MFA prompt.
- Successful sign-in recorded from unfamiliar IP/geo immediately after approval.
- New session established; additional access attempts observed shortly after.
- No change window or travel exception documented.

**Assessment (TP/FP + confidence):** High-confidence compromise risk (high).  
**Action Taken / Next Step:** Immediate escalation and containment recommendation.  
**Escalation (if any):** Escalated to Tier 2/Lead. Recommended: revoke sessions, force password reset, re-register MFA, check for persistence (rules/forwarding), and evaluate account disable per policy.
