# KPI: User Stories Average End-to-End Cycle Time

## 📖 Definition
The average number of days required to deliver a User Story from the moment it is committed to development (`Ready`) until it is fully completed and approved (`Done`).

> **Formula:**
> $$ \text{Avg Cycle Time} = \frac{\sum (\text{Max(Date Done)} - \text{Min(Date Ready)})}{\text{Total Stories Completed}} $$

## 💡 Business Value & Management Insights
This metric is the primary indicator of **Flow Efficiency**. It measures the total time to deliver value, capturing every stage of the lifecycle including Development, QA, and UAT (Validation).

**How we interpret the signals:**
*   **✅ Stable/Flat Trend:** The team is reliably shipping finished work; process is predictable.
*   **⚠️ Rising Trend:** Highlights systemic issues across the pipeline (Dev + QA + Validation).

**Key Questions Prompts:**
When this metric spikes, it triggers a root-cause analysis:
1.  *Is QA becoming a bottleneck?* (Waiting time increasing).
2.  *Are we seeing increased rework?* (Stories bouncing between Dev and Test).
3.  *Are requirements unclear?* (Development taking longer than estimated).

## Scope & Assumptions
*   **Scope:** Includes only `User Stories` with a final status of `Done`.
*   **Aggregation:** Calculated monthly, based on the month the story was *completed*.
*   **Assumption:** The developer changes the Jira status to "Ready" immediately when work begins.

## Technical Implementation
The SQL logic (found in `cycle_time.sql`) addresses the complexity of Jira's history table:
1.  **Timestamp Isolation:** Uses `MIN(Ready)` to capture the *first* start time and `MAX(Done)` to capture the *final* completion time, effectively accounting for any rework loops where a ticket might move back and forth.
2.  **Exclusions:** Filters out non-story items (Bugs, Tasks) to ensure we are measuring feature velocity.

## 📊 Visualisation
![Cycle Time Chart](./cycle_time_chart.png)
