/* Group cibil_score into ranges (e.g., <600, 600–700, 700–800, >800).

Approval Rate Calculation: Calculate approval rates for each range. For example:

<600: 20% approval rate
600–700: 50% approval rate
700–800: 80% approval rate
800: 95% approval rate
*/

SELECT 
  cibil_score_range,
  COUNT(*) AS total_loans,
  SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS approved_loans,
  ROUND(100.0 * SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate
FROM (
  SELECT 
    loan_id,
    cibil_score,
    loan_status,
    
    CASE 
      WHEN cibil_score < 600 THEN '<600'
      WHEN cibil_score BETWEEN 600 AND 700 THEN '600-700'
      WHEN cibil_score BETWEEN 701 AND 800 THEN '701-800'
      WHEN cibil_score > 800 THEN '>800'
    END AS cibil_score_range

  FROM world.loan_approval
  WHERE cibil_score BETWEEN 300 AND 900  -- filter outliers
) AS scored_data

GROUP BY cibil_score_range
ORDER BY 
  FIELD(cibil_score_range, '<600', '600-700', '701-800', '>800');

