select emp.calc_year, d.name as department, l.full_name_lead,

	count(emp.full_name) as count_emp, 
	round(cast(avg(emp.experience) as numeric), 1) as avg_experience,
	round(cast(avg(emp.salary) as numeric)) as avg_salary,	
	sum(case when emp.employee_level_id = 1 then 1 else 0 end) as countJun,
	sum(case when emp.employee_level_id = 2 then 1 else 0 end) as countMiddle,
	sum(case when emp.employee_level_id = 3 then 1 else 0 end) as countSenior,
	sum(case when emp.employee_level_id = 4 then 1 else 0 end) as countLead,	
	sum(emp.salary) as total_salary,
	sum(emp.new_salary) as total_new_salary,	
	sum(countMarkA) as countMarkA, 
	sum(countMarkB) as countMarkB,
	sum(countMarkC) as countMarkC,
	sum(countMarkD) as countMarkD,
	sum(countMarkE) as countMarkE,
	round(cast(avg(emp.coefficient) as numeric), 1) as avg_coefficient,
	sum(bonus) as total_bonus,
	sum(emp.salary) + sum(bonus) as total_salary_with_bonus,
	sum(emp.new_salary) + sum(bonus) as total_new_salary_with_bonus,
	sum(emp.new_salary) - sum(emp.salary) as diff
from
	departments d
	inner join
	(
		select department_id, full_name, employee_level_id, experience, 
			calc_year, coefficient, salary, new_salary, 
			salary * coefficient as bonus, 
			countMarkA, countMarkB, countMarkC, countMarkD, countMarkE
		from
		(
			select department_id, full_name, calc_year, 
				coefficient, salary,
				case 
					when coefficient >= 1.2 then salary * 1.2
					when coefficient >= 1 and coefficient < 1.2 then salary * 1.1
					else salary
				end as new_salary, 
				experience, employee_level_id,
				countMarkA, countMarkB, countMarkC, countMarkD, countMarkE
			from
				(
					select e.id as employee_id, e.department_id, concat(p.surname, ' ' || p."name", ' ' || p.patronymic) as full_name, 
						em."year" as calc_year, 1 + sum(m.coefficient) as coefficient, e.salary,
						DATE_PART('year', CURRENT_DATE::date) - DATE_PART('year', e.start_date::date) AS experience,
						e.employee_level_id,
						sum(case when em.mark_id = 1 then 1 else 0 end) as countMarkA,
						sum(case when em.mark_id = 2 then 1 else 0 end) as countMarkB,
						sum(case when em.mark_id = 3 then 1 else 0 end) as countMarkC,
						sum(case when em.mark_id = 4 then 1 else 0 end) as countMarkD,
						sum(case when em.mark_id = 5 then 1 else 0 end) as countMarkE
					from employees e
						inner join persons p on e.person_id = p.id
						inner join employee_marks em on em.employee_id = e.id
						inner join marks m on em.mark_id = m.id
					group by e.id, e.department_id, e.start_date, e.employee_level_id, full_name, em."year"
				) t1
		) t2
	) emp on d.id = emp.department_id
	inner join
	(
		select e.department_id, concat(p.surname, ' ' || p."name", ' ' || p.patronymic) as full_name_lead
		from employees e
			inner join persons p on e.person_id = p.id
		where e.post_id = 1	
	) l on d.id = l.department_id
group by emp.calc_year, d.name, l.full_name_lead
order by emp.calc_year, d.name