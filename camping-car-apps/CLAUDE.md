# 🚨 デプロイメント・デバッグの鉄則（2025年8月21日追加）

## 「データフローファースト・推測デプロイ禁止・段階的修正」原則
**重大インシデント**: 2025年8月21日、TripList年間表示で方面情報が表示されない問題で、真の原因（App.jsxのCRUD操作漏れ）を見つけるのに2時間、9回の不要なデプロイを実行。5分で解決可能だった問題を過度に複雑化。

### デバッグの必須プロセス（Phase制）
1. **Phase 1: 問題の正確な把握**（5分）
   - 症状の明確な記述と再現性確認
   - エラーログ・コンソール確認
2. **Phase 2: データフロー確認**（10分） 
   - フォーム入力→API→DB→取得→表示の順序確認
   - 各段階でのconsole.log・Network tab活用
3. **Phase 3: 段階的修正**（20分）
   - 最も可能性の高い箇所から1つずつ修正
   - ローカル環境での完全確認
4. **Phase 4: デプロイと確認**（10分）
   - 修正理由明記、1回のデプロイで解決確認

### デプロイメント管理の鉄則
- **1問題2デプロイ制限**: 1つの問題につき最大2回のデプロイまで
- **ローカルテスト必須**: ローカル環境で問題解決確認後のみデプロイ
- **Single Responsibility**: 1回のデプロイで1つの問題のみ対応
- **デプロイ理由明記**: 推測でのデプロイ（「多分これで直る」）は絶対禁止

### 絶対禁止事項（デプロイ・デバッグ関連）
- ❌ **推測に基づく連続デプロイ**: 根拠なしでの「とりあえずデプロイ」
- ❌ **データフロー確認前の修正**: フロントエンド・バックエンドの両方同時修正
- ❌ **高度な問題の優先疑い**: Tree-shaking・ビルド最適化等を最初に疑う
- ❌ **Git操作による問題解決**: ブランチ・マージでの問題解決試行
- ❌ **API Key直接使用**: コマンドラインでのAPI Key Raw使用

### 成功パターンと失敗パターン
```
✅ 正しいアプローチ:
症状確認 → データフロー確認 → CRUD操作確認 → 1箇所修正 → 解決

❌ 今回の失敗パターン:  
症状確認 → Git操作 → 複数デプロイ → Tree-shaking対策 → バンドル解析 → 最後にCRUD確認
```

### 関連ファイル
- `/DEPLOYMENT_SECURITY_RULEBOOK.md` - 詳細なルールブック
- `/learning-logs/2025-08-21.md` - 今回のインシデント詳細記録

---

# 🔒 Supabaseセキュリティ対応の鉄則（2025年8月13日追加）

## 概要
2025年8月13日、Supabaseから週次セキュリティ警告を受信。6件のエラーと4件の警告を1時間で0件と1件に改善した成功体験を記録。

## 「RLSファースト・ポリシー必須・定期監査」原則

### RLS（Row Level Security）対応の必須プロセス
1. **新規テーブル作成時**: 必ずRLSを有効化する
2. **ポリシー設定**: RLS有効化後、必ず適切なポリシーを設定
3. **アクセス制御**: 最小権限の原則に基づいたポリシー設計
4. **定期監査**: Security Advisorを定期的にチェック

### セキュリティ設定のベストプラクティス
```sql
-- テーブル作成時のテンプレート
CREATE TABLE example_table (...);
ALTER TABLE example_table ENABLE ROW LEVEL SECURITY;

-- 基本テーブル（全ユーザー読み取り可）
CREATE POLICY "Allow all to read example_table" 
ON example_table FOR SELECT USING (true);

-- ユーザー固有テーブル（所有者のみ）
CREATE POLICY "Users can manage own data" 
ON user_specific_table FOR ALL 
USING (auth.uid() = user_id);
```

