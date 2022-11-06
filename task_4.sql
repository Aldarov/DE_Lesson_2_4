select e.id, concat(p.surname, ' ' || p."name", ' ' || p.patronymic) as full_name, d.name as department
from employees e
	inner join persons p on e.person_id = p.id
	inner join departments d on e.department_id = d.id
order by department, full_name
