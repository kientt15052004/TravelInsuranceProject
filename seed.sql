-- =====================================
-- RESET + SEED DATABASE insuranceSystem
-- =====================================

-- 1️⃣ Xóa database cũ nếu có
DROP DATABASE IF EXISTS insuranceSystem;

-- 2️⃣ Tạo database mới
CREATE DATABASE insuranceSystem CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 3️⃣ Sử dụng database này
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
-- CHÈN DỮ LIỆU THỰC TẾ (seed data)
-- =====================================

-- Dán toàn bộ script seed từ phần trước vào đây:
-- (bắt đầu từ dòng "SET @old_foreign_key_checks = @@FOREIGN_KEY_CHECKS;" 
-- đến hết phần UNION ALL SELECT kiểm tra)

-- 👉 Dán toàn bộ phần seed code ở đây 👈
