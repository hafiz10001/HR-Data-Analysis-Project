CREATE DATABASE hr;
USE hr;

-- Cleaning Data

SELECT *
FROM human_resources ;

ALTER TABLE human_resources
MODIFY COLUMN ï»؟id VARCHAR(20) NULL;

DESCRIBE human_resources ;

ALTER TABLE human_resources
RENAME COLUMN ï»؟id TO emp_id ;


SELECT *
FROM human_resources ;

SELECT birthdate
FROM human_resources ;

UPDATE human_resources
SET birthdate = CASE
	WHEN birthdate like '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'),'%Y-%m-%d')
    WHEN birthdate like '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;
    
ALTER TABLE human_resources
MODIFY COLUMN birthdate DATE;

DESCRIBE human_resources ;


UPDATE human_resources
SET hire_date = CASE
	WHEN hire_date like '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'),'%Y-%m-%d')
    WHEN hire_date like '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;
    
SELECT hire_date
FROM human_resources ;

ALTER TABLE human_resources
MODIFY COLUMN hire_date DATE;

DESCRIBE human_resources ;

UPDATE human_resources
SET termdate = DATE(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE  termdate is not null;

UPDATE human_resources
SET termdate = '0000-00-00'
WHERE  termdate= '';

UPDATE human_resources
SET termdate = null
WHERE  termdate=  '0000-00-00';

SELECT termdate
FROM human_resources ;

ALTER TABLE human_resources
MODIFY COLUMN termdate DATE;

DESCRIBE human_resources ;

SELECT *
FROM human_resources ;

ALTER TABLE human_resources
ADD COLUMN age INT;

UPDATE human_resources
SET age = timestampdiff(YEAR,birthdate,CURDATE());

SELECT age
FROM human_resources ;

SELECT 
    MIN(age) AS yuongest, MAX(age) AS older
FROM
    human_resources;
SELECT COUNT(*)
FROM human_resources
WHERE age < 18;


-- What is gender brekdown of employeesin the company?

SELECT 
	gender, COUNT(*) AS count
FROM 
	human_resources
WHERE 
	age >= 18 AND termdate IS NULL
GROUP BY gender;

-- What is the race/ethnicity breakdown of employee in company ?

SELECT 
	race, COUNT(*) AS count
FROM 
	human_resources
WHERE 
	age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY count DESC;

-- What is age distribution of employee in the company ?

SELECT 
	MIN(age) AS yougest, MAX(age) AS oldest
FROM 
	human_resources
WHERE 
	age >= 18 AND termdate IS NULL ;


SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
		ELSE '65+'
    END AS age_group, COUNT(*) AS count
FROM
	human_resources
WHERE 
	age >= 18 AND termdate IS NULL 
    GROUP BY age_group
    ORDER BY age_group;
    
-- How many employees work atr headquarters versus remote location ?  
  
SELECT 
	location, COUNT(*) AS count
FROM 
	human_resources
WHERE 
	age >= 18 AND termdate IS NULL 
    GROUP BY location;
    
    -- What is the average length of employment for employees who have been terminated ?
    
SELECT 
	ROUND(AVG(DATEDIFF(termdate,hire_date)/365)) AS avg_length_employment
FROM 
	human_resources
WHERE 
	age >= 18 AND termdate IS NOT NULL ;
    
    
-- How dose gender distributin vary across departments and job title ?
    
SELECT 
	department, gender , COUNT(*) AS count
FROM 
	human_resources
WHERE 
	age >= 18 AND termdate IS NULL
GROUP BY department, gender
ORDER BY department ;

-- What is the destribution of job title across the company ?

SELECT 
	jobtitle, COUNT(*) AS count
FROM
	human_resources
WHERE 
	age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY count  DESC;


-- Which department has the highest turnover rate?

SELECT
	department,
    total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM (
	SELECT department,
    COUNT(*) AS total_count,
    SUM(CASE
		WHEN termdate IS NOT NULL AND termdate<= curdate() THEN 1 
        ELSE 0 END) AS terminated_count
	FROM 
		human_resources
	WHERE age>=18
    GROUP BY department) AS subquary
ORDER BY termination_rate DESC;

-- What is the destribution of employees across location by city ?

SELECT 
	location_state,
    COUNT(*) AS count
FROM
		human_resources
	WHERE age>=18 AND termdate is NULL 
GROUP BY  location_state
ORDER BY  count DESC;

-- How has company's employee count change over time based on hire term date ?

SELECT
	year,
    hires,
    termination,
    hires - termination AS net_change,
    ROUND((hires - termination)/ hires *100,2) AS net_change_percent
FROM ( 
	SELECT
			year(hire_date) AS year,
            COUNT(*) AS hires,
            SUM( CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS termination
		FROM 
            human_resources
            WHERE age>=18
            GROUP BY YEAR(hire_date)
            ) AS subquary
	ORDER BY year ASC ;
    
    -- What is the tenure distribution for each department?
    
    SELECT
		department,
        ROUND(AVG(datediff(termdate, hire_date)/365),0) AS avg_tenur
	FROM
		 human_resources
	WHERE termdate <= curdate() AND termdate IS NOT NULL AND age >=18
	GROUP BY department;
    
    