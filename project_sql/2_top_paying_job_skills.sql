/*
Question: What skills are requried for the top-paying senior roles?
- Use the top 10 highest-paying senior roles from 1_top_paying_jobs.sql
- Add the specific skills required for these roles
- Why? IT provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop to make it to the senior bracket.
*/
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title LIKE '%Senior%' AND
        job_location LIKE '%Germany' AND 
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 15 -- Changed it to top 15 in the filter because we lose data from the inner join
    )

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;