-- =====================================
-- RESET + SEED DATABASE insuranceSystem
-- =====================================

DROP DATABASE IF EXISTS insuranceSystem;
CREATE DATABASE insuranceSystem CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE insuranceSystem;

-- =====================================
-- TẠO CẤU TRÚC BẢNG
-- =====================================

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(255),
  password VARCHAR(255),
  fullname VARCHAR(255),
  mail VARCHAR(255),
  dob DATE,
  address VARCHAR(255),
  phone VARCHAR(20),
  cccd VARCHAR(20),
  avatar VARCHAR(255),
  role ENUM('admin','staff','customer'),
  cccd_img VARCHAR(255),
  status ENUM('active','inactive')
);

CREATE TABLE insurance_benefits (
  id INT PRIMARY KEY AUTO_INCREMENT,
  death_or_permanent_disability DECIMAL(10,2),
  death_due_to_illness DECIMAL(10,2),
  third_party_liability DECIMAL(10,2),
  lost_bank_card DECIMAL(10,2),
  kidnap_and_hostage DECIMAL(10,2),
  lost_or_damaged_golf_equipment DECIMAL(10,2),
  is_deleted BOOLEAN,
  medical_cost DECIMAL(10,2),
  emergency_transport DECIMAL(10,2),
  repatriation_vn DECIMAL(10,2),
  repatriation_abroad DECIMAL(10,2),
  hospital_visit DECIMAL(10,2),
  funeral_arrangement DECIMAL(10,2),
  child_care DECIMAL(10,2),
  hospital_allowance DECIMAL(10,2),
  accident_death_injury DECIMAL(10,2),
  trip_cancellation DECIMAL(10,2),
  companion_support DECIMAL(10,2),
  delayed_baggage DECIMAL(10,2),
  travel_documents DECIMAL(10,2),
  trip_delay DECIMAL(10,2)
);

CREATE TABLE products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  benefit_id INT,
  type ENUM('domestic','international'),
  name VARCHAR(255),
  img VARCHAR(255),
  description TEXT,
  package_type ENUM('Basic','Standard','Advanced','Comprehensive'),
  price DECIMAL(10,2),
  domestic_percentage_rate DECIMAL(5,2),
  international_rate_1_7 DECIMAL(5,2),
  international_rate_8_30 DECIMAL(5,2),
  international_rate_31_90 DECIMAL(5,2),
  international_rate_91_365 DECIMAL(5,2),
  is_active BOOLEAN,
  is_delete BOOLEAN,
  FOREIGN KEY (benefit_id) REFERENCES insurance_benefits(id)
);

CREATE TABLE applications (
  id INT PRIMARY KEY AUTO_INCREMENT,
  purchaser_id INT,
  product_id INT,
  type ENUM('domestic','international'),
  destination VARCHAR(255),
  startDate DATE,
  endDate DATE,
  travelers_quantity INT,
  total_price DECIMAL(10,2),
  FOREIGN KEY (purchaser_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE application_traveler (
  id INT PRIMARY KEY AUTO_INCREMENT,
  application_id INT,
  name VARCHAR(255),
  gender ENUM('Male','Female'),
  cccd_id VARCHAR(20),
  dob DATE,
  age INT,
  phone VARCHAR(20),
  email VARCHAR(255),
  FOREIGN KEY (application_id) REFERENCES applications(id)
);

CREATE TABLE `Contract` (
  contract_id INT PRIMARY KEY AUTO_INCREMENT,
  current_benefit_id INT,
  application_id INT,
  description TEXT,
  contract_status ENUM('pending','active','cancelled'),
  FOREIGN KEY (current_benefit_id) REFERENCES insurance_benefits(id),
  FOREIGN KEY (application_id) REFERENCES applications(id)
);

CREATE TABLE invoices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  contract_id INT,
  base_amount DECIMAL(10,2),
  tax_rate DECIMAL(5,2),
  payment_method ENUM('credit_card','bank_transfer','cash'),
  payment_code VARCHAR(255),
  notes TEXT,
  created_at DATETIME,
  FOREIGN KEY (contract_id) REFERENCES `Contract`(contract_id)
);

CREATE TABLE Claims (
  id INT PRIMARY KEY AUTO_INCREMENT,
  contract_id INT,
  requestDate DATE,
  claim_type VARCHAR(255),
  description TEXT,
  payment_bank VARCHAR(255),
  payment_number VARCHAR(255),
  related_img VARCHAR(255),
  related_file VARCHAR(255),
  claim_status ENUM('pending','approved','rejected'),
  FOREIGN KEY (contract_id) REFERENCES `Contract`(contract_id)
);

CREATE TABLE ClaimsRes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  claim_id INT,
  createDate DATE,
  description TEXT,
  related_img VARCHAR(255),
  related_file VARCHAR(255),
  status ENUM('open','follow_up','resolved'),
  FOREIGN KEY (claim_id) REFERENCES Claims(id)
);

