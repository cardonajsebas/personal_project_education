
	-- After a previous review and cleaning in Excel of all the data sets I am going to work with,
	-- I start reviewing each table, making sure that everything looks OK to start working with them:

SELECT *
FROM Project_Education..economy;

SELECT *
FROM Project_Education..population;

SELECT *
FROM Project_Education..education;

SELECT *
FROM Project_Education..education_quality;


	-- Ordering the economy table by GDP per capita and Average goverment expenditure in education:

SELECT "Country", "GDP per capita 2020 (USD)" AS 'GDP_per_capita', 
	"Avg Gov exp education % of GDP (last 20 years)" AS 'Avg_gov_exp_edu'
FROM economy
ORDER BY GDP_per_capita DESC;

SELECT "Country", "GDP per capita 2020 (USD)" AS 'GDP_per_capita', 
	"Avg Gov exp education % of GDP (last 20 years)" AS 'Avg_gov_exp_edu'
FROM economy
ORDER BY Avg_gov_exp_edu DESC;


	-- Building relations between tables,
	-- Finding any relations between GDP per capita and enrollment and completion of levels of education:

SELECT economy."Country", "GDP per capita 2020 (USD)" AS 'GDP_per_capita', 
	economy."Avg Gov exp education % of GDP (last 20 years)" AS 'Avg_gov_exp_edu',
	education."Avg primary enrollment ratio (%)" AS 'primary_enrollment_%', 
	education."Avg primary completion rate (%)" AS 'primary_completion_%'
FROM economy LEFT JOIN education
	ON economy.Country = education.Country
ORDER BY GDP_per_capita DESC;

SELECT economy."Country", "GDP per capita 2020 (USD)" AS 'GDP_per_capita', 
	economy."Avg Gov exp education % of GDP (last 20 years)" AS 'Avg_gov_exp_edu',
	education."Avg secondary enrollment ratio (%)" As 'secondary_enrollment_%',
	education."Avg secondary completion rate (%)" AS 'secondary_completion_%' 
FROM economy LEFT JOIN education
	ON economy.Country = education.Country
ORDER BY GDP_per_capita DESC;

SELECT economy."Country", "GDP per capita 2020 (USD)" AS 'GDP_per_capita', 
	economy."Avg Gov exp education % of GDP (last 20 years)" AS 'Avg_gov_exp_edu',
	education."Avg terciary enrollment ratio (%)" As 'terciary_enrollment_%', 
	education."Avg terciary completion rate (%)" AS 'terciary_completion_%'
FROM economy LEFT JOIN education
	ON economy.Country = education.Country
ORDER BY GDP_per_capita DESC;


	-- Finding relations between GDP per capita, avg of gverment expenditure in education and quaility of education
	-- Calculating an avg of PISA performance:

SELECT economy."Country", "GDP per capita 2020 (USD)" AS 'GDP_per_capita',
	economy."Avg Gov exp education % of GDP (last 20 years)" AS 'Avg_gov_exp_edu',
	education_quality."Avg PISA performance_reading" AS 'reading', 
	education_quality."Avg PISA performance_mathematics" AS 'mathematics', 
	education_quality."Avg PISA performance_science" AS 'science',
	CAST((education_quality."Avg PISA performance_reading" + 
	education_quality."Avg PISA performance_mathematics" + 
	education_quality."Avg PISA performance_science") / 3 AS int) AS 'Avg_PISA'
FROM economy LEFT JOIN education_quality
	ON economy.Country = education_quality.Country
WHERE education_quality.[Avg PISA performance_reading] IS NOT NULL
ORDER BY Avg_PISA DESC;


	-- Let's start working with continents

SELECT *
FROM Project_Education..continents;


	-- I realized there where some inconsistencies when joining population and continents between the typing of country names 
	-- in both tables, so I need to fix this updating the names:

SELECT population."Country", continents.country
FROM population LEFT JOIN continents
		ON population.Country LIKE continents.country
WHERE continents.country IS NULL;

SELECT population."Country", continents.country
FROM population RIGHT JOIN continents
		ON population.Country LIKE continents.country
WHERE population."Country" IS NULL;

UPDATE continents
SET country = 'Cabo Verde'
WHERE country = 'Cape Verde'

UPDATE continents
SET country = 'Curaçao'
WHERE country = 'Curacao';

UPDATE continents
SET country = 'Czech Republic (Czechia)'
WHERE country = 'Czech Republic';

UPDATE continents
SET country = 'Faeroe Islands'
WHERE country = 'Faroe Islands';

UPDATE continents
SET country = 'Macao'
WHERE country = 'Macau';

UPDATE continents
SET country = 'Congo'
WHERE country = 'Republic of the Congo';

UPDATE continents
SET country = 'Réunion'
WHERE country = 'Reunion';

UPDATE continents
SET country = 'Saint Kitts & Nevis'
WHERE country = 'Saint Kitts and Nevis';

