-- 既存のメイン目的IDを確認して、ルール・マナーデータを挿入

-- 全般的なルール（全ての目的に適用）
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'general' as rule_category,
    'ゴミの持ち帰り' as rule_title,
    'ゴミは必ず持ち帰り、現地に残さないようにしましょう。自然環境の保護にご協力ください。' as rule_description,
    true as is_required,
    1 as display_order
FROM main_purposes;

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'general' as rule_category,
    'アイドリング禁止' as rule_title,
    '不要なアイドリングは避け、環境に配慮した運転を心がけましょう。' as rule_description,
    true as is_required,
    2 as display_order
FROM main_purposes;

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'general' as rule_category,
    '地元住民への配慮' as rule_title,
    '地元住民の生活に迷惑をかけない行動を心がけ、騒音や駐車マナーに注意しましょう。' as rule_description,
    true as is_required,
    3 as display_order
FROM main_purposes;

-- 登山関連のルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '登山届けの提出' as rule_title,
    '登山届けが必要なエリアでは、必ず事前に提出してください。安全確保のために重要です。' as rule_description,
    true as is_required,
    10 as display_order
FROM main_purposes 
WHERE name LIKE '%登山%' OR name LIKE '%トレッキング%' OR name LIKE '%ハイキング%';

-- 釣り関連のルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '遊漁券の購入' as rule_title,
    '遊漁券が必要なエリアでは事前に購入してください。現地の釣具店や組合で購入できます。' as rule_description,
    true as is_required,
    10 as display_order
FROM main_purposes 
WHERE name LIKE '%釣り%' OR name LIKE '%フィッシング%';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '遊漁禁止エリアの確認' as rule_title,
    '遊漁禁止エリアには絶対に立ち入らないでください。事前に禁止区域を確認しましょう。' as rule_description,
    true as is_required,
    11 as display_order
FROM main_purposes 
WHERE name LIKE '%釣り%' OR name LIKE '%フィッシング%';

-- 海水浴関連のルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '遊泳禁止エリアの確認' as rule_title,
    '遊泳禁止エリアには絶対に入らないでください。安全のため、指定された海水浴場を利用しましょう。' as rule_description,
    true as is_required,
    10 as display_order
FROM main_purposes 
WHERE name LIKE '%海水浴%' OR name LIKE '%ビーチ%' OR name LIKE '%海%';

-- 撮影関連のルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '私有地への立ち入り禁止' as rule_title,
    '撮影のために私有地に無断で立ち入ることは禁止されています。必ず許可を得てから撮影してください。' as rule_description,
    true as is_required,
    10 as display_order
FROM main_purposes 
WHERE name LIKE '%撮影%' OR name LIKE '%写真%' OR name LIKE '%カメラ%';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '肖像権への配慮' as rule_title,
    '人物が写る撮影では、必ず事前に許可を得てください。特に子供の撮影には注意が必要です。' as rule_description,
    true as is_required,
    11 as display_order
FROM main_purposes 
WHERE name LIKE '%撮影%' OR name LIKE '%写真%' OR name LIKE '%カメラ%';

-- 観光関連のルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '文化財の保護' as rule_title,
    '史跡や文化財では、指定されたルールを守り、損傷させないよう注意してください。' as rule_description,
    true as is_required,
    10 as display_order
FROM main_purposes 
WHERE name LIKE '%観光%' OR name LIKE '%史跡%' OR name LIKE '%文化%';