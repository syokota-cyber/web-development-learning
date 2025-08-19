-- 全ての問題を解決するための包括的な修正
-- Date: 2025-08-14
-- Purpose: trip_purposesのRLSポリシー修正と全main_purposesへのルールデータ追加

-- ========================================
-- 1. trip_purposesテーブルのRLSポリシー修正
-- ========================================

-- RLSを有効化（既に有効な場合はスキップ）
ALTER TABLE trip_purposes ENABLE ROW LEVEL SECURITY;

-- 既存のポリシーを削除して再作成
DROP POLICY IF EXISTS "Users can manage own trip_purposes" ON trip_purposes;
DROP POLICY IF EXISTS "Users can read own trip_purposes" ON trip_purposes;
DROP POLICY IF EXISTS "Users can insert own trip_purposes" ON trip_purposes;
DROP POLICY IF EXISTS "Users can update own trip_purposes" ON trip_purposes;
DROP POLICY IF EXISTS "Users can delete own trip_purposes" ON trip_purposes;

-- ユーザーが自分の旅行の目的を管理できるポリシー
CREATE POLICY "Users can manage own trip_purposes" 
ON trip_purposes FOR ALL 
USING (
  EXISTS (
    SELECT 1 FROM trips 
    WHERE trips.id = trip_purposes.trip_id 
    AND trips.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM trips 
    WHERE trips.id = trip_purposes.trip_id 
    AND trips.user_id = auth.uid()
  )
);

-- ========================================
-- 2. 全てのmain_purposesに基本ルールを確実に追加
-- ========================================

-- まず全ての一般ルールをクリア（重複防止）
DELETE FROM travel_rules 
WHERE rule_category = 'general';

-- 全main_purposesに対して一般ルールを追加
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

-- ========================================
-- 3. 各main_purposeに特定のルールを追加
-- ========================================

-- 既存の特定ルールをクリア（重複防止）
DELETE FROM travel_rules 
WHERE rule_category = 'specific';

-- 登山・ハイキング関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '登山届けの提出',
    '登山届けが必要なエリアでは、必ず事前に提出してください。', true, 10
FROM main_purposes 
WHERE name LIKE '%登山%' OR name LIKE '%ハイキング%';

-- 海水浴・シュノーケリング関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '遊泳禁止エリアの確認',
    '遊泳禁止エリアには絶対に入らないでください。', true, 10
FROM main_purposes 
WHERE name LIKE '%海水浴%' OR name LIKE '%シュノーケリング%';

-- サイクリング関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '交通ルールの遵守',
    '自転車も車両です。信号や標識を守り、歩行者優先で安全運転を心がけてください。', true, 10
FROM main_purposes 
WHERE name LIKE '%サイクリング%';

-- フルーツ狩り関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '農園のルール遵守',
    '各農園の収穫ルールを守り、指定された果物のみを収穫してください。', true, 10
FROM main_purposes 
WHERE name LIKE '%フルーツ狩り%';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '食べ残しの禁止',
    '収穫した果物は責任を持って食べきるか、持ち帰ってください。', true, 11
FROM main_purposes 
WHERE name LIKE '%フルーツ狩り%';

-- 釣り関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '遊漁券の購入',
    '遊漁券が必要なエリアでは事前に購入してください。', true, 10
FROM main_purposes 
WHERE name LIKE '%釣り%';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '禁漁区域の確認',
    '禁漁区域には絶対に立ち入らないでください。', true, 11
FROM main_purposes 
WHERE name LIKE '%釣り%';

-- 天体観測関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '光害への配慮',
    '観測地では車のライトやスマホの光を最小限にしてください。', true, 10
FROM main_purposes 
WHERE name LIKE '%天体観測%';

-- 鉄道撮影関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '線路への立ち入り禁止',
    '線路内は絶対に立ち入らないでください。', true, 10
FROM main_purposes 
WHERE name LIKE '%鉄道撮影%';

-- 登山・トレッキング・ハイキング関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '装備の確認',
    '天候や標高に応じた適切な装備を準備してください。', true, 11
FROM main_purposes 
WHERE name LIKE '%登山%' OR name LIKE '%トレッキング%' OR name LIKE '%ハイキング%';

-- キャンプ・アウトドア関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '火の取り扱い注意',
    '焚き火は指定場所のみで行い、完全に消火してください。', true, 10
FROM main_purposes 
WHERE name LIKE '%キャンプ%' OR name LIKE '%アウトドア%';

-- 温泉・スパ関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '入浴マナーの遵守',
    '体を洗ってから湯船に入り、タオルは湯船に入れないでください。', true, 10
FROM main_purposes 
WHERE name LIKE '%温泉%' OR name LIKE '%スパ%';

-- 野生動物観察関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '動物への接近禁止',
    '野生動物に餌を与えたり、必要以上に近づかないでください。', true, 10
FROM main_purposes 
WHERE name LIKE '%野生動物%' OR name LIKE '%動物観察%';

-- 写真撮影関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', '撮影マナーの遵守',
    '私有地への無断立ち入りや他人の迷惑になる撮影は控えてください。', true, 10
FROM main_purposes 
WHERE name LIKE '%写真%' OR name LIKE '%撮影%';

-- スキー・スノーボード関連
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order) 
SELECT 
    id, 'specific', 'ゲレンデルールの遵守',
    'スピードを制御し、前方の滑走者を優先してください。', true, 10
FROM main_purposes 
WHERE name LIKE '%スキー%' OR name LIKE '%スノーボード%';

-- ========================================
-- 4. データ確認クエリ
-- ========================================

-- 各main_purposeのルール数を確認
SELECT 
    mp.name as purpose_name,
    COUNT(tr.id) as rule_count
FROM main_purposes mp
LEFT JOIN travel_rules tr ON mp.id = tr.main_purpose_id
GROUP BY mp.id, mp.name
ORDER BY mp.name;