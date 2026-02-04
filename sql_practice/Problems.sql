----------------------------------------------------------------------------
/* Practice Problem 6
Create 3 tables: Jan 2023 jobs, Feb 2023 jobs, Mar 2023 jobs
*/

CREATE TABLE january_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE febraury_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

----------------------------------------------------------------------------
/* Mini-Practice: CASE WHEN
Categorize salaries from each job posting to see if it fits within a desired salary range
- Salary in buckets
- Define whats high, standard, or kow
- Only data analyst roles
- order from low to high
*/

SELECT 
    COUNT(job_id),
    CASE 
        WHEN salary_year_avg > 100000 THEN 'High'
        WHEN (salary_year_avg BETWEEN 50000 AND 100000) THEN 'Average'
        ELSE 'Low'
    END AS salary_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY salary_category;


/* Mini-Practice: CTE
Find the companies that have the most job openings.
- Get the total number of postins per company id
- Return the total number of jobs with the company name
*/
-- You will need to run the WITH along with the later chunk/
WITH job_counts AS (
    SELECT 
        COUNT(job_id) as totals,
        company_id
    FROM 
        job_postings_fact
    GROUP BY company_id
    )

SELECT 
    name,
    job_counts.totals
FROM company_dim
LEFT JOIN job_counts ON job_counts.company_id = company_dim.company_id
ORDER BY totals DESC;

/* Mini-Practice: Sub-query
- Identify the top 5 skills that are most frequently mentioned. 
- Use sub-query to find skill ids with highest counts and join results
*/

SELECT s.skills, skill_counts.skill_count
FROM (
    SELECT skill_id, COUNT(*) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY skill_count DESC
    LIMIT 5
) AS skill_counts
JOIN skills_dim s ON skill_counts.skill_id = s.skill_id;

/* Subquery II
Determine size category small, medium, or large for each company.
- Identify # of openings; Use subquery to calc the number of total job postings per company. 
- Small < 10
- Medium between 10 and 50
- Large more than 50
Use subquery to aggregate job counts per company before classifying them based on size
*/
-- 1: Count of job posts per company id
SELECT
    COUNT(job_id) AS posts,
    company_id
FROM job_postings_fact
GROUP BY company_id
ORDER BY posts DESC;

-- 2: Combine and use CASE WHEN
SELECT 
    company_dim.name, 
    job_counts.posts,
    CASE 
        WHEN job_counts.posts > 50 THEN 'Large'
        WHEN job_counts.posts BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Small'
    END AS size
FROM (
    SELECT
        COUNT(job_id) AS posts,
        company_id
    FROM job_postings_fact
    GROUP BY company_id
    ) AS job_counts
LEFT JOIN company_dim ON job_counts.company_id = company_dim.company_id
ORDER BY job_counts.posts DESC;


----------------------------------------------------------------------------
/* Practice Problem 7: 
Find the count of the number of remote jobs postings per skill
- Display top 5 skills by their demand in remote jobs
- Include skill ID, name, count of postings requring that skill
*/
-- Version 1 with CTE and subquery
WITH remote AS (
    SELECT job_id
    FROM job_postings_fact
    WHERE 
        job_work_from_home = true AND 
        job_title_short = 'Data Analyst' -- optional filter
)

SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    skill_counts.totals
FROM (
    SELECT -- Filtering skills dim with remote job
    skill_id,
    COUNT(job_id) AS totals
    FROM skills_job_dim
    WHERE job_id IN (SELECT * FROM remote)
    GROUP BY skill_id
    ) AS skill_counts
INNER JOIN skills_dim ON skills_dim.skill_id = skill_counts.skill_id
ORDER BY skill_counts.totals DESC
LIMIT 5;

-- Alternative method (with only CTE):
WITH remote_jobs_skills AS (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = true AND
        job_postings.job_title_short = 'Data Analyst' -- optional filter
    GROUP BY skill_id
    )

SELECT 
    skill.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_jobs_skills
INNER JOIN skills_dim AS skill ON skill.skill_id = remote_jobs_skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;

----------------------------------------------------------------------------
/* Practice Problem 8:
Find a job postings from the first quarter that habe a salary greater than $70K
- Combine job posting tables from the very first quarter of 2023 (Jan-Mar)
- Gets job postings with an average salary > $70,000
*/


WITH Q1 AS (
    SELECT *
    FROM january_jobs

    UNION ALL -- combine a table

    SELECT *
    FROM febraury_jobs

    UNION ALL -- combine another table

    SELECT *
    FROM march_jobs
) --NOTE: You can also use this as a subquery in the FROM statement

SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::date,
    salary_year_avg    
FROM Q1
WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;
