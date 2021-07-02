# Segmentation searches by product categories  
  
**Task**  
When looking for goods or services users can: 
* navigate by selecting a relevant category (A);  
* use search (B);  
* combine search and category selection (C).  

We want to know what category users are interested in when they don't use category selection (B).  

1. For searches with both search term and selected category, count frequency of search term - category pairs.  

2. Highlight the most frequent pair for each search term, for exqmple with:  
```sql
ROW_NUMBER() OVER (PARTITION BY search ORDER BY n DESC) AS r
```  
so the most frequent pair will have `r == 1`   

3. Left join the results with all searches and make sure that the right table only includes rows with `r = 1`.  

4. For searches where category was selected by user, remain initial values, for searches where category wasn't selected use the most frequent category for the search term.  
  
The full query is buy the link: https://github.com/dzianissokalau/sql_analysis/blob/main/sql/segment_searches.sql 
