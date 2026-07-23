SELECT d.department_name "اسم القسم",COUNT(*) "عدد الموظفين",sum(e.salary) "مجموع رواتب القسم",min(e.salary) "أقل راتب في كل قسم",
max(e.salary) "أعلى راتب في كل قسم",ROUND(AVG(e.salary),2) "معدل رواتب القسم"
FROM employees e join 
departments d ON(e.department_id = d.department_id)
GROUP BY d.department_name
ORDER BY sum(e.salary) desc

