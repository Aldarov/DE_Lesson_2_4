select el.id as employee_level_id, el.name as employee_level, 
	round(avg(DATE_PART('year', CURRENT_DATE::date) - DATE_PART('year', e.start_date::date))) as avg_experience
from employees e
	inner join employee_levels el on el.id = e.employee_level_id
group by el.id, el.name
order by el.id