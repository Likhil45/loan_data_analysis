/* The debt-to-income (DTI) ratio is calculated as:

DTI = Total Monthly Debt Payments/Monthly Income

For example, if income_annum is $60,000 ($5,000/month) and monthly debt payments are $1,500, the DTI is 1500/5000 = 0.3 or 30%.

Analyzing DTI by loan_status involves comparing the DTI ratio across loan outcomes (e.g., Approved vs. Rejected)
*/
with 
T1 As 
	(select loan_id,
    (income_annum /12) as Monthly_income,
    loan_status
	from world.loan_approval),
T2 AS
	(select loan_id,
    round((1500/Monthly_income)*100,2) as DTI,
    loan_status	from T1)
    Select * from T2
