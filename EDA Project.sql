Select * from layoffs2;
-- Maximum laid_off in a day 
Select max(total_laid_off) as max_laid_off from layoffs2;
Select company, total_laid_off  from layoffs2
order by 2 desc;

select company, sum(total_laid_off) as total from layoffs2
group by company
order by 2 desc;

select * from layoffs2;



select max(date) , min(date)
from layoffs2;

select substr(`date`,1,7) as date_of_month, sum(total_laid_off) as rolling_total
from layoffs2
where substr(`date`,1,7) is not null
group by date_of_month
order by 1 asc;



With total_CTE as
(
select substr(`date`,1,7) as date_of_month, sum(total_laid_off) as total_per_month
from layoffs2
where substr(`date`,1,7) is not null
group by date_of_month
order by 1 asc)
Select date_of_month, total_per_month, sum(total_per_month) over(order by date_of_month) as rolling_total
from total_CTE;


with industry_layoff as
(select industry, year(date) as `year`, sum(total_laid_off) as total
from layoffs2
where year(date) is not null and industry is not null
group by industry, `year`)
select *
from industry_layoff;

with industry_layoff as
(select industry, year(date) as `year`, sum(total_laid_off) as total
from layoffs2
where year(date) is not null and industry is not null
group by industry, `year`), industry_ranking as (
select *,  dense_rank() over(partition by `year` order by total desc) as ranking from industry_layoff)
Select * from industry_ranking
where ranking<=5;

with company_layoff as
(select company, year(date) as `year`, sum(total_laid_off) as total
from layoffs2
where year(date) is not null and company is not null
group by company, `year`), company_ranking as (
select *,  dense_rank() over(partition by `year` order by total desc) as ranking from company_layoff)
Select * from company_ranking
where ranking<=5;

select country, sum(total_laid_off) as total_laid_off
from layoffs2
group by country
order by 2 desc;


select country, location, sum(total_laid_off) as total_laid_off
from layoffs2
group by country, location
order by  total_laid_off desc;

select country, location,company, sum(total_laid_off) as total_laid_off 
from layoffs2
where country='United States' and total_laid_off is not null
group by location, company
order by total_laid_off desc;

-- top 5 location with max laid off
with max_loc as(
Select location, sum(total_laid_off) as total 
from layoffs2
group by location), ranking_cte as(
Select *, dense_rank() over(order by total desc) as ranking
from max_loc)
Select * from ranking_cte
where ranking<=5;
With CTE as(
Select date, company,  total_laid_off, round((total_laid_off/percentage_laid_off),0)as no_of_emp_before 
from layoffs2
where total_laid_off is not null and percentage_laid_off is not null
group by company, date)
Select *, (no_of_emp_before - total_laid_off) as current_emp
from CTE
order by date asc;

Select * from layoffs2
where percentage_laid_off= 1;

Select country, location,company,date, total_laid_off, percentage_laid_off
from layoffs2
where company='Amazon';


