# 🛡️ KPI: Code Review Failure Rate

## 📖 Definition
The overall monthly percentage of User Stories that failed the **'Code Review'** status (transitioned to 'Failed Review'), out of all stories that entered that status.

## 💡 Business Value & Relevance
This is an **internal team efficiency metric**. It measures the "First-Pass Quality" of development work before it reaches formal QA.

**Interpreting the Signals:**
A high or rising failure rate points to specific systemic issues:
*   **Unclear Requirements:** Developers may be building the wrong thing due to poor specs.
*   **Poor Unit Testing:** Work is being submitted with obvious bugs that should have been caught locally.
*   **Inconsistent Standards:** The team isn't aligned on what "good code" looks like.

## ⚡ Actionable Insights
As a Project Manager, I use this data to drive improvements, not to blame individuals. When this metric spikes, the corrective actions include:
*   Facilitating team discussions on the **Definition of Ready (DoR)**.
*   Reviewing and standardizing **Coding Standards**.
*   Implementing **Pre-review Checklists** to ensure code is truly ready for peer review.

## 📋 Scope & Assumptions
*   **Scope:** Includes only User Stories with a final status of `Done`.
*   **Cohort Alignment:** Calculated monthly, based on the month the story **first entered 'Under Validation' (QA)**. This ensures this quality metric aligns with the "Time to QA" KPI.
*   **Assumption:** This metric reflects the quality of the team's *collective* output.

## ⚙️ Technical Logic
The SQL logic (found in `code_review_failure_rate.sql`) includes advanced filtering:
1.  **Denominator:** Counts *unique* stories. If a story fails 3 times, it is still one "opportunity," but generates 3 "failure" events.
2.  **Developer Mapping:** The query includes logic to attribute stories to specific developers (based on who moved it to 'Rea
