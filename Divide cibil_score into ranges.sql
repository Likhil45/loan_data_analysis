/* Divide cibil_score into ranges, e.g., <600 (poor), 600–700 (fair), 700–800 (good), 800+ (excellent).
Compute approval rates for each range. 
For example, <600 might have a 20% approval rate while 800+ has 95% */

WITH T1 AS (
  SELECT 
    cibil_score,
    CASE 
      WHEN cibil_score > 800 THEN 'Excellent'
      WHEN cibil_score BETWEEN 700 AND 800 THEN 'Good'
      WHEN cibil_score BETWEEN 600 AND 699 THEN 'Fair'
      WHEN cibil_score < 600 THEN 'Poor'
      ELSE 'Unknown'
    END AS credit_rating,
    CASE 
      WHEN cibil_score > 800 THEN '>800'
      WHEN cibil_score BETWEEN 700 AND 800 THEN '700–800'
      WHEN cibil_score BETWEEN 600 AND 699 THEN '600–699'
      WHEN cibil_score < 600 THEN '<600'
      ELSE 'Unknown'
    END AS cibil_range
  FROM world.loan_approval
),
T2 AS (
  SELECT credit_rating,cibil_range FROM T1
),
T3 AS (
  SELECT credit_rating,cibil_range, COUNT(*) AS status_count
  FROM T2
  GROUP BY credit_rating,cibil_range
),
T4 AS (
  SELECT COUNT(*) AS total_count FROM T2
)
SELECT 
  T3.credit_rating,
  T3.cibil_range,
  ROUND(T3.status_count * 100.0 / T4.total_count, 2) AS Approval_percentage
FROM T3, T4
ORDER BY 
  CASE 
    WHEN T3.credit_rating = 'Excellent' THEN 1
    WHEN T3.credit_rating = 'Good' THEN 2
    WHEN T3.credit_rating = 'Fair' THEN 3
    WHEN T3.credit_rating = 'Poor' THEN 4
    ELSE 5
  END;



 

