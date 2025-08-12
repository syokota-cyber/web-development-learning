-- trip_reviewsテーブルのtrip_idをUUIDに修正
-- 現在の問題: trip_reviews.trip_id (BIGINT) vs trips.id (UUID)

-- 1. 既存のtrip_reviewsテーブルを確認
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'trip_reviews' AND column_name = 'trip_id';

-- 2. tripsテーブルのidカラムを確認
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'trips' AND column_name = 'id';

-- 3. 外部キー制約を削除
ALTER TABLE trip_reviews DROP CONSTRAINT IF EXISTS trip_reviews_trip_id_fkey;

-- 4. trip_idカラムのデータ型をUUIDに変更
ALTER TABLE trip_reviews ALTER COLUMN trip_id TYPE UUID USING trip_id::text::uuid;

-- 5. 外部キー制約を再作成
ALTER TABLE trip_reviews ADD CONSTRAINT trip_reviews_trip_id_fkey 
    FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE;

-- 6. 修正結果を確認
SELECT 
    'trip_reviews修正完了' as status,
    (SELECT data_type FROM information_schema.columns 
     WHERE table_name = 'trip_reviews' AND column_name = 'trip_id') as trip_reviews_trip_id_type,
    (SELECT data_type FROM information_schema.columns 
     WHERE table_name = 'trips' AND column_name = 'id') as trips_id_type;