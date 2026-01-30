-- Add training requirement fields to visitor_types table
ALTER TABLE visitor_types 
ADD COLUMN IF NOT EXISTS requires_training BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS training_video_url TEXT,
ADD COLUMN IF NOT EXISTS training_title TEXT DEFAULT 'Safety Training';

-- Update the Contractor visitor type to require training
UPDATE visitor_types 
SET requires_training = true,
    training_video_url = 'https://www.youtube.com/embed/9Yrt9qkBQ2Q',
    training_title = 'Contractor Safety Orientation'
WHERE LOWER(name) = 'contractor';

-- Create a table to track completed training sessions
CREATE TABLE IF NOT EXISTS training_completions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visitor_id UUID NOT NULL REFERENCES visitors(id) ON DELETE CASCADE,
  visitor_type_id UUID NOT NULL REFERENCES visitor_types(id) ON DELETE CASCADE,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_training_completions_visitor ON training_completions(visitor_id);
CREATE INDEX IF NOT EXISTS idx_training_completions_type ON training_completions(visitor_type_id);

-- Enable RLS on training_completions
ALTER TABLE training_completions ENABLE ROW LEVEL SECURITY;

-- Policy for admins
CREATE POLICY "Admins can manage training completions"
ON training_completions FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- Policy for public/kiosk to insert training completions
CREATE POLICY "Kiosk can insert training completions"
ON training_completions FOR INSERT
TO anon
WITH CHECK (true);

-- Policy for public/kiosk to read training completions
CREATE POLICY "Kiosk can read training completions"
ON training_completions FOR SELECT
TO anon
USING (true);
