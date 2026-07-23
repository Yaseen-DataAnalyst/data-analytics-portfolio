--هل هناك موظفين مكررين بنفس البريد الالكتروني او رقم الهاتف ؟!
SELECT first_name,last_name,email,count(*)
FROM employees
GROUP BY first_name,last_name,email
HAVING count(*) > 1;

--هل هناك رواتب أعلى من 50000 أو أقل من 1000 (شاذة) ؟!
SELECT first_name,last_name,salary
from employees
where salary > 50000 OR salary < 1000;


--هل هناك موظفين تاريخ توظيفهم بعد اليوم او قبل تاريخ 1980؟!
select first_name,last_name,hire_date
from employees
where hire_date > sysdate OR EXTRACT(YEAR FROM hire_date) <1980;

--هل هناك موظفين بدون مدير (عدا الرأيس) ؟!
select first_name,last_name,employee_id,manager_id
from employees
where manager_id=NULL and employee_id !=100;