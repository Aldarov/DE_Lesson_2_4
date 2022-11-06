select e.id, concat(p.surname, ' ' || p."name", ' ' || p.patronymic) as full_name, 
	e.salary
from employees e
	inner join persons p on e.person_id = p.id
order by e.salary desc	
limit 1