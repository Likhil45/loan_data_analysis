/* 
Compute the asset-to-loan ratio for each loan application and analyze its relationship with loan_status.

Segment the ratio into buckets (e.g., <1, 1–2, 2–5, >5) and calculate approval rates for each bucket. For example, a ratio >5 (assets significantly exceed loan amount) might have a 90% approval rate, while a ratio <1 might have a 30% approval rate.
*/

SELECT 
  CASE 
    WHEN (residential_assets_value + commercial_assets_value + luxury_assets_value + bank_asset_value) / loan_amount < 1 THEN '<1'
    WHEN (residential_assets_value + commercial_assets_value + luxury_assets_value + bank_asset_value) / loan_amount BETWEEN 1 AND 2 THEN '1-2'
    WHEN (residential_assets_value + commercial_assets_value + luxury_assets_value + bank_asset_value) / loan_amount BETWEEN 2 AND 5 THEN '2-5'
    ELSE '>5'
  END AS ratio_bucket,
  
  COUNT(*) AS total_applications,
  
  SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS approved_count,
  
  ROUND(100.0 * SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate_percentage

FROM 
  world.loan_approval

GROUP BY 
  ratio_bucket
ORDER BY 
  approval_rate_percentage DESC;
