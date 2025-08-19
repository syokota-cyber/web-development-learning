-- 不足しているmain_purposesのルールを追加
-- Date: 2025-08-14
-- Purpose: フルーツ狩りなど、ルールが登録されていないmain_purposesに対してルールを追加

-- まず、全てのmain_purposesに基本的なルールが存在することを確認
-- （既存のMigrationで全main_purposesに一般ルールが追加されているはずだが、念のため再実行）

-- 既存の一般ルールを削除して再作成（重複防止）
DELETE FROM travel_rules 
WHERE rule_category = 'general' 
AND rule_title IN ('ゴミの持ち帰り', 'アイドリング禁止', '地元住民への配慮');

-- 全般的なルール（全ての目的に適用）を再挿入
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

-- フルーツ狩り関連の特定ルールを追加
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '農園のルール遵守' as rule_title,
    '各農園の収穫ルールを守り、指定された果物のみを収穫してください。未熟な果物は取らないでください。' as rule_description,
    true as is_required,
    10 as display_order
FROM main_purposes 
WHERE name LIKE '%フルーツ%' OR name LIKE '%果物%' OR name LIKE '%狩り%';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '食べ残しの禁止' as rule_title,
    '収穫した果物は責任を持って食べきるか、持ち帰ってください。畑に捨てることは禁止です。' as rule_description,
    true as is_required,
    11 as display_order
FROM main_purposes 
WHERE name LIKE '%フルーツ%' OR name LIKE '%果物%' OR name LIKE '%狩り%';

-- サイクリング関連のルールを追加（もし不足していれば）
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '交通ルールの遵守' as rule_title,
    '自転車も車両です。信号や標識を守り、歩行者優先で安全運転を心がけてください。' as rule_description,
    true as is_required,
    10 as display_order
FROM main_purposes 
WHERE name LIKE '%サイクリング%' OR name LIKE '%自転車%'
AND NOT EXISTS (
    SELECT 1 FROM travel_rules tr 
    WHERE tr.main_purpose_id = main_purposes.id 
    AND tr.rule_category = 'specific'
);

-- 天体観測関連のルールを追加（もし不足していれば）
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '光害への配慮' as rule_title,
    '観測地では車のライトやスマホの光を最小限にし、他の観測者の妨げにならないよう配慮してください。' as rule_description,
    true as is_required,
    10 as display_order
FROM main_purposes 
WHERE name LIKE '%天体%' OR name LIKE '%星%'
AND NOT EXISTS (
    SELECT 1 FROM travel_rules tr 
    WHERE tr.main_purpose_id = main_purposes.id 
    AND tr.rule_category = 'specific'
);

-- 鉄道撮影関連のルールを追加（もし不足していれば）
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id as main_purpose_id,
    'specific' as rule_category,
    '線路への立ち入り禁止' as rule_title,
    '線路内は絶対に立ち入らないでください。駅構内での撮影は駅員の指示に従ってください。' as rule_description,
    true as is_required,
    10 as display_order
FROM main_purposes 
WHERE name LIKE '%鉄道%' OR name LIKE '%撮り鉄%'
AND NOT EXISTS (
    SELECT 1 FROM travel_rules tr 
    WHERE tr.main_purpose_id = main_purposes.id 
    AND tr.rule_category = 'specific'
);