-- trip_reviewsテーブルの作成（本番環境準拠）
CREATE TABLE IF NOT EXISTS trip_reviews (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    trip_id UUID REFERENCES trips(id) ON DELETE CASCADE,
    achieved_main_purposes TEXT[] DEFAULT '{}',
    achieved_sub_purposes TEXT[] DEFAULT '{}',
    used_items TEXT[] DEFAULT '{}',
    review_date TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(trip_id)
);

-- RLS (Row Level Security) の有効化
ALTER TABLE trip_reviews ENABLE ROW LEVEL SECURITY;

-- 既存のポリシーを削除してから作成
DROP POLICY IF EXISTS "Users can manage their own trip reviews" ON trip_reviews;
CREATE POLICY "Users can manage their own trip reviews" ON trip_reviews
    FOR ALL USING (
        trip_id IN (
            SELECT id FROM trips WHERE user_id = auth.uid()
        )
    );

-- インデックスの作成
CREATE INDEX IF NOT EXISTS idx_trip_reviews_trip_id ON trip_reviews(trip_id);
CREATE INDEX IF NOT EXISTS idx_trip_reviews_review_date ON trip_reviews(review_date);

-- トリガー関数：updated_atの自動更新
CREATE OR REPLACE FUNCTION update_trip_reviews_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- トリガーの作成（既存の場合は削除してから作成）
DROP TRIGGER IF EXISTS trigger_update_trip_reviews_updated_at ON trip_reviews;
CREATE TRIGGER trigger_update_trip_reviews_updated_at
    BEFORE UPDATE ON trip_reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_trip_reviews_updated_at();

-- コメント追加
COMMENT ON COLUMN trip_reviews.achieved_main_purposes IS 'Achieved main purpose IDs (supports both numeric and string IDs)';
COMMENT ON COLUMN trip_reviews.achieved_sub_purposes IS 'Achieved sub purpose IDs (supports both numeric and custom string IDs like custom_name_XXX)';
COMMENT ON COLUMN trip_reviews.used_items IS 'Used item IDs (supports both numeric and string IDs)';