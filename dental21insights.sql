
-- using a join query to merge both tables to fully understand their relationships
SELECT * 
FROM Dental21.clean_test_revenues R
INNER JOIN Dental21.clean_test_appointments A
ON R.appointment_id = A.appointment_id;

-- Lets look at our Monthly Revenue for 2022 this should help shead more insights for our goals for the next years (2023)
SELECT 
 YEAR(A.appointment_date) AS year,
 MONTH(A.appointment_date) AS Month,
 ROUND(SUM(R.revenues),2) AS Revenue_Amount -- Rounding the sum to 2 decimal
 FROM Dental21.clean_test_appointments AS A
 INNER JOIN Dental21.clean_test_revenues AS R
 ON A.appointment_id = R.appointment_id
 WHERE  YEAR(A.appointment_date) = 2022
 GROUP BY year, Month
 ORDER BY year, Month
 LIMIT 0, 1000;
 
 -- Total Revenue generated in 2022 was 1,957,963.54 using simple addition calculations, 
 -- next i would like to know the amount of patients influence that generated this Sum;
 
 -- lets find out total number of patient who visited the clinic for each month in 2022
 SELECT 
 YEAR(appointment_date) AS year,
 MONTH(appointment_date) AS Month,
 COUNT(patient_id) as total_montly_patients_2022
 FROM Dental21.clean_test_appointments 
 WHERE  YEAR(appointment_date) = 2022
 GROUP BY year, Month
 ORDER BY year, Month
 LIMIT 0, 1000;
 
 -- Sum up the total number of patients who visited the clinic in 2022
SELECT
    SUM(total_patients) AS total_patients_in_2022
FROM
    (
        -- The query for monthly total patients in 2022
        SELECT
            YEAR(appointment_date) AS year,
            MONTH(appointment_date) AS month,
            COUNT(patient_id) AS total_patients
        FROM
            Dental21.clean_test_appointments
        WHERE
            YEAR(appointment_date) = 2022
        GROUP BY
            YEAR(appointment_date), MONTH(appointment_date)
    ) AS monthly_counts;
    
    
-- We had a total sum of 11015 patients who visited the clinic on several occasions, 
    
    --  let look into the SUM values of the unique patients to know the total values of the year 2022
-- Sum up the total number of unique patients who visited the clinic in 2022

SELECT 
    SUM(unique_patients) AS total_unique_patients_in_2022
FROM
    (
        -- The query for monthly unique patients in 2022
        SELECT
            YEAR(appointment_date) AS year,
            MONTH(appointment_date) AS month,
            COUNT(DISTINCT patient_id) AS unique_patients
        FROM
            Dental21.clean_test_appointments
        WHERE
            YEAR(appointment_date) = 2022
        GROUP BY
            YEAR(appointment_date), MONTH(appointment_date)
    ) AS monthly_counts;

-- total sum of unique patients is 7685, relating it to our total count of patients actually means that,
-- these are patients who visited the clinic multiple times during the year 

-- Let's calculate the average number of patient each month in 2022 to help us understanding and identify peak months when numbers are higher,  
-- understanding the typical patient volume the clinic experiences throughout the year
-- Calculate the average total number of patients per month in 2022
-- Calculate the average total number of patients per month in 2022
SELECT
    appointment_year,
    appointment_month,
    AVG(total_patients) AS average_total_patients_per_month
FROM (
    SELECT
        YEAR(appointment_date) AS appointment_year,
        MONTH(appointment_date) AS appointment_month,
        COUNT(DISTINCT patient_id) AS total_patients
    FROM
        Dental21.clean_test_appointments
    WHERE
        YEAR(appointment_date) = 2022
    GROUP BY
        appointment_year, appointment_month
) AS monthly_counts
GROUP BY
    appointment_year, appointment_month
ORDER BY
    appointment_year, appointment_month;
 
 -- the number of unique patients per month ranged from 499 in january to 888 in decemeber , that was definitely an upward trends 
 
 -- lets look into the average monthly revenues to get a baseline to calculates an estimates for next year 2023, 
 -- considering that 2 clinics would be  open in 2023, should be lead to increase in income but first we need to know how much on average is made monthly
 -- Calculate the average monthly revenue in 2022
-- Calculate the average monthly revenue in 2022
SELECT
    appointment_year,
    appointment_month,
    AVG(revenues) AS average_monthly_revenue
FROM (
    SELECT
        A.appointment_id,
        YEAR(A.appointment_date) AS appointment_year,
        MONTH(A.appointment_date) AS appointment_month,
        SUM(R.revenues) AS revenues
    FROM
        Dental21.clean_test_appointments A
    JOIN
        Dental21.clean_test_revenues R ON A.appointment_id = R.appointment_id
    WHERE
        YEAR(A.appointment_date) = 2022
    GROUP BY
        A.appointment_id, appointment_year, appointment_month
) AS monthly_revenues
GROUP BY
    appointment_year, appointment_month
ORDER BY
    appointment_year, appointment_month;
--  it appears that the revenue generally increased from January to March, experienced a peak around June and july,
-- and then had some fluctuations in the later months.


-- Let's dive a little deep into patients who visited more than once and their impact on revenues including months 
-- This would help the clinic understand revenue patterns to set realistic goals for 2023 

-- Show Patients who visited more than once and their impact on monthly revenue
SELECT
    A.patient_id,
    YEAR(A.appointment_date) AS appointment_year,
    MONTH(A.appointment_date) AS appointment_month,
    COUNT(A.appointment_id) AS total_visits,
    SUM(R.revenues) AS total_revenue
FROM
    Dental21.clean_test_appointments A
JOIN
    Dental21.clean_test_revenues R ON A.appointment_id = R.appointment_id
WHERE
    YEAR(A.appointment_date) = 2022
GROUP BY
    A.patient_id, appointment_year, appointment_month
HAVING
    COUNT(A.appointment_id) > 1
ORDER BY
    appointment_year, appointment_month, total_revenue DESC;
    
    -- Let contunue with python

