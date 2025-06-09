/*
Step 1: Define Loan Term Buckets:
Group loan_term into meaningful buckets based on typical loan durations. For example:
Short-term: 1–5 years
Medium-term: 6–10 years
Long-term: 11–20 years
Very long-term: >20 years
Adjust buckets based on the dataset’s range (e.g., if loan_term is in months, use 12–60 months, 61–120 months, etc.).
Step 2: Calculate Frequency:
Count the number of loan applications in each bucket to determine their prevalence.
Example: 500 applications in the 1–5 year bucket, 300 in the 6–10 year bucket, etc.
Step 3: Calculate Approval Rates:
Compute the approval rate for each bucket
*/
SELECT 
  loan_term_bucket,
  COUNT(*) AS total_applications,
  SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS approved_applications,
  ROUND(100.0 * SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate
FROM (
  SELECT 
    loan_id,
    loan_term,
    loan_status,

    CASE 
      WHEN loan_term BETWEEN 12 AND 60 THEN 'Short-term (1–5 yrs)'
      WHEN loan_term BETWEEN 61 AND 120 THEN 'Medium-term (6–10 yrs)'
      WHEN loan_term BETWEEN 121 AND 240 THEN 'Long-term (11–20 yrs)'
      WHEN loan_term > 240 THEN 'Very long-term (>20 yrs)'
      ELSE 'Unknown'
    END AS loan_term_bucket

  FROM world.loan_approval
  WHERE loan_term IS NOT NULL
) AS term_grouped

GROUP BY loan_term_bucket
ORDER BY 
  FIELD(loan_term_bucket, 
    'Short-term (1–5 yrs)', 
    'Medium-term (6–10 yrs)', 
    'Long-term (11–20 yrs)', 
    'Very long-term (>20 yrs)', 
    'Unknown');
