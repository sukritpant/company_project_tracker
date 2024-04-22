-- CREATE DATABASE organization; -- Ran this individually
-- CREATE SCHEMA employee_info; --  Ran this to create new schema
SET search_path = employee_info, "$user", public; -- Ran this to make sure the schema will always be the created schema
CREATE TABLE IF NOT EXISTS employee_info.employees
(
    id serial,
    first_name character varying COLLATE pg_catalog."default" NOT NULL,
    last_name character varying COLLATE pg_catalog."default" NOT NULL,
    hire_date date NOT NULL,
    hourly_salary numeric NOT NULL,
    title_id integer,
    manager_id integer,
    team integer,
    CONSTRAINT employees_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS employee_info.hour_tracking
(
    employee_id integer NOT NULL,
    project_id integer NOT NULL,
    total_hours numeric NOT NULL,
    CONSTRAINT hour_tracking_pkey PRIMARY KEY (employee_id, project_id)
);

CREATE TABLE IF NOT EXISTS employee_info.projects
(
    id serial,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    client character varying COLLATE pg_catalog."default" NOT NULL,
    start_date date NOT NULL,
    deadline date NOT NULL,
    CONSTRAINT projects_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS employee_info.team_project
(
    team_id integer NOT NULL,
    project_id integer NOT NULL,
    CONSTRAINT team_project_pkey PRIMARY KEY (team_id, project_id)
);

CREATE TABLE IF NOT EXISTS employee_info.teams
(
    id serial,
    team_name character varying COLLATE pg_catalog."default" NOT NULL,
    location character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT teams_pkey PRIMARY KEY (id),
    CONSTRAINT ukey_teams UNIQUE (team_name)
);

CREATE TABLE IF NOT EXISTS employee_info.titles
(
    id serial,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT titles_pkey PRIMARY KEY (id),
    CONSTRAINT ukey_titles UNIQUE (name)
);

ALTER TABLE IF EXISTS employee_info.employees
    ADD CONSTRAINT employees_fkey_self FOREIGN KEY (manager_id)
    REFERENCES employee_info.employees (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE SET NULL
    NOT VALID;


ALTER TABLE IF EXISTS employee_info.employees
    ADD CONSTRAINT employees_fkey_teams FOREIGN KEY (team)
    REFERENCES employee_info.teams (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE SET NULL
    NOT VALID;


ALTER TABLE IF EXISTS employee_info.employees
    ADD CONSTRAINT employees_fkey_titles FOREIGN KEY (title_id)
    REFERENCES employee_info.titles (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE SET NULL
    NOT VALID;


ALTER TABLE IF EXISTS employee_info.hour_tracking
    ADD CONSTRAINT hour_tracking_fkey_employees FOREIGN KEY (employee_id)
    REFERENCES employee_info.employees (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE SET NULL;


ALTER TABLE IF EXISTS employee_info.hour_tracking
    ADD CONSTRAINT hour_tracking_fkey_projects FOREIGN KEY (project_id)
    REFERENCES employee_info.projects (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE SET NULL
    NOT VALID;


ALTER TABLE IF EXISTS employee_info.team_project
    ADD CONSTRAINT team_project_fkey_projects FOREIGN KEY (project_id)
    REFERENCES employee_info.projects (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE SET NULL
    NOT VALID;


ALTER TABLE IF EXISTS employee_info.team_project
    ADD CONSTRAINT team_project_fkey_teams FOREIGN KEY (team_id)
    REFERENCES employee_info.teams (id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE SET NULL;

-- Copying all the tables, need to change file path accordingly
COPY titles (name) FROM '/Library/data/titles.csv' DELIMITER ',' CSV HEADER;
COPY teams (team_name, location) FROM '/Library/data/teams.csv' DELIMITER ',' CSV HEADER;
COPY projects (name, client, start_date, deadline) FROM '/Library/data/projects.csv' DELIMITER ',' CSV HEADER;
COPY team_project (team_id, project_id) FROM '/Library/data/team_project.csv' DELIMITER ',' CSV HEADER;
COPY hour_tracking (employee_id, project_id, total_hours) FROM '/Library/data/hour_tracking.csv' DELIMITER ',' CSV HEADER;
COPY employees (first_name, last_name, hire_date, hourly_salary, title_id, manager_id, team) FROM '/Library/data/employees.csv' DELIMITER ';' CSV HEADER;