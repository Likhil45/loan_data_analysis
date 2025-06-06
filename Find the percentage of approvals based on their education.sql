/* Find the percentage of approvals based on their education
e.g., 60% graduates, 40% undergraduates */

select count(case when education ='Graduate' THEN 1 END) * 100 / count(education) as Graduate_Percentage, 
count(case when education = 'Not Graduate' THEN 1 END) * 100 / count(education) as NotGraduate_Percentage from world.loan_approval; 
