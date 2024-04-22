-- CREATE database employee_database;

-- CREATE SCHEMA employee_details AUTHORIZATION sukritpant;

CREATE TABLE IF NOT EXISTS employee_details.titles(
title_id SERIAL PRIMARY KEY,
name VARCHAR);

CREATE TABLE IF NOT EXISTS employee_details.teams (
    team_id SERIAL PRIMARY KEY,
    team_name VARCHAR,
    location VARCHAR
);

CREATE TABLE IF NOT EXISTS employee_details.projects (
    project_id SERIAL PRIMARY KEY,
    name VARCHAR,
    client VARCHAR,
    start_date DATE,
    deadline DATE
);

CREATE TABLE IF NOT EXISTS employee_details.team_project (
    team_id INT,
    project_id INT,
    FOREIGN KEY (team_id) REFERENCES employee_details.teams(team_id),
    FOREIGN KEY (project_id) REFERENCES employee_details.projects(project_id)
);
CREATE TABLE IF NOT EXISTS employee_details.employees(
employee_id SERIAL PRIMARY KEY,
	first_name VARCHAR,
	last_name VARCHAR,
	hire_date DATE,
	hourly_salary DECIMAL (10,2),
	title_id INT,
	manager_id INT,
	team INT,
	FOREIGN KEY (title_id) REFERENCES employee_details.titles(title_id),
    FOREIGN KEY (manager_id) REFERENCES employee_details.employees(employee_id),
    FOREIGN KEY (team) REFERENCES employee_details.teams(team_id)
)

-- GRANT pg_read_server_files TO sukritpant;

-- copy employee_details.titles (name) FROM '/Users/sukritpant/Downloads/6_company-database/data/titles.csv' DELIMITER ',' CSV HEADER;
