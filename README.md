# Data manipulation and analysis with SQL  
  

### N day retention  
Products: any.

**Task**  
We want to know what percentage of users return to our product on a specific day after their first visit. Users should be grouped by the date of the first visit.  
  
**Solution**  
[SQL](https://github.com/dzianissokalau/sql_analysis/blob/main/sql/n_day_retention.sql)  
[Description](https://github.com/dzianissokalau/sql_analysis/blob/main/description/n_day_retention.md)


  
### Segmentation searches by product categories  
Products: e-commerces, marketplaces.

**Task**  
When looking for goods or services users can: 
* navigate by selecting a relevant category (A);  
* use search (B);  
* combine search and category selection (C).  
We want to know what category users are interested in when they don't use category selection (B).  

**Solution**  
Find the most frequent category for each search term in subset C and extend it to subset B.  
  

