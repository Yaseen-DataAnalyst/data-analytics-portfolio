SELECT FIRST_NAME AS "الاسم الأول",
       LAST_NAME AS "اسم العائلة",
       SALARY AS "الراتب الشهري",
       DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS "رتبة الأداء(الأول=الأعلى راتباّ)"
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 80;