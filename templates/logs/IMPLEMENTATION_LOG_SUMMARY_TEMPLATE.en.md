> ⚙️ **הודעת תבנית:**  
> This file is an official Docs-as-System template.  
> Do not edit it directly inside the project — when initializing a new system,  
> copy it to the `docs/logs/` folder and rename it according to your cycle.  
> The output language is automatically determined by the file suffix:  
> - If the file name ends with `he.md` → the agent generates the summary in Hebrew.  
> - If the file name ends with `en.md` → the agent generates the summary in English.  
> The selection occurs automatically at each `BY_CYCLE` execution based on the file name suffix.

# Implementation Log Summary Template (BY_CYCLE)

**In-project file:** `docs/logs/IMPLEMENTATION_LOG_SUMMARY_BY_CYCLE.md`  
**Template location:** `templates/logs/IMPLEMENTATION_LOG_SUMMARY_TEMPLATE.en.md`  

**Purpose:**  
Provide a concise overview of development status for a specific work cycle —  
how many commits were made, how many were human-approved, which exceptions are open,  
and the overall validation results.  

The agent automatically generates and updates this file  
based on data from `docs/logs/IMPLEMENTATION_LOG.md`.

---

## Cycle Information

| Field | Value |
|--------|--------|
| **Cycle ID** | CY-YYYY-MM-NN |
| **Period** | YYYY-MM-DD → YYYY-MM-DD |
| **Last Updated** | YYYY-MM-DD HH:MM |
| **Total Commits** | 0 |
| **Human-Approved Commits** | 0 (0%) |
| **Active Exceptions** | 0 |
| **Overall Status** | ✅ Stable / ⚠️ Warnings / ❌ Issues |

---

## Recent Actions

| Date | Action | Status | Executed By | Approved By |
|------|---------|---------|--------------|--------------|
| YYYY-MM-DD | Commit | Passed | Agent | Tomer Kedem |
| YYYY-MM-DD | Merge | Passed | Human | — |
| YYYY-MM-DD | Test | Warning | Agent | — |

> Up to 10 most recent records are displayed.  
> The agent refreshes this section automatically on every CI run or new PR event.

## Active Exceptions

| ID | Description | Status | Created By | Last Updated |
|------|--------------|---------|-------------|----------------|
| EXC-000 | Security issue in communication module | Open | Agent | YYYY-MM-DD |
| EXC-001 | Integration test failure | Fixed | Human | YYYY-MM-DD |

> Closed exceptions are automatically archived.  
> Only currently active issues are shown here.


## General Metrics

| Metric | Current Value | Target | Notes |
|----------|----------------|---------|--------|
| Commits by Agent | 0 | — | Updated automatically |
| Human-approved Commits | 0% | ≥ 90% | Quality indicator |
| Avg. PR Approval Time | 0 min | — | Calculated by CI |
| Open Exceptions | 0 | 0 | Target: none active |

---

## Data Sources

- Logs are retrieved from `docs/logs/IMPLEMENTATION_LOG-YYYY-MM.md` files.  
- Data is updated by the agent at runtime and after each pipeline completes.  
- This file is never edited manually — every cycle summary is regenerated automatically.  
- Historical summaries are stored in the `docs/logs/archive/` directory.

---

## Usage Notes

- This file provides a current snapshot of the system state per cycle.  
- It should not be modified manually — any edits will be overwritten by the agent.  
- The summary serves both human and automated audit processes.  
- For historical data, refer to previous cycle summaries in `docs/logs/archive/`.

---

## Summary

`IMPLEMENTATION_LOG_SUMMARY_BY_CYCLE.md` gives a clear, human-readable overview of each work cycle.  
It helps teams quickly assess project progress, validate agent performance,  
and review ongoing issues at a glance.  

This file bridges the technical implementation logs with management-level reporting  
and serves as the operational truth for any Docs-as-System–based project.

---

> © 2025 Tomer Kedem. Part of the official **Docs-as-System** template collection.
