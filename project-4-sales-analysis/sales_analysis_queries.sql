/*
===========================================================
**  مشروع تحليل مبيعات المناطق والمنتجات
**  Project: Regional Sales & Product Analysis
**  التاريخ: 2026-07-26
**  المحلل: ياسين المحمد
**  Analytics Engineer: Yaseen Al-Mohamad
**  
**  ملف يتضمن ثلاثة استعلامات تحليلية رئيسية:
**  1. إجمالي المبيعات لكل منطقة (القيمة المالية).
**  2. أفضل منتج مبيعاً في كل منطقة (من حيث الكمية).
**  3. ترتيب مندوبي المبيعات (حسب إجمالي القيمة المالية).
===========================================================
*/


-- ============================================================
--  الاستعلام الأول: إجمالي المبيعات لكل منطقة
--  Query 1: Total Sales per Region (Financial Value)
-- ============================================================
--  الهدف: حساب مجموع القيمة المالية (totalprice) لكل منطقة،
--  وتقريب الناتج إلى منزلتين عشريتين، مع ترتيب النتائج تنازلياً.
--  Goal: Calculate the sum of totalprice per region,
--  round the result to 2 decimals, and order by total descending.

SELECT
    region,                                  -- اسم المنطقة (Grouping Key)
    ROUND(SUM(totalprice), 2) "Total_Sales"  -- إجمالي المبيعات المقربة
FROM
    sales                                    -- الجدول الرئيسي للمبيعات
GROUP BY
    region                                   -- التجميع حسب المنطقة
ORDER BY
    SUM(totalprice) DESC;                    -- الترتيب من الأعلى للأقل


-- ============================================================
--  الاستعلام الثاني: أفضل منتج مبيعاً في كل منطقة (من حيث الكمية)
--  Query 2: Best Selling Product per Region (By Quantity)
-- ============================================================
--  الهدف: تحديد المنتج الذي حقق أعلى إجمالي مبيعات (كمية)
--  داخل كل منطقة باستخدام دالة ROW_NUMBER لترقيم المنتجات
--  داخل كل مجموعة (Partition) واختيار الرقم 1 (الأعلى).
--  Goal: Identify the product with the highest total quantity
--  sold within each region using ROW_NUMBER to rank products
--  within each partition, then selecting rank 1 (the highest).

WITH Ranked_Products AS (
    SELECT
        region,                              -- اسم المنطقة (Partition Key)
        product,                             -- اسم المنتج
        SUM(quantity) AS total_quantity,     -- إجمالي الكمية المباعة للمنتج
        ROW_NUMBER() OVER (                  -- ترقيم المنتجات داخل كل منطقة
            PARTITION BY region              -- تقسيم النتائج حسب المنطقة
            ORDER BY SUM(quantity) DESC      -- ترتيب المنتجات داخل المنطقة تنازلياً حسب الكمية
        ) AS rank                            -- رقم الترتيب (1 = الأعلى)
    FROM
        sales                                -- الجدول الرئيسي للمبيعات
    GROUP BY
        region, product                      -- التجميع حسب المنطقة والمنتج معاً
)
SELECT
    region,                                  -- اسم المنطقة
    product,                                 -- اسم المنتج الفائز (الأعلى مبيعاً)
    total_quantity                           -- إجمالي الكمية المباعة من هذا المنتج في تلك المنطقة
FROM
    Ranked_Products
WHERE
    rank = 1;                                -- اختيار الأعلى فقط (المرتبة الأولى)


-- ============================================================
--  الاستعلام الثالث: ترتيب مندوبي المبيعات (حسب القيمة المالية)
--  Query 3: Salesperson Ranking (By Total Financial Value)
-- ============================================================
--  الهدف: حساب إجمالي المبيعات لكل مندوب على مستوى الشركة،
--  وتقريب الناتج إلى منزلتين عشريتين، مع ترتيب المندوبين
--  من الأعلى إلى الأقل مبيعاً.
--  Goal: Calculate total sales per salesperson across the company,
--  round the result to 2 decimals, and rank salespeople
--  from highest to lowest total sales.

SELECT
    salesperson,                                     -- اسم مندوب المبيعات
    ROUND(SUM(totalprice), 2) SUM_TOTAL_PRICE        -- إجمالي مبيعات المندوب
FROM
    sales                                            -- الجدول الرئيسي للمبيعات
GROUP BY
    salesperson                                      -- التجميع حسب المندوب
ORDER BY
    SUM(totalprice) DESC;                            -- الترتيب من الأعلى للأقل
