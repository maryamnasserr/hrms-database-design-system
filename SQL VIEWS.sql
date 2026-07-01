-- Create the following views:

-- Workforce views

CREATE VIEW vw_employee_count_by_department AS
SELECT 
    d.DEP_ID,
    d.DEP_NAME,
    COUNT(DISTINCT ja.EMPLOYEE_ID) AS Employee_Count
FROM DEPARTMENT d
LEFT JOIN JOB j 
    ON j.Department_ID = d.DEP_ID
LEFT JOIN JOB_ASSIGNMENT ja
    ON ja.JOB_ID = j.Job_ID
GROUP BY d.DEP_ID, d.DEP_NAME;

CREATE VIEW vw_gender_distribution AS
SELECT 
    Gender,
    COUNT(*) AS Total
FROM EMPLOYEE
GROUP BY Gender;

CREATE VIEW vw_employment_status_distribution AS
SELECT 
    Employment_Status,
    COUNT(*) AS Total
FROM EMPLOYEE
GROUP BY Employment_Status;

-- Job Structure Views 

CREATE VIEW vw_jobs_by_level AS
SELECT 
    Job_Level,
    COUNT(*) AS Total_Jobs
FROM JOB
GROUP BY Job_Level;

CREATE VIEW vw_salary_stats_by_category AS
SELECT 
    Job_Category,
    MIN(Min_Salary) AS Min_Salary,
    MAX(Max_Salary) AS Max_Salary,
    AVG((Min_Salary + Max_Salary) / 2) AS Avg_Salary
FROM JOB
GROUP BY Job_Category;

CREATE VIEW vw_active_job_assignments AS
SELECT 
    ja.ASSIGNMENT_ID,
    ja.EMPLOYEE_ID,
    e.First_Name,
    e.Last_Name,
    ja.JOB_ID,
    j.Job_Title,
    ja.CONTRACT_ID,
    ja.START_DATE,
    ja.END_DATE,
    ja.STATUS
FROM JOB_ASSIGNMENT ja
JOIN EMPLOYEE e ON e.Employee_ID = ja.EMPLOYEE_ID
JOIN JOB j ON j.Job_ID = ja.JOB_ID
WHERE ja.STATUS = 'Active';

-- Performance Views
CREATE VIEW vw_kpi_scores_summary AS
SELECT 
    e.Employee_ID,
    CONCAT(e.First_Name, ' ', e.Last_Name) AS Employee_Name,
    ecs.Performance_Cycle_ID,
    SUM(ecs.Weighted_Score) AS Total_Weighted_Score,
    AVG(ecs.Employee_Score) AS Avg_Score
FROM EMPLOYEE e
JOIN EMPLOYEE_KPI_SCORE ecs ON e.Employee_ID = ecs.Assignment_ID
GROUP BY e.Employee_ID, ecs.Performance_Cycle_ID;

CREATE VIEW vw_appraisal_scores_per_cycle AS
SELECT 
    pc.Performance_ID AS Cycle_ID,
    pc.PERFORMANCE_NAME,
    ja.EMPLOYEE_ID,
    CONCAT(e.First_Name, ' ', e.Last_Name) AS Employee_Name,
    a.APPRAISAL_OVERALSCORE
FROM PERFORMANCE_CYCLE pc
JOIN APPRAISAL a ON pc.Performance_ID = a.PERFORMANCE_ID
JOIN JOB_ASSIGNMENT ja ON a.ASSIGNMENT_ID = ja.ASSIGNMENT_ID
JOIN EMPLOYEE e ON ja.EMPLOYEE_ID = e.Employee_ID;


CREATE VIEW vw_full_appraisal_summary AS
SELECT 
    e.Employee_ID,
    CONCAT(e.First_Name, ' ', e.Last_Name) AS Employee_Name,
    j.Job_ID,
    j.Job_Title,
    pc.Performance_ID AS Cycle_ID,
    pc.PERFORMANCE_NAME AS Cycle_Name,
    a.APPRAISAL_ID,
    a.APPRAISAL_OVERALSCORE,
    a.APPRAISAL_MANAGER_COMMENTS,
    a.APPRAISAL_HRCOMMENTS,
    a.APPRAISAL_EMPLOYEE_COMMENTS
FROM EMPLOYEE e
JOIN JOB_ASSIGNMENT ja ON e.Employee_ID = ja.EMPLOYEE_ID
JOIN JOB j ON ja.JOB_ID = j.Job_ID
JOIN APPRAISAL a ON ja.ASSIGNMENT_ID = a.ASSIGNMENT_ID
JOIN PERFORMANCE_CYCLE pc ON a.PERFORMANCE_ID = pc.Performance_ID;

-- Training Views

DROP VIEW IF EXISTS vw_training_participation;

CREATE VIEW vw_training_participation AS
SELECT 
    tp.Program_ID,
    tp.Program_Code,
    tp.Title AS Program_Title,
    COUNT(et.Employee_ID) AS Total_Participants
FROM TRAINING_PROGRAM tp
LEFT JOIN EMPLOYEE_TRAINING et 
    ON tp.Program_ID = et.Program_ID
GROUP BY tp.Program_ID, tp.Program_Code, tp.Title;

CREATE VIEW vw_training_completion_stats AS
SELECT 
    tp.Program_ID,
    tp.Program_Code,
    tp.Title AS Program_Title,

    COUNT(et.ET_ID) AS Total_Enrolled,

    SUM(CASE WHEN et.Completion_Status = 'Completed' THEN 1 ELSE 0 END) AS Completed_Count,
    SUM(CASE WHEN et.Completion_Status = 'In Progress' THEN 1 ELSE 0 END) AS InProgress_Count,
    SUM(CASE WHEN et.Completion_Status = 'Not Started' THEN 1 ELSE 0 END) AS NotStarted_Count,
    SUM(CASE WHEN et.Completion_Status = 'Dropped' THEN 1 ELSE 0 END) AS Dropped_Count

FROM TRAINING_PROGRAM tp
LEFT JOIN EMPLOYEE_TRAINING et
    ON tp.Program_ID = et.Program_ID
GROUP BY tp.Program_ID, tp.Program_Code, tp.Title;






