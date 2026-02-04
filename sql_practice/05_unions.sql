
-- Combine two tables vertically (NOT JOIN: MUST HAVE SAME DATATYPE & COLUMN NUMBERS)
SELECT
    job_title_short,
    company_id,
    job_location
FROM january_jobs

UNION -- combine a table

SELECT
    job_title_short,
    company_id,
    job_location
FROM febraury_jobs

UNION -- combine another table

SELECT
    job_title_short,
    company_id,
    job_location
FROM march_jobs


/*Use UNION ALL to keep duplicates! Regular UNION deletes duplicates!
This is more common.
*/
SELECT
    job_title_short,
    company_id,
    job_location
FROM january_jobs

UNION ALL -- combine a table

SELECT
    job_title_short,
    company_id,
    job_location
FROM febraury_jobs

UNION ALL -- combine another table

SELECT
    job_title_short,
    company_id,
    job_location
FROM march_jobs