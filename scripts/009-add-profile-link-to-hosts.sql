-- Add profile_id and avatar_url columns to hosts table
-- This allows linking hosts to user profiles and storing photos

-- Add profile_id column to link hosts to profiles
ALTER TABLE hosts ADD COLUMN IF NOT EXISTS profile_id UUID REFERENCES profiles(id) ON DELETE SET NULL;

-- Add avatar_url column for host photos
ALTER TABLE hosts ADD COLUMN IF NOT EXISTS avatar_url TEXT;

-- Create index for faster profile lookups
CREATE INDEX IF NOT EXISTS idx_hosts_profile_id ON hosts(profile_id);

-- Create unique constraint to ensure one host per profile
CREATE UNIQUE INDEX IF NOT EXISTS idx_hosts_profile_id_unique ON hosts(profile_id) WHERE profile_id IS NOT NULL;
