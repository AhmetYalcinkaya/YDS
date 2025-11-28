-- Add category and difficulty_level columns to words and user_words tables

-- 1. Add columns to words table
ALTER TABLE words 
ADD COLUMN IF NOT EXISTS category VARCHAR(50) DEFAULT 'noun',
ADD COLUMN IF NOT EXISTS difficulty_level VARCHAR(5) DEFAULT 'B1';

-- 2. Add columns to user_words table  
ALTER TABLE user_words 
ADD COLUMN IF NOT EXISTS category VARCHAR(50) DEFAULT 'noun',
ADD COLUMN IF NOT EXISTS difficulty_level VARCHAR(5) DEFAULT 'B1';

-- 3. Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_words_category ON words(category);
CREATE INDEX IF NOT EXISTS idx_words_difficulty ON words(difficulty_level);
CREATE INDEX IF NOT EXISTS idx_user_words_category ON user_words(category);
CREATE INDEX IF NOT EXISTS idx_user_words_difficulty ON user_words(difficulty_level);

-- 4. Optional: Update existing words with sample categories and difficulties
-- This is just an example, you can customize based on your data
UPDATE words 
SET 
  category = CASE part_of_speech
    WHEN 'noun' THEN 'noun'
    WHEN 'verb' THEN 'verb'
    WHEN 'adjective' THEN 'adjective'
    WHEN 'adverb' THEN 'adverb'
    ELSE 'other'
  END,
  difficulty_level = 'B1'  -- Default all to B1, can be updated manually later
WHERE category IS NULL OR difficulty_level IS NULL;
