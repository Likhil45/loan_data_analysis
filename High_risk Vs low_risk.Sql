
/*
Use features like cibil_score, income_annum, DTI ratio, asset-to-loan ratio, loan_term, loan_amount, education, and self_employed to create risk profiles.

Example:

Define a high-risk profile as applicants with cibil_score < 600, DTI > 40%, and asset-to-loan ratio < 1.

Define a low-risk profile as cibil_score > 750, DTI < 20%, and asset-to-loan ratio > 2.
*/
SELECT 
  loan_id,
  no_of_dependents,
  education,
  self_employed,
  income_annum,
  loan_amount,
  loan_term,
  cibil_score,
  residential_assets_value,
  commercial_assets_value,
  luxury_assets_value,
  bank_asset_value,
  loan_status,
  
  -- Compute asset-to-loan ratio
  (residential_assets_value + commercial_assets_value + luxury_assets_value + bank_asset_value) / loan_amount AS asset_to_loan_ratio,

  -- Compute DTI Ratio (Debt-to-Income), assume DTI_ratio = (loan_amount / income_annum) * 100
  ROUND((loan_amount / income_annum) * 100, 2) AS DTI_ratio,

  -- Define Risk Profile
  CASE 
    WHEN cibil_score < 600 
         AND (loan_amount / income_annum) * 100 > 40 
         AND (residential_assets_value + commercial_assets_value + luxury_assets_value + bank_asset_value) / loan_amount < 1 
    THEN 'High Risk'

    WHEN cibil_score > 750 
         AND (loan_amount / income_annum) * 100 < 20 
         AND (residential_assets_value + commercial_assets_value + luxury_assets_value + bank_asset_value) / loan_amount > 2 
    THEN 'Low Risk'

    ELSE 'Medium Risk'
  END AS risk_profile

FROM 
  world.loan_approval;
