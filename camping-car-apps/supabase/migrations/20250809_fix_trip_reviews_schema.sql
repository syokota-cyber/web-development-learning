-- 2025年8月9日: trip_reviewsテーブルのカスタムスポットID対応修正
-- カスタムスポットIDが文字列形式のため、INTEGER[]からTEXT[]に変更

-- achieved_sub_purposesカラムをTEXT[]に変更
ALTER TABLE trip_reviews 
ALTER COLUMN achieved_sub_purposes TYPE TEXT[] USING array_to_string(achieved_sub_purposes, ',')::TEXT[];

-- achieved_main_purposesとused_itemsも将来の拡張性を考慮してTEXT[]に変更
ALTER TABLE trip_reviews 
ALTER COLUMN achieved_main_purposes TYPE TEXT[] USING array_to_string(achieved_main_purposes, ',')::TEXT[];

ALTER TABLE trip_reviews 
ALTER COLUMN used_items TYPE TEXT[] USING array_to_string(used_items, ',')::TEXT[];

-- コメント追加
COMMENT ON COLUMN trip_reviews.achieved_main_purposes IS 'Achieved main purpose IDs (supports both numeric and string IDs)';
COMMENT ON COLUMN trip_reviews.achieved_sub_purposes IS 'Achieved sub purpose IDs (supports both numeric and custom string IDs like custom_name_XXX)';
COMMENT ON COLUMN trip_reviews.used_items IS 'Used item IDs (supports both numeric and string IDs)';
