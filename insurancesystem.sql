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
  total_price DECIMAL(15,2),
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
  base_amount DECIMAL(15,2),
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
  compensation_amount DECIMAL(15,2) DEFAULT NULL,
  FOREIGN KEY (contract_id) REFERENCES `Contract`(contract_id)
);

CREATE TABLE ClaimsRes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  claim_id INT,
  user_id INT DEFAULT NULL,
  createDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  description TEXT,
  related_img VARCHAR(255),
  related_file VARCHAR(255),
  action_type ENUM('approve','reject','review') DEFAULT 'review',
  FOREIGN KEY (claim_id) REFERENCES Claims(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_user_id (user_id),
  INDEX idx_action_type (action_type)
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
-- TEST SCENARIOS:
-- - Large contract values for getUnusualLargeContractClaims test
-- - Products with different claim rates (some high, some low)
-- - Revenue scenarios for getRevenueByProduct test
DROP PROCEDURE IF EXISTS seed_applications$$
CREATE PROCEDURE seed_applications()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE purchaser INT;
  DECLARE prod INT;
  DECLARE startD DATE;
  DECLARE endD DATE;
  DECLARE trav_qty INT;
  DECLARE base_price DECIMAL(15,2);
  DECLARE total_price_calc DECIMAL(15,2);
  DECLARE price_multiplier DECIMAL(5,2);

  WHILE i <= 150 DO
    SET purchaser = ((i - 1) % 120) + 1;
    SET prod = ((i - 1) % 120) + 1;
    SET startD = DATE_ADD('2025-01-01', INTERVAL i DAY);
    SET endD = DATE_ADD(startD, INTERVAL (2 + (i % 10)) DAY);
    SET trav_qty = 1 + (i % 3);

    SELECT price INTO base_price FROM products WHERE id = prod LIMIT 1;
    IF base_price IS NULL THEN SET base_price = 500000; END IF;
    
    -- Create some large contract values (for testing getUnusualLargeContractClaims)
    -- Applications 1-10: Very high value contracts
    -- Applications 11-30: High value contracts
    -- Rest: Normal values
    IF i <= 10 THEN
      SET price_multiplier = 8.0 + (RAND() * 4.0);  -- 8x to 12x multiplier
    ELSEIF i <= 30 THEN
      SET price_multiplier = 3.0 + (RAND() * 3.0);  -- 3x to 6x multiplier
    ELSE
      SET price_multiplier = 1.0 + (RAND() * 0.5);  -- 1x to 1.5x multiplier
    END IF;
    
    SET total_price_calc = ROUND(base_price * trav_qty * price_multiplier, 2);

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
      total_price_calc
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
-- TEST SCENARIOS:
-- - ~50% active contracts (for getActiveContractsCount test)
-- - ~30% pending
-- - ~20% cancelled
-- - Some contracts with high total_price (for getUnusualLargeContractClaims test)
DROP PROCEDURE IF EXISTS seed_contracts$$
CREATE PROCEDURE seed_contracts()
BEGIN
  DECLARE a_id INT DEFAULT 1;
  DECLARE max_app INT;
  DECLARE contract_status VARCHAR(20);
  
  SELECT MAX(id) INTO max_app FROM applications;

  WHILE a_id <= IFNULL(max_app,0) DO
    -- Distribution: 50% active, 30% pending, 20% cancelled
    IF (a_id % 10) <= 4 THEN
      SET contract_status = 'active';
    ELSEIF (a_id % 10) <= 7 THEN
      SET contract_status = 'pending';
    ELSE
      SET contract_status = 'cancelled';
    END IF;
    
    INSERT INTO `Contract` (current_benefit_id, application_id, description, contract_status)
    SELECT p.benefit_id, appl.id, CONCAT('Hợp đồng cho đơn ', appl.id),
           contract_status
    FROM applications appl
    JOIN products p ON p.id = appl.product_id
    WHERE appl.id = a_id;
    SET a_id = a_id + 1;
  END WHILE;
END$$
CALL seed_contracts()$$
DROP PROCEDURE IF EXISTS seed_contracts$$

-- 7️⃣ INVOICES
-- TEST SCENARIOS:
-- - Revenue calculations with proper base_amount and tax_rate
-- - High revenue products for getRevenueByProduct test
-- - Total revenue for getTotalRevenue test
DROP PROCEDURE IF EXISTS seed_invoices$$
CREATE PROCEDURE seed_invoices()
BEGIN
  DECLARE c_id INT DEFAULT 1;
  DECLARE max_c INT;
  DECLARE base_amt DECIMAL(15,2);
  DECLARE tax_rt DECIMAL(5,2);
  
  SELECT MAX(contract_id) INTO max_c FROM `Contract`;

  WHILE c_id <= IFNULL(max_c,0) DO
    -- Get total_price from application
    SELECT COALESCE(a.total_price, 1000000) INTO base_amt
    FROM `Contract` c
    LEFT JOIN applications a ON a.id = c.application_id
    WHERE c.contract_id = c_id;
    
    -- Tax rate: vary between 8% and 12%
    SET tax_rt = 0.08 + (RAND() * 0.04);
    
    INSERT INTO invoices (contract_id, base_amount, tax_rate, payment_method, payment_code, notes, created_at)
    SELECT c.contract_id,
           base_amt,
           tax_rt,
           CASE 
             WHEN c.contract_id % 3 = 0 THEN 'credit_card'
             WHEN c.contract_id % 3 = 1 THEN 'bank_transfer'
             ELSE 'cash'
           END,
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
-- TEST SCENARIOS:
-- - ~40% approved (half with compensation_amount, half without)
-- - ~35% pending
-- - ~25% rejected
-- - At least 20-30 claims in last 30 days (for getClaimsLast30Days test)
-- - Claims with dates from 1-365 days ago
-- - High compensation amounts for getHighCompensationClaims test
-- - Multiple claims per customer for risk customer testing
DROP PROCEDURE IF EXISTS seed_claims$$
CREATE PROCEDURE seed_claims()
BEGIN
  DECLARE c_id INT DEFAULT 1;
  DECLARE max_c INT;
  DECLARE claim_status VARCHAR(20);
  DECLARE compensation_amt DECIMAL(15,2);
  DECLARE days_ago INT;
  DECLARE claim_num INT DEFAULT 1;
  DECLARE total_claims INT DEFAULT 250;
  DECLARE contract_counter INT DEFAULT 1;
  DECLARE risk_customer_id INT DEFAULT 14;
  DECLARE risk_contract_id INT;
  DECLARE risk_claim_count INT;
  DECLARE risk_claim_num INT;
  DECLARE high_claim_product_id INT DEFAULT 1;
  DECLARE high_claim_contract_id INT;
  DECLARE high_claim_count INT;
  DECLARE high_claim_num INT;
  
  SELECT MAX(contract_id) INTO max_c FROM `Contract`;
  
  -- Create claims: 250 total, distributed across contracts
  WHILE claim_num <= total_claims DO
    -- Cycle through contracts
    SET contract_counter = ((claim_num - 1) % max_c) + 1;
    
    -- Determine status: 40% approved, 35% pending, 25% rejected
    IF (claim_num % 10) <= 3 THEN
      SET claim_status = 'approved';
    ELSEIF (claim_num % 10) <= 6 THEN
      SET claim_status = 'pending';
    ELSE
      SET claim_status = 'rejected';
    END IF;
    
    -- For approved claims: 50% with compensation, 50% without
    IF claim_status = 'approved' THEN
      IF (claim_num % 2) = 0 THEN
        -- High compensation amounts for testing getHighCompensationClaims
        SET compensation_amt = ROUND(500000 + RAND() * 4500000, 2);
      ELSE
        SET compensation_amt = NULL;
      END IF;
    ELSE
      SET compensation_amt = NULL;
    END IF;
    
    -- Date distribution: 
    -- - First 30 claims: last 30 days (for getClaimsLast30Days test)
    -- - Next 50 claims: 31-90 days ago
    -- - Rest: 91-365 days ago
    IF claim_num <= 30 THEN
      SET days_ago = (claim_num - 1) % 30;  -- 0-29 days ago
    ELSEIF claim_num <= 80 THEN
      SET days_ago = 31 + ((claim_num - 31) % 60);  -- 31-90 days ago
    ELSE
      SET days_ago = 91 + ((claim_num - 81) % 275);  -- 91-365 days ago
    END IF;
    
    INSERT INTO Claims (contract_id, requestDate, claim_type, description, payment_bank, payment_number, related_img, related_file, claim_status, compensation_amount)
    VALUES (
      contract_counter,
      DATE_SUB(CURDATE(), INTERVAL days_ago DAY),
      CASE (claim_num % 8)
        WHEN 0 THEN 'medical'
        WHEN 1 THEN 'lost_baggage'
        WHEN 2 THEN 'flight_delay'
        WHEN 3 THEN 'third_party'
        WHEN 4 THEN 'trip_cancellation'
        WHEN 5 THEN 'accident'
        WHEN 6 THEN 'theft'
        ELSE 'other'
      END,
      CONCAT('Yêu cầu bồi thường cho hợp đồng ', contract_counter, ' - Claim số ', claim_num),
      CONCAT('Bank ', (claim_num % 10) + 1),
      CONCAT('ACC', LPAD(500000 + claim_num,8,'0')),
      CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
      CONCAT('https://example.com/file_', FLOOR(1 + RAND()*1000), '.pdf'),
      claim_status,
      compensation_amt
    );
    
    SET claim_num = claim_num + 1;
  END WHILE;
  
  -- Create multiple claims for some customers (risk customers test scenario)
  -- Customer 14-20: High risk customers with many claims
  SET risk_customer_id = 14;
  
  WHILE risk_customer_id <= 20 DO
    -- Find contracts for this customer
    SELECT c.contract_id INTO risk_contract_id 
    FROM `Contract` c
    JOIN applications a ON c.application_id = a.id
    WHERE a.purchaser_id = risk_customer_id
    LIMIT 1;
    
    IF risk_contract_id IS NOT NULL THEN
      -- Create 5-10 claims per risk customer
      SET risk_claim_count = 5 + (risk_customer_id % 6);
      SET risk_claim_num = 1;
      
      WHILE risk_claim_num <= risk_claim_count DO
        -- Mix of approved and rejected for risk customers
        IF (risk_claim_num % 3) = 0 THEN
          SET claim_status = 'approved';
          SET compensation_amt = ROUND(100000 + RAND() * 500000, 2);
        ELSEIF (risk_claim_num % 3) = 1 THEN
          SET claim_status = 'rejected';
          SET compensation_amt = NULL;
        ELSE
          SET claim_status = 'pending';
          SET compensation_amt = NULL;
        END IF;
        
        INSERT INTO Claims (contract_id, requestDate, claim_type, description, payment_bank, payment_number, related_img, related_file, claim_status, compensation_amount)
        VALUES (
          risk_contract_id,
          DATE_SUB(CURDATE(), INTERVAL (30 + risk_claim_num * 10) DAY),
          CASE (risk_claim_num % 5)
            WHEN 0 THEN 'medical'
            WHEN 1 THEN 'lost_baggage'
            WHEN 2 THEN 'accident'
            WHEN 3 THEN 'theft'
            ELSE 'other'
          END,
          CONCAT('Risk customer claim - Customer ', risk_customer_id, ' - Claim ', risk_claim_num),
          CONCAT('Bank ', (risk_customer_id % 5) + 1),
          CONCAT('ACC', LPAD(900000 + risk_customer_id * 100 + risk_claim_num,8,'0')),
          CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
          CONCAT('https://example.com/risk_file_', risk_customer_id, '_', risk_claim_num, '.pdf'),
          claim_status,
          compensation_amt
        );
        
        SET risk_claim_num = risk_claim_num + 1;
      END WHILE;
    END IF;
    
    SET risk_customer_id = risk_customer_id + 1;
  END WHILE;
  
  -- Create additional claims for high-claim-rate products (test scenario)
  -- Products 1-10: High claim rate products (>50% claim rate)
  -- Products 11-20: Medium claim rate products
  -- Products 21+: Low claim rate products (already have normal distribution)
  SET high_claim_product_id = 1;
  
  WHILE high_claim_product_id <= 10 DO
    -- Find contracts for this high-claim-rate product
    SELECT c.contract_id INTO high_claim_contract_id
    FROM `Contract` c
    JOIN applications a ON c.application_id = a.id
    WHERE a.product_id = high_claim_product_id
    LIMIT 1;
    
    IF high_claim_contract_id IS NOT NULL THEN
      -- Create 3-5 additional claims per high-claim-rate product
      SET high_claim_count = 3 + (high_claim_product_id % 3);
      SET high_claim_num = 1;
      
      WHILE high_claim_num <= high_claim_count DO
        -- Mix of statuses for high-claim-rate products
        IF (high_claim_num % 3) = 0 THEN
          SET claim_status = 'approved';
          SET compensation_amt = ROUND(200000 + RAND() * 800000, 2);
        ELSEIF (high_claim_num % 3) = 1 THEN
          SET claim_status = 'pending';
          SET compensation_amt = NULL;
        ELSE
          SET claim_status = 'rejected';
          SET compensation_amt = NULL;
        END IF;
        
        INSERT INTO Claims (contract_id, requestDate, claim_type, description, payment_bank, payment_number, related_img, related_file, claim_status, compensation_amount)
        VALUES (
          high_claim_contract_id,
          DATE_SUB(CURDATE(), INTERVAL (20 + high_claim_num * 5) DAY),
          CASE (high_claim_num % 6)
            WHEN 0 THEN 'medical'
            WHEN 1 THEN 'lost_baggage'
            WHEN 2 THEN 'flight_delay'
            WHEN 3 THEN 'accident'
            WHEN 4 THEN 'theft'
            ELSE 'other'
          END,
          CONCAT('High claim rate product claim - Product ', high_claim_product_id, ' - Claim ', high_claim_num),
          CONCAT('Bank ', (high_claim_product_id % 5) + 1),
          CONCAT('ACC', LPAD(800000 + high_claim_product_id * 100 + high_claim_num,8,'0')),
          CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
          CONCAT('https://example.com/highclaim_file_', high_claim_product_id, '_', high_claim_num, '.pdf'),
          claim_status,
          compensation_amt
        );
        
        SET high_claim_num = high_claim_num + 1;
      END WHILE;
    END IF;
    
    SET high_claim_product_id = high_claim_product_id + 1;
  END WHILE;
END$$
CALL seed_claims()$$
DROP PROCEDURE IF EXISTS seed_claims$$

-- 9️⃣ CLAIM RESPONSES
-- TEST SCENARIOS:
-- - Link ClaimsRes with staff user_id (IDs 4-13 are staff)
-- - createDate as DATETIME distributed across date ranges
-- - Mỗi approved/rejected claim chỉ có 1 ClaimsRes từ staff quyết định
-- - Staff approval patterns:
--   * Staff 4-7: Approve nhiều claims (optimistic) - 70% approved, 30% rejected
--   * Staff 8-10: Reject nhiều claims (strict) - 30% approved, 70% rejected  
--   * Staff 11-13: Cân bằng (balanced) - 50% approved, 50% rejected
-- - Pending claims có thể có 1 response review ban đầu
DROP PROCEDURE IF EXISTS seed_claimsres$$
CREATE PROCEDURE seed_claimsres()
BEGIN
  DECLARE cl_id INT DEFAULT 1;
  DECLARE max_claim INT;
  DECLARE staff_user_id INT;
  DECLARE claim_status_check VARCHAR(20);
  DECLARE days_offset INT;
  DECLARE hours_offset INT;
  DECLARE response_date DATETIME;
  DECLARE staff_pattern INT;

  SELECT MAX(id) INTO max_claim FROM Claims;
  
  WHILE cl_id <= IFNULL(max_claim,0) DO
    -- Get claim status to determine which staff processed it
    SELECT claim_status INTO claim_status_check FROM Claims WHERE id = cl_id;
    
    -- Only create responses for approved or rejected claims (staff processed them)
    IF claim_status_check IN ('approved', 'rejected') THEN
      -- Mỗi claim chỉ có 1 ClaimsRes từ staff quyết định
      -- Phân bố staff theo pattern:
      -- Staff 4-7: Approve nhiều (70% approved claims được gán cho họ)
      -- Staff 8-10: Reject nhiều (70% rejected claims được gán cho họ)
      -- Staff 11-13: Cân bằng
      
      IF claim_status_check = 'approved' THEN
        -- For approved claims: 70% staff 4-7, 20% staff 11-13, 10% staff 8-10
        SET staff_pattern = cl_id % 10;
        IF staff_pattern <= 6 THEN
          SET staff_user_id = 4 + (cl_id % 4);  -- Staff 4-7 (70%)
        ELSEIF staff_pattern <= 8 THEN
          SET staff_user_id = 11 + (cl_id % 3);  -- Staff 11-13 (20%)
        ELSE
          SET staff_user_id = 8 + (cl_id % 3);  -- Staff 8-10 (10%)
        END IF;
      ELSE
        -- For rejected claims: 70% staff 8-10, 20% staff 11-13, 10% staff 4-7
        SET staff_pattern = cl_id % 10;
        IF staff_pattern <= 6 THEN
          SET staff_user_id = 8 + (cl_id % 3);  -- Staff 8-10 (70%)
        ELSEIF staff_pattern <= 8 THEN
          SET staff_user_id = 11 + (cl_id % 3);  -- Staff 11-13 (20%)
        ELSE
          SET staff_user_id = 4 + (cl_id % 4);  -- Staff 4-7 (10%)
        END IF;
      END IF;
      
      -- Create date/time: distribute across date ranges
      -- Use DATETIME with hours offset for variety
      SET days_offset = (cl_id % 90);  -- 0-89 days ago
      SET hours_offset = (cl_id % 24);  -- 0-23 hours
      SET response_date = DATE_SUB(NOW(), INTERVAL days_offset DAY);
      SET response_date = DATE_SUB(response_date, INTERVAL hours_offset HOUR);
      
      INSERT INTO ClaimsRes (claim_id, user_id, createDate, description, related_img, related_file, action_type)
      VALUES (
        cl_id,
        staff_user_id,
        response_date,
        CONCAT('Quyết định ', claim_status_check, ' cho claim ', cl_id, ' bởi staff ', staff_user_id),
        CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
        CONCAT('https://example.com/res_file_', cl_id, '.pdf'),
        CASE 
          WHEN claim_status_check = 'approved' THEN 'approve'
          WHEN claim_status_check = 'rejected' THEN 'reject'
          ELSE 'review'
        END
      );
    ELSE
      -- For pending claims, create initial review response (1/4 of pending claims)
      IF (cl_id % 4) = 0 THEN
        -- Some pending claims have initial response from random staff
        SET staff_user_id = 4 + (cl_id % 10);  -- Any staff 4-13
        SET days_offset = (cl_id % 30);  -- Recent dates
        SET hours_offset = (cl_id % 24);
        SET response_date = DATE_SUB(NOW(), INTERVAL days_offset DAY);
        SET response_date = DATE_SUB(response_date, INTERVAL hours_offset HOUR);
        
        INSERT INTO ClaimsRes (claim_id, user_id, createDate, description, related_img, related_file, action_type)
        VALUES (
          cl_id,
          staff_user_id,
          response_date,
          CONCAT('Initial review cho claim ', cl_id, ' - Đang xử lý'),
          CONCAT('https://picsum.photos/id/', FLOOR(1 + RAND()*1000), '/200/300'),
          CONCAT('https://example.com/review_file_', cl_id, '.pdf'),
          'review'
        );
      END IF;
    END IF;
    
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

ALTER TABLE insurance_benefits
    MODIFY death_or_permanent_disability DECIMAL(15,2),
    MODIFY death_due_to_illness DECIMAL(15,2),
    MODIFY third_party_liability DECIMAL(15,2),
    MODIFY lost_bank_card DECIMAL(15,2),
    MODIFY kidnap_and_hostage DECIMAL(15,2),
    MODIFY lost_or_damaged_golf_equipment DECIMAL(15,2),
    MODIFY medical_cost DECIMAL(15,2),
    MODIFY emergency_transport DECIMAL(15,2),
    MODIFY repatriation_vn DECIMAL(15,2),
    MODIFY repatriation_abroad DECIMAL(15,2),
    MODIFY hospital_visit DECIMAL(15,2),
    MODIFY funeral_arrangement DECIMAL(15,2),
    MODIFY child_care DECIMAL(15,2),
    MODIFY hospital_allowance DECIMAL(15,2),
    MODIFY accident_death_injury DECIMAL(15,2),
    MODIFY trip_cancellation DECIMAL(15,2),
    MODIFY companion_support DECIMAL(15,2),
    MODIFY delayed_baggage DECIMAL(15,2),
    MODIFY travel_documents DECIMAL(15,2),
    MODIFY trip_delay DECIMAL(15,2);
    
        ALTER TABLE products
    modify domestic_percentage_rate decimal(15,2),
    modify international_rate_1_7 decimal(15,2),
    modify international_rate_8_30 decimal(15,2),
    modify international_rate_31_90 decimal(15,2),
    modify international_rate_91_365 decimal(15,2),
    modify price decimal(15,2);

    -- =====================================
-- MIGRATION SCRIPT: Add user_id column to ClaimsRes table
-- =====================================
-- This script adds a user_id column to track which user created the claim response
-- Created: 2025

USE insurancesystem;

-- Add user_id column to ClaimsRes table
ALTER TABLE claimsres 
ADD COLUMN user_id INT DEFAULT NULL AFTER claim_id;

-- Add foreign key constraint to link to users table
ALTER TABLE claimsres 
ADD CONSTRAINT claimsres_ibfk_2 FOREIGN KEY (user_id) REFERENCES users(id);

-- Add index for better query performance
CREATE INDEX idx_user_id ON claimsres(user_id);

-- If you want to update existing records with a default user (optional)
-- Uncomment the following line and replace 1 with the appropriate user ID
-- UPDATE claimsres SET user_id = 1 WHERE user_id IS NULL;

-- Verify the changes
DESCRIBE claimsres;

-- =====================================
-- MIGRATION SCRIPT: Fix createDate column to support time
-- =====================================
-- This script changes createDate from DATE to DATETIME to store time information
-- Created: 2025

USE insurancesystem;

-- Change createDate column from DATE to DATETIME
ALTER TABLE claimsres 
MODIFY COLUMN createDate DATETIME DEFAULT CURRENT_TIMESTAMP;

-- Verify the changes
DESCRIBE claimsres;

ALTER TABLE claimsres DROP COLUMN status;

-- =====================================
-- MIGRATION SCRIPT: Add compensation_amount column to Claims table
-- =====================================
-- This script adds a compensation_amount column to track the actual compensation amount paid to customers
-- Created: 2025

USE insurancesystem;

-- Add compensation_amount column to Claims table
ALTER TABLE claims 
ADD COLUMN compensation_amount DECIMAL(15,2) DEFAULT NULL AFTER claim_status;

-- Verify the changes
DESCRIBE claims;

-- =====================================
-- MIGRATION SCRIPT: Add action_type column to ClaimsRes table
-- =====================================
-- This script adds an action_type column to track what action staff took (approve/reject/review)
-- Created: 2025

USE insurancesystem;

-- Add action_type column to ClaimsRes table
ALTER TABLE claimsres 
ADD COLUMN action_type ENUM('approve','reject','review') DEFAULT 'review' AFTER related_file;

-- Add index for better query performance
CREATE INDEX idx_action_type ON claimsres(action_type);

-- Update existing records based on claim status
-- If claim is approved and has ClaimsRes, set action_type = 'approve'
UPDATE claimsres cr
JOIN claims cl ON cr.claim_id = cl.id
SET cr.action_type = 'approve'
WHERE cl.claim_status = 'approved' AND cr.action_type = 'review';

-- If claim is rejected and has ClaimsRes, set action_type = 'reject'
UPDATE claimsres cr
JOIN claims cl ON cr.claim_id = cl.id
SET cr.action_type = 'reject'
WHERE cl.claim_status = 'rejected' AND cr.action_type = 'review';

-- Verify the changes
DESCRIBE claimsres;