### 関数のセキュリティ設定
```sql
-- SECURITY DEFINER関数には必ずsearch_pathを明記
CREATE OR REPLACE FUNCTION example_function()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public  -- 必須
AS $function$
BEGIN
    -- 関数の処理
END;
$function$;
```

### Auth設定の推奨値
- **OTP有効期限**: 3600秒（1時間）以下
- **パスワード漏洩保護**: Pro Plan以上で有効化推奨
- **最小パスワード長**: 8文字以上

### セキュリティ監査チェックリスト
- [ ] 全publicテーブルでRLS有効化済み
- [ ] 各テーブルに適切なポリシー設定済み
- [ ] SECURITY DEFINER関数にsearch_path設定済み
- [ ] OTP期限が推奨値以下
- [ ] 定期的なSecurity Advisor確認

### 絶対禁止事項（セキュリティ関連）
- ❌ **RLS無効のpublicテーブル**: データ漏洩リスク
- ❌ **ポリシーなしのRLS**: アクセス不可状態
- ❌ **search_path未指定**: Function Search Path攻撃リスク
- ❌ **長すぎるOTP期限**: セキュリティホール
- ❌ **セキュリティ警告の放置**: 段階的悪化リスク

### 正しい思考プロセス
```
✅ 正しい: テーブル作成 → RLS有効化 → ポリシー設定 → 動作確認
❌ 間違い: テーブル作成 → 後でセキュリティ → 警告発生 → 緊急対応
```

### 今回の成功パターン
1. **問題の整理**: エラー6件、警告4件を分類
2. **優先順位付け**: エラー（RLS）→ 警告（Auth、Function）
3. **段階的対応**: Migration作成 → 実行 → 確認
4. **制約の理解**: 無料プラン制限を受け入れ
5. **結果確認**: Security Advisor再チェック

### セキュリティ対応の価値
- **信頼性向上**: プロダクションレディなセキュリティレベル
- **リスク軽減**: データ漏洩・不正アクセスの防止
- **運用安定性**: セキュリティインシデントの予防
- **学習効果**: PostgreSQL、Supabaseの深い理解

## 📁 関連ファイル
- `/supabase/migrations/20250813_enable_rls_security.sql` - RLS有効化
- `/supabase/migrations/20250813_create_rls_policies.sql` - ポリシー設定
- `/supabase/migrations/20250813_fix_function_search_path.sql` - 関数修正
- `/fix_security_issues.md` - 対応手順書
- `/learning-logs/2025-08-13.md` - 詳細作業ログ

## 🎯 今後の運用指針
1. **新規開発時**: セキュリティファーストでの設計
2. **定期監査**: 月次でSecurity Advisor確認
3. **ドキュメント更新**: セキュリティ変更時の記録徹底
4. **学習継続**: PostgreSQL・Supabaseセキュリティの深化

---

## 🔄 **開発環境同期・バージョン管理の鉄則（2025年8月19日追加）**

### 「本番同期ファースト・バージョン管理必須・差異ゼロ」原則
**重要な教訓**: 2025年8月19日、本番環境と開発環境の差異により、マスターデータ不整合・機能動作不良が発生。完全同期により解決した成功体験を記録。

#### **メジャー・マイナーアップデート時の必須プロセス**
1. **本番環境の完全バックアップ**: スキーマ・マスターデータ・設定の保存
2. **開発環境の初期化**: 古いデータの完全クリア
3. **本番→開発 完全同期**: 読み取り専用での安全な同期
4. **バージョン管理**: 同期状態の記録と追跡

#### **同期対象の必須チェックリスト**
- [ ] **マスターデータテーブル**
  - [ ] `main_purposes` - メイン目的マスターデータ
  - [ ] `sub_purposes` - サブ目的マスターデータ  
  - [ ] `default_items` - 推奨持ち物マスターデータ
  - [ ] `travel_rules` - ルール・マナーマスターデータ
- [ ] **テーブル構造**
  - [ ] カラム定義（新規追加カラム含む）
  - [ ] インデックス設定
  - [ ] 制約条件（外部キー、CHECK制約）