UPDATE continents
SET country = 'Saint Pierre & Miquelon'
WHERE country = 'Saint Pierre and Miquelon';

UPDATE continents
SET country = 'St. Vincent & Grenadines'
WHERE country = 'Saint Vincent and the Grenadines';

UPDATE continents
SET country = 'State of Palestine'
WHERE country = 'Palestine';

UPDATE continents
SET country = 'Sao Tome & Principe'
WHERE country = 'Sao Tome and Principe';

UPDATE continents
SET country = 'Turks and Caicos'
WHERE country = 'Turks and Caicos Islands';

UPDATE continents
SET country = 'U.S. Virgin Islands'
WHERE country = 'United States Virgin Islands';

UPDATE continents
SET country = 'Wallis & Futuna'
WHERE country = 'Wallis and Futuna';

UPDATE continents
SET country = 'Holy See'
WHERE country = 'Vatican City';

UPDATE continents
SET country = 'Holy See'
WHERE country = 'Vatican City';

UPDATE continents
SET country = 'Channel Islands'
WHERE country = 'Guernsey';

UPDATE continents
SET country = 'Channel Islands'
WHERE country = 'Jersey';

	-- There was a special case with the Country "Ivory Coast", because this one contained an apostrophe, so I decided to change it on every table:

UPDATE population
SET country = 'Côte dIvoire'
WHERE country LIKE '%Côte %';

UPDATE economy
SET country = 'Côte dIvoire'
WHERE country LIKE '%Côte %';

UPDATE education
SET country = 'Côte dIvoire'
WHERE country LIKE '%Côte %';

UPDATE education_quality
SET country = 'Côte dIvoire'
WHERE country LIKE '%Côte %';

UPDATE continents
SET country = 'Côte dIvoire'
WHERE country LIKE '%Côte %';

	-- I also updated the Caribbean Netherlands and Saint Helena because those were missing from continents table:

INSERT INTO continents (country, continent, subregion)
VALUES ('Caribbean Netherlands', 'Europe', 'Caribbean');

INSERT INTO continents (country, continent, subregion)
VALUES ('Saint Helena', 'Europe', 'Western Africa, Sub-Saharan Africa');


	-- Now it is all set to start joining the tables:

SELECT population."Country", 
	continents."Continent", "GDP per capita 2020 (USD)" AS 'GDP_per_capita'
FROM population LEFT JOIN continents
		ON population.Country LIKE continents.country;

SELECT continents.continent, 
	CAST(AVG("GDP per capita 2020 (USD)") AS int) AS 'AVG_GDP_continent',
	FORMAT(AVG("Avg Gov exp education % of GDP (last 20 years)"), 'N2') AS 'Avg_gov_exp_edu'
FROM economy LEFT JOIN continents
		ON economy.Country = continents.country
GROUP BY Continent
ORDER BY AVG_GDP_continent DESC;

SELECT continents.subregion, 
	CAST(AVG("GDP per capita 2020 (USD)") AS int) AS 'AVG_GDP_subregion',
	FORMAT(AVG("Avg Gov exp education % of GDP (last 20 years)"), 'N2') AS 'Avg_gov_exp_edu'
FROM economy LEFT JOIN continents
		ON economy.Country = continents.country
GROUP BY subregion
ORDER BY AVG_GDP_subregion DESC;

SELECT *
FROM Project_Education..continents
WHERE subregion = 'Northern Europe, Sub-Saharan Africa';

UPDATE Project_Education..continents
SET subregion = 'Northern Europe'
WHERE country = 'Channel Islands';


	-- Working with education and continents tables:

	-- Let's start with enrollment and completion ratios of education levels by continent and subregion:

SELECT education.Country, 
	continents.continent, 
	continents.subregion, 
	education."Avg primary enrollment ratio (%)", education."Avg primary completion rate (%)"
FROM education LEFT JOIN continents
		ON education.Country = continents.country;

SELECT continents.continent, 
	FORMAT(AVG("Avg primary enrollment ratio (%)"), 'N2') AS 'Avg_primary_enrollment_%', 
	FORMAT(AVG("Avg primary completion rate (%)"), 'N2') AS 'Avg_primary_completion_%'
FROM education LEFT JOIN continents
		ON education.Country = continents.country
GROUP BY continent
ORDER BY 'Avg_primary_completion_%' DESC;

SELECT continents.continent, 
	FORMAT(AVG("Avg secondary enrollment ratio (%)"), 'N2') AS 'Avg_secondary_enrollment_%', 
	FORMAT(AVG("Avg secondary completion rate (%)"), 'N2') AS 'Avg_secondary_completion_%'
FROM education LEFT JOIN continents
		ON education.Country = continents.country
GROUP BY continent
ORDER BY 'Avg_secondary_completion_%' DESC;

SELECT continents.continent, 
	FORMAT(AVG("Avg terciary enrollment ratio (%)"), 'N2') AS 'Avg_terciary_enrollment_%', 
	FORMAT(AVG("Avg terciary completion rate (%)"), 'N2') AS 'Avg_terciary_completion_%'
