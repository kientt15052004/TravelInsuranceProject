-- Script để insert sample products vào database
-- Chạy script này trong MySQL để test

USE insurancesystem;

-- Kiểm tra table structure
DESCRIBE products;

-- Xem data hiện tại
SELECT * FROM products;

-- Insert sample products nếu table trống
INSERT INTO products (id, benefit_id, name, img, type, description) VALUES
(1, 1, 'Bảo hiểm du lịch cơ bản', 'basic_travel.jpg', 'Du lịch trong nước', 'Bảo hiểm du lịch cơ bản cho các chuyến đi trong nước'),
(2, 2, 'Bảo hiểm du lịch cao cấp', 'premium_travel.jpg', 'Du lịch nước ngoài', 'Bảo hiểm du lịch cao cấp cho các chuyến đi quốc tế'),
(3, 1, 'Bảo hiểm du lịch gia đình', 'family_travel.jpg', 'Du lịch trong nước', 'Bảo hiểm du lịch dành cho gia đình'),
(4, 2, 'Bảo hiểm du lịch doanh nhân', 'business_travel.jpg', 'Du lịch nước ngoài', 'Bảo hiểm du lịch dành cho doanh nhân');

-- Kiểm tra lại data
SELECT * FROM products;
