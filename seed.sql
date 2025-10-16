DROP DATABASE IF EXISTS insuranceSystem;
CREATE DATABASE insuranceSystem CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE insuranceSystem;

-- BẢNG USERS
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255),
  password VARCHAR(255),
  fullname VARCHAR(255),
  mail VARCHAR(255),
  dob DATE,
  address VARCHAR(255),
  phone VARCHAR(20),
  cccd VARCHAR(20),
  avatar VARCHAR(255),
  role ENUM('customer','staff','admin') NOT NULL,
  cccd_img VARCHAR(255),
  status VARCHAR(50)
);

-- BẢNG insurance_benefits
CREATE TABLE insurance_benefits (
  id INT AUTO_INCREMENT PRIMARY KEY,
  death_or_permanent_disability DECIMAL(15,2),
  death_due_to_illness DECIMAL(15,2),
  third_party_liability DECIMAL(15,2),
  lost_bank_card DECIMAL(15,2),
  kidnap_and_hostage DECIMAL(15,2),
  lost_or_damaged_golf_equipment DECIMAL(15,2),
  medical_cost DECIMAL(15,2),
  emergency_transport DECIMAL(15,2),
  repatriation_vn DECIMAL(15,2),
  repatriation_abroad DECIMAL(15,2),
  hospital_visit DECIMAL(15,2),
  funeral_arrangement DECIMAL(15,2),
  child_care DECIMAL(15,2),
  hospital_allowance DECIMAL(15,2),
  accident_death_injury DECIMAL(15,2),
  trip_cancellation DECIMAL(15,2),
  companion_support DECIMAL(15,2),
  delayed_baggage DECIMAL(15,2),
  travel_documents DECIMAL(15,2),
  trip_delay DECIMAL(15,2),
  is_deleted BOOLEAN DEFAULT FALSE
);

-- BẢNG products
CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  benefit_id INT,
  type ENUM('domestic','international'),
  name VARCHAR(255),
  img VARCHAR(255),
  description TEXT,
  package ENUM('basic','standard','advanced','comprehensive'),
  price DECIMAL(15,2),
  domestic_percentage_rate DECIMAL(15,2),
  international_rate_1_7 DECIMAL(15,2),
  international_rate_8_30 DECIMAL(15,2),
  international_rate_31_90 DECIMAL(15,2),
  international_rate_91_180 DECIMAL(15,2),
  is_active BOOLEAN DEFAULT TRUE,
  is_delete BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (benefit_id) REFERENCES insurance_benefits(id)
);

-- BẢNG applications
CREATE TABLE applications (
  id INT AUTO_INCREMENT PRIMARY KEY,
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

-- BẢNG application_traveler
CREATE TABLE application_traveler (
  id INT AUTO_INCREMENT PRIMARY KEY,
  application_id INT,
  name VARCHAR(255),
  gender ENUM('male','female'),
  cccd_id BIGINT,
  dob DATE,
  age INT,
  phone VARCHAR(20),
  email VARCHAR(255),
  FOREIGN KEY (application_id) REFERENCES applications(id)
);

-- BẢNG contract
CREATE TABLE contract (
  contract_id INT AUTO_INCREMENT PRIMARY KEY,
  current_benefit_id INT,
  application_id INT UNIQUE,
  description VARCHAR(255),
  contract_status VARCHAR(50),
  FOREIGN KEY (application_id) REFERENCES applications(id),
  FOREIGN KEY (current_benefit_id) REFERENCES insurance_benefits(id)
);

-- BẢNG invoices
CREATE TABLE invoices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  contract_id INT UNIQUE,
  base_amount DECIMAL(10,2),
  tax_rate DECIMAL(5,4) DEFAULT 0.1,
  payment_method VARCHAR(100),
  payment_code VARCHAR(100),
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (contract_id) REFERENCES contract(contract_id)
);

