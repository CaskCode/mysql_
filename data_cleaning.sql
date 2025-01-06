-- Data cleaning

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null values
-- 4. Remove any Columns

use world_layoffs;

select * from layoffs_staging;

-- creating a duplicate table to perform edits
Create table layoffs_staging
like layoffs;
insert into layoffs_staging
select *
from layoffs;

-- Removing duplicates

With duplicate_cte as 
(
Select *,
row_number() over(
Partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions
) as row_num
from layoffs_staging
)

-- Run this query to check duplicates
select * 
from duplicate_cte
where row_num > 1;

-- Create a new table and add row_num as a persistent column
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- Insert the data from layoffs_staging into layoffs_staging2, this time round, with row_num being persistent

INSERT INTO layoffs_staging2
Select *,
row_number() over(
Partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

-- this query returns the duplicates in layoffs_staging2
select *
 from layoffs_staging2
where row_num>1;

-- delete the duplicates
delete 
 from layoffs_staging2
where row_num>1;


/*
Incase you get an error 'you are using safe update mode to update a table without a....
just disable the safe mode temporarily
*/
-- run this query to disable safe mode and rerun the delete query, this time it should work 
SET SQL_SAFE_UPDATES = 0;


-- Optionally, re-enable safe mode after you're done
SET SQL_SAFE_UPDATES = 1;

/*
NOTES
What is Safe Mode?
Safe mode (SQL_SAFE_UPDATES) prevents accidental deletion or update of data when WHERE or LIMIT is missing.

How to Handle Safe Mode Errors?
1. Disable safe mode temporarily (SET SQL_SAFE_UPDATES = 0).

2. Add a WHERE clause or a LIMIT to your query.
When to Re-enable Safe Mode?

After performing sensitive operations, turn it back on (SET SQL_SAFE_UPDATES = 1) for added safety.

*/

--  Run this query to confirm the rows have been deleted
SELECT *
from layoffs_staging2
where row_num >1;


-- Standardiziing data

/* The TRIM() function removes leading (spaces before the text)
 and trailing (spaces after the text) whitespace characters from a string 
 */
 
Select company, trim(company) as trim_company
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select * 
from layoffs_staging2
where industry LIKE 'Crypto';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct location
from layoffs_staging2
order by 1;

select * 
from layoffs_staging2
where location like '%dorf';


update layoffs_staging2
set industry = 'Dusseldorf'
where industry like 'dorf%';