-- =====================================
-- SEED DATABASE
-- =====================================

SET @old_foreign_key_checks = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE ClaimsRes;
TRUNCATE TABLE Claims;
TRUNCATE TABLE invoices;
TRUNCATE TABLE `Contract`;
TRUNCATE TABLE application_traveler;
TRUNCATE TABLE applications;
TRUNCATE TABLE products;
TRUNCATE TABLE insurance_benefits;
TRUNCATE TABLE users;

DELIMITER $$

-- 1️⃣ USERS
DROP PROCEDURE IF EXISTS seed_users$$
CREATE PROCEDURE seed_users()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 120 DO
    INSERT INTO users (username, password, fullname, mail, dob, address, phone, cccd, avatar, role, cccd_img, status)
    VALUES (
      CONCAT('user', LPAD(i,3,'0')),
      CONCAT('pass', LPAD(i,4,'0')),
      CONCAT('User Fullname ', i),
      CONCAT('user', i, '@example.com'),
      DATE_SUB(CURDATE(), INTERVAL (20 + (i % 45)) YEAR),
      CONCAT((i % 200)+1, ' Example St, District ', (i % 20) + 1),
      CONCAT('09', LPAD(10000000 + i,8,'0')),
      CONCAT('0', 100000000000 + i),
      CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
      CASE 
        WHEN i <= 3 THEN 'admin'
        WHEN i <= 13 THEN 'staff'
        ELSE 'customer'
      END,
      CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
      CASE WHEN i % 10 = 0 THEN 'inactive' ELSE 'active' END
    );
    SET i = i + 1;
  END WHILE;
END$$
CALL seed_users()$$
DROP PROCEDURE IF EXISTS seed_users$$

-- 2️⃣ INSURANCE BENEFITS
DROP PROCEDURE IF EXISTS seed_benefits$$
CREATE PROCEDURE seed_benefits()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 120 DO
    INSERT INTO insurance_benefits (
      death_or_permanent_disability, death_due_to_illness, third_party_liability,
      lost_bank_card, kidnap_and_hostage, lost_or_damaged_golf_equipment, is_deleted,
      medical_cost, emergency_transport, repatriation_vn, repatriation_abroad,
      hospital_visit, funeral_arrangement, child_care, hospital_allowance,
      accident_death_injury, trip_cancellation, companion_support, delayed_baggage, travel_documents, trip_delay
    )
    VALUES (
      ROUND(100000 + RAND()*900000,2),
      ROUND(50000 + RAND()*400000,2),
      ROUND(50000 + RAND()*300000,2),
      ROUND(100 + RAND()*1000,2),
      ROUND(1000 + RAND()*50000,2),
      ROUND(500 + RAND()*10000,2),
      FALSE,
      ROUND(1000 + RAND()*200000,2),
      ROUND(500 + RAND()*50000,2),
      ROUND(1000 + RAND()*50000,2),
      ROUND(2000 + RAND()*100000,2),
      ROUND(100 + RAND()*10000,2),
      ROUND(500 + RAND()*20000,2),
      ROUND(300 + RAND()*10000,2),
      ROUND(50 + RAND()*2000,2),
      ROUND(10000 + RAND()*300000,2),
      ROUND(100 + RAND()*50000,2),
      ROUND(100 + RAND()*50000,2),
      ROUND(50 + RAND()*5000,2),
      ROUND(50 + RAND()*3000,2),
      ROUND(50 + RAND()*2000,2)
    );
    SET i = i + 1;
  END WHILE;
