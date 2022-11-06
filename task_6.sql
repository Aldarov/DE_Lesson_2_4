select d.id as department_id, d.name as department,
	em."year", sum(1 + m.coefficient) as coefficient
from employees e
	inner join departments d on e.department_id = d.id
	inner join employee_marks em on em.employee_id = e.id
	inner join marks m on em.mark_id = m.id
group by d.id, d.name, em."year"
order by coefficient desc
limit 1