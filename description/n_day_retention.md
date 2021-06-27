# N day retention  
  
**Task**  
We want to know what percentage of users return to our product on a specific day after their first visit. Users should be grouped by the date of the first visit. 


1. Find the first app open date for every user. Probably the most tidy and efficient way of doing it would be a window function:  
```sql
MIN(date) OVER (PARTITION BY user_id) AS cohort_date
```  
2. On the next step we need to calculate unique number of users for evey combination of `cohort_date` (see above) and difference between `cohort_date` and the date of visit:  
```sql
SELECT cohort_date
    , DATE_DIFF(date, cohort_date, DAY) AS day_number
    , COUNT(DISTINCT user_id) AS users
```  
3. Now when we have number of users for every `cohort_date` and `day_number` combination, we can calculate N day retention itself:  
```sql
users / MAX(users) OVER (PARTITION BY cohort_date) AS retention_rate
```   
4. Generating sequence of numbers. It will help to have result for each day number even if there were no users on this day. Below is Big Query variant, other data bases may have different approaches. Alternatively a table may be used.  
```sql
SELECT day_number FROM UNNEST(GENERATE_ARRAY(0, 364)) AS day_number
```    
5. Join generated day_numbers and cohort dates to get all combination of `cohort_date` and `day_number`. With this approach we should remove all future days:  
```sql
WHERE DATE_ADD(cohort_date, INTERVAL day_number DAY) < CURRENT_DATE
```  
6. Finally join retention and all posible combination of `cohort_date` and `day_number` and fill missing values with 0:   
```sql
COALESCE(retention_rate, 0) AS retention_rate
```   
  
The full query is buy the link: https://github.com/dzianissokalau/sql_analysis/blob/main/sql/n_day_retention.sql  

