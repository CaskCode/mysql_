-- Select all columns from the layoffs_staging2 table.
-- This gives a complete view of the dataset for initial exploration.
SELECT * 
FROM layoffs_staging2;

-- Find the maximum values for total_laid_off and percentage_laid_off columns.
-- This helps identify the largest layoffs and their corresponding percentage.
SELECT MAX(total_laid_off), MAX(percentage_laid_off) 
FROM layoffs_staging2;

-- Select rows where the percentage_laid_off is 1 (100% of staff laid off).
-- Orders the result by funds_raised_millions in descending order to find companies that raised the most funds but still laid off 100% of their staff.
SELECT * 
FROM layoffs_staging2 
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

-- Calculate the total number of layoffs for each company.
-- Groups by company and orders results by total layoffs in descending order.
SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY company 
ORDER BY 2 DESC;

-- Find the earliest and latest dates in the dataset.
-- Helps establish the timeframe of the data.
SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2;

-- Calculate the total number of layoffs by country.
-- Groups by country and orders by total layoffs in descending order.
SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY country 
ORDER BY 2 DESC;

-- Retrieve distinct companies in the 'consumer' industry.
-- Useful for filtering and analyzing data specific to this industry.
SELECT DISTINCT company 
FROM layoffs_staging2 
WHERE industry = 'consumer';

-- Select all columns from the layoffs_staging2 table again.
-- Likely for further exploration or debugging purposes.
SELECT * 
FROM layoffs_staging2;

-- Calculate the total number of layoffs by company stage.
-- Groups by the `stage` column and orders results alphabetically by stage.
SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY stage 
ORDER BY 1 DESC;

-- Calculate a rolling total of layoffs by month.
-- Uses a Common Table Expression (CTE) to group data by month (using substring of the date column) and calculates cumulative totals.
WITH Rolling_Total AS (
    SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_off 
    FROM layoffs_staging2 
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL 
    GROUP BY `month` 
    ORDER BY 1 ASC
) 
SELECT `month`, total_off, 
       SUM(total_off) OVER(ORDER BY `month`) AS rolling_total 
FROM Rolling_Total;

-- Calculate the total layoffs for each company and rank them by year.
-- Groups by company and year, then orders results by the total layoffs in descending order.
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY company, YEAR(`date`) 
ORDER BY 3 DESC;

-- Identify the top 5 companies with the most layoffs for each year.
-- Uses a CTE to calculate yearly layoffs for each company and ranks them using DENSE_RANK.
WITH company_year(company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) 
    FROM layoffs_staging2 
    GROUP BY company, YEAR(`date`)
), 
company_year_rank AS (
    SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking 
    FROM company_year 
    WHERE years IS NOT NULL
) 
SELECT * 
FROM company_year_rank 
WHERE ranking <= 5;
-- This query identifies the top 5 companies with the highest layoffs for each year.
