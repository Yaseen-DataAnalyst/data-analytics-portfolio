-- ============================================================
--  المشروع الخامس أحدث موظف تم تعيينه في كل قسم
--  Project 5 Latest Hired Employee per Department
-- ============================================================
--  الهدف استخراج الموظف الأحدث (من حيث تاريخ التوظيف) في كل قسم إداري.
--  التقنية استخدام ROW_NUMBER() لترقيم الموظفين داخل كل قسم
--           حسب تاريخ التوظيف من الأحدث إلى الأقدم، ثم اختيار الرقم 1.
--  Goal Extract the latest hired employee in each department.
--  Technique Use ROW_NUMBER() to rank employees within each department
--            by hire date descending, then select rank = 1.
-- ============================================================

-- استخدام CTE (Common Table Expression) لترقيم الموظفين داخل كل قسم
WITH Ranked_Employees AS (
    SELECT 
        e.employee_id,                         -- معرف الموظف
        e.first_name,                          -- الاسم الأول
        e.last_name,                           -- اسم العائلة
        e.hire_date,                           -- تاريخ التوظيف
        d.department_name,                     -- اسم القسم (من جدول الأقسام)
        -- ترقيم الموظفين داخل كل قسم حسب تاريخ التوظيف (الأحدث أولاً)
        ROW_NUMBER() OVER (
            PARTITION BY e.department_id       -- تقسيم النتائج حسب القسم
            ORDER BY e.hire_date DESC          -- ترتيب تنازلي (الأحدث أولاً)
        ) AS hire_rank                         -- عمود الترتيب
    FROM 
        employees e
    JOIN 
        departments d ON e.department_id = d.department_id
)
-- اختيار الموظف الذي حصل على الرقم 1 (الأحدث) في كل قسم
SELECT 
    department_name AS "اسم القسم",
    first_name AS "الاسم الأول",
    last_name AS "اسم العائلة",
    TO_CHAR(hire_date, 'DD/MM/YYYY') AS "تاريخ التوظيف"  -- تنسيق التاريخ
FROM 
    Ranked_Employees
WHERE 
    hire_rank = 1
ORDER BY 
    department_name;  -- ترتيب النتائج حسب اسم القسم