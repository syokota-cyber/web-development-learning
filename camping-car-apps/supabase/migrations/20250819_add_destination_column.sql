-- Add destination column to trips table
ALTER TABLE trips 
ADD COLUMN IF NOT EXISTS destination TEXT;

-- Update existing trips with a default value (optional)
-- UPDATE trips SET destination = '未設定' WHERE destination IS NULL;