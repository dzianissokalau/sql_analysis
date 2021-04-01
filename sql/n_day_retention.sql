-- calculate retention rate for every cohort_date and day_number pair
-- calculate retention rate as proportion of users opened the app on the day N and day 0
SELECT cohort_date
    , day_number 
    , users / FIRST_VALUE(users) OVER (PARTITION BY cohort_date ORDER BY day_number ASC) AS retention_rate
FROM (
    -- for every app open calculate number of days after the first visit
    -- count distinct number of users for every cohort_date and day_number pair
    SELECT cohort_date
        , DATE_DIFF(date, cohort_date, DAY) AS day_number
        , COUNT(DISTINCT user_id) AS users
    FROM (
        -- get the first app visit data for every iser
        SELECT user_id
            , date
            , MIN(date) OVER (PARTITION BY user_id) AS cohort_date
        FROM `data-analysis-sql-309220.synthetic.app_open`
    ) AS a0
    GROUP BY 1,2
) AS a1
ORDER BY 1,2