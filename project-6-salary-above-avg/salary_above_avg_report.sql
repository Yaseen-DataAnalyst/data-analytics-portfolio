-- ============================================================
--  المشروع السادس: التحقق من راتب الموظف مقابل متوسط قسمه
--  Project 6: Check if Employee Salary is Above Department Average
-- ============================================================
--  الهدف: تحديد ما إذا كان راتب كل موظف أعلى من متوسط رواتب قسمه أم لا.
--  التقنية: حساب متوسط الراتب لكل قسم باستخدام AVG() مع OVER و PARTITION BY،
--           ثم مقارنة راتب كل موظف بهذا المتوسط باستخدام CASE.
--  Goal: Determine whether each employee's salary is higher than 
--        the average salary of their department.
--  Technique: Calculate department average using AVG() with OVER and PARTITION BY,
--             then compare each employee's salary using CASE.
-- ============================================================

-- استخدام CTE (Common Table Expression) لحساب متوسط الراتب لكل قسم
WITH Salary_Comparison AS (
    SELECT 
        e.first_name,                          -- الاسم الأول
        e.last_name,                           -- اسم العائلة
        e.salary,                              -- راتب الموظف
        d.department_name,                     -- اسم القسم
        -- حساب متوسط الراتب لكل قسم على حدة (دالة نافذة)
        ROUND(AVG(e.salary) OVER (
            PARTITION BY e.department_id       -- تقسيم الحساب حسب القسم
        ), 2) AS department_avg_salary         -- متوسط الراتب (مقرب لمنزلتين عشريتين)
    FROM 
        employees e
    JOIN 
        departments d ON e.department_id = d.department_id
)
-- إضافة عمود يوضح إذا كان الراتب أعلى من المتوسط
SELECT 
    department_name AS "اسم القسم",
    first_name AS "الاسم الأول",
    last_name AS "اسم العائلة",
    salary AS "الراتب",
    department_avg_salary AS "متوسط راتب القسم",
    -- استخدام CASE لمقارنة الراتب بمتوسط القسم
    CASE 
        WHEN salary > department_avg_salary THEN 'YES'   -- أعلى من المتوسط
        ELSE 'NO'                                          -- أقل أو يساوي المتوسط
    END AS "هل الراتب أعلى من متوسط القسم؟"
FROM 
    Salary_Comparison
ORDER BY 
    department_name, salary DESC;  -- ترتيب حسب القسم ثم الراتب تنازلياً