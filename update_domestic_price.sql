-- Script để cập nhật price cho các sản phẩm nội địa = max benefit × rate
-- Chạy script này nếu price không khớp với công thức: price = max benefit × domestic_percentage_rate

USE insurancesystem;

-- Cập nhật price = max benefit × rate cho tất cả sản phẩm nội địa
-- Max benefit = death_or_permanent_disability (giá trị lớn nhất trong các quyền lợi nội địa)
UPDATE products p
INNER JOIN insurance_benefits ib ON p.benefit_id = ib.id
SET p.price = (
    -- Max benefit = death_or_permanent_disability (lớn nhất trong các quyền lợi nội địa)
    GREATEST(
        COALESCE(ib.death_or_permanent_disability, 0),
        COALESCE(ib.death_due_to_illness, 0),
        COALESCE(ib.third_party_liability, 0),
        COALESCE(ib.lost_bank_card, 0),
        COALESCE(ib.kidnap_and_hostage, 0),
        COALESCE(ib.lost_or_damaged_golf_equipment, 0)
    ) * (p.domestic_percentage_rate / 100)
)
WHERE p.type = 'domestic' 
  AND p.domestic_percentage_rate IS NOT NULL 
  AND p.domestic_percentage_rate > 0
  AND ib.death_or_permanent_disability IS NOT NULL;

-- Kiểm tra kết quả
SELECT 
    p.id,
    p.name,
    p.type,
    p.package_type,
    p.price AS current_price,
    p.domestic_percentage_rate AS rate,
    ib.death_or_permanent_disability AS max_benefit,
    (ib.death_or_permanent_disability * (p.domestic_percentage_rate / 100)) AS calculated_price,
    CASE 
        WHEN ABS(p.price - (ib.death_or_permanent_disability * (p.domestic_percentage_rate / 100))) < 0.01 
        THEN 'OK' 
        ELSE 'KHÔNG KHỚP' 
    END AS status
FROM products p
INNER JOIN insurance_benefits ib ON p.benefit_id = ib.id
WHERE p.type = 'domestic'
ORDER BY p.id;

