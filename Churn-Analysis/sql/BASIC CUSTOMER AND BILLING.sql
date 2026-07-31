use churn ;

ALTER TABLE cleaned_churn
RENAME COLUMN ï»¿Customer_ID TO customer_id;

-- 1 Customer Distribution by State and Gender
select state,Gender,count(*) as customer_count from cleaned_churn
group by state,Gender
order by state,Gender;

-- 2. Age Distribution of Churned vs. Stayed Customers
select 
	Customer_Status,
    min(age) as min_age,
    round(avg(age) ,2)as avg_age,
    max(age) as max_age
    from cleaned_churn
    group by Customer_Status;
    
 -- Marital Status Impact on Churn   
select Married,
		Customer_Status,
        Count(*) as total_customer,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Married), 2) AS percentage
 from cleaned_churn    
 group by Married,Customer_Status
 order by Married,Customer_Status;
 
 
-- 4 State wise churn Rate
select 
	State,
    count(*) as total_customer,
    SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS churned_count,
	ROUND(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
    from cleaned_churn 
    group by State
    order by churn_rate desc;
    
    
    
  -- REVENUE AND BILLING
 
 -- 5 Average Monthly Charge by Customer Status and Contract Type
	select Contract,Customer_Status,
    round(avg(Monthly_Charge),2) as avg_bill,
    count(*) as total_customer
    from cleaned_churn
    group by Contract,Customer_Status
    order by avg_bill desc;
    
  -- 6 Revenue loss from churn customers   
  select 
  round(sum(Total_revenue),2) as total_revenue_lost
  from cleaned_churn
  where Customer_Status='Churned';
  
  
  -- Top 10 Highest Revenue Customers at Risk  
  SELECT 
    Customer_Id,
    Total_Revenue,
    Monthly_Charge,
    Tenure_in_Months,
    Churn_Reason
FROM cleaned_churn
WHERE Customer_Status = 'Churned'
ORDER BY Total_Revenue DESC
LIMIT 10;

-- 8 Refund Analysis
select Customer_Status,
	round(avg(Total_Refunds),2) as avg_refund,
    round(sum(Total_Refunds),2) as total_refund
    from cleaned_churn
    group by Customer_Status