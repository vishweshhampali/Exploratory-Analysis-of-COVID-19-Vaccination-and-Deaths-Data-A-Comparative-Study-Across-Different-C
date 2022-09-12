-- counting rows in tables

SELECT COUNT(*) as 'CountCovidDeaths'
FROM Portfolio1.CovidDeaths cd ; 

-- describing tables

desc Portfolio1.CovidVaccinations ;

-- Location wise daily total vaccinations due to Covid

SELECT cv.location, cv.date, cd.population, cv.total_vaccinations 
FROM Portfolio1.CovidVaccinations cv
JOIN Portfolio1.CovidDeaths cd 
ON cd.location = cv.location and cd.`date` = cv.`date`  
ORDER BY 1,2;

-- Location wise daily percatage of total vaccinations

SELECT cv.location, cv.date,cd.population, cv.total_vaccinations, (cv.total_vaccinations/cd.population)*100 as '% Total Vaccinations' 
FROM Portfolio1.CovidVaccinations cv 
JOIN Portfolio1.CovidDeaths cd 
ON cd.location = cv.location and cd.`date` = cv.`date`
WHERE cv.total_vaccinations IS NOT NULL
ORDER BY 1,2;

-- Location wise monthly total vaccinations

SELECT cv.location, DATE_FORMAT(cv.date,'%M-%Y') as 'Month', cd.population, sum(cv.new_vaccinations) 
FROM Portfolio1.CovidVaccinations cv 
JOIN Portfolio1.CovidDeaths cd 
ON cd.location = cv.location and cd.`date` = cv.`date`
WHERE cv.new_vaccinations IS NOT NULL
GROUP BY 1,2,3
ORDER BY 1,2 ;



-- Populating  Daily Total Cases from New Cases

SELECT location, date,total_vaccinations , new_vaccinations , SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY location,date) as 'Total_Cases_Calculated' 
FROM Portfolio1.CovidVaccinations cv 
WHERE location = 'India'
ORDER BY 1,2;


-- Ranking of Countries in Continent by Total Vaccinations in Year 2021


WITH CTE_TABLE (Continent, Location, Year, TotalVaccinations)
AS(
SELECT continent, location, DATE_FORMAT(date,'%Y'), SUM(new_vaccinations)
FROM Portfolio1.CovidVaccinations cv 
WHERE continent != ''
GROUP BY 1,2,3)
SELECT *, ROW_NUMBER() OVER (PARTITION BY continent ORDER BY TotalVaccinations DESC) AS 'Rank'
FROM CTE_TABLE
WHERE Year = '2021'
GROUP BY 1,2,3;

-

-- Creating Views 


CREATE VIEW Portfolio1.CovidVaccinationsInIndia AS(
SELECT cv.date,cv.location, cd.population, cv.total_vaccinations, cv.new_vaccinations
FROM Portfolio1.CovidVaccinations cv  
JOIN Portfolio1.CovidDeaths cd 
ON cd.location = cv.location and cd.`date` = cv.`date`
WHERE cv.location = 'India'
ORDER BY 1);


SELECT * FROM Portfolio1.CovidVaccinationsInIndia;



