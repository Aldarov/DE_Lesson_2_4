select d.name as department, s.id, s.full_name, s.salary
from departments d 
	left join lateral
	(
		select e.id, concat(p.surname, ' ' || p."name", ' ' || p.patronymic) as full_name, e.department_id, e.salary
		from employees e
			inner join persons p on e.person_id = p.id
		where e.department_id = d.id
		order by e.salary desc
		limit 1		
	) s ON TRUE
order by d.name