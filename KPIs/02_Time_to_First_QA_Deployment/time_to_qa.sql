/*
   KPI: Time to First QA Deployment
   Description: Measures development throughput by calculating the time from 'Ready' to the *first* handoff to QA ('Under Validation').
   Target Project: Core Platform Development
*/

WITH story_development_times AS (
    -- Step 1: Isolate timestamps for the Development Phase.
    SELECT
        -- Start Clock: The earliest time the story was committed to (Ready)
        MIN(CASE WHEN h.status = 'Ready' THEN h.started_at END) AS start_time,
        
        -- Stop Clock: The earliest time the story was handed to QA (Under Validation).
        -- We use MIN() here to capture the *first* attempt at QA, even if it failed later.
        MIN(CASE WHEN h.status = 'UNDER VALIDATION' THEN h.started_at END) AS end_time
    FROM
        jira_issue AS i
        JOIN jira_project AS p ON i.project_id = p.project_id
        JOIN jira_issue_status_history AS h ON i.issue_id = h.issue_id
    WHERE
        p.name = 'Core_Platform_Project' -- Genericized Project Name
        AND i.issue_type = 'Story'
        AND i.status = 'Done' -- Scope: Only fully completed stories to ensure data integrity
    GROUP BY
        i.issue_key, i.parent_issue_id
)

-- Step 2: Aggregate by month to visualize the trend.
SELECT
    CAST(DATE_TRUNC('month', end_time) AS date) AS month_completed,
    -- Calculate the average development duration in days
    AVG(DATEDIFF(day, start_time, end_time)) AS average_development_time_days
FROM
    story_development_times
WHERE
    start_time IS NOT NULL AND end_time IS NOT NULL
GROUP BY
    month_completed
ORDER BY
    month_completed ASC;
