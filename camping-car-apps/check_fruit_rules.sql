-- フルーツ狩りに関連するデータの確認
-- Date: 2025-08-14

-- 1. フルーツ狩りのmain_purposeを確認
SELECT id, name 
FROM main_purposes 
WHERE name LIKE '%フルーツ%' OR name LIKE '%果物%' OR name LIKE '%狩り%';

-- 2. travel_rulesテーブルの全データ件数
SELECT COUNT(*) as total_rules FROM travel_rules;

-- 3. フルーツ狩りに関連するルールが存在するか確認
SELECT 
    tr.*,
    mp.name as main_purpose_name
FROM travel_rules tr
JOIN main_purposes mp ON tr.main_purpose_id = mp.id
WHERE mp.name LIKE '%フルーツ%' OR mp.name LIKE '%果物%' OR mp.name LIKE '%狩り%';

-- 4. 全てのmain_purposesとそのルール件数を確認
SELECT 
    mp.id,
    mp.name,
    COUNT(tr.id) as rule_count
FROM main_purposes mp
LEFT JOIN travel_rules tr ON mp.id = tr.main_purpose_id
GROUP BY mp.id, mp.name
ORDER BY mp.name;

-- 5. ルールが0件のmain_purposesを特定
SELECT 
    mp.id,
    mp.name
FROM main_purposes mp
LEFT JOIN travel_rules tr ON mp.id = tr.main_purpose_id
WHERE tr.id IS NULL
ORDER BY mp.name;