select employee_id, full_name, coefficient, salary,
	case 
		when coefficient >= 1.2 then salary * 1.2
		when coefficient >= 1 and coefficient < 1.2 then salary * 1.1
		else salary
	end as new_salary
from
(
	select e.id as employee_id, concat(p.surname, ' ' || p."name", ' ' || p.patronymic) as full_name, 
		em."year", 1 + sum(m.coefficient) as coefficient, e.salary
	from employees e
		inner join persons p on e.person_id = p.id
		inner join employee_marks em on em.employee_id = e.id
		inner join marks m on em.mark_id = m.id
	group by e.id, full_name, em."year"
) t