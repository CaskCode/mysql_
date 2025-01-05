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
Select *,
row_number() over(
Partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;


With duplicate_cte as 
(
Select *,
row_number() over(
Partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions
) as row_num
from layoffs_staging
)
select * 
from duplicate_cte
where row_num > 1;





