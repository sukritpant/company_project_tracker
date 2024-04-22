SET search_path = employee_info, "$user", public;

-- Work tracking function
CREATE OR REPLACE FUNCTION track_working_hours(emp_id INT, proj_id INT, hours_worked NUMERIC)
RETURNS VOID AS $$
BEGIN
    
    IF NOT EXISTS (
        SELECT 1
        FROM employees
        JOIN team_project ON employees.team = team_project.team_id
        WHERE employees.id = emp_id AND team_project.project_id = proj_id
    ) THEN
        RAISE EXCEPTION 'Employee % does not belong to Project %', emp_id, proj_id;
    END IF;

    INSERT INTO hour_tracking(employee_id, project_id, total_hours)
    VALUES(emp_id, proj_id, hours_worked);
END;
$$ LANGUAGE plpgsql;

-- Track working hour function test
SELECT track_working_hours(20, 7, 40.5);
SELECT track_working_hours(23, 7, 32.25);
-- The ones below should provide error
SELECT track_working_hours(12, 7, 22.75);
SELECT track_working_hours(25, 21, 7.75);

-- Checkking if the correct working hours were added
SELECT * from hour_tracking;

CREATE OR REPLACE FUNCTION create_project(project_name VARCHAR, client_name VARCHAR, start_date DATE, deadline DATE, team_ids INT[])
RETURNS VOID AS $$
DECLARE new_project_id INT; team_id INT;
BEGIN
    INSERT INTO projects(name, client, start_date, deadline)
    VALUES(project_name, client_name, start_date, deadline)
    RETURNING id INTO new_project_id;

	FOR team_id IN SELECT unnest(team_ids)
    LOOP
        INSERT INTO team_project(team_id, project_id)
        VALUES(team_id, new_project_id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Checking create project function
SELECT create_project(
    'New Project',
    'Client XYZ',
    '2023-07-01',
    '2023-12-31',
    ARRAY[1, 2, 3]
);

SELECT create_project(
    'Project Helio',
    'Don and Sons',
    '2023-07-01',
    '2023-12-31',
    ARRAY[4, 2, 5]
);

SELECT * from projects;
SELECT * from hour_tracking;

