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
