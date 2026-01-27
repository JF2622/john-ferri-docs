# Query Examples (Pseudo-Queries for Tier 1 SOC)

## Purpose
Provide tool-agnostic examples of how a Tier 1 analyst can quickly validate common authentication and alert scenarios using log searches. These are written as **pseudo-queries** with light examples to translate into your environment (SIEM, IdP logs, EDR, etc.).

## Conventions
- `AUTH_LOGS` = identity provider / authentication event source (IdP sign-ins, SSO logs)
- `MFA_LOGS` = MFA challenge/verification events (push/SMS/TOTP outcomes)
- `VPN_LOGS` = remote access logs (if applicable)
- `timestamp` fields may differ by platform (e.g., `TimeGenerated`, `@timestamp`)
- Replace `user`, `src_ip`, `geo`, `device_id`, `user_agent` with your schema

## Quick Filters (Reusable)
- **User filter:** `user == "jdoe@example.com"`
- **Time range:** `timestamp between (T-1h, T)`
- **Success/Failure:** `result in ("success","failure")`
- **MFA outcome:** `mfa_result in ("approved","denied","timeout")`

---

## Scenario 1 — Suspicious Login / Impossible Travel

### 1A) Find all sign-ins for a user (last 24 hours)
**Goal:** establish baseline activity and identify anomalies.

```text
FROM AUTH_LOGS
WHERE user == "<USER>"
  AND timestamp >= now() - 24h
SELECT timestamp, result, src_ip, geo_country, geo_city, device_id, user_agent, risk_level
ORDER BY timestamp DESC
```

### 1B) Detect concurrent sign-ins for a user (last 24 hours)
**Goal:** Identify "impossible travel" patterns. 

```text
FROM AUTH_LOGS
WHERE user == "<USER>"
  AND timestamp >= now() - 24h
GROUP BY user, device_id
WINDOW 10m
CALCULATE distinct(geo_country), distinct(src_ip)
WHERE distinct(geo_country) >= 2 OR distinct(src_ip) >= 2
```

### 1C) Success after repeated failures (credential guessing) 
**Goal:** See whether a brute-force or spray led to a successful login. 

```text
FROM AUTH_LOGS
WHERE user == "<USER>"
  AND timestamp >= now() - 24h
GROUP BY user
WINDOW 30m
CALCULATE count_if(result=="failure"), count_if(result=="success")
WHERE count_if(result=="failure") >= 10 AND count_if(result=="success") >= 1
```

## Scenario 2 - MFA Fatigue (Push Bombing)

### 2A) Count MFA Challenges for a User (15-Minute Time Window)
**Goal:** Confirm prompt volume and outcomes. 

```text
FROM MFA_LOGS
WHERE user == "<USER>"
  AND timestamp >= now() - 2h
GROUP BY user
WINDOW 15m
CALCULATE count(*), count_if(mfa_result=="approved"), count_if(mfa_result=="denied"), count_if(mfa_result=="timeout")
WHERE count(*) >= 5
```

### 2B) Identify top users by MFA prompt volume (triage queue support)
**Goal:** Quickly find the noisiest and/or highest-risk cases.

```text
FROM MFA_LOGS
WHERE timestamp >= now() - 1h
GROUP BY user
CALCULATE count(*) AS mfa_prompts
ORDER BY mfa_prompts DESC
LIMIT 20

```

### 2C) MFA Fatigue and Suspicious Sign-In Correlation
**Goal:** Tie prompts to sign-in attempts and determine whether success occurred. 

```text
JOIN AUTH_LOGS AS a WITH MFA_LOGS AS m
ON a.user == m.user
AND abs(a.timestamp - m.timestamp) <= 5m
WHERE a.user == "<USER>"
  AND a.timestamp >= now() - 24h
SELECT a.timestamp, a.result, a.src_ip, a.geo, m.mfa_result, a.device_id
ORDER BY a.timestamp DESC
```

## Scenario 3 - Password Spray Indicators (Many Users, One IP)

### 3A) Identify IPs failing across many usernames (last 60 minutes)
**Goal:** Spot spray sources early. 

```text
JOIN AUTH_LOGS AS a WITH MFA_LOGS AS m
ON a.user == m.user
AND abs(a.timestamp - m.timestamp) <= 5m
WHERE a.user == "<USER>"
  AND a.timestamp >= now() - 24h
SELECT a.timestamp, a.result, a.src_ip, a.geo, m.mfa_result, a.device_id
ORDER BY a.timestamp DESC
```

### 3B) Identify targeted users for a suspected spray IP
**Goal:** Support blocking/escalation decisions.

```text
FROM AUTH_LOGS
WHERE timestamp >= now() - 60m
  AND result == "failure"
GROUP BY src_ip
CALCULATE distinct(user) AS unique_users, count(*) AS failures
WHERE unique_users >= 10 OR failures >= 50
ORDER BY unique_users DESC, failures DESC
```

## Scenario 4 - New Device/New User Agent

### 4A) Identify "new device" events for a user (last 30 days)
**Goal:** Determine whether the device is genuinely new.

```text
FROM AUTH_LOGS
WHERE user == "<USER>"
  AND timestamp >= now() - 30d
GROUP BY device_id
CALCULATE min(timestamp) AS first_seen, max(timestamp) AS last_seen, count(*) AS signins
ORDER BY first_seen DESC
```

### 4B) Find first-seen user agent strings
**Goal:** Spot new browsers/automation frameworks.

```text
FROM AUTH_LOGS
WHERE user == "<USER>"
  AND timestamp >= now() - 30d
GROUP BY user_agent
CALCULATE min(timestamp) AS first_seen, count(*) AS events
ORDER BY first_seen DESC
```

## Scenario 5 - VPN vs. Non-VPN Context (if Applicable)

### 5A) Determine whether a suspicious sign-in aligns with a VPN connection
**Goal:** Reduce false positives when corporate egress is involved. 

```text
JOIN AUTH_LOGS AS a WITH VPN_LOGS AS v
ON a.user == v.user
AND abs(a.timestamp - v.timestamp) <= 10m
WHERE a.user == "<USER>"
  AND a.timestamp >= now() - 24h
SELECT a.timestamp, a.src_ip, a.geo, v.vpn_gateway, v.vpn_src_ip
ORDER BY a.timestamp DESC
```

## Escalation Evidence Checklist (What to Include with Query Output)
### When escalating, capture: 
- Query name/purpose
- Time range used
- Key rows (timestamps, IPs, geo, device/user-agent, outcomes)
- Counts (failures, MFA prompts, distinct users)
- Interpretation (what it likely indicates, plus the confidence level)

(References: SOP Escalation Criteria and the Ticket Note Examples)