-- SUP・カヤック用品
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
WHERE name = '鉄道撮影';