use churn;

-- TENURE & RETENTION METRICS
-- 1 Tenure Distribution: Churned vs. Stayed
SELECT 
    customer_id,
    Customer_Status,
    ROUND(AVG(Tenure_in_Months), 0) AS avg_tenure_months,
    MIN(Tenure_in_Months) AS min_tenure,
    MAX(Tenure_in_Months) AS max_tenure
FROM CLEANED_CHURN
GROUP BY customer_id,Customer_Status; 
 
 -- 2 Churn Rate by Tenure Bracket 
SELECT 
    CASE 
        WHEN Tenure_in_Months <= 6 THEN '0-6 months'
        WHEN Tenure_in_Months <= 12 THEN '7-12 months'
        WHEN Tenure_in_Months <= 24 THEN '13-24 months'
        ELSE '25+ months'
    END AS tenure_bracket,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS churned_count,
    ROUND(SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM CLEANED_CHURN
GROUP BY tenure_bracket
ORDER BY churn_rate DESC;

-- 3  Average Tenure by Churn Reason
SELECT 
    Churn_Reason,
    ROUND(AVG(Tenure_in_Months), 0) AS avg_tenure,
    COUNT(*) AS customer_count
FROM CLEANED_CHURN
WHERE Customer_Status = 'Churned'
GROUP BY Churn_Reason
ORDER BY avg_tenure ASC; 

-- SERVICE & PRODUCT ANALYSIS

-- 4 Internet Service Type Preference and Churn
SELECT 
    Internet_Service,
    Internet_Type,
    Customer_Status,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Internet_Service, Customer_Status), 2) AS percentage
FROM CLEANED_CHURN
GROUP BY Internet_Service, Internet_Type, Customer_Status
ORDER BY Internet_Service, Customer_Status;

-- 5 Impact of Phone Service on Churn
SELECT 
    Phone_Service,
    Multiple_Lines,
    Customer_Status,
    COUNT(*) AS customer_count
FROM CLEANED_CHURN
GROUP BY Phone_Service, Multiple_Lines, Customer_Status
ORDER BY Phone_Service, Customer_Status;

-- 6  Value Deal Analysis: Do Deals Reduce Churn
SELECT 
    Value_Deal,
    Customer_Status,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Value_Deal), 2) AS percentage
FROM CLEANED_CHURN
GROUP BY Value_Deal, Customer_Status
ORDER BY Value_Deal, Customer_Status;

-- 7 Online Security & Backup Impact on Churn   
SELECT 
    Online_Security,
    Online_Backup,
    Customer_Status,
    COUNT(*) AS customer_count
FROM CLEANED_CHURN
WHERE Online_Security != 'No Internet' AND Online_Backup != 'No Internet'
GROUP BY Online_Security, Online_Backup, Customer_Status
ORDER BY Online_Security, Online_Backup, Customer_Status;

-- 8 Streaming Services Adoption and Churn Correlation
SELECT 
    Streaming_TV,
    Streaming_Movies,
    Streaming_Music,
    Customer_Status,
    COUNT(*) AS customer_count
FROM CLEANED_CHURN
WHERE Streaming_TV != 'No Internet' 
GROUP BY Streaming_TV, Streaming_Movies, Streaming_Music, Customer_Status
ORDER BY Customer_Status, COUNT(*) DESC;

--  CONTRACT & BILLING PREFERENCES
-- 9 Contract Type: The Ultimate Churn Predictor
SELECT 
    Contract,
    Customer_Status,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Contract), 2) AS percentage
FROM CLEANED_CHURN
GROUP BY Contract, Customer_Status
ORDER BY Contract, Customer_Status;


-- 10  Paperless Billing Impact on Churn
SELECT 
    Paperless_Billing,
    Payment_Method,
    Customer_Status,
    COUNT(*) AS customer_count
FROM CLEANED_CHURN
GROUP BY Paperless_Billing, Payment_Method, Customer_Status
ORDER BY Paperless_Billing, Customer_Status;  

-- 11  Payment Method Analysis
SELECT 
    Payment_Method,
    Customer_Status,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Payment_Method), 2) AS churn_rate
FROM CLEANED_CHURN
GROUP BY Payment_Method, Customer_Status
ORDER BY Payment_Method, Customer_Status;
