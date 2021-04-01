# N day retention  
  
N day retention shows the percent of users who return to the app on a specified day after their first visit.  
  
In order to calculate N day retention, we need to follow the next steps (BigQuery syntax is used).  
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

The full query is buy the link: https://github.com/dzianissokalau/sql_analysis/blob/main/sql/n_day_retention.sql  

