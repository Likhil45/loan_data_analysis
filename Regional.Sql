/* Divide residential_assets_value into three groups using percentiles or fixed thresholds:

Low: Bottom 33% (e.g., 0–33rd percentile or <$150,000).
Medium: Middle 33% (e.g., 33rd–66th percentile or $150,000–$600,000).
High: Top 33% (e.g., 66th–100th percentile or >$600,000).

Compute approval rates for each group:
*/ 

SELECT 
  asset_group,
  COUNT(*) AS total_loans,
  SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) AS approved_loans,
  ROUND(100.0 * SUM(CASE WHEN loan_status = 'Approved' THEN 1 ELSE 0 END) / COUNT(*), 2) AS approval_rate
FROM (
  SELECT 
    loan_id,
    loan_status,
    residential_assets_value,
    
    NTILE(3) OVER (ORDER BY residential_assets_value) AS asset_bucket

  FROM world.loan_approval
  WHERE residential_assets_value IS NOT NULL
) AS with_percentiles

-- Map buckets to names
CROSS JOIN (
  SELECT 1 AS bucket, 'Low' AS asset_group UNION ALL
  SELECT 2, 'Medium' UNION ALL
  SELECT 3, 'High'
) AS bucket_map
WHERE with_percentiles.asset_bucket = bucket_map.bucket

GROUP BY asset_group
ORDER BY 
  FIELD(asset_group, 'Low', 'Medium', 'High');
