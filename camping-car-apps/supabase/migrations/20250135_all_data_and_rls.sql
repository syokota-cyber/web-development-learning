-- メイン目的データ挿入
INSERT INTO main_purposes (name, display_order) VALUES
  ('観光', 1),
  ('SUP・カヤック', 2),
  ('サイクリング', 3),
  ('スキー・スノーボード', 4),
  ('登山・ハイキング', 5);

-- 続きのメイン目的
INSERT INTO main_purposes (name, display_order) VALUES
  ('フルーツ狩り', 6),
  ('夜景撮影', 7),
  ('天体観測', 8),
  ('日の出・夕陽撮影', 9),
  ('海水浴・シュノーケリング', 10);

-- さらに続きのメイン目的
INSERT INTO main_purposes (name, display_order) VALUES
  ('潮干狩り', 11),
  ('花見', 12),
  ('紅葉狩り', 13),
  ('野鳥観察', 14),
  ('釣り', 15),
  ('鉄道撮影', 16);

-- サブ目的データ挿入
INSERT INTO sub_purposes (name, display_order) VALUES
  ('温泉', 1),
  ('道の駅', 2),
  ('バーベキュー', 3),
  ('キャンプ場', 4),
  ('RVパーク', 5);

-- 続きのサブ目的
INSERT INTO sub_purposes (name, display_order) VALUES
  ('地元グルメ', 6),
  ('地元特産品店', 7),
  ('展望台', 8),
  ('文化財・史跡訪問', 9),
  ('国立公園', 10),
  ('景勝地', 11);-- SUP・カヤック用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('SUP/カヤック本体', 1),
  ('パドル', 2),
  ('ライフジャケット', 3),
  ('リーシュコード', 4),
  ('防水バッグ', 5)
) AS items(item_name, row_number)
WHERE name = 'SUP・カヤック';

-- サイクリング用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('自転車', 1),
  ('ヘルメット', 2),
  ('グローブ', 3),
  ('空気入れ', 4),
  ('パンク修理キット', 5)
) AS items(item_name, row_number)
WHERE name = 'サイクリング';

-- スキー・スノーボード用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('スキー/ボード本体', 1),
  ('ブーツ', 2),
  ('ウェア上下', 3),
  ('ゴーグル', 4),
  ('グローブ', 5)
) AS items(item_name, row_number)
WHERE name = 'スキー・スノーボード';

-- 登山・ハイキング用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('トレッキングシューズ', 1),
  ('リュック', 2),
  ('雨具', 3),
  ('地図・コンパス', 4),
  ('行動食', 5)
) AS items(item_name, row_number)
WHERE name = '登山・ハイキング';

-- 夜景撮影用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('カメラ', 1),
  ('三脚', 2),
  ('レリーズ', 3),
  ('予備バッテリー', 4),
  ('レンズクリーナー', 5)
) AS items(item_name, row_number)
WHERE name = '夜景撮影';

-- 観光用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('カメラ', 1),
  ('ガイドブック', 2),
  ('歩きやすい靴', 3),
  ('日焼け止め', 4),
  ('帽子', 5)
) AS items(item_name, row_number)
WHERE name = '観光';

-- フルーツ狩り用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('軍手', 1),
  ('カゴ・容器', 2),
  ('ウェットティッシュ', 3),
  ('クーラーボックス', 4),
  ('エプロン', 5)
) AS items(item_name, row_number)
WHERE name = 'フルーツ狩り';

-- 天体観測用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('双眼鏡/望遠鏡', 1),
  ('星座早見盤', 2),
  ('赤色ライト', 3),
  ('レジャーシート', 4),
  ('防寒着', 5)
) AS items(item_name, row_number)
WHERE name = '天体観測';

-- 日の出・夕陽撮影用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('カメラ', 1),
  ('三脚', 2),
  ('NDフィルター', 3),
  ('予備バッテリー', 4),
  ('防寒着', 5)
) AS items(item_name, row_number)
WHERE name = '日の出・夕陽撮影';

