-- テーブル構造確認
SELECT 
    t.table_name,
    c.column_name,
    c.data_type,
    c.is_nullable
FROM information_schema.tables t
LEFT JOIN information_schema.columns c 
    ON t.table_name = c.table_name 
    AND t.table_schema = c.table_schema
WHERE t.table_schema = 'public' 
    AND t.table_name IN ('trips', 'trip_reviews')
ORDER BY t.table_name, c.ordinal_position;

-- trip_reviewsテーブルの存在確認
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'trip_reviews'
) as trip_reviews_exists;

-- tripsテーブルのサンプルデータ確認
SELECT 
    id,
    title,
    status,
    pg_typeof(id) as id_type
FROM trips 
LIMIT 3;