# Documentation Style Guide

## Purpose
This guide defines writing and formatting standards for this documentation set, so that pages remain consistent, scannable, and easy to maintain.

## Voice and Tone
- Use **imperative, action-oriented** steps (e.g., “Open the IdP logs,” “Verify MFA outcome”).
- Prefer **plain language** over jargon. Define acronyms on first use.
- Be **concise:** short sentences, short paragraphs
- Use **consistent terminology** (see Capitalization and Terms).

## Audience
Primary: Tier 1 SOC analysts (new hires)  
Secondary: Tier 2/Lead analysts who receive escalations

## Capitalization and Terms
Use these consistently:
- **SOC**, **SIEM**, **SOAR**, **EDR**, **MFA**, **IdP**
- **Tier 1**, **Tier 2** (not “tier-1” unless required by a system)
- **Playbook** (page type), **SOP** (standard operating procedure)

If you introduce a new acronym, then please spell it out once:
- Example: “Identity provider (IdP)”

## Page Structure Standards

### SOP pages should include
- Purpose
- Scope
- Prerequisites
- Procedure / Workflow
- Escalation Criteria
- Troubleshooting
- Glossary
- Definition of Done (optional but recommended)

### Playbooks should include
- Purpose
- When to Use
- Required Inputs
- Data Sources to Check
- Triage Steps (Tier 1)
- Common False Positives
- Escalation Criteria (link back to SOP)
- Ticket Note Template
- Definition of Done

## Lists and Formatting Rules

### Numbered steps
- Use numbered lists for procedures.
- Keep list items short and parallel in structure.
- Avoid random blank lines in lists.
- If a step contains sub-bullets, indent them **4 spaces**:

```md
3. Example step:
    - Sub-bullet A
    - Sub-bullet B
