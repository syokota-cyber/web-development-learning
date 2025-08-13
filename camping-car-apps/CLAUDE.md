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