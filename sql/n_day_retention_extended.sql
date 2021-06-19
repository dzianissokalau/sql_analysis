-- calculate retention rate for every cohort_date and day_number pair
-- calculate retention rate as proportion of users opened the app on the day N and day 0
-- solving no visits days problem with sequence generator
WITH cohorts AS (
    SELECT cohort_date
        , day_number 
        , users / MAX(users) OVER (PARTITION BY cohort_date) AS retention_rate
    FROM (
        -- for every app open calculate number of days after the first visit
        -- count distinct number of users for every cohort_date and day_number pair
        SELECT cohort_date
            , DATE_DIFF(date, cohort_date, DAY) AS day_number
            , COUNT(DISTINCT user_id) AS users
        FROM (
            -- get the first app visit data for every user
            SELECT user_id
                , date
                , MIN(date) OVER (PARTITION BY user_id) AS cohort_date
            FROM `data-analysis-sql-309220.synthetic.app_open`
        ) AS a0
        GROUP BY 1,2
    ) AS a1
)
SELECT days.cohort_date
    , days.day_number
    , COALESCE(retention_rate, 0) AS retention_rate
FROM (
    -- generate sequence of numbers between 0 and 364 (first 365 days)
    SELECT cohort_date
        , day_number 
    FROM UNNEST(GENERATE_ARRAY(0, 364)) AS day_number
    -- join to every cohort date, so we will have retention for all days between 0 and 364
    CROSS JOIN (
        SELECT DISTINCT cohort_date
        FROM cohorts
    ) AS c0
    -- filter out future days
    WHERE DATE_ADD(cohort_date, INTERVAL day_number DAY) < CURRENT_DATE
) AS days
-- join cohorts and replace no visites days with 0 (retention rate = 0)
LEFT JOIN cohorts AS c1 ON c1.cohort_date = days.cohort_date
    AND c1.day_number = days.day_number
ORDER BY 1,2;