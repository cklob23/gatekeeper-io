-- Add geolocation columns to locations table
ALTER TABLE locations ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 8);
ALTER TABLE locations ADD COLUMN IF NOT EXISTS longitude DECIMAL(11, 8);
ALTER TABLE locations ADD COLUMN IF NOT EXISTS auto_signin_radius_meters INTEGER DEFAULT 100;

-- Create employee_sign_ins table for tracking employee attendance
CREATE TABLE IF NOT EXISTS employee_sign_ins (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  location_id UUID NOT NULL REFERENCES locations(id) ON DELETE CASCADE,
  sign_in_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  sign_out_time TIMESTAMPTZ,
  auto_signed_in BOOLEAN DEFAULT FALSE,
  device_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_employee_sign_ins_profile ON employee_sign_ins(profile_id);
CREATE INDEX IF NOT EXISTS idx_employee_sign_ins_location ON employee_sign_ins(location_id);
CREATE INDEX IF NOT EXISTS idx_employee_sign_ins_active ON employee_sign_ins(profile_id, sign_out_time) WHERE sign_out_time IS NULL;

-- Enable RLS on employee_sign_ins
ALTER TABLE employee_sign_ins ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "employee_signins_read_anon" ON employee_sign_ins;
DROP POLICY IF EXISTS "employee_signins_insert_anon" ON employee_sign_ins;
DROP POLICY IF EXISTS "employee_signins_update_anon" ON employee_sign_ins;
DROP POLICY IF EXISTS "employee_signins_admin" ON employee_sign_ins;

-- Policies for employee_sign_ins
CREATE POLICY "employee_signins_read_anon" ON employee_sign_ins
  FOR SELECT TO anon USING (true);

CREATE POLICY "employee_signins_insert_anon" ON employee_sign_ins
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "employee_signins_update_anon" ON employee_sign_ins
  FOR UPDATE TO anon USING (true);

CREATE POLICY "employee_signins_read_auth" ON employee_sign_ins
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "employee_signins_insert_auth" ON employee_sign_ins
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "employee_signins_update_auth" ON employee_sign_ins
  FOR UPDATE TO authenticated USING (true);

-- Update sample location with coordinates (example: TalusAg HQ - San Francisco)
UPDATE locations 
SET latitude = 37.7749, longitude = -122.4194, auto_signin_radius_meters = 150
WHERE name = 'Main Office';

-- Note: To create an employee account, use Supabase Auth to create a user first,
-- then update their profile role to 'employee' using:
-- UPDATE profiles SET role = 'employee' WHERE email = 'employee@talusag.com';
