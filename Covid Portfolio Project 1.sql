Select *
From [Portfolio Project]..CovidDeaths
Where continent is not Null
Order By 3,4

Select *
From [Portfolio Project]..CovidVaccinations
Order By 3,4

Select Location, Date, Total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
Order By 1,2

Select Location, Date, Total_cases, total_deaths, (Cast(total_deaths as float) / Nullif(Cast(Total_cases as float),0)) * 100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%state%'
Order By 1,2

-- Show what percentage of population got covid

Select Location, Date, Total_cases, Population, (Cast(total_cases as float) / Nullif(Cast(Population as float),0)) * 100 as Percentageofpopulation
From [Portfolio Project]..CovidDeaths
Order By Location

-- Looking at countries with highest infection rate compared to population

Select Location,
Population,
max(cast(total_cases as float)) as highestInfectionCount,
max(cast(total_cases as float)/nullif(cast(population as float),0)) * 100 as PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
Group By Location, Population
Order by PercentPopulationInfected desc

--Showing the countries with highest death count per population

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
Where continent <> ''
Group By Location
Order by TotalDeathCount desc

--Breaking things down by continent
-- Showing continents with the highest death count per population

Select Continent, max(cast(total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
Where continent <> ''
Group By Continent
Order by TotalDeathCount desc

--Global Number

Select Date, Sum(cast(new_cases as float)) as TotalNewcases, sum(cast(new_deaths as int)) as TotalNewDeaths,
Sum(cast(new_deaths as int))/nullif(sum(cast(new_cases as float)),0)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where continent <> ''
Group By Date
Order By Date, TotalNewcases

Select Sum(cast(new_cases as float)) as TotalNewcases, sum(cast(new_deaths as int)) as TotalNewDeaths,
Sum(cast(new_deaths as int))/nullif(sum(cast(new_cases as float)),0)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where continent <> ''
Order By 1,2

--Looking for Total population with 
--CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as 
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order By dea.location,dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent <> ''
--Order by 2,3
)
Select*,(Cast(RollingPeopleVaccinated as float)/Nullif(Population,0))*100
From PopvsVac

--Temp Table
Drop Table if exists #PercentPopulationVaccinated;
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date DATETIME,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);
Insert into #PercentPopulationVaccinated
Select 
dea.continent, 
dea.location, 
Try_convert(date,dea.date), 
Try_convert(numeric,dea.population),
Try_convert(numeric, vac.new_vaccinations),
sum(Try_convert(bigint,vac.new_vaccinations)) Over (Partition by dea.Location Order By dea.location,dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent <> ''
--Order by 2,3

Select*,(Cast(RollingPeopleVaccinated as float)/Nullif(Population,0))*100 as PercentVaccinated
From #PercentPopulationVaccinated

--Create view to store data for later visualisation
Drop view if exists PercentPopulationVaccinated;
Go
Create View PercentPopulationVaccinated as
Select 
dea.continent, 
dea.location, 
Try_convert(date,dea.date) as Date, 
Try_convert(numeric,dea.population) as Population,
Try_convert(numeric, vac.new_vaccinations) as New_Vaccinations,
sum(Try_convert(bigint,vac.new_vaccinations)) Over (Partition by dea.Location Order By dea.location,dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent <> ''
--Order by 2,3
Go

Select*
From PercentPopulationVaccinated