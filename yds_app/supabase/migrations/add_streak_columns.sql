-- Add streak tracking columns to users table
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS last_study_date DATE,
ADD COLUMN IF NOT EXISTS streak INTEGER DEFAULT 0;

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_users_last_study_date ON users(last_study_date);
