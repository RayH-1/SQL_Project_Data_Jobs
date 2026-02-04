/* 
Question: What are teh most optimal skills to learn (aka it's in high demand and high paying)?
- Identify all skills in high demand and associated with average high salaries for senior roles
- Conentrates on positions in Germany with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development
*/
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title LIKE '%Senior%' AND
        job_location LIKE '%Germany' AND
        salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), average_salary AS ( -- When doing two CTEs you only need one WITH command
    SELECT 
        skills_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title LIKE '%Senior%' AND
        job_location LIKE '%Germany' AND
        salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
)


SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 5 -- Using counts over 5 just to remove any outliers
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;



-- Making a more concise version of the above.
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title LIKE '%Senior%' AND    
    salary_year_avg IS NOT NULL AND
    job_location LIKE '%Germany' 
GROUP BY skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 5
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
