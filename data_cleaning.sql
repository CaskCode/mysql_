-- Data Cleaning Process

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Handle Null Values
-- 4. Remove Unnecessary Columns

-- Use the database
USE world_layoffs;

-- Display the current data in the `layoffs_staging` table
SELECT * FROM layoffs_staging;

-- Step 1: Creating a duplicate table to perform edits
-- Create a new table `layoffs_staging` with the same structure as `layoffs`
CREATE TABLE layoffs_staging LIKE layoffs;

-- Insert all data from `layoffs` into the new `layoffs_staging` table
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- Step 2: Removing duplicates using a Common Table Expression (CTE)
-- Create a CTE to identify duplicate rows based on selected columns
WITH duplicate_cte AS 
(
    SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, 
        percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM layoffs_staging
)

-- Run this query to check duplicate rows (row_num > 1 indicates duplicates)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- Step 3: Create a new table and add `row_num` as a persistent column
CREATE TABLE `layoffs_staging2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert the data from `layoffs_staging` into `layoffs_staging2`
-- Add `row_num` as a persistent column
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`
) AS row_num
FROM layoffs_staging;

-- Query to check duplicates in `layoffs_staging2`
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Delete duplicates where `row_num > 1` in `layoffs_staging2`
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- If you get an error about safe mode, follow these steps to disable safe mode temporarily
-- Safe mode prevents accidental deletions/updates without a WHERE or LIMIT clause
SET SQL_SAFE_UPDATES = 0;

-- Re-run the DELETE query after disabling safe mode

-- Optionally, re-enable safe mode after deletion
SET SQL_SAFE_UPDATES = 1;

-- Verify that duplicate rows have been removed
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Step 4: Standardizing Data

-- Example of using the TRIM function to remove leading/trailing spaces from company names
SELECT company, TRIM(company) AS trim_company
FROM layoffs_staging2;

-- Update the `company` column with trimmed values
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize values in the `industry` column to match "Crypto"
SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Update `industry` to "Crypto" for rows that start with "Crypto"
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- List unique locations in alphabetical order
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- Standardize `country` values to remove trailing periods
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) AS clean_country
FROM layoffs_staging2
ORDER BY 1;

-- Update the `country` column to remove trailing periods
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Convert date strings to a consistent date format using STR_TO_DATE
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') AS formatted_date
FROM layoffs_staging2;

Update layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

Alter table layoffs_staging2
Modify column `date` date; 

-- checking null values
select *
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL
and industry is NULL or
industry = '';

Use world_layoffs;

select * from 
layoffs_staging2
where company like 'bally%';

Update layoffs_staging2
SET industry = NULL
Where industry = '';


SELECT t1.industry, t2.industry from
layoffs_staging2 t1
join  layoffs_staging2 t2	
	on t1.company = t2.company
	AND t1.location=t2.location
where (t1.industry is Null or t1.industry = '')
AND t2.industry is not NULL;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry =t2.industry
where (t1.industry is NULL OR t1.industry = '')
and t2.industry is NOT NULL;

SET SQL_SAFE_UPDATES = 0;









