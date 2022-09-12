-- counting rows in tables

SELECT COUNT(*) as 'CountCovidVaccinations'
FROM Portfolio1.CovidVaccinations cv ;

SELECT COUNT(*) as 'CountCovidDeaths'
FROM Portfolio1.CovidDeaths cd ; 

-- describing tables

desc Portfolio1.CovidDeaths ;

desc Portfolio1.CovidVaccinations ;

-- Location wise daily total cases and deaths due to Covid

SELECT location, date, population, total_cases, total_deaths 
FROM Portfolio1.CovidDeaths cd
ORDER BY 1,2;

-- Location wise daily percatage of total cases and deaths due to Covid

SELECT location, date,population, (total_cases/population)*100 as '% Total Cases', (total_deaths/population)*100 as '% Total Deaths' 
FROM Portfolio1.CovidDeaths cd
ORDER BY 1,2;

-- Location wise monthly total cases and deaths due to Covid

SELECT location, DATE_FORMAT(`date`,'%M-%Y') as 'Month', population, sum(new_cases), sum(new_deaths) 
FROM Portfolio1.CovidDeaths cd
GROUP BY 1,2,3
ORDER BY 1;

-- Location wise monthly percatage of total cases and deaths due to Covid

SELECT location, DATE_FORMAT(`date`,'%M-%Y') as 'Month', population, (sum(new_cases)/population)*100 as '% Total Cases', (sum(total_deaths)/population)*100 as '% Total Deaths' 
FROM Portfolio1.CovidDeaths cd
GROUP BY 1,2,3
ORDER BY 1,2;

-- Location wise yearly total cases and deaths due to Covid

SELECT location, DATE_FORMAT(`date`,'%Y') as 'Year', population, sum(new_cases), sum(total_deaths) 
FROM Portfolio1.CovidDeaths cd
GROUP BY 1,2,3
ORDER BY 1;

-- Location wise yearly percatage of total cases and deaths due to Covid

SELECT location, DATE_FORMAT(`date`,'%Y') as 'Year', population, (sum(new_cases)/population)*100 as '% Total Cases', (sum(new_deaths)/population)*100 as '% Total Deaths' 
FROM Portfolio1.CovidDeaths cd
GROUP BY 1,2,3
ORDER BY 1,2;

-- Populating  Daily Total Cases from New Cases

SELECT location, date,total_cases, new_cases, SUM(new_cases) OVER (PARTITION BY location ORDER BY location,date) as 'Total_Cases_Calculated' 
FROM Portfolio1.CovidDeaths cd
ORDER BY 1,2;


-- Ranking of Countries in Continent by Total Cases in Year 2021

DESC Portfolio1.CovidDeaths ;


WITH CTE_TABLE (Continent, Location, Year, TotalCases)
AS(
SELECT continent, location, DATE_FORMAT(date,'%Y'), SUM(new_cases)
FROM Portfolio1.CovidDeaths cd 
WHERE continent != ''
GROUP BY 1,2,3)
SELECT *, ROW_NUMBER() OVER (PARTITION BY continent ORDER BY TotalCases DESC) AS 'Rank'
FROM CTE_TABLE
WHERE Year = '2021'
GROUP BY 1,2,3;

-- Ranking of Countries by Total Cases

SELECT location,MAX(total_cases)
FROM Portfolio1.CovidDeaths cd 
WHERE continent != ''
GROUP BY 1
ORDER BY 2 DESC,1 ;

-- Ranking of Countries in Continents by Total Cases

WITH CTE_TABLE (continent,Location,TotalCases)
AS(
SELECT continent ,location,SUM(new_cases)
FROM Portfolio1.CovidDeaths cd 
WHERE continent != ''
GROUP BY 1,2)
SELECT *, ROW_NUMBER() OVER (PARTITION BY continent  ORDER BY TotalCases DESC) AS 'Rank'
FROM CTE_TABLE
GROUP BY 1,2;


-- Creating Views 


CREATE VIEW Portfolio1.CovidDeathsInIndia AS(
SELECT date,location, population, total_cases, new_cases, total_deaths, new_deaths
FROM Portfolio1.CovidDeaths cd 
WHERE location = 'India'
ORDER BY 1);


SELECT * FROM Portfolio1.CovidDeathsInIndia;



