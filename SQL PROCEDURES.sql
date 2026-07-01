-- procedures
-- Employee Management Procedures
DELIMITER $$

CREATE PROCEDURE AddNewEmployee(
    IN p_First_Name VARCHAR(50),
    IN p_Middle_Name VARCHAR(50),
    IN p_Last_Name VARCHAR(50),
    IN p_Arabic_Name VARCHAR(100),
    IN p_Gender VARCHAR(10),
    IN p_Nationality VARCHAR(50),
    IN p_DOB DATE,
    IN p_Place_of_Birth VARCHAR(100),
    IN p_Marital_Status VARCHAR(20),
    IN p_Religion VARCHAR(50),
    IN p_Employment_Status VARCHAR(20),
    IN p_Mobile_Phone VARCHAR(20),
    IN p_Work_Phone VARCHAR(20),
    IN p_Work_Email VARCHAR(100),
    IN p_Personal_Email VARCHAR(100),
    IN p_Emergency_Contact_Name VARCHAR(100),
    IN p_Emergency_Contact_Phone VARCHAR(20),
    IN p_Emergency_Contact_Relationship VARCHAR(50),
    IN p_Residential_City VARCHAR(100),
    IN p_Residential_Area VARCHAR(100),
    IN p_Residential_Street VARCHAR(150),
    IN p_Residential_Country VARCHAR(100),
    IN p_Permanent_City VARCHAR(100),
    IN p_Permanent_Area VARCHAR(100),
    IN p_Permanent_Street VARCHAR(150),
    IN p_Permanent_Country VARCHAR(100),
    IN p_Medical_Clearance_Status VARCHAR(50),
    IN p_Criminal_Status VARCHAR(50)
)
BEGIN

    -- Insert the employee
    INSERT INTO EMPLOYEE (
        First_Name, Middle_Name, Last_Name, Arabic_Name, Gender, Nationality,
        DOB, Place_of_Birth, Marital_Status, Religion, Employment_Status,
        Mobile_Phone, Work_Phone, Work_Email, Personal_Email,
        Emergency_Contact_Name, Emergency_Contact_Phone, Emergency_Contact_Relationship,
        Residential_City, Residential_Area, Residential_Street, Residential_Country,
        Permanent_City, Permanent_Area, Permanent_Street, Permanent_Country,
        Medical_Clearance_Status, Criminal_Status
    )
    VALUES (
        p_First_Name, p_Middle_Name, p_Last_Name, p_Arabic_Name, p_Gender, p_Nationality,
        p_DOB, p_Place_of_Birth, p_Marital_Status, p_Religion, p_Employment_Status,
        p_Mobile_Phone, p_Work_Phone, p_Work_Email, p_Personal_Email,
        p_Emergency_Contact_Name, p_Emergency_Contact_Phone, p_Emergency_Contact_Relationship,
        p_Residential_City, p_Residential_Area, p_Residential_Street, p_Residential_Country,
        p_Permanent_City, p_Permanent_Area, p_Permanent_Street, p_Permanent_Country,
        p_Medical_Clearance_Status, p_Criminal_Status
    );

    -- Capture inserted Employee_ID
    SET @newEmployeeID = LAST_INSERT_ID();

    -- Insert basic social insurance record
    INSERT INTO SOCIAL_INSURANCE (
        Employee_ID, Insurance_Number, Coverage_Details, Start_Date,  End_Date, Status
    )
    VALUES (
        @newEmployeeID,
        CONCAT('INS-', @newEmployeeID),  -- auto-generated insurance number
        'Full medical and accident coverage',
        CURDATE(),
        '2026-03-1',
        'Active'
    );

    -- Return the Employee ID
    SELECT @newEmployeeID AS New_Employee_ID;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE UpdateEmployeeContactInfo(
    IN p_Employee_ID INT,
    IN p_Mobile_Phone VARCHAR(20),
    IN p_Work_Phone VARCHAR(20),
    IN p_Work_Email VARCHAR(100),
    IN p_Personal_Email VARCHAR(100),
    IN p_Emergency_Contact_Name VARCHAR(100),
    IN p_Emergency_Contact_Phone VARCHAR(20),
    IN p_Emergency_Contact_Relationship VARCHAR(50)
)
BEGIN
    UPDATE EMPLOYEE
    SET 
        Mobile_Phone = p_Mobile_Phone,
        Work_Phone = p_Work_Phone,
        Work_Email = p_Work_Email,
        Personal_Email = p_Personal_Email,
        Emergency_Contact_Name = p_Emergency_Contact_Name,
        Emergency_Contact_Phone = p_Emergency_Contact_Phone,
        Emergency_Contact_Relationship = p_Emergency_Contact_Relationship
    WHERE Employee_ID = p_Employee_ID;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE AddEmployeeDisability(
    IN p_Employee_ID INT,
    IN p_Disability_Type VARCHAR(100),
    IN p_Severity_Level VARCHAR(10),
    IN p_Required_Support VARCHAR(200)
)
BEGIN
    INSERT INTO EMPLOYEE_DISABILITY (
        Employee_ID,
        Disability_Type,
        Severity_Level,
        Required_Support
    )
    VALUES (
        p_Employee_ID,
        p_Disability_Type,
        p_Severity_Level,
        p_Required_Support
    );
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE GetEmployeeFullProfile(
    IN p_Employee_ID INT
)
BEGIN
    --  Basic Employee Info + Address Info
    SELECT 
        Employee_ID, First_Name, Middle_Name, Last_Name, Arabic_Name,
        Gender, Nationality, DOB, Place_of_Birth, Marital_Status,
        Religion, Employment_Status,
        Mobile_Phone, Work_Phone, Work_Email, Personal_Email,
        Emergency_Contact_Name, Emergency_Contact_Phone, Emergency_Contact_Relationship,
        Residential_City, Residential_Area, Residential_Street, Residential_Country,
        Permanent_City, Permanent_Area, Permanent_Street, Permanent_Country,
        Medical_Clearance_Status, Criminal_Status
    FROM EMPLOYEE
    WHERE Employee_ID = p_Employee_ID;

    --  Disability Records
    SELECT 
        Disability_Type,
        Severity_Level,
        Required_Support
    FROM EMPLOYEE_DISABILITY
    WHERE Employee_ID = p_Employee_ID;

    -- Educational Qualifications
    SELECT 
        Qualification_ID,
        Institution_Name,
        Major,
        Degree_Type
    FROM EDUCATIONAL_QUALIFICATION
    WHERE Employee_ID = p_Employee_ID;

    -- Professional Certificates
    SELECT 
        Certificate_ID,
        Certification_Name,
        Issuing_Organization,
        Issue_Date,
        Expiry_Date,
        Credential_ID
    FROM PROFESSIONAL_CERTIFICATE
    WHERE Employee_ID = p_Employee_ID;

    -- Job Assignment + Job Info + Contract Info
    SELECT
        ja.Assignment_ID,
        ja.Start_Date,
        ja.End_Date,
        ja.Status,
        ja.Assigned_Salary,
        j.Job_Title,
        j.Job_Level,
        j.Job_Category,
        j.Job_Grade,
        c.Type AS Contract_Type,
        c.Work_Modality
    FROM JOB_ASSIGNMENT ja
    JOIN JOB j ON ja.Job_ID = j.Job_ID
    JOIN CONTRACT c ON ja.CONTRACT_ID = c.Contract_ID
    WHERE ja.Employee_ID = p_Employee_ID
    ORDER BY ja.Start_Date DESC;

