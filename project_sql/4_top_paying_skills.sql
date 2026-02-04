/*
Question: What are the top skills based on salary?
- Look for the average salary associated with each skill for all senior roles.
- Focus on roles with specified salaries, regarless of location
- Why? It reveals how different skills impact salary levels for senior roles and
    helps identify the most financially rewarding skills to acquire or improve
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS skill_pay_avg
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title LIKE '%Senior%' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY skill_pay_avg DESC
LIMIT 25;

-- How does it compare to roles in Germany
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS skill_pay_avg
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title LIKE '%Senior%' AND
    job_location LIKE '%Germany' AND 
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY skill_pay_avg DESC
LIMIT 25;