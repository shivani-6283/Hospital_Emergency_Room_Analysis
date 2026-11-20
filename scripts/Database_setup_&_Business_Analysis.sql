-- =====================================================
-- 1. DATABASE AND TABLE SETUP
-- =====================================================

USE master;

GO

-- Drop and recreate the Hospital_Management database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name ='Hospital_Management')

BEGIN

    ALTER DATABASE Hospital_Management SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE Hospital_Management;

END;

GO

-- Create the Hospital_Management database

CREATE DATABASE Hospital_Management;

GO

USE Hospital_Management;

GO

-- -----------------------------------------------------
-- 1.1. Create the Raw Hospital Data Table
-- -----------------------------------------------------

CREATE TABLE dbo.Hospital_Data
(
    Patient_Id VARCHAR(20),

    Patient_Admission_Date VARCHAR(30),

    Patient_First_Inital VARCHAR(5),

    Patient_Last_Name VARCHAR(100),

    Patient_Gender VARCHAR(10),

    Patient_Age INT,

    Patient_Race VARCHAR(100),

    Department_Referral VARCHAR(100),

    Patient_Admission_Flag VARCHAR(10),

    Patient_Satisfaction_Score INT,

    Patient_Waittime INT
);

GO

-- Truncate the raw data table
TRUNCATE TABLE dbo.Hospital_Data;

GO

-- Import data from the CSV file.
BULK INSERT dbo.Hospital_Data

FROM 'C:\Users\sande\Music\Hospital Management\Hospital Emergency Room Data.csv'

WITH (
        FIRSTROW = 2,

        FIELDTERMINATOR = ',',

        TABLOCK
);

GO
  
-- =====================================================
-- 2. DATA TRANSFORMATION
-- =====================================================

SELECT * INTO Hospital_Data_Transformed

FROM(

SELECT

Patient_Id,

Patient_Admission_Date AS Patient_Admission_Datetime,

-- Extract DATE

    CAST(

        TRY_CONVERT(DATETIME, Patient_Admission_Date, 103)

        AS DATE)AS Patient_Admission_Date,


    -- Extract Time in 12-hour format

    FORMAT(

        TRY_CONVERT(DATETIME, Patient_Admission_Date, 103),

        'hh:mm:ss tt'

    ) AS Patient_Admission_Time,

Patient_First_Inital,

Patient_Last_Name,

CONCAT(Patient_First_Inital, '.',' ', Patient_Last_Name) AS Patient_Full_Name,

CASE patient_gender

WHEN 'F' THEN 'Female'

WHEN 'M' THEN 'Male'

ELSE patient_gender

END AS Patient_Gender,

Patient_Age,

Patient_Race,

Department_Referral,

CASE Patient_Admission_Flag

WHEN 'FALSE' THEN 'Not Active'

WHEN 'True' THEN 'Active'

ELSE Patient_Admission_Flag

END AS Patient_Admission_Flag,

Patient_Satisfaction_Score,

Patient_Waittime,

    CASE

    WHEN Patient_Age>70 THEN '70-79'

    WHEN Patient_Age>60 THEN '60-69'

    WHEN Patient_Age>50 THEN '50-59'

    WHEN Patient_Age>40 THEN '40-49'

    WHEN Patient_Age>30 THEN '30-39'

    WHEN Patient_Age>20 THEN '20-29'

    WHEN Patient_Age>10 THEN '10-19'

    ELSE '0-09'

END AS Age_Group,

IIF(Patient_Waittime>30,'Delay','On Time') AS Patient_Attend_Status

FROM dbo.Hospital_Data

)t;


-- =====================================================
-- 3. FINAL TABLE FOR ANALYSIS
-- =====================================================

SELECT

*,

DATEPART(year,Patient_Admission_Date) AS Year,

DATEPART(MONTH,Patient_Admission_Date) AS Month,

DATEPART(HOUR,Patient_Admission_Time) AS Admission_Hour,

CONCAT(

    FORMAT(FLOOR(DATEPART(HOUR,Patient_Admission_Time) / 2.0) * 2, '00'),

    '-',

    FORMAT(FLOOR(DATEPART(HOUR,Patient_Admission_Time) / 2.0) * 2 + 2, '00')

) AS Time_Slot,

FORMAT(Patient_Admission_Date, 'ddd') AS Day_Name,

DATEPART(WEEKDAY,Patient_Admission_Date) AS Day_Number

INTO Hospital_Data_Final

FROM dbo.Hospital_Data_Transformed


--- =====================================================
-- 4. BUSINESS QUESTIONS AND SQL ANALYSIS
-- =====================================================

-- -----------------------------------------------------
-- Q1. KPI Calculation – Overall ER Performance
-- -----------------------------------------------------

-- 1.1. ER Performance-Yearly

SELECT

Year,

COUNT(Patient_Id) AS No_of_patient,

