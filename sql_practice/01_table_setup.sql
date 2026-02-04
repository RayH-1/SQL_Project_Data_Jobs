-- Create a new table
CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resule_file_name VARCHAR(255),
    cover_letter_send BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)
);

-- See whats in table
SELECT *
FROM job_applied;


-- Insert Values into Table
INSERT INTO job_applied 
            (job_id,
             application_sent_date,
             custom_resume,
             resule_file_name,
             cover_letter_send,
             cover_letter_file_name,
             status)
VALUES      (1,
            '2024-02-01',
             true,
             'resume_01.pdf',
             true,
             'cover_letter_01.pdf',
             'submitted'),
             (2,
            '2024-02-01',
             true,
             'resume_01.pdf',
             true,
             'cover_letter_01.pdf',
             'submitted'),
             (3,
            '2024-02-01',
             true,
             'resume_01.pdf',
             true,
             'cover_letter_01.pdf',
             'submitted'),
             (4,
            '2024-02-04',
             true,
             'resume_04.pdf',
             true,
             'cover_letter_04.pdf',
             'submitted');

-- Modify table
---- Add column
ALTER TABLE job_applied
ADD contact VARCHAR(50);

---- Update values
UPDATE job_applied
SET    contact = 'Erlich'
WHERE  job_id = 1;

UPDATE job_applied
SET    contact = 'Dinest'
WHERE  job_id = 2;

UPDATE job_applied
SET    contact = 'Bert'
WHERE  job_id = 3;

UPDATE job_applied
SET    contact = 'Ji'
WHERE  job_id = 4;

---- Rename Columns
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

----- Change column type
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

----- Delete a column
ALTER TABLE job_applied
DROP COLUMN contact_name;

-- Delete a table (PERMANENT!)
DROP TABLE job_applied;


-- Casting Data Types 
SELECT 
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'true'::BOOLEAN,
    '3.14'::REAL;

