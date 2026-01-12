/*
   KPI: Code Review Failure Rate by Developer
   Description: Break down of the failure rate metric by individual contributor.
   Logic: Attributes a story to a developer based on who first moved it to 'Ready'.
   Target Project: Core Platform Development
*/

-- Step 1: Developer Attribution Logic
-- We identify the "Responsible Developer" as the user who FIRST transitioned the story to 'Ready'.
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
-- Stories are grouped by the month they were handed off to QA ('Under Validation').
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

-- Step 3: Count Failures per Developer
failures_per_developer AS (
    SELECT
        mc.month_completed_dev,
        dm.developer_account_id,
        COUNT(h.issue_id) AS failure_count
    FROM
        jira_issue_status_history AS h
        JOIN monthly_cohorts AS mc ON h.issue_id = mc.issue_id
        JOIN developer_mapping AS dm ON h.issue_id = dm.issue_id
    WHERE
        h.prev_status = 'Code Review' AND h.status = 'FAILED REVIEW'
    GROUP BY
        mc.month_completed_dev, dm.developer_account_id
),

-- Step 4: Count Total Opportunities per Developer
opportunities_per_developer AS (
    SELECT
        mc.month_completed_dev,
        dm.developer_account_id,
        COUNT(DISTINCT h.issue_id) AS opportunity_count
    FROM
        jira_issue_status_history AS h
        JOIN monthly_cohorts AS mc ON h.issue_id = mc.issue_id
        JOIN developer_mapping AS dm ON h.issue_id = dm.issue_id
    WHERE
        h.status = 'Code Review'
    GROUP BY
        mc.month_completed_dev, dm.developer_account_id
)

-- Final Step: Calculate Percentage and Join Names
SELECT
    opp.month_completed_dev AS month,
    acc.name AS developer_name,
    (COALESCE(fail.failure_count, 0) * 100.0) / opp.opportunity_count AS code_review_failure_rate_percent
FROM
    opportunities_per_developer AS opp
    JOIN account AS acc ON opp.developer_account_id = acc.account_id
    LEFT JOIN failures_per_developer AS fail 
        ON opp.month_completed_dev = fail.month_completed_dev 
        AND opp.developer_account_id = fail.developer_account_id
WHERE
    opp.opportunity_count > 0
    -- Dynamic filter for Dashboard interaction
    AND acc.name IN ({TEAM_MEMBER})
ORDER BY
    month ASC, developer_name ASC;
