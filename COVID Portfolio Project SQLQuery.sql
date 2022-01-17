--Select * from [Portfolio Project]..covidDeaths
--order by 3,4

--Select * from [Portfolio Project]..covidVaccination
--order by 3,4



--Select location, date, total_cases, new_cases, total_deaths, population 
--from [Portfolio Project]..covidDeaths
--order by 1,2

--Total deaths Vs total cases
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathPercent 
from [Portfolio Project]..covidDeaths
where location='India'
order by date desc	

-- Total cases vs population
Select location, date, population, total_cases,  (total_cases/population)*100 as InfectionPercentage
From [Portfolio Project]..covidDeaths
where location = 'India'
order by InfectionPercentage desc

--countries with highest infection rate 
Select location, population, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as InfectionPercentage
From [Portfolio Project]..covidDeaths
--where location = 'India'
group by location, population
order by InfectionPercentage desc

-- Countriess with hiighest death count per population
Select Location, max(cast(total_deaths as int)) as TotalDeathCount 
from [Portfolio Project]..covidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Grouping by continent
Select continent, max(cast(total_deaths as int)) as TotalDeathCount 
from [Portfolio Project]..covidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers
Select sum(new_cases) as totalCases, sum(cast(new_deaths as int)) TotalDeaths
from [Portfolio Project]..covidDeaths
where continent is not null
--group by date
--order by date desc


--Total Population Vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over(partition by vac.location order by vac.location, vac.date 
ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) as RollingPeopleVaccinated
from [Portfolio Project]..covidDeaths dea
join [Portfolio Project]..covidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Use CTE
-- ORDER BY list of RANGE window frame has total size of 1020 bytes. Largest size supported is 900 bytes.
--keeps Popping
--ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW
--with cast or convert use bigint instead of big
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location 
order by dea.location, dea.date	ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) as RollingPeopleVaccinated
from [Portfolio Project]..covidDeaths dea
join [Portfolio Project]..covidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select * , (RollingPeopleVaccinated/population)*100
from PopvsVac
--i belive there were two doses of vaccine which resulted in over 100% in some locations

--Practice Example Ignore
--Select location, date, new_vaccinations, total_vaccinations, sum(cast(new_vaccinations as bigint)) over (partition by location order by location, date
--ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW)
--from [Portfolio Project]..covidVaccination
--where continent is not null
--order by 1,2

--Temp Table
Drop table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over(partition by vac.location order by vac.location, vac.date 
ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) as RollingPeopleVaccinated
from [Portfolio Project]..covidDeaths dea
join [Portfolio Project]..covidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * , (RollingPeopleVaccinated/population)*100
from #PercentagePopulationVaccinated

--creating View for later visualizations
create view PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over(partition by vac.location order by vac.location, vac.date 
ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) as RollingPeopleVaccinated
from [Portfolio Project]..covidDeaths dea
join [Portfolio Project]..covidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentagePopulationVaccinated