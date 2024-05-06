select *
	from city 
	order by countrycode

select *
	from city 
	Where countrycode like 'U__' 
	
select *
	from city 
	where countrycode = 'DZA'
	
select countrycode ,count(countrycode), sum(population)
	from city 
	group by countrycode 

select *
	from city
	where countrycode = 'COG'
	
select c.name as city, c2.name as country, c2.continent
	from country c2 join city c on code = countrycode 
	
select c.headofstate, count(c.headofstate)
	from country c 
	group by headofstate
	having count(c.headofstate) > 1 

select name as country, lifeexpectancy
	from country 
	group by country, population , lifeexpectancy 
	having population > 10000000
	limit 10
	
select c.continent, count(c.code) as num_countries
	from country c 
	group by c.continent 
	
select c.continent, count(c2.countrycode) as num_cities
	from country c join city c2 on c.code = c2.countrycode
	group by c.continent

select cl.countrycode, c.name ,cl.language
	from countrylanguage cl join country c on cl.countrycode = c.code
	where cl.language = 'English'

select name, max(c.population)
	from country c 
	where c.population = (select max(c.population) from country c)
	group by name
	
	
	

	
	
	