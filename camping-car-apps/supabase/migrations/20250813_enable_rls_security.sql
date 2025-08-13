-- Enable RLS for all public tables to fix security errors
-- Date: 2025-08-13
-- Purpose: Fix Supabase Security Advisor errors

-- 1. Enable RLS on all tables that need it
ALTER TABLE public.purpose_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trip_purposes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.main_purposes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sub_purposes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.default_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trip_checklists ENABLE ROW LEVEL SECURITY;

-- 2. Create policies for read access (allowing all authenticated users to read)
-- Purpose Categories
CREATE POLICY "Allow authenticated users to read purpose_categories" 
ON public.purpose_categories FOR SELECT 
TO authenticated 
USING (true);

CREATE POLICY "Allow anon users to read purpose_categories" 
ON public.purpose_categories FOR SELECT 
TO anon 
USING (true);

-- Trip Purposes
CREATE POLICY "Allow authenticated users to read trip_purposes" 
ON public.trip_purposes FOR SELECT 
TO authenticated 
USING (true);

CREATE POLICY "Allow anon users to read trip_purposes" 
ON public.trip_purposes FOR SELECT 
TO anon 
USING (true);

-- Main Purposes
CREATE POLICY "Allow authenticated users to read main_purposes" 
ON public.main_purposes FOR SELECT 
TO authenticated 
USING (true);

CREATE POLICY "Allow anon users to read main_purposes" 
ON public.main_purposes FOR SELECT 
TO anon 
USING (true);

-- Sub Purposes
CREATE POLICY "Allow authenticated users to read sub_purposes" 
ON public.sub_purposes FOR SELECT 
TO authenticated 
USING (true);

CREATE POLICY "Allow anon users to read sub_purposes" 
ON public.sub_purposes FOR SELECT 
TO anon 
USING (true);

-- Default Items
CREATE POLICY "Allow authenticated users to read default_items" 
ON public.default_items FOR SELECT 
TO authenticated 
USING (true);

CREATE POLICY "Allow anon users to read default_items" 
ON public.default_items FOR SELECT 
TO anon 
USING (true);

-- Trip Checklists (trip-based access, trips table has user_id)
CREATE POLICY "Users can read own trip_checklists" 
ON public.trip_checklists FOR SELECT 
TO authenticated 
USING (
  EXISTS (
    SELECT 1 FROM public.trips 
    WHERE trips.id = trip_checklists.trip_id 
    AND trips.user_id = auth.uid()
  )
);

CREATE POLICY "Users can insert own trip_checklists" 
ON public.trip_checklists FOR INSERT 
TO authenticated 
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.trips 
    WHERE trips.id = trip_checklists.trip_id 
    AND trips.user_id = auth.uid()
  )
);

CREATE POLICY "Users can update own trip_checklists" 
ON public.trip_checklists FOR UPDATE 
TO authenticated 
USING (
  EXISTS (
    SELECT 1 FROM public.trips 
    WHERE trips.id = trip_checklists.trip_id 
    AND trips.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.trips 
    WHERE trips.id = trip_checklists.trip_id 
    AND trips.user_id = auth.uid()
  )
);

CREATE POLICY "Users can delete own trip_checklists" 
ON public.trip_checklists FOR DELETE 
TO authenticated 
USING (
  EXISTS (
    SELECT 1 FROM public.trips 
    WHERE trips.id = trip_checklists.trip_id 
    AND trips.user_id = auth.uid()
  )
);