END $$

DELIMITER ;



DELIMITER $$

-- Job & Assignment Procedures

CREATE PROCEDURE AddNewJob(
    IN p_job_title VARCHAR(100),
    IN p_department_id INT,
    IN p_job_level VARCHAR(50),
    IN p_min_salary DECIMAL(10,2),
    IN p_max_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Job (job_title, department_id, job_level, min_salary, max_salary)
    VALUES (p_job_title, p_department_id, p_job_level, p_min_salary, p_max_salary);
END $$
DELIMITER ;


DELIMITER $$

CREATE PROCEDURE AddJobObjective(
    IN p_job_id INT,
    IN p_objective_description VARCHAR(255),
    IN p_weight DECIMAL(5,2)
)
BEGIN
    DECLARE totalWeight DECIMAL(6,2);

    -- Calculate current total weight for this job
    SELECT IFNULL(SUM(weight), 0)
    INTO totalWeight
    FROM Job_Objective
    WHERE job_id = p_job_id;

    -- Check if adding the new weight exceeds 100%
    IF (totalWeight + p_weight) > 100 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Total weight for this job exceeds 100%.';
    ELSE
        -- Insert new objective
        INSERT INTO Job_Objective(job_id, objective_description, weight)
        VALUES (p_job_id, p_objective_description, p_weight);
    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AddKPIToObjective(
    IN p_objective_id INT,
    IN p_kpi_description VARCHAR(255),
    IN p_target_value VARCHAR(100),
    IN p_measurement_method VARCHAR(100)
)
BEGIN
    INSERT INTO KPI (job_objective_id, kpi_description, target_value, measurement_method)
    VALUES (p_objective_id, p_kpi_description, p_target_value, p_measurement_method);
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE AssignJobToEmployee(
    IN p_employee_id INT,
    IN p_job_id INT,
    IN p_contract_id INT,
    IN p_start_date DATETIME,
    IN p_end_date DATETIME,
    IN p_assigned_salary DECIMAL(10,2)
)
BEGIN
    DECLARE contract_exists INT;
    DECLARE overlap_count INT;

    -- 1️ Validate that the contract exists
    SELECT COUNT(*) INTO contract_exists
    FROM CONTRACT
    WHERE Contract_ID = p_contract_id;

    IF contract_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Contract does not exist.';
    END IF;

    -- 2️ Check for overlapping active jobs for the employee
    SELECT COUNT(*) INTO overlap_count
    FROM JOB_ASSIGNMENT
    WHERE Employee_ID = p_employee_id
      AND Status = 'Active'
      AND (
            (p_start_date BETWEEN START_DATE AND END_DATE)
         OR (p_end_date BETWEEN START_DATE AND END_DATE)
         OR (START_DATE BETWEEN p_start_date AND p_end_date)
         OR (END_DATE BETWEEN p_start_date AND p_end_date)
      );

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Employee has overlapping active job assignment.';
    END IF;

    -- 3️ Insert the job assignment
    INSERT INTO JOB_ASSIGNMENT(
        Employee_ID, Job_ID, Contract_ID, Start_Date, End_Date, Status, Assigned_Salary
    )
    VALUES (
        p_employee_id, p_job_id, p_contract_id, p_start_date, p_end_date, 'Active', p_assigned_salary
    );

END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE CloseJobAssignment(
    IN p_assignment_id INT,
    IN p_end_date DATETIME
)
BEGIN
    -- Check if assignment exists and is currently active
    IF NOT EXISTS (
        SELECT 1 FROM JOB_ASSIGNMENT
        WHERE Assignment_ID = p_assignment_id
          AND Status = 'Active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Assignment does not exist or is already closed.';
    END IF;

    -- Update assignment to mark as closed
    UPDATE JOB_ASSIGNMENT
    SET Status = 'Inactive',
        End_Date = p_end_date
    WHERE Assignment_ID = p_assignment_id;
END $$

DELIMITER ;
DELIMITER $$

-- Performance Management Procedures

CREATE PROCEDURE CreatePerformanceCycle(
    IN p_performance_name VARCHAR(50),
    IN p_performance_type VARCHAR(50),
    IN p_start_date DATETIME,
    IN p_end_date DATETIME,
    IN p_submission_deadline DATETIME
)
BEGIN
    -- Validate dates
    IF p_start_date > p_end_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Start date cannot be after end date.';
    END IF;

    -- Insert the new performance cycle
    INSERT INTO PERFORMANCE_CYCLE (
        PERFORMANCE_NAME,
        PERFORMANCE_TYPE,
        PERFORMANCE_START_DATE,
        PERFORMANCE_END_DATE,
        PERFORMANCE_SUBMISSION_DEADLINE
    )
    VALUES (
        p_performance_name,
        p_performance_type,
        p_start_date,
        p_end_date,
        p_submission_deadline
    );
END $$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE AddEmployeeKPIScore(
    IN p_assignment_id INT,
    IN p_kpi_id INT,
    IN p_performance_cycle_id INT,
    IN p_actual_value DECIMAL(10,2),
    IN p_employee_score DECIMAL(5,2),
    IN p_weighted_score DECIMAL(5,2),
    IN p_reviewer_id INT,
    IN p_comments VARCHAR(300),
    IN p_review_date DATE
)
BEGIN
    -- Validate employee score
    IF p_employee_score < 1 OR p_employee_score > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Employee score must be between 1 and 100.';
    END IF;

    -- Insert KPI score
    INSERT INTO EMPLOYEE_KPI_SCORE (
        Assignment_ID,
        KPI_ID,
        Performance_Cycle_ID,
        Actual_Value,
        Employee_Score,
        Weighted_Score,
        Reviewer_ID,
        Comments,
        Review_Date
    )
    VALUES (
        p_assignment_id,
        p_kpi_id,
        p_performance_cycle_id,
        p_actual_value,
        p_employee_score,
        p_weighted_score,
        p_reviewer_id,
        p_comments,
        p_review_date
    );
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE CalculateEmployeeWeightedScore(
    IN p_assignment_id INT,
    IN p_performance_cycle_id INT
)
BEGIN
    DECLARE total_weighted_score DECIMAL(10,2);
    DECLARE appraisal_exists INT;

    -- 1️ Calculate sum of weighted scores
    SELECT IFNULL(SUM(Weighted_Score), 0)
    INTO total_weighted_score
    FROM EMPLOYEE_KPI_SCORE
    WHERE Assignment_ID = p_assignment_id
      AND Performance_Cycle_ID = p_performance_cycle_id;

    -- 2️ Check if an appraisal exists for this assignment/cycle
    SELECT COUNT(*) INTO appraisal_exists
    FROM APPRAISAL
    WHERE ASSIGNMENT_ID = p_assignment_id
      AND PERFORMANCE_ID = p_performance_cycle_id;

    -- 3️ If appraisal exists, update the overall score
    IF appraisal_exists > 0 THEN
        UPDATE APPRAISAL
        SET APPRAISAL_OVERALSCORE = total_weighted_score
        WHERE ASSIGNMENT_ID = p_assignment_id
          AND PERFORMANCE_ID = p_performance_cycle_id;
    ELSE
        -- Optional: create appraisal if it doesn't exist
        INSERT INTO APPRAISAL (
            ASSIGNMENT_ID,
            PERFORMANCE_ID,
            REVIEWER_ID,
            APPRAISAL_DATE,
            APPRAISAL_OVERALSCORE
        )
        VALUES (
            p_assignment_id,
            p_performance_cycle_id,
            NULL,          -- reviewer can be NULL if not assigned yet
            NOW(),
            total_weighted_score
        );
    END IF;

END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE CreateAppraisal(
    IN p_assignment_id INT,
    IN p_performance_id INT,
    IN p_reviewer_id INT,
    IN p_appraisal_date DATETIME
)
BEGIN
    -- Check if an appraisal already exists for this assignment/cycle
    IF EXISTS (
        SELECT 1 
        FROM APPRAISAL
        WHERE ASSIGNMENT_ID = p_assignment_id
          AND PERFORMANCE_ID = p_performance_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Appraisal for this assignment and performance cycle already exists.';
    END IF;

    -- Insert a new appraisal record
    INSERT INTO APPRAISAL (
        ASSIGNMENT_ID,
        PERFORMANCE_ID,
        REVIEWER_ID,
        APPRAISAL_DATE,
        APPRAISAL_OVERALSCORE
    )
    VALUES (
        p_assignment_id,
        p_performance_id,
        p_reviewer_id,
        p_appraisal_date,
        0 -- default score; will be updated later after KPIs
    );
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE SubmitAppeal(
    IN p_appraisal_id INT,
    IN p_submission_date DATE,
    IN p_reason VARCHAR(500)
)
BEGIN
    -- 1️⃣ Check if the appraisal exists
    IF NOT EXISTS (
        SELECT 1 FROM APPRAISAL
        WHERE APPRAISAL_ID = p_appraisal_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Appraisal does not exist.';
    END IF;

    -- 2️ Insert the appeal
    INSERT INTO APPEAL (
        Appraisal_ID,
        Submission_Date,
        Reason,
        Approval_Status,
        Original_Score,
        Appeal_Outcome_Score
    )
    VALUES (
        p_appraisal_id,
        p_submission_date,
        p_reason,
        'Pending',      -- default status
        (SELECT APPRAISAL_OVERALSCORE FROM APPRAISAL WHERE APPRAISAL_ID = p_appraisal_id),
        NULL            -- outcome score will be set after review
    );
END $$

DELIMITER ;

-- Training Procedures

DELIMITER $$

CREATE PROCEDURE AddTrainingProgram(
    IN p_program_code VARCHAR(50),
    IN p_title VARCHAR(100),
    IN p_objectives VARCHAR(255),
    IN p_type VARCHAR(50),
    IN p_subtype VARCHAR(50),
    IN p_delivery_method VARCHAR(50),
    IN p_approval_status VARCHAR(50)
)
BEGIN
    -- Insert a new training program
    INSERT INTO TRAINING_PROGRAM (
        Program_Code,
        Title,
        Objectives,
        Type,
        Subtype,
        Delivery_Method,
        Approval_Status
    )
    VALUES (
        p_program_code,
        p_title,
        p_objectives,
        p_type,
        p_subtype,
        p_delivery_method,
        p_approval_status
    );
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE RecordTrainingCompletion(
    IN p_et_id INT,                 -- Employee_Training_ID
    IN p_completion_status VARCHAR(50),
    IN p_certificate_file_path VARCHAR(255)  -- optional, can be NULL
)
BEGIN
    -- 1️ Validate Employee Training record exists
    IF NOT EXISTS (
        SELECT 1 FROM EMPLOYEE_TRAINING
        WHERE ET_ID = p_et_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Employee training record does not exist.';
    END IF;

    -- 2️ Validate completion status
    IF p_completion_status NOT IN ('Completed', 'In Progress', 'Not Started', 'Dropped') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Invalid completion status.';
    END IF;

    -- 3️ Update training completion status
    UPDATE EMPLOYEE_TRAINING
    SET Completion_Status = p_completion_status
    WHERE ET_ID = p_et_id;

    -- 4️ Optionally insert a training certificate if provided and status is Completed
    IF p_completion_status = 'Completed' AND p_certificate_file_path IS NOT NULL THEN
        INSERT INTO TRAINING_CERTIFICATE (ET_ID, Issue_Date, Certificate_File_Path)
        VALUES (p_et_id, NOW(), p_certificate_file_path);
    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE IssueTrainingCertificate(
    IN p_et_id INT,                 -- Employee_Training_ID
    IN p_certificate_file_path VARCHAR(255),
    IN p_issue_date DATE
)
BEGIN
    -- 1️⃣ Validate that the Employee Training record exists
    IF NOT EXISTS (
        SELECT 1 
        FROM EMPLOYEE_TRAINING
        WHERE ET_ID = p_et_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Employee training record does not exist.';
    END IF;

    -- 2️⃣ Ensure the training is completed before issuing a certificate
    IF NOT EXISTS (
        SELECT 1
        FROM EMPLOYEE_TRAINING
        WHERE ET_ID = p_et_id
          AND Completion_Status = 'Completed'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Training not completed. Cannot issue certificate.';
    END IF;

    -- 3️⃣ Insert certificate
    INSERT INTO TRAINING_CERTIFICATE (
        ET_ID,
        Issue_Date,
        Certificate_File_Path
    )
    VALUES (
        p_et_id,
        p_issue_date,
        p_certificate_file_path
    );
END $$

DELIMITER ;



















