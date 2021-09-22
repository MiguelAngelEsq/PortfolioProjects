select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4;

select *
from PortfolioProject..CovidVaccinations
order by 3,4;

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2;

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deaths
from PortfolioProject..CovidDeaths
order by 1,2;

--Mexico death percentage

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%mex%'
order by 1,2;

--US Contagion Percentage

select location, date, total_cases, total_deaths, population, (total_cases/population)*100 as Contagion
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2;

--Countries with highest infection rate

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
group by location, population
order by PercentPopulationInfected desc;

-- Countries with highest deathcount

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location, population
order by TotalDeathCount desc;

--Continent Deathcount (CHIDA)

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc;

--Global Numbers

select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2;

--Vaccinations

select *
from PortfolioProject..CovidVaccinations;

-- Join tables

 select *
 from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date;

 --Rolling vaccinations

 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingVaccinations
 from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3;


 --Rolling vaccinations vs Population (CTE)
 
 With PopvsVac (continent, location, date, population, new_vaccinations, RollingVaccinations)
 as
 (
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingVaccinations
 from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null)

 select *, (RollingVaccinations/population)*100
 from PopvsVac;

 --TEMP TABLE

 --Create view to store data for future usage

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as RollingVaccinations
 from PortfolioProject..CovidDeaths dea
 join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null

 select location, population, MAX(cast(total_deaths as int)) as DeathToll
 from PortfolioProject..CovidDeaths
 where continent is not null
 group by  location, population
 order by DeathToll desc;



 

