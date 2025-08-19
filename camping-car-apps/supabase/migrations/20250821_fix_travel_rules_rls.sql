-- Fix travel_rules RLS issue in production
-- Date: 2025-08-14
-- Purpose: Re-enable RLS and recreate policies for travel_rules tables

-- RLSの再有効化
ALTER TABLE travel_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE trip_rule_confirmations ENABLE ROW LEVEL SECURITY;

-- ポリシーの再作成
DROP POLICY IF EXISTS "All users can read travel rules" ON travel_rules;
CREATE POLICY "All users can read travel rules" ON travel_rules
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can manage their own rule confirmations" ON trip_rule_confirmations;
CREATE POLICY "Users can manage their own rule confirmations" ON trip_rule_confirmations
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM trips 
            WHERE trips.id = trip_rule_confirmations.trip_id 
            AND trips.user_id = auth.uid()
        )
    );