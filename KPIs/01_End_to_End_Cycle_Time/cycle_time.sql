/*
   KPI: User Stories Average End-to-End Cycle Time
   Description: Calculates the average days from 'Ready' to 'Done'.
   Target Project: Core Platform Development
*/

WITH story_individual_times AS (
    -- Step 1: Isolate the start and end timestamps for every story.
    -- We use MIN/MAX to capture the *first* time it became Ready and the *last* time it was Done.
    SELECT
        MIN(CASE WHEN h.status = 'Ready' THEN h.started_at END) AS start_time,
        MAX(CASE WHEN h.status = 'Done' THEN h.started_at END) AS end_time
    FROM
        jira_issue AS i
        JOIN jira_project AS p ON i.project_id = p.project_id
        JOIN jira_issue_status_history AS h ON i.issue_id = h.issue_id
    WHERE
        p.name = 'Core_Platform_Project' -- Genericized Project Name
        AND i.issue_type = 'Story'
        AND i.status = 'Done'
    GROUP BY
        i.issue_key, i.parent_issue_id
)

-- Step 2: Aggregate by month to show the trend over time.
SELECT
    CAST(DATE_TRUNC('month', end_time) AS date) AS month_completed,
    -- Calculate the delta in days and average it for the month
    AVG(DATEDIFF(day, start_time, end_time)) AS average_cycle_time_days
FROM
    story_individual_times
WHERE
    start_time IS NOT NULL AND end_time IS NOT NULL
GROUP BY
    month_completed
ORDER BY
    month_completed ASC;
