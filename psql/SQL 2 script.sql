-- 1. ukol----------------------------
with maxPopCities  as(
select 
	c.code,
	max(c2.population) as population
from 
	country c 
join
	city c2 on c.code = c2.countrycode
group by 
	c.code
)
select 
	c.name as country,
	c2.name as city,
	mp.population
from 
	country c
join 
	city c2 on c.code = c2.countrycode 
join 
	maxPopCities mp on c.code = mp.code
where 
	c2.population = mp.population
order by 
	mp.population desc, c.code

-- 2. ukol----------------------------
with medPopCities  as(
SELECT 
	countrycode,
  	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY population) AS median
FROM
  city
group by countrycode
)
select 
	c.name as country,
	c2.name as city,
	mp.median
from 
	country c
join 
	city c2 on c.code = c2.countrycode 
join 
	medPopCities mp on c.code = mp.countrycode
where 
	mp.median = c2.population
order by
	mp.median desc, c.code

-- 3. ukol-----------------------------
select
	c.headofstate,
	count(c.headofstate) as countOf
from 
	country c
group by 
	c.headofstate
having 
	count(c.headofstate) > 1

-- 4. ukol-----------------------------
with maxPopCities  as(
select 
	c.code,
	max(c2.population) as population
from 
	country c 
join
	city c2 on c.code = c2.countrycode
group by 
	c.code
),
moreHead as(
select
	c.headofstate,
	count(c.headofstate) as countOf
from 
	country c
group by 
	c.headofstate
having 
	count(c.headofstate) > 1
)
select 
	c.name as country,
	c2.name as city,
	mp.population,
	mh.headofstate
from 
	country c
join 
	city c2 on c.code = c2.countrycode 
join 
	maxPopCities mp on c.code = mp.code
join
	moreHead mh on c.headofstate = mh.headofstate
where 
	c2.population = mp.population
order by 
	mp.population desc, c.code

-- 5. ukol-----------------------------
with maxPopCities  as(
select 
	c.code,
	c.name AS country,
	max(c2.population) as population,
	c.headofstate 
from 
	country c 
join
	city c2 on c.code = c2.countrycode
group by 
	c.code, c.name, c.headofstate 
),
moreHead as(
select
	c.headofstate,
	count(c.headofstate) as countOf
from 
	country c
group by 
	c.headofstate
having 
	count(c.headofstate) > 1
)
select 
	mpc1.country AS country1,
    mpc1.population AS population1,
    mpc2.country AS country2,
    mpc2.population AS population2,
    mpc1.headofstate,
    100.0 * abs(mpc1.population - mpc2.population) / greatest(mpc1.population, mpc2.population) AS percDiff
from
	maxPopCities mpc1
join
	maxpopcities mpc2 on mpc2.headofstate = mpc1.headofstate and mpc2.code <> mpc1.code
join 
	moreHead mh on mh.headofstate = mpc1.headofstate
where 
	100.0 * abs(mpc1.population - mpc2.population) / greatest(mpc1.population, mpc2.population) <= 25
order by
	mpc1.headofstate, percdiff desc

-- 6. ukol-----------------------------
with numCitInCont as (
select 
	c.continent,
	count(c.code) as numCounInCon
from
	country c
group by
	c.continent
),
everyDistInCont as (
    select
        c2.continent,
        c.district
    from 
        city c 
    join
        country c2 ON c2.code = c.countrycode 
)
select
	dc.district
from
	everyDistInCont dc
join
	numCitInCont cc on cc.continent = dc.continent
where
	cc.numCounInCon = (select max(cc.numCounInCon) from numCitInCont cc)
order by
	dc.district

-- 7. ukol-----------------------------
with everyCityInCont as (
	select
        c2.continent,
        c.name
    from 
        city c 
    join
        country c2 ON c2.code = c.countrycode 
),
everyDistInCont as (
    select
        c2.continent,
        c.district
    from 
        city c 
    join
        country c2 ON c2.code = c.countrycode 
)
select 
    cc.name AS city_district
from 
	everyCityInCont cc
where 
	cc.continent = 'Europe'
union 
	all
select 
	dc.district AS city_district
from 
	everyDistInCont dc
where 
	district is not null and district != ''

-- 8. ukol-----------------------------
with everyCityInCont as (
	select
        c2.continent,
        c.name as city,
        c.population
    from 
        city c 
    join
        country c2 ON c2.code = c.countrycode 
    where 
    	c2.continent = 'Europe'
)
select
	cc.city,
	case
		when cc.population > 3000000 then 'big'
		when cc.population < 3000000 and cc.population > 1000000 then 'middle'
		when cc.population < 1000000 then 'small'
	end as population 
from 
	everyCityInCont cc
order by
	cc.city, cc.population
