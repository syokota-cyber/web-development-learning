-- ========================================
-- i18n対応: 英語データ投入Migration
-- 作成日: 2025-10-07
-- 対象: マスターデータテーブル
-- 方式: name列をキーにした更新（UUIDに依存しない）
-- ========================================

-- ========================================
-- 1. main_purposes 英語データ更新
-- ========================================
UPDATE main_purposes SET name_en = 'Sightseeing' WHERE name = '観光';
UPDATE main_purposes SET name_en = 'SUP & Kayaking' WHERE name = 'SUP・カヤック';
UPDATE main_purposes SET name_en = 'Cycling' WHERE name = 'サイクリング';
UPDATE main_purposes SET name_en = 'Skiing & Snowboarding' WHERE name = 'スキー・スノーボード';
UPDATE main_purposes SET name_en = 'Hiking & Trekking' WHERE name = '登山・ハイキング';
UPDATE main_purposes SET name_en = 'Fruit Picking' WHERE name = 'フルーツ狩り';
UPDATE main_purposes SET name_en = 'Night View Photography' WHERE name = '夜景撮影';
UPDATE main_purposes SET name_en = 'Stargazing' WHERE name = '天体観測';
UPDATE main_purposes SET name_en = 'Sunrise & Sunset Photography' WHERE name = '日の出・夕陽撮影';
UPDATE main_purposes SET name_en = 'Beach & Snorkeling' WHERE name = '海水浴・シュノーケリング';
UPDATE main_purposes SET name_en = 'Clam Digging' WHERE name = '潮干狩り';
UPDATE main_purposes SET name_en = 'Cherry Blossom Viewing' WHERE name = '花見';
UPDATE main_purposes SET name_en = 'Autumn Leaves Viewing' WHERE name = '紅葉狩り';
UPDATE main_purposes SET name_en = 'Bird Watching' WHERE name = '野鳥観察';
UPDATE main_purposes SET name_en = 'Fishing' WHERE name = '釣り';
UPDATE main_purposes SET name_en = 'Railway Photography' WHERE name = '鉄道撮影';
UPDATE main_purposes SET name_en = 'Family Trip' WHERE name = '家族サービス';
UPDATE main_purposes SET name_en = 'Pet-Friendly Travel' WHERE name = 'ペット連れ旅';
UPDATE main_purposes SET name_en = 'Other' WHERE name = 'その他';

-- ========================================
-- 2. sub_purposes 英語データ更新
-- ========================================
UPDATE sub_purposes SET name_en = 'Hot Springs' WHERE name = '温泉';
UPDATE sub_purposes SET name_en = 'Roadside Station' WHERE name = '道の駅';
UPDATE sub_purposes SET name_en = 'BBQ' WHERE name = 'バーベキュー';
UPDATE sub_purposes SET name_en = 'Campground' WHERE name = 'キャンプ場';
UPDATE sub_purposes SET name_en = 'RV Park' WHERE name = 'RVパーク';
UPDATE sub_purposes SET name_en = 'Local Gourmet' WHERE name = '地元グルメ';
UPDATE sub_purposes SET name_en = 'Local Specialty Shop' WHERE name = '地元特産品店';
UPDATE sub_purposes SET name_en = 'Observatory' WHERE name = '展望台';
UPDATE sub_purposes SET name_en = 'Cultural Heritage & Historic Sites' WHERE name = '文化財・史跡訪問';
UPDATE sub_purposes SET name_en = 'National Park' WHERE name = '国立公園';
UPDATE sub_purposes SET name_en = 'Scenic Spot' WHERE name = '景勝地';

