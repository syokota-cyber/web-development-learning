-- ========================================
-- i18n対応: 英語カラム追加Migration（簡略版）
-- 作成日: 2025-10-07
-- 対象: マスターデータテーブル
-- ========================================

-- 1. main_purposes テーブルに英語カラム追加
ALTER TABLE main_purposes
  ADD COLUMN IF NOT EXISTS name_en TEXT;

COMMENT ON COLUMN main_purposes.name_en IS 'メイン目的の英語名';

-- 2. sub_purposes テーブルに英語カラム追加
ALTER TABLE sub_purposes
  ADD COLUMN IF NOT EXISTS name_en TEXT;

COMMENT ON COLUMN sub_purposes.name_en IS 'サブ目的の英語名';

-- 3. default_items テーブルに英語カラム追加
ALTER TABLE default_items
  ADD COLUMN IF NOT EXISTS name_en TEXT;

COMMENT ON COLUMN default_items.name_en IS '持ち物の英語名';

-- 4. travel_rules テーブルに英語カラム追加
ALTER TABLE travel_rules
  ADD COLUMN IF NOT EXISTS rule_title_en TEXT,
  ADD COLUMN IF NOT EXISTS rule_description_en TEXT;

COMMENT ON COLUMN travel_rules.rule_title_en IS 'ルールタイトルの英語版';
COMMENT ON COLUMN travel_rules.rule_description_en IS 'ルール説明の英語版';
