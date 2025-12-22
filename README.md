# 📊 Atlassian Analytics: Agile KPI Framework

## Executive Summary
**Transitioning Project Management from Intuition to Data.**

This repository contains the architecture and SQL logic for a comprehensive KPI framework built within **Atlassian Analytics (Data Lake)**. 

As a Project Manager, I identified a critical gap in our development process: while we were tracking ticket statuses, we lacked granular visibility into **flow efficiency**, **bottlenecks**, and **first-pass quality**. To solve this, I designed a custom analytics dashboard to provide objective metrics for Retrospectives and resource planning.

## 🎯 The Business Problem
The development team was operating in a "black box." Stakeholders knew when a sprint started and ended, but we lacked answers to critical questions:
*   *How long does a story actually sit in "Ready" before work begins?*
*   *How much time is lost to rework and code review failures?*
*   *What is our true End-to-End Cycle Time versus our estimated velocity?*

## 💡 The Solution
I engineered a series of SQL queries to extract raw data from the Jira Data Lake, transform it into meaningful metrics, and visualize it for the team.

### Core Metrics Implemented:
*   ** Flow Efficiency:** Average End-to-End Cycle Time (Concept to Cash).
*   ** Throughput:** Time to First QA Deployment (Development Speed).
*   ** Quality Assurance:** Code Review Failure Rate (Systemic Rework Analysis).
*   ** Performance:** Developer-specific Quality Metrics.

## 📂 Repository Structure
This repository is organized by KPI. Each directory contains the SQL logic and a specific explanation of the metric's intent.

## 🛠️ Technology & Methodology
*   **Platform:** Atlassian Analytics (Jira Data Lake).
*   **Language:** SQL (PostgreSQL dialect).
*   **Techniques Used:**
    *   `CTE` (Common Table Expressions) for modular query building.
    *   `Window Functions` (`ROW_NUMBER`, `LAG`) to track status transitions.
    *   `DATEDIFF` logic for precise business-day calculations.
*   **AI Implementation:** As a PM leveraging modern tools, I utilized AI to draft complex syntax patterns, which I then validated against internal datasets to ensure logic accuracy and data integrity.

## 📈 Impact
Implementing this framework allowed the team to:
1.  **Objectively measure** the impact of process changes.
2.  **Identify bottlenecks** in the QA handoff process.
3.  **Reduce rework** by visualizing code review failure trends.

## Roadmap & Future Iterations
This framework is currently in **Phase 1 (MVP)**, focusing on core flow and quality metrics. 

**Planned upcoming modules:**
*   Time in Code Review
*   Time in QA Validation
*   QA Rejection Rate
*   UAT Rejection Rate
*   Bug Density