END$$
CALL seed_benefits()$$
DROP PROCEDURE IF EXISTS seed_benefits$$

-- 3️⃣ PRODUCTS (với package_type enum và ảnh random)
DROP PROCEDURE IF EXISTS seed_products$$
CREATE PROCEDURE seed_products()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 120 DO
    INSERT INTO products (
      benefit_id, type, name, img, description, package_type, price,
      domestic_percentage_rate, international_rate_1_7,
      international_rate_8_30, international_rate_31_90,
      international_rate_91_365, is_active, is_delete
    )
    VALUES (
      i,
      CASE WHEN i % 2 = 0 THEN 'international' ELSE 'domestic' END,
      CONCAT(CASE WHEN i % 2 = 0 THEN 'International Travel Plan ' ELSE 'Domestic Travel Plan ' END, LPAD(i,3,'0')),
      CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
      CONCAT('Gói bảo hiểm ', CASE WHEN i % 2 = 0 THEN 'quốc tế' ELSE 'nội địa' END, ' số ', i),
      CASE (i % 4)
        WHEN 0 THEN 'Basic'
        WHEN 1 THEN 'Standard'
        WHEN 2 THEN 'Advanced'
        ELSE 'Comprehensive'
      END,
      ROUND(300000 + RAND()*5000000,2),
      ROUND(5 + RAND()*25,2),
      ROUND(0.5 + RAND()*5,2),
      ROUND(1 + RAND()*6,2),
      ROUND(2 + RAND()*8,2),
      ROUND(3 + RAND()*10,2),
      TRUE,
      FALSE
    );
    SET i = i + 1;
  END WHILE;
END$$
CALL seed_products()$$
DROP PROCEDURE IF EXISTS seed_products$$

-- 4️⃣ APPLICATIONS
DROP PROCEDURE IF EXISTS seed_applications$$
CREATE PROCEDURE seed_applications()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE purchaser INT;
  DECLARE prod INT;
  DECLARE startD DATE;
  DECLARE endD DATE;
  DECLARE trav_qty INT;
  DECLARE base_price DECIMAL(10,2);

  WHILE i <= 150 DO
    SET purchaser = ((i - 1) % 120) + 1;
    SET prod = ((i - 1) % 120) + 1;
    SET startD = DATE_ADD('2025-01-01', INTERVAL i DAY);
    SET endD = DATE_ADD(startD, INTERVAL (2 + (i % 10)) DAY);
    SET trav_qty = 1 + (i % 3);

    SELECT price INTO base_price FROM products WHERE id = prod LIMIT 1;
    IF base_price IS NULL THEN SET base_price = 500000; END IF;

    INSERT INTO applications (purchaser_id, product_id, type, destination, startDate, endDate, travelers_quantity, total_price)
    VALUES (
      purchaser,
      prod,
      CASE WHEN prod % 2 = 0 THEN 'international' ELSE 'domestic' END,
      CASE 
        WHEN prod % 5 = 0 THEN 'Tokyo, Japan'
        WHEN prod % 5 = 1 THEN 'Hanoi, Vietnam'
        WHEN prod % 5 = 2 THEN 'Ho Chi Minh City, Vietnam'
        WHEN prod % 5 = 3 THEN 'Bangkok, Thailand'
        ELSE 'Da Nang, Vietnam'
      END,
      startD,
      endD,
      trav_qty,
      ROUND(base_price * trav_qty * (1 + (RAND()*0.3)),2)
    );
    SET i = i + 1;
  END WHILE;