-- BẢNG claims
CREATE TABLE claims (
  id INT AUTO_INCREMENT PRIMARY KEY,
  contract_id INT,
  requestDate DATE,
  claim_type VARCHAR(255),
  description TEXT,
  payment_bank VARCHAR(255),
  payment_number VARCHAR(255),
  related_img VARCHAR(255),
  related_file VARCHAR(255),
  claim_status VARCHAR(255),
  FOREIGN KEY (contract_id) REFERENCES contract(contract_id)
);

-- BẢNG claimsRes
CREATE TABLE claimsRes (
  claimRes_id INT AUTO_INCREMENT PRIMARY KEY,
  claim_id INT,
  createDate DATE,
  description TEXT,
  related_img VARCHAR(255),
  related_file VARCHAR(255),
  status VARCHAR(255),
  FOREIGN KEY (claim_id) REFERENCES claims(id)
);

-- STORED PROCEDURE TẠO DỮ LIỆU RANDOM
DELIMITER $$

CREATE PROCEDURE seed_all()
BEGIN
  DECLARE i INT DEFAULT 1;

  -- USERS
  WHILE i <= 100 DO
    INSERT INTO users(username,password,fullname,mail,dob,address,phone,cccd,avatar,role,cccd_img,status)
    VALUES (
      CONCAT('user', i),
      '123456',
      CONCAT('Nguyen Van ', i),
      CONCAT('user', i, '@mail.com'),
      DATE_ADD('1980-01-01', INTERVAL FLOOR(RAND()*15000) DAY),
      CONCAT('Address ', i),
      CONCAT('09', LPAD(FLOOR(RAND()*100000000),8,'0')),
      CONCAT('0', LPAD(FLOOR(RAND()*1000000000),9,'0')),
      'default.png',
      ELT(FLOOR(1 + RAND()*3), 'customer','staff','admin'),
      'cccd.png',
      'active'
    );
    SET i = i + 1;
  END WHILE;

  SET i = 1;
  -- BENEFITS
  WHILE i <= 100 DO
    INSERT INTO insurance_benefits(
      death_or_permanent_disability,
      death_due_to_illness,
      third_party_liability,
      lost_bank_card,
      kidnap_and_hostage,
      lost_or_damaged_golf_equipment,
      medical_cost,
      emergency_transport,
      repatriation_vn,
      repatriation_abroad,
      hospital_visit,
      funeral_arrangement,
      child_care,
      hospital_allowance,
      accident_death_injury,
      trip_cancellation,
      companion_support,
      delayed_baggage,
      travel_documents,
      trip_delay,
      is_deleted
    ) VALUES (
      RAND()*500000000,
      RAND()*300000000,
      RAND()*200000000,
      RAND()*5000000,
      RAND()*10000000,
      RAND()*8000000,
      RAND()*100000000,
      RAND()*150000000,
      RAND()*50000000,
      RAND()*70000000,
      RAND()*20000000,
      RAND()*15000000,
      RAND()*5000000,
      RAND()*8000000,
      RAND()*25000000,
      RAND()*5000000,
      RAND()*7000000,
      RAND()*4000000,
      RAND()*3000000,
      RAND()*1000000,
      0
    );
    SET i = i + 1;
  END WHILE;

  SET i = 1;
  -- PRODUCTS
  WHILE i <= 100 DO
    INSERT INTO products(benefit_id,type,name,img,description,package,price,domestic_percentage_rate,
      international_rate_1_7,international_rate_8_30,international_rate_31_90,international_rate_91_180)
    VALUES(
      FLOOR(1 + RAND()*100),
      ELT(FLOOR(1 + RAND()*2), 'domestic','international'),
      CONCAT('Gói bảo hiểm số ', i),
      'upload_imgs/default.png',
      CONCAT('Mô tả sản phẩm số ', i),
      ELT(FLOOR(1 + RAND()*4), 'basic','standard','advanced','comprehensive'),
      ROUND(RAND()*10000000,2),
      RAND(),
      ROUND(RAND()*1000000,2),
      ROUND(RAND()*2000000,2),
      ROUND(RAND()*3000000,2),
      ROUND(RAND()*5000000,2)
    );
    SET i = i + 1;
  END WHILE;

  SET i = 1;
  -- APPLICATIONS
  WHILE i <= 100 DO
    INSERT INTO applications(purchaser_id,product_id,type,destination,startDate,endDate,travelers_quantity,total_price)
    VALUES(
      FLOOR(1 + RAND()*100),
      FLOOR(1 + RAND()*100),
      ELT(FLOOR(1 + RAND()*2), 'domestic','international'),
      CONCAT('Địa điểm ', i),
      DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*300) DAY),
      DATE_ADD('2024-12-01', INTERVAL FLOOR(RAND()*300) DAY),
      FLOOR(1 + RAND()*5),
      ROUND(RAND()*10000000,2)
    );
    SET i = i + 1;
  END WHILE;

  SET i = 1;
  -- APPLICATION_TRAVELER
  WHILE i <= 100 DO
    INSERT INTO application_traveler(application_id,name,gender,cccd_id,dob,age,phone,email)
    VALUES(
      FLOOR(1 + RAND()*100),
      CONCAT('Traveler ', i),
      ELT(FLOOR(1 + RAND()*2), 'male','female'),
      FLOOR(RAND()*999999999999),
      DATE_ADD('1970-01-01', INTERVAL FLOOR(RAND()*20000) DAY),
      FLOOR(10 + RAND()*60),
      CONCAT('09', LPAD(FLOOR(RAND()*100000000),8,'0')),
      CONCAT('traveler', i, '@mail.com')
    );
    SET i = i + 1;
  END WHILE;

  SET i = 1;
  -- CONTRACT
  WHILE i <= 100 DO
    INSERT INTO contract(current_benefit_id,application_id,description,contract_status)
    VALUES(
      FLOOR(1 + RAND()*100),
      i,
      CONCAT('Hợp đồng số ', i),
      ELT(FLOOR(1 + RAND()*3), 'pending','active','expired')
    );
    SET i = i + 1;
  END WHILE;

  SET i = 1;
  -- INVOICES
  WHILE i <= 100 DO
    INSERT INTO invoices(contract_id,base_amount,payment_method,payment_code,notes)
    VALUES(
      i,
      ROUND(RAND()*10000000,2),
      ELT(FLOOR(1 + RAND()*3), 'credit_card','bank_transfer','cash'),
      CONCAT('PM', LPAD(i,5,'0')),
      'Auto-generated'
    );
    SET i = i + 1;
  END WHILE;

  SET i = 1;
  -- CLAIMS
  WHILE i <= 100 DO
    INSERT INTO claims(contract_id,requestDate,claim_type,description,payment_bank,payment_number,related_img,related_file,claim_status)
    VALUES(
      FLOOR(1 + RAND()*100),
      DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*300) DAY),
      CONCAT('Loại yêu cầu ', i),
      CONCAT('Yêu cầu bồi thường số ', i),
      'VCB',
      CONCAT('AC', LPAD(i,6,'0')),
      'img.png',
      'file.pdf',
      ELT(FLOOR(1 + RAND()*3), 'pending','approved','rejected')
    );
    SET i = i + 1;
  END WHILE;

  SET i = 1;
  -- CLAIMS RES
  WHILE i <= 100 DO
    INSERT INTO claimsRes(claim_id,createDate,description,related_img,related_file,status)
    VALUES(
      FLOOR(1 + RAND()*100),
      DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*300) DAY),
      CONCAT('Phản hồi số ', i),
      'img.png',
      'file.pdf',
      ELT(FLOOR(1 + RAND()*3), 'pending','reviewed','closed')
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

-- GỌI HÀM SINH DỮ LIỆU
CALL seed_all();
