# Playbook: MFA Fatigue (Push Bombing)

## Purpose
Help Tier 1 analysts triage alerts or user reports involving repeated MFA prompts and suspected “push bombing” attempts, and then determine when to escalate and/or request containment actions.

## When to Use
- User reports repeated MFA prompts that they did not initiate.
- IdP alert: multiple MFA challenges, unusual MFA failures, or high-risk sign-in with MFA anomalies
- SIEM alert: suspicious authentication patterns tied to MFA outcomes

## Required Inputs
- Username / UPN
- Timestamp range (UTC and local)
- Source IP(s) and geolocation
- Device / user agent (if available)
- MFA method (push, SMS, TOTP, phone call)
- IdP platform involved (e.g., Azure AD / Okta)

## Data Sources to Check
- IdP sign-in logs (risk flags, MFA outcomes, device context)
- MFA provider logs (challenge counts, approvals/denials/timeouts)
- VPN logs (if applicable)
- EDR/endpoint context (if device compromise suspected)
- Ticketing system (recent access issues, password resets, travel notices)

## Triage Steps (Tier 1)
1. Confirm the report/alert details (user, time range, MFA method, volume of prompts).
2. Determine whether the user **approved any** unexpected MFA prompt.
3. Review sign-in pattern:
    - failed attempts count
    - success after failures
    - MFA outcomes (approved/denied/timed out)
4. Validate source context:
    - unfamiliar IP/geo?
    - known corporate/VPN egress?
    - unusual user agent/device?
5. Check for “impossible travel” or concurrent sessions across locations/devices.
6. Check account privilege and sensitivity (admin/VIP/critical systems).
7. If the user approved an unexpected prompt, treat as **high-confidence compromise**.
8. If repeated prompts occurred without approval:
    - treat as **attempted compromise** (credential stuffing + MFA fatigue)
9. Collect evidence for escalation and recommended containment steps.
10. Document actions and evidence in the ticket using the template below.

## Recommended Containment (Request via Tier 2/Lead per policy)
- Force password reset
- Revoke active sessions / refresh tokens
- Require re-registration of MFA (if supported)
- Block source IP / apply conditional access policy (location/device)
- Temporarily disable account if compromise is likely and policy allows

## Common False Positives
- User accidentally triggering repeated prompts (multiple login attempts)
- MFA app sync issues or delayed push notifications
- Legitimate sign-ins from VPN causing unusual geo
- Device reauthentication loops (SSO token refresh)

## Escalation Criteria
- Escalate if any apply:
    - User approved an unexpected prompt.
    - Privileged/VIP account involved
    - Success after repeated failures from unfamiliar IP/geo
    - High volume of prompts in a short time window
    - You cannot confidently explain activity after initial checks.

(Reference: SOP “Escalation Criteria (Tier 1 → Tier 2/Lead)”)

## Ticket Note Template (copy/paste)
**Alert / Report:**  
**User:**  
**Time Range:**  
**MFA Method:**  
**Source IP / Geo:**  
**Device / User Agent:**  
**IdP Outcome (MFA):**  
**What I Checked:**  
-  
-  
**Findings:**  
-  
-  
**Assessment (TP/FP and confidence level):**  
**Recommended Containment / Escalation:**  

## Definition of Done
- Ticket includes alert/report details, evidence checked, and final disposition.
- If escalated: Tier 2 has enough context to take action without repeating Tier 1 work.
