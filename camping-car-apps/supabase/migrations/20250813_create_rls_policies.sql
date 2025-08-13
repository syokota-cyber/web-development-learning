-- Create RLS policies for tables with RLS enabled
-- Date: 2025-08-13
-- Purpose: Add policies after RLS has been enabled

-- Drop existing policies if they exist and recreate them
-- Purpose Categories - Allow all users to read
DROP POLICY IF EXISTS "Allow all to read purpose_categories" ON public.purpose_categories;
CREATE POLICY "Allow all to read purpose_categories" 
ON public.purpose_categories FOR SELECT 
USING (true);

-- Trip Purposes - Allow all users to read
DROP POLICY IF EXISTS "Allow all to read trip_purposes" ON public.trip_purposes;
CREATE POLICY "Allow all to read trip_purposes" 
ON public.trip_purposes FOR SELECT 
USING (true);

-- Main Purposes - Allow all users to read
DROP POLICY IF EXISTS "Allow all to read main_purposes" ON public.main_purposes;
CREATE POLICY "Allow all to read main_purposes" 
ON public.main_purposes FOR SELECT 
USING (true);

-- Sub Purposes - Allow all users to read  
DROP POLICY IF EXISTS "Allow all to read sub_purposes" ON public.sub_purposes;
CREATE POLICY "Allow all to read sub_purposes" 
ON public.sub_purposes FOR SELECT 
USING (true);

-- Default Items - Allow all users to read
DROP POLICY IF EXISTS "Allow all to read default_items" ON public.default_items;
CREATE POLICY "Allow all to read default_items" 
ON public.default_items FOR SELECT 
USING (true);

-- Trip Checklists - Users can manage their own trip checklists
DROP POLICY IF EXISTS "Users can read own trip_checklists" ON public.trip_checklists;
CREATE POLICY "Users can read own trip_checklists" 
ON public.trip_checklists FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM public.trips 
    WHERE trips.id = trip_checklists.trip_id 
    AND trips.user_id = auth.uid()
  )
);

DROP POLICY IF EXISTS "Users can insert own trip_checklists" ON public.trip_checklists;
CREATE POLICY "Users can insert own trip_checklists" 
ON public.trip_checklists FOR INSERT 
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.trips 
    WHERE trips.id = trip_checklists.trip_id 
    AND trips.user_id = auth.uid()
  )
);

DROP POLICY IF EXISTS "Users can update own trip_checklists" ON public.trip_checklists;
CREATE POLICY "Users can update own trip_checklists" 
ON public.trip_checklists FOR UPDATE 
USING (
  EXISTS (
    SELECT 1 FROM public.trips 
    WHERE trips.id = trip_checklists.trip_id 
    AND trips.user_id = auth.uid()
  )
);

DROP POLICY IF EXISTS "Users can delete own trip_checklists" ON public.trip_checklists;
CREATE POLICY "Users can delete own trip_checklists" 
ON public.trip_checklists FOR DELETE 
USING (
  EXISTS (
    SELECT 1 FROM public.trips 
    WHERE trips.id = trip_checklists.trip_id 
    AND trips.user_id = auth.uid()
  )
);