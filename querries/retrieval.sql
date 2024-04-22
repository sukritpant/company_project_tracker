SET search_path = employee_info, "$user", public;
-- Retreiving project count for each team
SELECT teams.team_name, count(team_project.project_id) AS project_count
FROM teams
LEFT JOIN team_project ON teams.id = team_project.team_id
GROUP BY teams.team_name;

-- Retreiving projects managed by people starting with 'J' or 'D'
SELECT *
FROM projects
JOIN team_project on projects.id = team_project.project_id
JOIN employees on team_project.team_id = employees.team
WHERE employees.manager_id IS NOT NULL AND (employees.first_name LIKE 'J%' or employees.first_name LIKE 'D%');

-- Retreiving everyone managed by Michael Williams
WITH RECURSIVE hierarchy AS (
SELECT id, first_name, last_name, manager_id
FROM employees
WHERE first_name = 'Michael' AND last_name = 'Williams'
UNION ALL
SELECT employees.id, employees.first_name, employees.last_name, employees.manager_id
FROM employees
JOIN hierarchy ON employees.manager_id = hierarchy.id
)
SELECT * FROM hierarchy;

-- Retrieving average salary for each position
SELECT name AS title, ROUND(AVG(employees.hourly_salary),2) AS average_salary
FROM titles
JOIN employees ON titles.id = employees.title_id
GROUP BY name;

-- Retrieving people who make mor ethan the team average salary
WITH avgsalary AS (
SELECT team, AVG(hourly_salary) AS avg_team
FROM employees
GROUP BY team
)

SELECT *
FROM employees
JOIN avgsalary ON employees.team = avgsalary.team
WHERE employees.hourly_salary > avgsalary.avg_team
ORDER BY employees.team;

-- Projects with more than 3 teams assigned
SELECT projects.*
FROM projects
JOIN team_project ON projects.id = team_project.project_id
GROUP BY projects.id, projects.name, projects.client, projects.start_date, projects.deadline
HAVING COUNT(team_project.team_id) > 3;

-- Total hourly salary for each team
SELECT teams.team_name, SUM(employees.hourly_salary) AS total_salary_hourly
FROM teams
JOIN employees ON teams.id = employees.team
GROUP BY teams.team_name;