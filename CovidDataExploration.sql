SELECT *
FROM coviddeaths
ORDER BY 3,4;

-- SELECT *
-- FROM covidvaccinations
-- ORDER BY 3,4

-- The datatype for date is text, so we need to change it to timestamp
-- ALTER TABLE coviddeaths
-- MODIFY COLUMN date DATETIME;

-- Select Data that we are going to be using 

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2;

-- Looking at Total cases vs Total deaths
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_rate
FROM coviddeaths
WHERE Location like '%states%'
ORDER BY 1,2;

-- Looking at Total cases vs Population
-- Shows what percentage of population got Covid 
SELECT Location, date, Population, total_cases, (total_cases/population)*100 as Case_rate
FROM coviddeaths
WHERE Location like '%states%'
ORDER BY 1,2;

-- Looking at countries with the highest infection rate compared to population
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM coviddeaths
group by Location, Population
order by PercentPopulationInfected desc;


-- Showing countries with highest death count per population
SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM coviddeaths
where continent is not null
group by Location, Population
order by TotalDeathCount desc;

-- Break down by continent
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- Showing continents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- Global Numbers

SELECT date, sum(new_cases) as total_cases,sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
FROM coviddeaths
where continent is not null
group by date
order by 1,2;

-- Looking at total pop vs. vaccinations

SELECT 
    dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
    , sum(vac.new_vaccinations) over (patition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
where dea.continent is not null
order by 1,2,3;

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(SELECT 
    dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
    , sum(vac.new_vaccinations) over (patition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
where dea.continent is not null
)

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-- Temp Table

Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated)


DROP Table if exists #PercentPopulationVaccinated
Insert Into #PercentPopulationVaccinated
SELECT 
    dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
    , sum(vac.new_vaccinations) over (patition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
where dea.continent is not null

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

-- Creating view to store data for later

Create View PercentPopulationVaccinated as 
SELECT 
    dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
    , sum(vac.new_vaccinations) over (patition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM
    coviddeaths dea
        JOIN
    covidvaccinations vac ON dea.location = vac.location
        AND dea.date = vac.date
where dea.continent is not null


SELECT * 
FROM PercentPopulationVaccinated