-- ========================================
-- 3. default_items 英語データ更新
-- ========================================
UPDATE default_items SET name_en = 'Camera' WHERE name = 'カメラ';
UPDATE default_items SET name_en = 'Bicycle' WHERE name = '自転車';
UPDATE default_items SET name_en = 'Ski/Snowboard' WHERE name = 'スキー/ボード本体';
UPDATE default_items SET name_en = 'Trekking Shoes' WHERE name = 'トレッキングシューズ';
UPDATE default_items SET name_en = 'SUP/Kayak' WHERE name = 'SUP/カヤック本体';
UPDATE default_items SET name_en = 'Work Gloves' WHERE name = '軍手';
UPDATE default_items SET name_en = 'Binoculars/Telescope' WHERE name = '双眼鏡/望遠鏡';
UPDATE default_items SET name_en = 'Swimsuit' WHERE name = '水着';
UPDATE default_items SET name_en = 'Rake' WHERE name = '熊手';
UPDATE default_items SET name_en = 'Leisure Sheet' WHERE name = 'レジャーシート';
UPDATE default_items SET name_en = 'Binoculars' WHERE name = '双眼鏡';
UPDATE default_items SET name_en = 'Fishing Rod' WHERE name = '釣り竿';
UPDATE default_items SET name_en = 'Bird Guidebook' WHERE name = '野鳥図鑑';
UPDATE default_items SET name_en = 'Snorkel Set' WHERE name = 'シュノーケルセット';
UPDATE default_items SET name_en = 'Tripod' WHERE name = '三脚';
UPDATE default_items SET name_en = 'Fishing Reel' WHERE name = 'リール';
UPDATE default_items SET name_en = 'Star Chart' WHERE name = '星座早見盤';
UPDATE default_items SET name_en = 'Backpack' WHERE name = 'リュック';
UPDATE default_items SET name_en = 'Helmet' WHERE name = 'ヘルメット';
UPDATE default_items SET name_en = 'Paddle' WHERE name = 'パドル';
UPDATE default_items SET name_en = 'Comfortable Shoes' WHERE name = '歩きやすい靴';
UPDATE default_items SET name_en = 'Guidebook' WHERE name = 'ガイドブック';
UPDATE default_items SET name_en = 'Boots' WHERE name = 'ブーツ';
UPDATE default_items SET name_en = 'Telephoto Lens' WHERE name = '望遠レンズ';
UPDATE default_items SET name_en = 'Lunch & Drinks' WHERE name = 'お弁当・飲み物';
UPDATE default_items SET name_en = 'Bucket' WHERE name = 'バケツ';
UPDATE default_items SET name_en = 'Basket/Container' WHERE name = 'カゴ・容器';
UPDATE default_items SET name_en = 'Notebook & Pen' WHERE name = 'メモ帳・筆記具';
UPDATE default_items SET name_en = 'Rain Gear' WHERE name = '雨具';
UPDATE default_items SET name_en = 'Cable Release' WHERE name = 'レリーズ';
UPDATE default_items SET name_en = 'Wet Wipes' WHERE name = 'ウェットティッシュ';
UPDATE default_items SET name_en = 'Red Light' WHERE name = '赤色ライト';
UPDATE default_items SET name_en = 'Fishing Bait/Lure' WHERE name = '釣り餌・ルアー';
UPDATE default_items SET name_en = 'ND Filter' WHERE name = 'NDフィルター';
UPDATE default_items SET name_en = 'Marine Shoes' WHERE name = 'マリンシューズ';
UPDATE default_items SET name_en = 'Garbage Bag' WHERE name = 'ゴミ袋';
UPDATE default_items SET name_en = 'Warm Clothing' WHERE name = '防寒着';
UPDATE default_items SET name_en = 'Life Jacket' WHERE name = 'ライフジャケット';
UPDATE default_items SET name_en = 'Gloves' WHERE name = 'グローブ';
UPDATE default_items SET name_en = 'Wear (Top & Bottom)' WHERE name = 'ウェア上下';
UPDATE default_items SET name_en = 'Sunscreen' WHERE name = '日焼け止め';
UPDATE default_items SET name_en = 'Timetable' WHERE name = '時刻表';
UPDATE default_items SET name_en = 'Camera (Telephoto Lens)' WHERE name = 'カメラ（望遠レンズ）';
UPDATE default_items SET name_en = 'Map & Compass' WHERE name = '地図・コンパス';
UPDATE default_items SET name_en = 'Leash Cord' WHERE name = 'リーシュコード';
UPDATE default_items SET name_en = 'Goggles' WHERE name = 'ゴーグル';
UPDATE default_items SET name_en = 'Spare Battery' WHERE name = '予備バッテリー';
UPDATE default_items SET name_en = 'Cooler Box' WHERE name = 'クーラーボックス';
UPDATE default_items SET name_en = 'Air Pump' WHERE name = '空気入れ';
UPDATE default_items SET name_en = 'Map' WHERE name = '地図';
UPDATE default_items SET name_en = 'Beach Towel' WHERE name = 'ビーチタオル';
UPDATE default_items SET name_en = 'Lens Cleaner' WHERE name = 'レンズクリーナー';
UPDATE default_items SET name_en = 'Puncture Repair Kit' WHERE name = 'パンク修理キット';
UPDATE default_items SET name_en = 'Hat' WHERE name = '帽子';
UPDATE default_items SET name_en = 'Waterproof Bag' WHERE name = '防水バッグ';
UPDATE default_items SET name_en = 'Apron' WHERE name = 'エプロン';
UPDATE default_items SET name_en = 'Camouflage Clothing & Hat' WHERE name = '迷彩服・帽子';
UPDATE default_items SET name_en = 'Trail Snacks' WHERE name = '行動食';
UPDATE default_items SET name_en = 'Long Boots' WHERE name = '長靴';

