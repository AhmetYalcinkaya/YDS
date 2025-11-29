-- Add is_favorite column to user_progress table
ALTER TABLE user_progress
ADD COLUMN IF NOT EXISTS is_favorite BOOLEAN DEFAULT FALSE;

-- Add is_favorite column to user_words table
ALTER TABLE user_words
ADD COLUMN IF NOT EXISTS is_favorite BOOLEAN DEFAULT FALSE;

-- Add index for faster favorite queries
CREATE INDEX IF NOT EXISTS idx_user_progress_favorite ON user_progress(user_id, is_favorite);
CREATE INDEX IF NOT EXISTS idx_user_words_favorite ON user_words(user_id, is_favorite);
