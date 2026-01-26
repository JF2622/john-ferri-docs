# Playbook: Suspicious Logins and Impossible Travel

## Purpose
This playbook serves to help Tier 1 analysts quickly validate and respond to alerts indicating suspicious authentication activity (e.g., impossible travel, an unfamiliar location or device, and/or abnormal login patterns).

## When to Use
- **SIEM Alert:** Impossible travel or geo-velocity
- **IdP Alert:** Risky sign-in or unfamiliar location
- **User Report:** “I received an MFA prompt that I did not approve.”
- Multiple failed logins followed by a success

## Required Inputs
- Username or UPN
- Timestamp Range (UTC and Local)
- Source IP(s)
- Location (Geo)
- User Agent / Device Info (if available)
- IdP / VPN / Email Platform Involved (Okta/Azure AD/etc.)

## Data Sources to Check
- IdP Sign-in Logs (risk events, MFA outcomes)
- VPN Logs (if remote access is in scope)
- Endpoint/EDR (if device compromise is suspected)
- Email Logs (if session hijack/phishing is suspected)
- Ticketing System (recent access requests / travel notices / change windows)

## Triage Steps (Tier 1)
1. Confirm the alert details (user, IP, geo, time, device).
2. Check if the source IP is known/benign (corporate egress, VPN, ISP, known vendor).
3. Review sign-in pattern:
    - Failed attempts count
    - Success after failures
    - MFA result (approved/denied/timed out)
4. Look for concurrent sign-ins from different geos/devices in a short window.
5. Check if the user is traveling or on PTO (ticket notes, travel notice, manager note if available).
6. Validate device context (known device? new device registration? unusual user agent?).
7. Assess account privilege (admin role, sensitive systems, VIP status).
8. If the user reported unexpected MFA, treat that event as higher-confidence suspicious activity.
9. If evidence suggests compromise, prepare an escalation with key facts (see Escalation Criteria in the SOP).
10. Document actions and evidence in the ticket.

## Common False Positives
- Mobile carrier IP geolocation inaccuracies
- Corporate VPN/Proxy egress showing the “wrong” location
- Travel or remote work
- Password manager or background re-authentication (tokens refreshing)

## Escalation Criteria
- Escalate if any of the following apply:
    - Privileged/VIP account
    - MFA approved unexpectedly or “push fatigue” suspected
    - Success after repeated failures from unfamiliar IP/geo
    - Multiple geos/devices concurrently
    - You cannot confidently explain the activity after initial checks.

(Reference: SOP “Escalation Criteria (Tier 1 → Tier 2/Lead)”)

## Ticket Note Template (copy/paste)
**Alert:**  
**User:**  
**Time Range:**  
**Source IP / Geo:**  
**Device / User Agent:**  
**IdP Outcome (MFA):**  
**What I Checked:**  
-  
-  
**Findings:**  
-  
-  
**Assessment (TP/FP + confidence level):**  
**Recommended Next Action / Escalation:**  

## Definition of Done
- **Ticket Includes:** alert details, checks performed, evidence summary, and final disposition (closed as FP, contained/escalated).
- **If Escalated:** Tier 2 has the minimum required context to continue the investigation without rework.
