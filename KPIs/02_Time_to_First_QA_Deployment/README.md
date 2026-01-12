# ⚡ KPI: Time to First QA Deployment

## 📖 Definition
The average number of days from the moment development starts (`Ready`) until the story is **first** handed over to Quality Assurance (`Under Validation`).

## 💡 Business Value & Relevance
While "End-to-End Cycle Time" measures the whole process, this KPI isolates the **Development Phase**. It is a pure measure of coding throughput.

**Why we track this:**
*   **Leading Indicator:** If this number rises, it warns of problems *before* they impact the final delivery date.
*   **Smooth Flow:** A consistently low and predictable number indicates the team has a healthy backlog and clear requirements.

**Management Questions Triggered:**
If the trend line spikes, we ask:
1.  *Are user stories becoming too large or complex?* (Need for better slicing).
2.  *Is the team facing resource constraints or hidden wait times?*
3.  *Have priorities shifted mid-sprint, delaying the handover?*

## 📋 Scope & Assumptions
*   **Focus:** Throughput, not Quality. (Quality is measured by the *Code Review Failure Rate* KPI).
*   **Trigger:** The *first* time a ticket enters `Under Validation`. If a ticket fails QA and goes back to dev, that extra time is captured in "End-to-End Cycle Time," not here.
*   **Assumption:** Developers change status to `Ready` immediately upon starting work.

## 📊 Visualisation
![Time to QA Chart](./time_to_qa_chart.png)
