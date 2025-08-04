-- trip_reviewsテーブルの作成
CREATE TABLE trip_reviews (
    id BIGSERIAL PRIMARY KEY,
    trip_id BIGINT REFERENCES trips(id) ON DELETE CASCADE,
    achieved_main_purposes INTEGER[] DEFAULT '{}',
    achieved_sub_purposes INTEGER[] DEFAULT '{}',
    used_items INTEGER[] DEFAULT '{}',
    review_date TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(trip_id)
);

-- RLS (Row Level Security) の有効化
ALTER TABLE trip_reviews ENABLE ROW LEVEL SECURITY;

-- ポリシーの作成（ユーザーは自分の旅行のレビューのみアクセス可能）
CREATE POLICY "Users can manage their own trip reviews" ON trip_reviews
    FOR ALL USING (
        trip_id IN (
            SELECT id FROM trips WHERE user_id = auth.uid()
        )
    );

-- インデックスの作成
CREATE INDEX idx_trip_reviews_trip_id ON trip_reviews(trip_id);
CREATE INDEX idx_trip_reviews_review_date ON trip_reviews(review_date);

-- トリガー関数：updated_atの自動更新
CREATE OR REPLACE FUNCTION update_trip_reviews_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- トリガーの作成
CREATE TRIGGER trigger_update_trip_reviews_updated_at
    BEFORE UPDATE ON trip_reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_trip_reviews_updated_at();