END$$
CALL seed_applications()$$
DROP PROCEDURE IF EXISTS seed_applications$$

-- 5️⃣ APPLICATION TRAVELERS
DROP PROCEDURE IF EXISTS seed_application_travelers$$
CREATE PROCEDURE seed_application_travelers()
BEGIN
  DECLARE app_id INT DEFAULT 1;
  DECLARE max_app INT;
  DECLARE tcount INT;
  DECLARE j INT;
  DECLARE dob DATE;
  SELECT MAX(id) INTO max_app FROM applications;

  WHILE app_id <= IFNULL(max_app,0) DO
    SET tcount = 1 + (app_id % 3);
    SET j = 1;
    WHILE j <= tcount DO
      SET dob = DATE_SUB(CURDATE(), INTERVAL (18 + ((app_id + j) % 55)) YEAR);
      INSERT INTO application_traveler (application_id, name, gender, cccd_id, dob, age, phone, email)
      VALUES (
        app_id,
        CONCAT('Traveler ', app_id, '-', j),
        CASE WHEN (app_id + j) % 2 = 0 THEN 'Male' ELSE 'Female' END,
        100000000000 + app_id*10 + j,
        dob,
        18 + ((app_id + j) % 55),
        CONCAT('09', LPAD(20000000 + app_id*10 + j,8,'0')),
        CONCAT('trav', app_id, '_', j, '@mail.com')
      );
      SET j = j + 1;
    END WHILE;
    SET app_id = app_id + 1;
  END WHILE;
END$$
CALL seed_application_travelers()$$
DROP PROCEDURE IF EXISTS seed_application_travelers$$

-- 6️⃣ CONTRACTS
DROP PROCEDURE IF EXISTS seed_contracts$$
CREATE PROCEDURE seed_contracts()
BEGIN
  DECLARE a_id INT DEFAULT 1;
  DECLARE max_app INT;
  SELECT MAX(id) INTO max_app FROM applications;

  WHILE a_id <= IFNULL(max_app,0) DO
    INSERT INTO `Contract` (current_benefit_id, application_id, description, contract_status)
    SELECT p.benefit_id, appl.id, CONCAT('Hợp đồng cho đơn ', appl.id),
           CASE 
             WHEN appl.id % 4 = 0 THEN 'active'
             WHEN appl.id % 5 = 0 THEN 'cancelled'
             ELSE 'pending'
           END
    FROM applications appl
    JOIN products p ON p.id = appl.product_id
    WHERE appl.id = a_id;
    SET a_id = a_id + 1;
  END WHILE;
END$$
CALL seed_contracts()$$
DROP PROCEDURE IF EXISTS seed_contracts$$

-- 7️⃣ INVOICES
DROP PROCEDURE IF EXISTS seed_invoices$$
CREATE PROCEDURE seed_invoices()
BEGIN
  DECLARE c_id INT DEFAULT 1;
  DECLARE max_c INT;
  SELECT MAX(contract_id) INTO max_c FROM `Contract`;

  WHILE c_id <= IFNULL(max_c,0) DO
    INSERT INTO invoices (contract_id, base_amount, tax_rate, payment_method, payment_code, notes, created_at)
    SELECT c.contract_id,
           COALESCE(a.total_price, 1000000),
           0.10,
           CASE WHEN c.contract_id % 2 = 0 THEN 'credit_card' ELSE 'bank_transfer' END,
           CONCAT('PAY', LPAD(c.contract_id,6,'0')),
           CONCAT('Invoice for contract ', c.contract_id),
           NOW()
    FROM `Contract` c
    LEFT JOIN applications a ON a.id = c.application_id
    WHERE c.contract_id = c_id;
    SET c_id = c_id + 1;
  END WHILE;