-- 海水浴・シュノーケリング用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('水着', 1),
  ('シュノーケルセット', 2),
  ('マリンシューズ', 3),
  ('日焼け止め', 4),
  ('ビーチタオル', 5)
) AS items(item_name, row_number)
WHERE name = '海水浴・シュノーケリング';

-- 潮干狩り用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('熊手', 1),
  ('バケツ', 2),
  ('軍手', 3),
  ('長靴', 4),
  ('クーラーボックス', 5)
) AS items(item_name, row_number)
WHERE name = '潮干狩り';

-- 花見用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('レジャーシート', 1),
  ('お弁当・飲み物', 2),
  ('ゴミ袋', 3),
  ('ウェットティッシュ', 4),
  ('防寒着', 5)
) AS items(item_name, row_number)
WHERE name = '花見';

-- 紅葉狩り用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('カメラ', 1),
  ('歩きやすい靴', 2),
  ('防寒着', 3),
  ('雨具', 4),
  ('地図', 5)
) AS items(item_name, row_number)
WHERE name = '紅葉狩り';

-- 野鳥観察用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('双眼鏡', 1),
  ('野鳥図鑑', 2),
  ('メモ帳・筆記具', 3),
  ('カメラ（望遠レンズ）', 4),
  ('迷彩服・帽子', 5)
) AS items(item_name, row_number)
WHERE name = '野鳥観察';

-- 釣り用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('釣り竿', 1),
  ('リール', 2),
  ('釣り餌・ルアー', 3),
  ('クーラーボックス', 4),
  ('ライフジャケット', 5)
) AS items(item_name, row_number)
WHERE name = '釣り';

-- 鉄道撮影用品
INSERT INTO default_items (main_purpose_id, name, display_order)
SELECT id, item_name, row_number
FROM main_purposes,
LATERAL (VALUES
  ('カメラ', 1),
  ('望遠レンズ', 2),
  ('三脚', 3),
  ('時刻表', 4),
  ('予備バッテリー', 5)
) AS items(item_name, row_number)
WHERE name = '鉄道撮影';-- Row Level Security (RLS) を有効化
ALTER TABLE purpose_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE main_purposes ENABLE ROW LEVEL SECURITY;
ALTER TABLE sub_purposes ENABLE ROW LEVEL SECURITY;
ALTER TABLE trip_purposes ENABLE ROW LEVEL SECURITY;
ALTER TABLE default_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE trip_checklists ENABLE ROW LEVEL SECURITY;

-- 読み取り専用テーブルのポリシー（全ユーザーが読み取り可能）
CREATE POLICY "Allow public read access" ON purpose_categories
  FOR SELECT USING (true);

CREATE POLICY "Allow public read access" ON main_purposes
  FOR SELECT USING (true);

CREATE POLICY "Allow public read access" ON sub_purposes
  FOR SELECT USING (true);

CREATE POLICY "Allow public read access" ON default_items
  FOR SELECT USING (true);

-- ユーザー固有のデータテーブルのポリシー
-- trip_purposes: 自分の旅行の目的のみアクセス可能
CREATE POLICY "Users can view own trip purposes" ON trip_purposes
  FOR SELECT USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own trip purposes" ON trip_purposes
  FOR INSERT WITH CHECK (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own trip purposes" ON trip_purposes
  FOR UPDATE USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own trip purposes" ON trip_purposes
  FOR DELETE USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

-- trip_checklists: 自分の旅行のチェックリストのみアクセス可能
CREATE POLICY "Users can view own checklists" ON trip_checklists
  FOR SELECT USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own checklists" ON trip_checklists
  FOR INSERT WITH CHECK (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own checklists" ON trip_checklists
  FOR UPDATE USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own checklists" ON trip_checklists
  FOR DELETE USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );