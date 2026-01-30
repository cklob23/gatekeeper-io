-- Add RLS policy for bookings table to allow public read access for kiosk check-in
-- This allows visitors to look up their bookings by email

-- Enable RLS on bookings if not already enabled
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- Drop existing policy if it exists
DROP POLICY IF EXISTS "Allow public to read bookings by email" ON bookings;

-- Create policy to allow anyone to read bookings (needed for kiosk check-in)
CREATE POLICY "Allow public to read bookings by email" ON bookings
    FOR SELECT
    USING (true);

-- Also ensure INSERT is allowed for the seed script
DROP POLICY IF EXISTS "Allow public to insert bookings" ON bookings;
CREATE POLICY "Allow public to insert bookings" ON bookings
    FOR INSERT
    WITH CHECK (true);

-- Allow updates for checking in
DROP POLICY IF EXISTS "Allow public to update bookings" ON bookings;
CREATE POLICY "Allow public to update bookings" ON bookings
    FOR UPDATE
    USING (true);