-- ========================================
-- 4. travel_rules 英語データ更新
-- ========================================
UPDATE travel_rules SET
  rule_title_en = 'Take Your Trash',
  rule_description_en = 'Please take all trash with you and do not leave it behind. Help protect the natural environment.'
WHERE rule_title = 'ゴミの持ち帰り';

UPDATE travel_rules SET
  rule_title_en = 'No Idling',
  rule_description_en = 'Avoid unnecessary idling and practice environmentally friendly driving.'
WHERE rule_title = 'アイドリング禁止';

UPDATE travel_rules SET
  rule_title_en = 'Respect Local Residents',
  rule_description_en = 'Be considerate of local residents by avoiding noise and parking violations.'
WHERE rule_title = '地元住民への配慮';

UPDATE travel_rules SET
  rule_title_en = 'Follow Slope Rules',
  rule_description_en = 'Control your speed and give priority to those ahead of you.'
WHERE rule_title = 'ゲレンデルールの遵守';

UPDATE travel_rules SET
  rule_title_en = 'Check No-Swimming Areas',
  rule_description_en = 'Never enter no-swimming zones.'
WHERE rule_title = '遊泳禁止エリアの確認';

UPDATE travel_rules SET
  rule_title_en = 'Follow Traffic Rules',
  rule_description_en = 'Bicycles are vehicles. Follow signals and signs, and prioritize pedestrians.'
WHERE rule_title = '交通ルールの遵守';

UPDATE travel_rules SET
  rule_title_en = 'Follow Orchard Rules',
  rule_description_en = 'Follow each orchard''s picking rules and only harvest designated fruits.'
WHERE rule_title = '農園のルール遵守';

UPDATE travel_rules SET
  rule_title_en = 'Respect Photography Etiquette',
  rule_description_en = 'Do not trespass on private property or cause inconvenience to others.'
WHERE rule_title = '撮影マナーの遵守';

UPDATE travel_rules SET
  rule_title_en = 'Submit Hiking Plan',
  rule_description_en = 'Submit a hiking plan in advance for areas where it is required.'
WHERE rule_title = '登山届けの提出';

UPDATE travel_rules SET
  rule_title_en = 'Purchase Fishing License',
  rule_description_en = 'Purchase a fishing license in advance for areas where it is required.'
WHERE rule_title = '遊漁券の購入';

UPDATE travel_rules SET
  rule_title_en = 'Minimize Light Pollution',
  rule_description_en = 'Minimize car headlights and smartphone light at observation sites.'
WHERE rule_title = '光害への配慮';

UPDATE travel_rules SET
  rule_title_en = 'No Trespassing on Tracks',
  rule_description_en = 'Never enter railway tracks.'
WHERE rule_title = '線路への立ち入り禁止';

UPDATE travel_rules SET
  rule_title_en = 'No Food Waste',
  rule_description_en = 'Eat all harvested fruits or take them home.'
WHERE rule_title = '食べ残しの禁止';

UPDATE travel_rules SET
  rule_title_en = 'Check Equipment',
  rule_description_en = 'Prepare appropriate equipment according to weather and altitude.'
WHERE rule_title = '装備の確認';

UPDATE travel_rules SET
  rule_title_en = 'Check Restricted Areas',
  rule_description_en = 'Never enter restricted fishing areas.'
WHERE rule_title = '禁漁区域の確認';

-- ========================================
-- 確認用クエリ
-- ========================================
SELECT
  'main_purposes' as table_name,
  COUNT(*) as total,
  SUM(CASE WHEN name_en IS NOT NULL THEN 1 ELSE 0 END) as en_count,
  ROUND(100.0 * SUM(CASE WHEN name_en IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) as en_percentage
FROM main_purposes
UNION ALL
SELECT
  'sub_purposes',
  COUNT(*),
  SUM(CASE WHEN name_en IS NOT NULL THEN 1 ELSE 0 END),
  ROUND(100.0 * SUM(CASE WHEN name_en IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM sub_purposes
UNION ALL
SELECT
  'default_items',
  COUNT(*),
  SUM(CASE WHEN name_en IS NOT NULL THEN 1 ELSE 0 END),
  ROUND(100.0 * SUM(CASE WHEN name_en IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM default_items
UNION ALL
SELECT
  'travel_rules',
  COUNT(*),
  SUM(CASE WHEN rule_title_en IS NOT NULL AND rule_description_en IS NOT NULL THEN 1 ELSE 0 END),
  ROUND(100.0 * SUM(CASE WHEN rule_title_en IS NOT NULL AND rule_description_en IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM travel_rules;
