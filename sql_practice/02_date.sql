-- You can use the ::DATE to remote the time information
SELECT 
    job_title AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM job_postings_fact
LIMIT 100;

--Data in our database has no time zone informaion
---- The data is UTC and we want to covert to EST you use the AT TIME ZONE twice
SELECT 
    job_title AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS time_date
FROM job_postings_fact
LIMIT 5;


-- Extract parts from date

SELECT 
    job_title AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS time_date,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM job_postings_fact
LIMIT 5;

--- Use Case: How job postings are trending from Month to Month?
SELECT 
    COUNT(job_id) AS job_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
GROUP BY month
ORDER BY job_count DESC;