/*
Question: What are the most in-demand skills for senior data-related roles?
- Join job postings to inner join table similar to 2_top_paying_job_skills.sql
- Identify the top 5 in-demand skills for said roles
- Focus on all job postings
- Why? Retrieves top 5 skills with the highest demand in the job market,
    providing insights into the most valuable skills for job seekers.
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title LIKE '%Senior%' AND
    job_location LIKE '%Germany'  
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;


-- Comparing to what ALL roles with-in Germany asks for (not just senior)
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_location LIKE '%Germany'  
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;

--Comparing to what skills are needed specifically in Berlin
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title LIKE '%Senior%' AND
    job_location = 'Berlin, Germany'  
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;

--Comparing to what skills are needed specifically in Berlin for ALL roles
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_location = 'Berlin, Germany'  
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;