END$$
CALL seed_invoices()$$
DROP PROCEDURE IF EXISTS seed_invoices$$

-- 8️⃣ CLAIMS
DROP PROCEDURE IF EXISTS seed_claims$$
CREATE PROCEDURE seed_claims()
BEGIN
  DECLARE c_id INT DEFAULT 1;
  DECLARE max_c INT;
  SELECT MAX(contract_id) INTO max_c FROM `Contract`;

  WHILE c_id <= IFNULL(max_c,0) AND c_id <= 120 DO
    INSERT INTO Claims (contract_id, requestDate, claim_type, description, payment_bank, payment_number, related_img, related_file, claim_status)
    VALUES (
      c_id,
      DATE_SUB(CURDATE(), INTERVAL (c_id % 50) DAY),
      CASE (c_id % 6)
        WHEN 0 THEN 'medical'
        WHEN 1 THEN 'lost_baggage'
        WHEN 2 THEN 'flight_delay'
        WHEN 3 THEN 'third_party'
        WHEN 4 THEN 'trip_cancellation'
        ELSE 'other'
      END,
      CONCAT('Yêu cầu bồi thường cho hợp đồng ', c_id),
      CONCAT('Bank ', (c_id % 8) + 1),
      CONCAT('ACC', LPAD(500000 + c_id,8,'0')),
      CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
      CONCAT('https://example.com/file_', FLOOR(1 + RAND()*1000), '.pdf'),
      CASE WHEN c_id % 3 = 0 THEN 'approved' WHEN c_id % 5 = 0 THEN 'rejected' ELSE 'pending' END
    );
    SET c_id = c_id + 1;
  END WHILE;
END$$
CALL seed_claims()$$
DROP PROCEDURE IF EXISTS seed_claims$$

-- 9️⃣ CLAIM RESPONSES
DROP PROCEDURE IF EXISTS seed_claimsres$$
CREATE PROCEDURE seed_claimsres()
BEGIN
  DECLARE cl_id INT DEFAULT 1;
  DECLARE max_claim INT;
  DECLARE k INT;
  DECLARE rcount INT;

  SELECT MAX(id) INTO max_claim FROM Claims;
  WHILE cl_id <= IFNULL(max_claim,0) DO
    SET rcount = 1 + (cl_id % 2);
    SET k = 1;
    WHILE k <= rcount DO
      INSERT INTO ClaimsRes (claim_id, createDate, description, related_img, related_file, status)
      VALUES (
        cl_id,
        DATE_ADD(DATE_SUB(CURDATE(), INTERVAL (cl_id % 50) DAY), INTERVAL k DAY),
        CONCAT('Phản hồi ', k, ' cho claim ', cl_id),
        CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
        CONCAT('https://example.com/res_file_', FLOOR(1 + RAND()*1000), '.pdf'),
        CASE WHEN k = 1 AND cl_id % 3 = 0 THEN 'resolved' WHEN k = 2 THEN 'follow_up' ELSE 'open' END
      );
      SET k = k + 1;
    END WHILE;
    SET cl_id = cl_id + 1;
  END WHILE;
END$$
CALL seed_claimsres()$$
DROP PROCEDURE IF EXISTS seed_claimsres$$

DELIMITER ;
SET FOREIGN_KEY_CHECKS = @old_foreign_key_checks;

-- ✅ Quick sanity check
SELECT 'users' AS tbl, COUNT(*) AS cnt FROM users
UNION ALL SELECT 'insurance_benefits', COUNT(*) FROM insurance_benefits
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'applications', COUNT(*) FROM applications
UNION ALL SELECT 'application_traveler', COUNT(*) FROM application_traveler
UNION ALL SELECT 'Contract', COUNT(*) FROM `Contract`
UNION ALL SELECT 'invoices', COUNT(*) FROM invoices
UNION ALL SELECT 'Claims', COUNT(*) FROM Claims
UNION ALL SELECT 'ClaimsRes', COUNT(*) FROM ClaimsRes;