FROM education LEFT JOIN continents
		ON education.Country = continents.country
GROUP BY continent
ORDER BY 'Avg_terciary_completion_%' DESC;

SELECT continents.subregion, 
	FORMAT(AVG("Avg primary enrollment ratio (%)"), 'N2') AS 'Avg_primary_enrollment_%', 
	FORMAT(AVG("Avg primary completion rate (%)"), 'N2') AS 'Avg_primary_completion_%'
FROM education LEFT JOIN continents
		ON education.Country = continents.country
GROUP BY subregion
ORDER BY 'Avg_primary_completion_%' DESC;

SELECT continents.subregion, 
	FORMAT(AVG("Avg secondary enrollment ratio (%)"), 'N2') AS 'Avg_secondary_enrollment_%', 
	FORMAT(AVG("Avg secondary completion rate (%)"), 'N2') AS 'Avg_secondary_completion_%'
FROM education LEFT JOIN continents
		ON education.Country = continents.country
GROUP BY subregion
ORDER BY 'Avg_secondary_completion_%' DESC;

SELECT continents.subregion, 
	FORMAT(AVG("Avg terciary enrollment ratio (%)"), 'N2') AS 'Avg_terciary_enrollment_%', 
	FORMAT(AVG("Avg terciary completion rate (%)"), 'N2') AS 'Avg_terciary_completion_%'
FROM education LEFT JOIN continents
		ON education.Country = continents.country
GROUP BY subregion
ORDER BY 'Avg_terciary_completion_%' DESC;


	-- Now let's move on to quality of education according to PISA Test:

SELECT education_quality.Country, 
	continents.continent, 
	continents.subregion, 
	education_quality."Avg PISA performance_reading" AS 'reading', 
	education_quality."Avg PISA performance_mathematics" AS 'mathematics', 
	education_quality."Avg PISA performance_science" AS 'science',
	CAST((education_quality."Avg PISA performance_reading" + 
	education_quality."Avg PISA performance_mathematics" + 
	education_quality."Avg PISA performance_science") / 3 AS int) AS 'Avg_PISA'
FROM education_quality LEFT JOIN continents
		ON education_quality.Country = continents.country
WHERE education_quality."Avg PISA performance_reading" IS NOT NULL
ORDER BY Avg_PISA DESC;

SELECT continents.continent,
	CAST(AVG(education_quality."Avg PISA performance_reading") AS int) AS 'Avg_reading',
	CAST(AVG(education_quality."Avg PISA performance_mathematics") AS int) AS 'mathematics', 
	CAST(AVG(education_quality."Avg PISA performance_science") AS int) AS 'science',
	CAST(((AVG(education_quality."Avg PISA performance_reading") +
		AVG(education_quality."Avg PISA performance_mathematics") +
		AVG(education_quality."Avg PISA performance_science")) / 3) AS int) AS 'Avg_PISA_continent'
FROM education_quality LEFT JOIN continents
		ON education_quality.Country = continents.country
GROUP BY continent
ORDER BY 'Avg_PISA_continent' DESC;

SELECT continents.subregion,
	CAST(AVG(education_quality."Avg PISA performance_reading") AS int) AS 'Avg_reading',
	CAST(AVG(education_quality."Avg PISA performance_mathematics") AS int) AS 'mathematics', 
	CAST(AVG(education_quality."Avg PISA performance_science") AS int) AS 'science',
	CAST(((AVG(education_quality."Avg PISA performance_reading") +
				AVG(education_quality."Avg PISA performance_mathematics") +
				AVG(education_quality."Avg PISA performance_science")) / 3) AS int) AS 'Avg_PISA_subregion'
FROM education_quality LEFT JOIN continents
		ON education_quality.Country = continents.country
GROUP BY subregion
ORDER BY 'Avg_PISA_subregion' DESC;


	-- Let's create some sumarize tables from previous queries results for analisys:

SELECT economy.Country,
	continents.continent, 
	continents.subregion,
	"GDP per capita 2020 (USD)" AS 'AVG_GDP',
	"Avg Gov exp education % of GDP (last 20 years)" AS 'Avg_gov_exp_edu',
	"Avg primary enrollment ratio (%)" AS 'primary_enrollment_%', 
	"Avg primary completion rate (%)" AS 'primary_completion_%',
	"Avg secondary enrollment ratio (%)" AS 'secondary enrollment',
	"Avg secondary completion rate (%)" AS 'secondary_completion_%',
	"Avg terciary enrollment ratio (%)" AS 'Avg_terciary_enrollment_%',
	"Avg terciary completion rate (%)" AS 'Avg_terciary_completion_%'
FROM economy LEFT JOIN continents
		ON economy.Country = continents.country
		LEFT JOIN education
		ON economy.country = education.Country
ORDER BY AVG_GDP DESC;
