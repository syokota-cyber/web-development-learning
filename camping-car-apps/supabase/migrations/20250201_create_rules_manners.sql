-- ルール・マナーテーブルの作成
CREATE TABLE travel_rules (
    id BIGSERIAL PRIMARY KEY,
    main_purpose_id UUID REFERENCES main_purposes(id) ON DELETE CASCADE,
    rule_category VARCHAR(50) NOT NULL, -- 'general', 'specific'
    rule_title VARCHAR(100) NOT NULL,
    rule_description TEXT NOT NULL,
    is_required BOOLEAN DEFAULT true, -- 必須確認項目かどうか
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- インデックス作成
CREATE INDEX idx_travel_rules_main_purpose_id ON travel_rules(main_purpose_id);
CREATE INDEX idx_travel_rules_category ON travel_rules(rule_category);
CREATE INDEX idx_travel_rules_display_order ON travel_rules(display_order);

-- RLS有効化
ALTER TABLE travel_rules ENABLE ROW LEVEL SECURITY;

-- 全てのユーザーが読み取り可能（ルールは共通データ）
CREATE POLICY "All users can read travel rules" ON travel_rules
    FOR SELECT USING (true);

-- ルール確認状況を記録するテーブル
CREATE TABLE trip_rule_confirmations (
    id BIGSERIAL PRIMARY KEY,
    trip_id UUID REFERENCES trips(id) ON DELETE CASCADE,
    rule_id BIGINT REFERENCES travel_rules(id) ON DELETE CASCADE,
    is_confirmed BOOLEAN DEFAULT false,
    confirmed_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(trip_id, rule_id)
);

-- インデックス作成
CREATE INDEX idx_trip_rule_confirmations_trip_id ON trip_rule_confirmations(trip_id);
CREATE INDEX idx_trip_rule_confirmations_rule_id ON trip_rule_confirmations(rule_id);

-- RLS有効化
ALTER TABLE trip_rule_confirmations ENABLE ROW LEVEL SECURITY;

-- ユーザーは自分の旅行のルール確認状況のみアクセス可能
CREATE POLICY "Users can manage their own rule confirmations" ON trip_rule_confirmations
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM trips 
            WHERE trips.id = trip_rule_confirmations.trip_id 
            AND trips.user_id = auth.uid()
        )
    );

-- トリガー関数：updated_atの自動更新
CREATE OR REPLACE FUNCTION update_travel_rules_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- トリガー作成
CREATE TRIGGER trigger_update_travel_rules_updated_at
    BEFORE UPDATE ON travel_rules
    FOR EACH ROW
    EXECUTE FUNCTION update_travel_rules_updated_at();