CAST(AVG(Patient_Waittime * 1.0) AS DECIMAL(10,2)) AS Avg_Waittime,

CAST(AVG(Patient_Satisfaction_Score * 1.0) AS DECIMAL(10,2)) AS Avg_Satisfaction_Score

FROM Hospital_Data_Final

GROUP BY Year

ORDER BY 1;


-- 1.2. Monthly ER Performance – Montly (March 2023)

SELECT

Year,

Month,

COUNT(Patient_Id) AS No_of_patient,

CAST(AVG(Patient_Waittime * 1.0) AS DECIMAL(10,2)) AS Avg_Waittime,

CAST(AVG(Patient_Satisfaction_Score * 1.0) AS DECIMAL(10,2)) AS Avg_Satisfaction_Score

FROM Hospital_Data_Final

WHERE Year=2023 AND Month=3 --filter(Mar,2023)

GROUP BY Year,Month

ORDER BY 2;


-- -----------------------------------------------------
-- Q2. Gender-wise Patient Distribution
-- -----------------------------------------------------

-- 2.1. Patient Distribution by Gender-Yearly

SELECT

    Year,

    Patient_Gender,

    COUNT(Patient_Id) AS Patient_Count,


    CAST(

    ROUND(

        COUNT(Patient_Id) * 100.0 /

        SUM(COUNT(Patient_Id)) OVER (PARTITION BY Year)

        ,0)

        AS INT

    ) AS Percentage


FROM Hospital_Data_Final

GROUP BY Year, Patient_Gender

ORDER BY Year, Patient_Gender;


-- 2.2. Monthly Patient Distribution by Gender – Montly (March 2023)

SELECT

    Year,

    Month,

    Patient_Gender,

    CAST(

    ROUND(

        COUNT(Patient_Id) * 100.0 /

        (

        SELECT COUNT(Patient_Id) FROM Hospital_Data_Final

        WHERE Year=H.Year AND Month=H.Month

        ),

        0

    ) AS INT

) AS Percentage

FROM Hospital_Data_Final H

WHERE YEAR= 2023 AND Month=3 --filter(Mar,2023)

GROUP BY

    Year,

    Month,

    Patient_Gender

ORDER BY Year,

        Month,

        Patient_Gender


-- -----------------------------------------------------
-- Q3. Patient Attendance: Within 30 Minutes vs. Delays
-- -----------------------------------------------------


-- 3.1. Patient Attendance Status-Yearly 

SELECT

Year,

Patient_Attend_Status,

    CAST(

    ROUND(

        COUNT(Patient_Id) * 100.0 /

        SUM(COUNT(Patient_Id)) OVER (PARTITION BY Year)

        ,0

    ) AS INT

) AS Percentage

FROM Hospital_Data_Final H

GROUP BY

Year,

Patient_Attend_Status

ORDER BY Year,

Patient_Attend_Status


-- 3.2. Monthly Patient Attendance Status – Montly (March 2023)

SELECT

Year,

Month,

Patient_Attend_Status,

    CAST(

    ROUND(

        COUNT(Patient_Id) * 100.0 /

        (

        SELECT COUNT(Patient_Id) FROM Hospital_Data_Final

        WHERE Year =H.Year AND Month=H.Month

        ),

        0

    ) AS INT

) AS Percentage

FROM Hospital_Data_Final H

WHERE Year= 2023 AND Month=3--filter(Mar 2023)

GROUP BY

Year,

Month,

Patient_Attend_Status

ORDER BY Year,

Month,

Patient_Attend_Status

-- -----------------------------------------------------
-- Q4. Patient Distribution by Age Group
-- -----------------------------------------------------

-- 4.1. Patient Distribution by Age Group-Yearly

SELECT

Year,

Age_Group,

COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

GROUP BY

Year,

Age_Group

ORDER BY Year,

Age_Group


-- 4.2. Monthly Patient Distribution by Age Group – Montly (March 2023)

SELECT

Year,

Month,

Age_Group,

COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

WHERE Year= 2023 AND Month=3--filter(Mar,2023)

GROUP BY

Year,

Month,

Age_Group

ORDER BY Year,

Month,

Age_Group


-- -----------------------------------------------------
-- Q5. Patient Distribution by Department
-- -----------------------------------------------------

-- 5.1. Patient Distribution by Department -Yearly

SELECT

Year,

Department_Referral,

COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

GROUP BY

Year,

Department_Referral

ORDER BY Year,

Patient_Count DESC


-- 5.2. Monthly Patient Distribution by Department – Montly (March 2023)

SELECT

Year,

Month,

Department_Referral,

COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

WHERE Year= 2023 AND Month=3--filter(Mar,2023)

GROUP BY

Year,

Month,

Department_Referral

ORDER BY Year,

Month,

Patient_Count DESC


-- -----------------------------------------------------
-- Q6. Admission vs. Non-Admission
-- -----------------------------------------------------

