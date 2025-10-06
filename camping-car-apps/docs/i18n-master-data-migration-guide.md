# 🌐 i18n対応マスターデータ移行ガイド

## 📋 目次
1. [概要](#概要)
2. [現状確認](#現状確認)
3. [データベース設計変更](#データベース設計変更)
4. [英語版データ作成](#英語版データ作成)
5. [Migration作成](#migration作成)
6. [ローカル環境での検証](#ローカル環境での検証)
7. [本番環境への適用](#本番環境への適用)
8. [フロントエンド対応](#フロントエンド対応)

---

## 概要

### 🎯 目的
- マスターデータ（メイン目的、サブ目的、持ち物、ルール・マナー）の多言語対応
- 日本語版と英語版の両方のデータをSupabaseに登録
- フロントエンドから言語に応じたデータを取得

### 📊 対象テーブル
1. `main_purposes` - メイン目的（16件）
2. `sub_purposes` - サブ目的（11件）
3. `default_items` - 推奨持ち物（80件）
4. `travel_rules` - ルール・マナー（複数件）

### ⚠️ 重要な注意事項
- **本番環境への影響**: 既存データは保持しながら新規カラム追加
- **後方互換性**: 既存の日本語データは維持
- **段階的移行**: ローカル環境で完全検証後に本番適用

---

## 現状確認

### Step 1: 現在のテーブル構造確認

```bash
# ローカル環境のSupabase CLIで確認
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "\d main_purposes"
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "\d sub_purposes"
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "\d default_items"
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "\d travel_rules"
```

### Step 2: 既存データのエクスポート

```bash
# 既存の日本語データを確認・バックアップ
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "SELECT * FROM main_purposes ORDER BY id;" > backup_main_purposes_ja.txt
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "SELECT * FROM sub_purposes ORDER BY id;" > backup_sub_purposes_ja.txt
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "SELECT * FROM default_items ORDER BY id;" > backup_default_items_ja.txt
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "SELECT * FROM travel_rules ORDER BY id;" > backup_travel_rules_ja.txt
```

---

## データベース設計変更

### 設計方針の選択

**Option 1: カラム追加方式（推奨）**
- メリット: シンプル、パフォーマンス良好、既存クエリへの影響最小
- デメリット: 言語追加時にカラム追加が必要

**Option 2: 別テーブル方式**
- メリット: 言語拡張性が高い
- デメリット: JOIN必須、複雑性増加

**👉 今回は Option 1（カラム追加方式）を採用**

### 新しいテーブル構造

#### 1. main_purposes テーブル
```sql
CREATE TABLE main_purposes (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,              -- 日本語名（既存）
  name_en TEXT,                    -- 英語名（新規追加）
  description TEXT,                -- 日本語説明（既存）
  description_en TEXT,             -- 英語説明（新規追加）
  display_order INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 2. sub_purposes テーブル
```sql
CREATE TABLE sub_purposes (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,              -- 日本語名（既存）
  name_en TEXT,                    -- 英語名（新規追加）
  description TEXT,                -- 日本語説明（既存）
  description_en TEXT,             -- 英語説明（新規追加）
  display_order INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 3. default_items テーブル
```sql
CREATE TABLE default_items (
  id SERIAL PRIMARY KEY,
  main_purpose_id INTEGER REFERENCES main_purposes(id),
  item_name TEXT NOT NULL,         -- 日本語名（既存）
  item_name_en TEXT,               -- 英語名（新規追加）
  description TEXT,                -- 日本語説明（既存）
  description_en TEXT,             -- 英語説明（新規追加）
  display_order INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### 4. travel_rules テーブル
```sql
CREATE TABLE travel_rules (
  id SERIAL PRIMARY KEY,
  destination TEXT,
  main_purpose_id INTEGER REFERENCES main_purposes(id),
  rule_text TEXT NOT NULL,         -- 日本語ルール（既存）
  rule_text_en TEXT,               -- 英語ルール（新規追加）
  category TEXT,                   -- 'basic', 'specific', 'required'
  is_required BOOLEAN DEFAULT false,
  display_order INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 英語版データ作成

### Step 1: 翻訳用CSVテンプレート作成

```bash
# main_purposes の翻訳テンプレート作成
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "
COPY (
  SELECT id, name, description, '' as name_en, '' as description_en
  FROM main_purposes
  ORDER BY id
) TO STDOUT WITH CSV HEADER
" > translation_main_purposes.csv

# sub_purposes の翻訳テンプレート作成
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "
COPY (
  SELECT id, name, description, '' as name_en, '' as description_en
  FROM sub_purposes
  ORDER BY id
) TO STDOUT WITH CSV HEADER
" > translation_sub_purposes.csv

# default_items の翻訳テンプレート作成
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "
COPY (
  SELECT id, main_purpose_id, item_name, description, '' as item_name_en, '' as description_en
  FROM default_items
  ORDER BY id
) TO STDOUT WITH CSV HEADER
" > translation_default_items.csv

# travel_rules の翻訳テンプレート作成
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "
COPY (
  SELECT id, destination, main_purpose_id, rule_text, category, is_required, '' as rule_text_en
  FROM travel_rules
  ORDER BY id
) TO STDOUT WITH CSV HEADER
" > translation_travel_rules.csv
```

### Step 2: 英語翻訳データ作成

**翻訳用のスプレッドシート作成手順:**

1. 上記CSVファイルをGoogleスプレッドシートまたはExcelで開く
2. 以下のシートを作成:
   - `main_purposes_translation`
   - `sub_purposes_translation`
   - `default_items_translation`
   - `travel_rules_translation`

3. 各シートで英語カラムを埋める:

#### main_purposes 翻訳例
| id | name | description | name_en | description_en |
|----|------|-------------|---------|----------------|
| 1 | 登山・ハイキング | 山登りやトレッキング | Hiking & Trekking | Mountain climbing and trekking activities |
| 2 | 海水浴・シュノーケリング | 海での遊泳活動 | Beach & Snorkeling | Swimming and snorkeling at the beach |
| ... | ... | ... | ... | ... |

#### sub_purposes 翻訳例
| id | name | description | name_en | description_en |
|----|------|-------------|---------|----------------|
| 1 | 温泉 | 温泉施設への立ち寄り | Hot Springs | Visit to hot spring facilities |
| 2 | 道の駅 | 道の駅での休憩・買い物 | Roadside Station | Rest and shopping at roadside stations |
| ... | ... | ... | ... | ... |

#### default_items 翻訳例
| id | main_purpose_id | item_name | description | item_name_en | description_en |
|----|-----------------|-----------|-------------|--------------|----------------|
| 1 | 1 | 登山靴 | 滑りにくい登山用の靴 | Hiking Boots | Non-slip boots for hiking |
| 2 | 1 | トレッキングポール | 歩行補助用のポール | Trekking Poles | Poles for walking assistance |
| ... | ... | ... | ... | ... | ... |

#### travel_rules 翻訳例
| id | destination | main_purpose_id | rule_text | category | is_required | rule_text_en |
|----|-------------|-----------------|-----------|----------|-------------|--------------|
| 1 | 北海道（道北） | 1 | 登山計画書の提出 | specific | true | Submit hiking plan |
| 2 | 北海道（道北） | 1 | ヒグマ対策グッズ携行 | specific | true | Carry bear deterrent equipment |
| ... | ... | ... | ... | ... | ... | ... |

### Step 3: 翻訳データのSQL変換

翻訳完了後、CSVからSQLに変換するスクリプトを作成:

```bash
# csv_to_sql_converter.js を作成
cat > csv_to_sql_converter.js << 'EOF'
const fs = require('fs');
const csv = require('csv-parser');

function convertCSVtoSQL(csvFile, tableName, updateColumns) {
  const results = [];

  fs.createReadStream(csvFile)
    .pipe(csv())
    .on('data', (data) => results.push(data))
    .on('end', () => {
      console.log(`-- ${tableName} 英語版データ更新`);

      results.forEach(row => {
        const setClause = updateColumns
          .map(col => `${col} = '${row[col].replace(/'/g, "''")}'`)
          .join(', ');

        console.log(`UPDATE ${tableName} SET ${setClause} WHERE id = ${row.id};`);
      });

      console.log('');
    });
}

// 実行
convertCSVtoSQL('translation_main_purposes.csv', 'main_purposes', ['name_en', 'description_en']);
convertCSVtoSQL('translation_sub_purposes.csv', 'sub_purposes', ['name_en', 'description_en']);
convertCSVtoSQL('translation_default_items.csv', 'default_items', ['item_name_en', 'description_en']);
convertCSVtoSQL('translation_travel_rules.csv', 'travel_rules', ['rule_text_en']);
EOF

# 実行
node csv_to_sql_converter.js > update_english_data.sql
```

---

## Migration作成

### Step 1: カラム追加Migration作成

```bash
# Migrationファイル作成
cat > supabase/migrations/$(date +%Y%m%d%H%M%S)_add_english_columns.sql << 'EOF'
-- ========================================
-- i18n対応: 英語カラム追加Migration
-- ========================================

-- 1. main_purposes テーブルに英語カラム追加
ALTER TABLE main_purposes
  ADD COLUMN IF NOT EXISTS name_en TEXT,
  ADD COLUMN IF NOT EXISTS description_en TEXT;

COMMENT ON COLUMN main_purposes.name_en IS 'メイン目的の英語名';
COMMENT ON COLUMN main_purposes.description_en IS 'メイン目的の英語説明';

-- 2. sub_purposes テーブルに英語カラム追加
ALTER TABLE sub_purposes
  ADD COLUMN IF NOT EXISTS name_en TEXT,
  ADD COLUMN IF NOT EXISTS description_en TEXT;

COMMENT ON COLUMN sub_purposes.name_en IS 'サブ目的の英語名';
COMMENT ON COLUMN sub_purposes.description_en IS 'サブ目的の英語説明';

-- 3. default_items テーブルに英語カラム追加
ALTER TABLE default_items
  ADD COLUMN IF NOT EXISTS item_name_en TEXT,
  ADD COLUMN IF NOT EXISTS description_en TEXT;

COMMENT ON COLUMN default_items.item_name_en IS '持ち物の英語名';
COMMENT ON COLUMN default_items.description_en IS '持ち物の英語説明';

-- 4. travel_rules テーブルに英語カラム追加
ALTER TABLE travel_rules
  ADD COLUMN IF NOT EXISTS rule_text_en TEXT;

COMMENT ON COLUMN travel_rules.rule_text_en IS 'ルールの英語テキスト';

-- 確認用: 変更後のテーブル構造表示
\d main_purposes
\d sub_purposes
\d default_items
\d travel_rules
EOF
```

### Step 2: 英語データ投入Migration作成

```bash
# 英語データ投入Migration作成（先ほど作成したSQLを使用）
cat > supabase/migrations/$(date +%Y%m%d%H%M%S)_insert_english_data.sql << 'EOF'
-- ========================================
-- i18n対応: 英語データ投入Migration
-- ========================================

-- main_purposes 英語データ更新
UPDATE main_purposes SET name_en = 'Hiking & Trekking', description_en = 'Mountain climbing and trekking activities' WHERE id = 1;
UPDATE main_purposes SET name_en = 'Beach & Snorkeling', description_en = 'Swimming and snorkeling at the beach' WHERE id = 2;
UPDATE main_purposes SET name_en = 'Cycling', description_en = 'Cycling tours and bike rides' WHERE id = 3;
-- ... (続く)

-- sub_purposes 英語データ更新
UPDATE sub_purposes SET name_en = 'Hot Springs', description_en = 'Visit to hot spring facilities' WHERE id = 1;
UPDATE sub_purposes SET name_en = 'Roadside Station', description_en = 'Rest and shopping at roadside stations' WHERE id = 2;
-- ... (続く)

-- default_items 英語データ更新
UPDATE default_items SET item_name_en = 'Hiking Boots', description_en = 'Non-slip boots for hiking' WHERE id = 1;
UPDATE default_items SET item_name_en = 'Trekking Poles', description_en = 'Poles for walking assistance' WHERE id = 2;
-- ... (続く)

-- travel_rules 英語データ更新
UPDATE travel_rules SET rule_text_en = 'Submit hiking plan before departure' WHERE id = 1;
UPDATE travel_rules SET rule_text_en = 'Carry bear deterrent equipment' WHERE id = 2;
-- ... (続く)

-- 確認用: 英語データ投入確認
SELECT id, name, name_en FROM main_purposes ORDER BY id LIMIT 5;
SELECT id, name, name_en FROM sub_purposes ORDER BY id LIMIT 5;
SELECT id, item_name, item_name_en FROM default_items ORDER BY id LIMIT 10;
SELECT id, rule_text, rule_text_en FROM travel_rules ORDER BY id LIMIT 5;
EOF
```

---

## ローカル環境での検証

### Step 1: Migration実行（ローカル）

```bash
# Supabase CLIでローカル環境にMigration適用
cd /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps

# Migrationリスト確認
supabase migration list

# Migration実行
supabase db reset

# または個別実行
psql "postgresql://postgres:postgres@localhost:54322/postgres" -f supabase/migrations/[timestamp]_add_english_columns.sql
psql "postgresql://postgres:postgres@localhost:54322/postgres" -f supabase/migrations/[timestamp]_insert_english_data.sql
```

### Step 2: データ確認

```bash
# 英語カラムが追加されたか確認
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "
SELECT id, name, name_en, description, description_en
FROM main_purposes
LIMIT 5;
"

# すべてのテーブルで英語データが正しく投入されたか確認
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "
SELECT
  (SELECT COUNT(*) FROM main_purposes WHERE name_en IS NOT NULL) as main_purposes_en,
  (SELECT COUNT(*) FROM sub_purposes WHERE name_en IS NOT NULL) as sub_purposes_en,
  (SELECT COUNT(*) FROM default_items WHERE item_name_en IS NOT NULL) as default_items_en,
  (SELECT COUNT(*) FROM travel_rules WHERE rule_text_en IS NOT NULL) as travel_rules_en;
"
```

### Step 3: フロントエンドでの動作確認

後述の「フロントエンド対応」セクション参照

---

## 本番環境への適用

### ⚠️ 重要: 本番適用前のチェックリスト

- [ ] ローカル環境で完全動作確認済み
- [ ] フロントエンドでの言語切り替え動作確認済み
- [ ] Migration SQLファイルのバックアップ作成済み
- [ ] 本番データベースのバックアップ取得済み
- [ ] RLSポリシーへの影響確認済み
- [ ] ロールバック手順の準備完了

### Step 1: 本番データベースバックアップ

```bash
# Supabase Dashboardから手動バックアップ
# または supabase db dump コマンド使用

# ローカルにバックアップダンプ作成
SUPABASE_PROJECT_ID="rwxllvnuuxabvgxpeuma"
SUPABASE_DB_PASSWORD="your_db_password"

pg_dump "postgresql://postgres:${SUPABASE_DB_PASSWORD}@db.${SUPABASE_PROJECT_ID}.supabase.co:5432/postgres" \
  > backup_production_before_i18n_$(date +%Y%m%d_%H%M%S).sql
```

### Step 2: 本番Migration適用

**Option A: Supabase Dashboard経由（推奨）**

1. Supabase Dashboard → SQL Editor を開く
2. `add_english_columns.sql` の内容を貼り付けて実行
3. 実行結果を確認
4. `insert_english_data.sql` の内容を貼り付けて実行
5. データ投入結果を確認

**Option B: Supabase CLI経由**

```bash
# 本番環境にリンク
supabase link --project-ref rwxllvnuuxabvgxpeuma

# Migration Push
supabase db push

# 実行確認
supabase migration list --remote
```

### Step 3: 本番データ確認

```bash
# Supabase Dashboard → Table Editor で確認
# または SQL Editor で以下を実行:

SELECT id, name, name_en FROM main_purposes LIMIT 5;
SELECT id, name, name_en FROM sub_purposes LIMIT 5;
SELECT id, item_name, item_name_en FROM default_items LIMIT 10;
SELECT id, rule_text, rule_text_en FROM travel_rules LIMIT 5;

-- 英語データ投入率確認
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
  SUM(CASE WHEN item_name_en IS NOT NULL THEN 1 ELSE 0 END),
  ROUND(100.0 * SUM(CASE WHEN item_name_en IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM default_items
UNION ALL
SELECT
  'travel_rules',
  COUNT(*),
  SUM(CASE WHEN rule_text_en IS NOT NULL THEN 1 ELSE 0 END),
  ROUND(100.0 * SUM(CASE WHEN rule_text_en IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM travel_rules;
```

---

## フロントエンド対応

### Step 1: データ取得関数の更新

#### 1. PurposeManager.jsx の更新

```javascript
// src/components/PurposeManager.jsx
import { useTranslation } from 'react-i18next';

const PurposeManager = ({ tripId, selectedPurposes, onPurposesUpdate }) => {
  const { t, i18n } = useTranslation();
  const currentLanguage = i18n.language; // 'ja' or 'en'

  const fetchPurposes = async () => {
    try {
      // メイン目的取得（言語対応）
      const { data: mainData, error: mainError } = await supabase
        .from('main_purposes')
        .select('id, name, name_en, description, description_en, display_order')
        .order('display_order');

      if (mainError) throw mainError;

      // 言語に応じた名前を使用
      const mainPurposes = mainData.map(item => ({
        ...item,
        displayName: currentLanguage === 'en' && item.name_en ? item.name_en : item.name,
        displayDescription: currentLanguage === 'en' && item.description_en ? item.description_en : item.description
      }));

      // サブ目的取得（言語対応）
      const { data: subData, error: subError } = await supabase
        .from('sub_purposes')
        .select('id, name, name_en, description, description_en, display_order')
        .order('display_order');

      if (subError) throw subError;

      const subPurposes = subData.map(item => ({
        ...item,
        displayName: currentLanguage === 'en' && item.name_en ? item.name_en : item.name,
        displayDescription: currentLanguage === 'en' && item.description_en ? item.description_en : item.description
      }));

      setMainPurposes(mainPurposes);
      setSubPurposes(subPurposes);
    } catch (error) {
      console.error('目的データ取得エラー:', error);
    } finally {
      setLoading(false);
    }
  };

  // 言語変更時に再取得
  useEffect(() => {
    fetchPurposes();
  }, [currentLanguage]);

  return (
    <div className="purpose-manager">
      {/* メイン目的 */}
      <div className="purpose-grid">
        {mainPurposes.map(purpose => (
          <label key={purpose.id} className="purpose-item">
            <input
              type="checkbox"
              checked={selectedMainIds.includes(purpose.id)}
              onChange={() => handleMainPurposeToggle(purpose.id)}
            />
            <span>{purpose.displayName}</span>
          </label>
        ))}
      </div>
      {/* ... */}
    </div>
  );
};
```

#### 2. ItemsManager.jsx の更新

```javascript
// src/components/ItemsManager.jsx
import { useTranslation } from 'react-i18next';

const ItemsManager = ({ tripId, selectedPurposes }) => {
  const { i18n } = useTranslation();
  const currentLanguage = i18n.language;

  const fetchDefaultItems = async () => {
    if (!selectedPurposes?.main || selectedPurposes.main.length === 0) {
      setDefaultItems([]);
      return;
    }

    try {
      const mainPurposeIds = selectedPurposes.main;

      const { data, error } = await supabase
        .from('default_items')
        .select('id, main_purpose_id, item_name, item_name_en, description, description_en')
        .in('main_purpose_id', mainPurposeIds)
        .order('display_order');

      if (error) throw error;

      // 言語対応
      const items = data.map(item => ({
        ...item,
        displayName: currentLanguage === 'en' && item.item_name_en ? item.item_name_en : item.item_name,
        displayDescription: currentLanguage === 'en' && item.description_en ? item.description_en : item.description
      }));

      setDefaultItems(items);
    } catch (error) {
      console.error('持ち物取得エラー:', error);
    }
  };

  useEffect(() => {
    fetchDefaultItems();
  }, [selectedPurposes, currentLanguage]);

  return (
    <div className="items-manager">
      {defaultItems.map(item => (
        <label key={item.id}>
          <input type="checkbox" />
          <span>{item.displayName}</span>
        </label>
      ))}
    </div>
  );
};
```

#### 3. RulesConfirmation.jsx の更新

```javascript
// src/components/RulesConfirmation.jsx
import { useTranslation } from 'react-i18next';

const RulesConfirmation = ({ destination, selectedPurposes, onComplete }) => {
  const { i18n } = useTranslation();
  const currentLanguage = i18n.language;

  const fetchRules = async () => {
    try {
      const { data, error } = await supabase
        .from('travel_rules')
        .select('id, rule_text, rule_text_en, category, is_required, display_order')
        .eq('destination', destination)
        .in('main_purpose_id', selectedPurposes.main)
        .order('display_order');

      if (error) throw error;

      // 言語対応
      const rules = data.map(rule => ({
        ...rule,
        displayText: currentLanguage === 'en' && rule.rule_text_en ? rule.rule_text_en : rule.rule_text
      }));

      setRules(rules);
    } catch (error) {
      console.error('ルール取得エラー:', error);
    }
  };

  useEffect(() => {
    fetchRules();
  }, [destination, selectedPurposes, currentLanguage]);

  return (
    <div className="rules-confirmation">
      {rules.map(rule => (
        <label key={rule.id}>
          <input type="checkbox" />
          <span>{rule.displayText}</span>
        </label>
      ))}
    </div>
  );
};
```

### Step 2: 共通ユーティリティ関数作成

```javascript
// src/utils/i18nDataHelper.js

/**
 * 言語に応じたフィールド名を取得
 */
export const getLocalizedField = (item, fieldName, language) => {
  const enFieldName = `${fieldName}_en`;

  if (language === 'en' && item[enFieldName]) {
    return item[enFieldName];
  }

  return item[fieldName];
};

/**
 * データ配列を言語対応に変換
 */
export const localizeData = (dataArray, fieldMappings, language) => {
  return dataArray.map(item => {
    const localizedItem = { ...item };

    fieldMappings.forEach(({ source, target }) => {
      localizedItem[target] = getLocalizedField(item, source, language);
    });

    return localizedItem;
  });
};

// 使用例:
// const localizedPurposes = localizeData(
//   rawPurposes,
//   [
//     { source: 'name', target: 'displayName' },
//     { source: 'description', target: 'displayDescription' }
//   ],
//   currentLanguage
// );
```

### Step 3: 動作確認

```bash
# 開発サーバー起動
npm start

# テスト項目:
# 1. 言語を日本語に設定 → メイン目的が日本語で表示される
# 2. 言語を英語に設定 → メイン目的が英語で表示される
# 3. サブ目的、持ち物、ルールも同様に確認
# 4. 言語切り替え時のリアルタイム反映確認
```

---

## トラブルシューティング

### 問題1: 英語データが表示されない

**原因**: name_en カラムが NULL
**解決**:
```sql
-- NULL確認
SELECT id, name, name_en FROM main_purposes WHERE name_en IS NULL;

-- 手動更新
UPDATE main_purposes SET name_en = 'Hiking & Trekking' WHERE id = 1;
```

### 問題2: 言語切り替え後もデータが変わらない

**原因**: useEffectの依存配列に currentLanguage がない
**解決**:
```javascript
useEffect(() => {
  fetchData();
}, [currentLanguage]); // 依存配列に追加
```

### 問題3: Migration実行エラー

**原因**: カラムが既に存在する
**解決**:
```sql
-- IF NOT EXISTS を使用
ALTER TABLE main_purposes
  ADD COLUMN IF NOT EXISTS name_en TEXT;
```

---

## チェックリスト

### 準備段階
- [ ] 既存データのバックアップ取得
- [ ] 翻訳用CSVテンプレート作成
- [ ] すべてのマスターデータの英語翻訳完了

### Migration作成
- [ ] カラム追加Migration作成
- [ ] 英語データ投入Migration作成
- [ ] Migration SQLのシンタックス確認

### ローカル検証
- [ ] ローカル環境でMigration実行成功
- [ ] 英語データ投入100%確認
- [ ] フロントエンドでの表示確認
- [ ] 言語切り替え動作確認

### 本番適用
- [ ] 本番データベースバックアップ取得
- [ ] 本番環境でMigration実行
- [ ] 本番データ確認（英語データ投入率100%）
- [ ] 本番環境でのフロントエンド動作確認

### デプロイ
- [ ] フロントエンドコードのコミット＆プッシュ
- [ ] Vercelへの自動デプロイ確認
- [ ] 本番URLでの最終動作確認

---

## 次回作業の開始手順

### 1. 事前準備（10分）

```bash
# 作業ディレクトリ移動
cd /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps

# 最新状態を確認
git status
git log --oneline -5

# ローカルSupabase起動確認
supabase status
```

### 2. 翻訳データ作成（1-2時間）

```bash
# 翻訳用CSVテンプレート生成
./scripts/generate_translation_templates.sh

# Google Spreadsheetで翻訳作業
# → 完了後CSVダウンロード

# SQL変換
node csv_to_sql_converter.js
```

### 3. Migration作成＆検証（30分）

```bash
# Migration作成
supabase migration new add_english_columns
supabase migration new insert_english_data

# ローカル適用
supabase db reset

# 確認
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c "SELECT * FROM main_purposes LIMIT 3;"
```

### 4. フロントエンド対応（1時間）

```bash
# コンポーネント更新
# - PurposeManager.jsx
# - ItemsManager.jsx
# - RulesConfirmation.jsx

# 動作確認
npm start
```

### 5. 本番適用（30分）

```bash
# 本番バックアップ取得
# Supabase Dashboard → Settings → Database → Backups

# Migration実行
supabase db push

# 確認＆デプロイ
git add .
git commit -m "feat: マスターデータ英語対応完了"
git push origin main
```

---

**作成日**: 2025年10月6日
**対象プロジェクト**: Travel Journal
**想定作業時間**: 3-4時間
**難易度**: 中級
