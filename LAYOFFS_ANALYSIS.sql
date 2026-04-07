-- =====================================================
-- 📊 DATA EXPLORATION PROJECT: LAYOFFS ANALYSIS
-- =====================================================

-- PROBLEM STATEMENT:
-- Analyze global layoffs data to identify trends over time,
-- top affected companies, and yearly layoff patterns.

-- =====================================================
-- 1. OVERVIEW METRICS
-- =====================================================

-- Maximum layoffs and percentage laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff_staging2;

-- Company with highest single layoff event
SELECT *
FROM layoff_staging2
WHERE total_laid_off = 12000;

-- =====================================================
-- 2. COMPANY-LEVEL ANALYSIS
-- =====================================================

-- Total layoffs by company
SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

-- =====================================================
-- 3. TIME ANALYSIS
-- =====================================================

-- Dataset date range
SELECT MAX(`date`), MIN(`date`)
FROM layoff_staging2;

-- Year-wise layoffs trend
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- =====================================================
-- 4. COMPANY LAYOFFS PER YEAR
-- =====================================================

SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_off
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- =====================================================
-- 5. TOP COMPANIES PER YEAR (RANKING)
-- =====================================================

WITH company_year (company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_off
    FROM layoff_staging2
    GROUP BY company, YEAR(`date`)
),
company_year_ranking AS (
    SELECT *,
    DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM company_year
    WHERE years IS NOT NULL
)

SELECT *
FROM company_year_ranking
WHERE ranking <= 5;