-- 6.1. Admission Status Distribution – Yearly

SELECT

    Year,

    Patient_Admission_Flag,

    COUNT(Patient_Id) AS Patient_Count,

    CAST(

        COUNT(Patient_Id) * 100.0 /

        SUM(COUNT(Patient_Id)) OVER (PARTITION BY Year)

    AS DECIMAL(10,2)) AS Percentage

FROM Hospital_Data_Final

GROUP BY

    Year,

    Patient_Admission_Flag

ORDER BY Year,

    Patient_Admission_Flag


-- 6.2. Admission Status Distribution – Monthly (March 2023)

SELECT

    Year,

    Month,

    Patient_Admission_Flag,

    COUNT(Patient_Id) AS Patient_Count,

    CAST(

        COUNT(Patient_Id) * 100.0 /

        SUM(COUNT(Patient_Id)) OVER (PARTITION BY Month)

    AS DECIMAL(10,2)) AS Percentage

FROM Hospital_Data_Final

WHERE Year= 2023 AND Month=3--filter(Mar,2023)

GROUP BY

    Year,

    Month,

    Patient_Admission_Flag

ORDER BY Year,

    Month,

    Patient_Admission_Flag

-- -----------------------------------------------------
-- Q7. Patient Distribution by Weekday
-- -----------------------------------------------------

-- 7.1. Patient Distribution by Weekday – Yearly

    SELECT

    Year,

    Day_Name,

    COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

GROUP BY

    Year,

Day_Name

ORDER BY

    Year,

    CASE Day_Name

        WHEN 'Mon' THEN 1

        WHEN 'Tue' THEN 2

        WHEN 'Wed' THEN 3

        WHEN 'Thu' THEN 4

        WHEN 'Fri' THEN 5

        WHEN 'Sat' THEN 6

        WHEN 'Sun' THEN 7

    END;

-- 7.2. Patient Distribution by Weekday – Monthly (March 2023)

SELECT

    Year,

    Month,

    Day_Name,

    COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

WHERE Year = 2023 AND Month=3 --filter(Mar,2023)

GROUP BY

    Year,

    Month,

Day_Name

ORDER BY

    Year,

    Month,

    CASE Day_Name

        WHEN 'Mon' THEN 1

        WHEN 'Tue' THEN 2

        WHEN 'Wed' THEN 3

        WHEN 'Thu' THEN 4

        WHEN 'Fri' THEN 5

        WHEN 'Sat' THEN 6

        WHEN 'Sun' THEN 7

    END;


-- -----------------------------------------------------
-- Q8. Patient Distribution by Time Slot
-- -----------------------------------------------------

-- 8.1. Patient Distribution by Time Slot – Yearly

SELECT

Year,

Time_Slot,

COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

GROUP BY

Year,

Time_Slot

ORDER BY

Year,

Time_Slot


-- 8.2. Patient Distribution by Time Slot – Monthly (March 2023)

SELECT

Year,

Month,

Time_Slot,

COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

WHERE Year= 2023 AND Month=3--filter(Mar,2023)

GROUP BY

Year,

Month,

Time_Slot

ORDER BY

Year,

Month,

Time_Slot


-- -----------------------------------------------------
-- Q9. Patient Distribution by Day and Time Slot
-- -----------------------------------------------------

-- 9.1. Patient Distribution by Day and Time Slot – Yearly

    SELECT

    Year,

    Day_Name,

    Time_Slot,

    COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

WHERE Time_Slot='00-02' AND Day_Name='Mon'


GROUP BY

Year,

    Day_Name,

    Time_Slot


ORDER BY

    Year,

Time_Slot,

    CASE Day_Name

        WHEN 'Mon' THEN 1

        WHEN 'Tue' THEN 2

        WHEN 'Wed' THEN 3

        WHEN 'Thu' THEN 4

        WHEN 'Fri' THEN 5

        WHEN 'Sat' THEN 6

        WHEN 'Sun' THEN 7

    END;

-- 9.2. Patient Distribution by Day and Time Slot – Montly (March 2023)

SELECT

    Year,

    Month,

    Day_Name,

    Time_Slot,

    COUNT(Patient_Id) AS Patient_Count

FROM Hospital_Data_Final

WHERE Time_Slot='00-02' AND Day_Name='Mon'AND

Year= 2023 AND Month=3--filter(Mar,2023)


GROUP BY

Year,

    Month,

    Day_Name,

    Time_Slot


ORDER BY

    Year,

    Month,

Time_Slot,

    CASE Day_Name

        WHEN 'Mon' THEN 1

        WHEN 'Tue' THEN 2

        WHEN 'Wed' THEN 3

        WHEN 'Thu' THEN 4

        WHEN 'Fri' THEN 5

        WHEN 'Sat' THEN 6

        WHEN 'Sun' THEN 7

    END;


