/*
COVID-19 DATA ANALYSIS SCRIPT
This script analyzes COVID-19 data from the tables `CovidDeaths` and `CovidVaccinations` within the `PortfolioProject` schema. It includes queries for key metrics like infection rates, death rates, and vaccination progress.
*/

-- STEP 1: View Raw Data

-- Display all records from CovidDeaths table
SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY location, date;

-- Display all records from CovidVaccinations table
SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY location, date;


-- STEP 2: Analyze Total Cases vs Total Deaths

-- Calculate the likelihood of dying if infected by COVID-19
SELECT location, date, total_cases, total_deaths,
       (CONVERT(FLOAT, total_deaths) / NULLIF(CONVERT(FLOAT, total_cases), 0)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY location, date;


-- STEP 3: Analyze Total Cases vs Population

-- Calculate the percentage of the population that got infected
SELECT location, date, total_cases, population,
       (CONVERT(FLOAT, total_cases) / NULLIF(CONVERT(FLOAT, population), 0)) * 100 AS InfectionPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY location, date;

-- Identify countries with the highest infection rates
SELECT location, population,
       MAX(total_cases) AS HighestInfectionCount,
       MAX((CONVERT(FLOAT, total_cases) / NULLIF(CONVERT(FLOAT, population), 0)) * 100) AS InfectionPercentage
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY InfectionPercentage DESC;


-- STEP 4: Analyze Death Counts

-- Identify countries with the highest total death counts
SELECT location,
       MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Aggregate death counts by continent
SELECT continent,
       MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Calculate global COVID-19 statistics
SELECT SUM(new_cases) AS TotalCases,
       SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
       (CONVERT(FLOAT, SUM(new_deaths)) / NULLIF(CONVERT(FLOAT, SUM(new_cases)), 0)) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL;


-- STEP 5: Analyze Vaccination Progress

-- Use a CTE to calculate rolling vaccination numbers by country
WITH PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (
               PARTITION BY dea.location
               ORDER BY dea.location, dea.date
           ) AS RollingPeopleVaccinated
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
       AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *,
       (CONVERT(FLOAT, RollingPeopleVaccinated) / NULLIF(CONVERT(FLOAT, population), 0)) * 100 AS VaccinationPercentage
FROM PopVsVac;


-- STEP 6: Temporary Table for Vaccination Progress

-- Create a temporary table for vaccination statistics
DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated (
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_Vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

-- Insert vaccination data into the temporary table
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (
           PARTITION BY dea.location
           ORDER BY dea.location, dea.date
       ) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- Query the temporary table
SELECT *,
       (CONVERT(FLOAT, RollingPeopleVaccinated) / NULLIF(CONVERT(FLOAT, population), 0)) * 100 AS VaccinationPercentage
FROM #PercentPopulationVaccinated;


-- STEP 7: Create a View for Vaccination Data

-- Create a view for easy access to vaccination progress data
CREATE OR ALTER VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (
           PARTITION BY dea.location
           ORDER BY dea.location, dea.date
       ) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
