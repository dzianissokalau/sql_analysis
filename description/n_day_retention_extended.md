# N day retention with solution for days with no visits 
  
This is an extention of basic N day retention query: https://github.com/dzianissokalau/sql_analysis/blob/main/description/n_day_retention.md  
  
With the extention we can calculate retention for days when there were no visits for a particular cohort. This is done by generating a sequence of numbers between 0 (day of cohort) and the calculation horizon and then using it to get full set of days for all cohorts.
    
Generating sequence of numbers (Big Query variant)
```sql
-- generate sequence of numbers between 0 and 364
SELECT day_number FROM UNNEST(GENERATE_ARRAY(0, 364)) AS day_number;
```   

The full query is buy the link: https://github.com/dzianissokalau/sql_analysis/blob/main/sql/n_day_retention_extended.sql  

