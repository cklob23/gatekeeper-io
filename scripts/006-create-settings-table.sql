-- Create settings table for system-wide configuration
CREATE TABLE IF NOT EXISTS settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT UNIQUE NOT NULL,
  value JSONB NOT NULL,
  location_id UUID REFERENCES locations(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to read settings
CREATE POLICY "settings_read_authenticated" ON settings
  FOR SELECT TO authenticated USING (true);

-- Allow anon users to read settings (for kiosk)
CREATE POLICY "settings_read_anon" ON settings
  FOR SELECT TO anon USING (true);

-- Allow admins to manage settings
CREATE POLICY "settings_admin_manage" ON settings
  FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Insert default settings
INSERT INTO settings (key, value) VALUES
  ('auto_sign_out', 'true'),
  ('host_notifications', 'true'),
  ('badge_printing', 'false'),
  ('distance_unit_miles', 'false')
ON CONFLICT (key) DO NOTHING;
