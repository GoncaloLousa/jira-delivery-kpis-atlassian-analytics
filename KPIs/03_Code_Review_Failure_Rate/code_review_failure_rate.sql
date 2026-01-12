/*
   KPI: Code Review Failure Rate (Quality Metric)
   Description: Calculates the percentage of stories that fail peer review.
   Features: Includes logic to attribute stories to specific developers based on workflow transitions.
   Target Project: Core Platform Development
*/

-- Step 1: Developer Attribution Logic
-- Uses Window Functions to identify the primary developer (the first person to transition the story to 'Ready').
WITH developer_mapping AS (
    SELECT
        issue_id,
        author_account_id AS developer_account_id
    FROM (
        SELECT
            h.issue_id,
            h.author_account_id,
            ROW_NUMBER() OVER (PARTITION BY h.issue_id ORDER BY h.started_at ASC) AS rn
        FROM
            jira_issue_status_history AS h
        WHERE
            h.status = 'Ready'
    ) ranked
    WHERE rn = 1
),

-- Step 2: Define Monthly Cohorts
-- Groups stories by the month they entered the QA phase ('Under Validation').
monthly_cohorts AS (
    SELECT
        i.issue_id,
        CAST(DATE_TRUNC('month', MIN(CASE WHEN h.status = 'UNDER VALIDATION' THEN h.started_at END)) AS date) AS month_completed_dev
    FROM
        jira_issue AS i
        JOIN jira_project AS p ON i.project_id = p.project_id
        JOIN jira_issue_status_history AS h ON i.issue_id = h.issue_id
    WHERE
        p.name = 'Core_Platform_Project' -- Genericized Project Name
        AND i.issue_type = 'Story'
        AND i.status = 'Done'
    GROUP BY
        i.issue_id
),

-- Step 3: Calculate Failures (The Numerator)
-- Counts specific transitions where a story was rejected during Code Review.
failure_counts AS (
    SELECT
        c.month_completed_dev,
        COUNT(h.issue_id) AS total_failures
    FROM
        jira_issue_status_history AS h
        JOIN monthly_cohorts AS c ON h.issue_id = c.issue_id
        JOIN developer_mapping AS dm ON h.issue_id = dm.issue_id
        JOIN account AS acc ON dm.developer_account_id = acc.account_id
    WHERE
        h.prev_status = 'Code Review' 
        AND h.status = 'FAILED REVIEW'
        -- Dynamic Variable: Allows dashboard users to filter by specific team members
        AND acc.name IN ({TEAM_MEMBER}) 
    GROUP BY
        c.month_completed_dev
),

-- Step 4: Calculate Total Opportunities (The Denominator)
-- Counts unique stories that went through the Code Review process.
opportunity_counts AS (
    SELECT
        c.month_completed_dev,
        COUNT(DISTINCT c.issue_id) AS total_opportunities
    FROM
        jira_issue_status_history AS h
        JOIN monthly_cohorts AS c ON h.issue_id = c.issue_id
        JOIN developer_mapping AS dm ON h.issue_id = dm.issue_id
        JOIN account AS acc ON dm.developer_account_id = acc.account_id
    WHERE
        h.status = 'Code Review'
        AND acc.name IN ({TEAM_MEMBER})
    GROUP BY
        c.month_completed_dev
)

-- Final Step: Calculate the Percentage
SELECT
    opp.month_completed_dev AS month,
    (COALESCE(fail.total_failures, 0) * 100.0) / opp.total_opportunities AS code_review_failure_rate_percent
FROM
    opportunity_counts AS opp
    LEFT JOIN failure_counts AS fail ON opp.month_completed_dev = fail.month_completed_dev
WHERE
    opp.total_opportunities > 0
ORDER BY
    month ASC;
