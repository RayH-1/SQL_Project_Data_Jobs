/* Question: What are the top-paying Data Science related jobs?
- Identify the top 10 highest-paying senior roles that are available in Germany.
- Focuses on job posting with specified salaries (remove nulls)
- Identify which company a job posting is from
-  Why? Highlight the top-paying opportunities for Data Scientists with experience.*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title LIKE '%Senior%' AND
    job_location LIKE '%Germany' AND -- Find roles in any location in Germany 
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
