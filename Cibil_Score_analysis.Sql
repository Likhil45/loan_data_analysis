/*
Methodology

Step 1: Define Narrow Bins for CIBIL Scores:
CIBIL scores typically range from 300 to 900.
Use narrow bins (e.g., 25-point or 50-point intervals) to capture granular trends. Example bins: 300–325, 325–350, ..., 875–900.
Narrow bins (e.g., 25 points) provide finer resolution but require sufficient data per bin to ensure reliable approval rate calculations.

Step 2: Calculate Approval Rates per Bin:
For each bin, compute the approval rate:


*/

SELECT 
  cibil_score_bin,
  COUNT(*) AS total_loans,
  SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS approved_loans,
  ROUND(100.0 * SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate
FROM (
  SELECT 
    loan_id,
    cibil_score,
    loan_status,
    
    -- Bin CIBIL scores into 25-point intervals
    CASE 
      WHEN cibil_score BETWEEN 300 AND 324 THEN '300-324'
      WHEN cibil_score BETWEEN 325 AND 349 THEN '325-349'
      WHEN cibil_score BETWEEN 350 AND 374 THEN '350-374'
      WHEN cibil_score BETWEEN 375 AND 399 THEN '375-399'
      WHEN cibil_score BETWEEN 400 AND 424 THEN '400-424'
      WHEN cibil_score BETWEEN 425 AND 449 THEN '425-449'
      WHEN cibil_score BETWEEN 450 AND 474 THEN '450-474'
      WHEN cibil_score BETWEEN 475 AND 499 THEN '475-499'
      WHEN cibil_score BETWEEN 500 AND 524 THEN '500-524'
      WHEN cibil_score BETWEEN 525 AND 549 THEN '525-549'
      WHEN cibil_score BETWEEN 550 AND 574 THEN '550-574'
      WHEN cibil_score BETWEEN 575 AND 599 THEN '575-599'
      WHEN cibil_score BETWEEN 600 AND 624 THEN '600-624'
      WHEN cibil_score BETWEEN 625 AND 649 THEN '625-649'
      WHEN cibil_score BETWEEN 650 AND 674 THEN '650-674'
      WHEN cibil_score BETWEEN 675 AND 699 THEN '675-699'
      WHEN cibil_score BETWEEN 700 AND 724 THEN '700-724'
      WHEN cibil_score BETWEEN 725 AND 749 THEN '725-749'
      WHEN cibil_score BETWEEN 750 AND 774 THEN '750-774'
      WHEN cibil_score BETWEEN 775 AND 799 THEN '775-799'
      WHEN cibil_score BETWEEN 800 AND 824 THEN '800-824'
      WHEN cibil_score BETWEEN 825 AND 849 THEN '825-849'
      WHEN cibil_score BETWEEN 850 AND 874 THEN '850-874'
      WHEN cibil_score BETWEEN 875 AND 900 THEN '875-900'
      ELSE 'Outlier'
    END AS cibil_score_bin

  FROM 
    world.loan_approval

  WHERE 
    cibil_score BETWEEN 300 AND 900  -- Filter out known outliers
) AS scored_data

GROUP BY 
  cibil_score_bin

HAVING 
  COUNT(*) > 30  -- Minimum sample size to avoid noise

ORDER BY 
  cibil_score_bin;