- [ ] **セキュリティ設定**
  - [ ] RLS（Row Level Security）有効状態
  - [ ] ポリシー定義
  - [ ] 権限設定

#### **バージョン管理コマンドセット**
```bash
# === 本番環境同期用コマンド（安全・読み取り専用） ===

# 1. 本番環境マスターデータの取得
curl "https://rwxllvnuuxabvgxpeuma.supabase.co/rest/v1/main_purposes?select=*" \
  -H "apikey: [本番API Key]" > production_main_purposes.json

curl "https://rwxllvnuuxabvgxpeuma.supabase.co/rest/v1/sub_purposes?select=*" \
  -H "apikey: [本番API Key]" > production_sub_purposes.json

curl "https://rwxllvnuuxabvgxpeuma.supabase.co/rest/v1/default_items?select=*" \
  -H "apikey: [本番API Key]" > production_default_items.json

curl "https://rwxllvnuuxabvgxpeuma.supabase.co/rest/v1/travel_rules?select=*" \
  -H "apikey: [本番API Key]" > production_travel_rules.json

# 2. 開発環境のマスターデータクリア（ローカルのみ）
psql "postgresql://postgres:postgres@localhost:54322/postgres" -c \
  "TRUNCATE main_purposes, sub_purposes, default_items, travel_rules RESTART IDENTITY CASCADE;"

# 3. 本番データの開発環境投入
node sync_master_data.js  # JSONをSQLに変換して投入

# 4. 同期状態の記録
echo "$(date): Production sync completed" >> sync_history.log
git add production_*.json sync_history.log
git commit -m "🔄 Production master data sync - $(date +%Y-%m-%d)"
```

#### **定期同期スケジュール**
- **メジャーアップデート前**: 必須実行
- **マイナーアップデート前**: 推奨実行
- **月次定期実行**: データ整合性確保
- **機能追加時**: マスターデータ変更確認後実行

#### **同期確認・検証プロセス**
```bash
# 同期後の確認コマンド
echo "=== Master Data Count Verification ==="
psql "$LOCAL_DB" -c "
SELECT 'main_purposes' as table_name, count(*) as count FROM main_purposes
UNION ALL
SELECT 'sub_purposes', count(*) FROM sub_purposes  
UNION ALL
SELECT 'default_items', count(*) FROM default_items
UNION ALL
SELECT 'travel_rules', count(*) FROM travel_rules;"

# 重複データ確認
psql "$LOCAL_DB" -c "
SELECT table_name, duplicate_count FROM (
  SELECT 'sub_purposes' as table_name, count(*) - count(DISTINCT name) as duplicate_count FROM sub_purposes
  UNION ALL
  SELECT 'main_purposes', count(*) - count(DISTINCT name) FROM main_purposes
) t WHERE duplicate_count > 0;"
```

#### **バージョン履歴管理**
- **sync_history.log**: 同期実行履歴
- **Git タグ**: `sync-YYYY-MM-DD` 形式でバージョン管理
- **Migration記録**: `/supabase/migrations/` 内でスキーマ変更を管理
- **バックアップ保持**: 直近3回分の同期データを保持

#### **絶対禁止事項（同期関連）**
- ❌ **本番環境への書き込み**: 同期は常に読み取り専用
- ❌ **部分的な同期**: 一部テーブルのみの同期は整合性を破綻させる
- ❌ **手動データ投入**: 本番未反映のマスターデータ追加禁止
- ❌ **RLS設定の無断変更**: セキュリティ設定は本番環境に合わせる
- ❌ **同期記録の省略**: バージョン管理なしの同期は事故の元

#### **同期失敗時の復旧手順**
1. **Migration履歴からの復旧**: 直前の正常な状態に戻す
2. **バックアップからの復元**: sync_history.logから正常バージョン特定
3. **段階的再同期**: テーブル単位での部分的再実行
4. **整合性チェック**: 外部キー制約・データ関連性の確認