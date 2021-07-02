-- query fills empy category with the most frequent category for the search term
SELECT s1.date
    , s1.user_id
    , s1.search
    , COALESCE(s1.category, s2.category) AS category
FROM search AS s1
-- create search term - category mapping
LEFT JOIN (
    SELECT search
        , category
        -- sort categories by frequency (descending) and calculate row number, so the most frequent category will have r = 1
        -- we can't use RANK, because if we have a few categories with the same frequency, it will return the same rank for them and duplicate rows in the end.
        -- altermatively we could use RANK and return list of the most frequent categories
        , ROW_NUMBER() OVER (PARTITION BY search ORDER BY n DESC) AS r
    FROM (
        SELECT LOWER(TRIM(search)) AS search
            , category
            , COUNT(*) AS n
        FROM searches
        WHERE search IS NOT NULL
            AND category IS NOT NULL
        GROUP BY 1,2
    ) AS a0
) AS s2 ON s2.search = LOWER(TRIM(s1.search)) 
    -- select only most frequent category
    AND s2.r = 1; 