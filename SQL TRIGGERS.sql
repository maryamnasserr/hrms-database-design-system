-- Triggers on JOB_OBJECTIVE:
DELIMITER $$

CREATE TRIGGER trg_validate_objective_weight
BEFORE INSERT ON JOB_OBJECTIVE
FOR EACH ROW
BEGIN
    DECLARE total_weight DECIMAL(5,2);

    -- Calculate current total weight for the job
    SELECT IFNULL(SUM(Weight), 0)
    INTO total_weight
    FROM JOB_OBJECTIVE
    WHERE Job_ID = NEW.Job_ID;

    -- Check if adding the new objective exceeds 100%
    IF (total_weight + NEW.Weight) > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Total objective weight for this job cannot exceed 100%';
    END IF;
END $$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_prevent_objective_delete
BEFORE DELETE ON JOB_OBJECTIVE
FOR EACH ROW
BEGIN
    DECLARE kpi_count INT;

    -- Count KPIs linked to this objective
    SELECT COUNT(*)
    INTO kpi_count
    FROM OBJECTIVE_KPI
    WHERE Objective_ID = OLD.Objective_ID;

    -- If any KPI exists, prevent deletion
    IF kpi_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot delete objective with linked KPIs';
    END IF;
END $$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_prevent_employee_delete
BEFORE DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE active_count INT;

    -- Count active job assignments for this employee
    SELECT COUNT(*)
    INTO active_count
    FROM JOB_ASSIGNMENT
    WHERE EMPLOYEE_ID = OLD.Employee_ID
      AND STATUS = 'Active';

    -- If any active assignments exist, prevent deletion
    IF active_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot delete employee with active job assignments';
    END IF;
END $$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_calc_weighted_score
AFTER INSERT ON EMPLOYEE_KPI_SCORE
FOR EACH ROW
BEGIN
    DECLARE kpi_weight DECIMAL(5,2);

    -- Get the KPI weight from OBJECTIVE_KPI table
    SELECT Weight
    INTO kpi_weight
    FROM OBJECTIVE_KPI
    WHERE KPI_ID = NEW.KPI_ID;

    -- Update the Weighted_Score in EMPLOYEE_KPI_SCORE
    UPDATE EMPLOYEE_KPI_SCORE
    SET Weighted_Score = NEW.Employee_Score * (kpi_weight / 100)
    WHERE Score_ID = NEW.Score_ID;
END $$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_prevent_training_delete
BEFORE DELETE ON TRAINING_PROGRAM
FOR EACH ROW
BEGIN
    DECLARE assigned_count INT;

    -- Count how many employees are assigned this training
    SELECT COUNT(*)
    INTO assigned_count
    FROM EMPLOYEE_TRAINING
    WHERE Program_ID = OLD.Program_ID;

    -- If any assignments exist, prevent deletion
    IF assigned_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot delete training program assigned to employees';
    END IF;
END $$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER trg_validate_training_certificate
BEFORE INSERT ON TRAINING_CERTIFICATE
FOR EACH ROW
BEGIN
    -- Check if the Employee Training record exists
    IF NOT EXISTS (
        SELECT 1
        FROM EMPLOYEE_TRAINING
        WHERE ET_ID = NEW.ET_ID
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot issue certificate. Employee training record does not exist.';
    END IF;
END $$

DELIMITER ;






