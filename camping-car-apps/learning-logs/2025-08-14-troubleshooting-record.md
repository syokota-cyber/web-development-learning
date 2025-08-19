# 🔍 トラブルシューティング詳細記録 - 2025年8月14日

## 📋 問題の概要
**症状**: 本番環境で「旅行を開始」ボタンを押すと「ルール・マナーを確認中...」の表示で画面が固まる
**影響**: PCでは動作するがスマホで固まる → 後にフルーツ狩り選択時に固まることが判明
**開始時刻**: 09:00
**解決時刻**: 17:30

## 🔄 試行錯誤の記録

### ❌ 失敗した対策1: RLS設定の追加（初回）
**仮説**: `travel_rules`テーブルにRLSが設定されていない
**実施内容**: 
```sql
-- /supabase/migrations/20250814_add_travel_rules_rls.sql を作成
ALTER TABLE travel_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE trip_rule_confirmations ENABLE ROW LEVEL SECURITY;
```
**結果**: ❌ 効果なし
**失敗理由**: 既存のMigration（`20250201_create_rules_manners.sql`）で既にRLS設定済みだった

### ❌ 失敗した対策2: RLSの再有効化
**仮説**: Supabase DashboardでRLSが無効化されている可能性
**実施内容**:
```sql
-- /supabase/migrations/20250814_fix_travel_rules_rls.sql を作成
ALTER TABLE travel_rules ENABLE ROW LEVEL SECURITY;
-- ポリシーの再作成
```
**結果**: ❌ 効果なし（"Success. No rows returned"は出たが問題解決せず）
**失敗理由**: RLS自体は有効だったが、別の問題があった

### ❌ 失敗した対策3: コンポーネントのエラーハンドリング改善（初回）
**仮説**: エラー処理が不適切でローディング状態が解除されない
**実施内容**: RulesConfirmation.jsxにタイムアウト処理とエラー表示を追加
**結果**: ❌ 根本解決にならず
**失敗理由**: エラーの根本原因を解決していない対症療法だった

### 🔍 転換点: デバッグログによる原因特定
**重要な発見**:
1. コンソールエラー: `403 (Forbidden)` - `trip_purposes`テーブルへのPOSTが拒否
2. エラーメッセージ: `new row violates row-level security policy for table "trip_purposes"`
3. `mainPurposeIds`が空配列 `[]` になっている
4. 「この目的地のルール・マナーはまだ登録されていません」と表示される

## ✅ 成功した最終対策

### 根本原因の特定:
1. **`trip_purposes`テーブルのRLSポリシーが不適切**
   - INSERT/UPDATE/DELETE権限が正しく設定されていない
2. **ルールデータの不足**
   - フルーツ狩りを含む複数のmain_purposesにルールが登録されていない
   - 一般ルールのみで特定ルールがない目的が多数存在

### 解決策の実装:
```sql
-- /supabase/migrations/20250814_fix_all_issues.sql

-- 1. trip_purposesのRLSポリシー修正
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

-- 2. 全main_purposesに一般ルール（3件）を追加
-- 3. 各目的に特定ルール（1-2件）を追加
-- フルーツ狩り、釣り、登山、海水浴など16種類全てに対応
```

## 📊 最終結果
- **全16種類のmain_purposes**に3〜5件のルールが登録完了
- **trip_purposes**の403エラー解決
- **PC/スマホ両環境**で正常動作確認

## 💡 教訓と学び

### 1. デバッグの重要性
- **最初からブラウザコンソールを確認すべきだった**
- 403エラーが出ていることに早く気づけば、RLSポリシーの問題だとすぐ分かった

### 2. 思い込みの危険性
- 「スマホだけで固まる」→「スマホ固有の問題」と思い込んだ
- 実際は「フルーツ狩り選択時」の問題だった
- 問題の再現条件を正確に把握することが重要

### 3. 段階的な問題解決
- 誤った仮説: RLSが無効 → コンポーネントの問題 → スマホ固有の問題
- 正しいアプローチ: エラーログ確認 → 403エラー特定 → RLSポリシー修正 → データ不足解消

### 4. 包括的な解決の重要性
- 部分的な修正（フルーツ狩りだけ）ではなく、全main_purposesに対して一括でルールを追加
- 将来の同様の問題を防ぐ予防的措置

## 🛠️ 今後の改善点

1. **エラー監視の強化**
   - 本番環境でのエラーログ収集システムの導入検討
   - Sentryなどのエラートラッキングツールの活用

2. **RLSポリシーの文書化**
   - 各テーブルのRLSポリシーを明確に文書化
   - ポリシー変更時の影響範囲を事前に把握

3. **データ整合性チェック**
   - 新しいmain_purposeを追加時に自動でルールも追加されるトリガーの検討
   - データ不足を検知する定期的なチェック機能

4. **開発プロセスの改善**
   - 本番環境の問題は、まずローカル環境で再現を試みる
   - ブラウザコンソールの確認を最優先にする
   - 思い込みを避け、事実（エラーログ）に基づいて対処する

## 📝 関連ファイル
- `/supabase/migrations/20250814_fix_all_issues.sql` - 最終的な解決策
- `/supabase/migrations/20250814_add_travel_rules_rls.sql` - 削除済み（不要だった）
- `/supabase/migrations/20250814_fix_travel_rules_rls.sql` - 中間対策
- `/src/components/RulesConfirmation.jsx` - デバッグログ追加（本番では削除予定）
- `/check_fruit_rules.sql` - 調査用SQL
- `/learning-logs/2025-08-14.md` - 当日の作業ログ

---

**作成日時**: 2025年8月14日 17:40
**作成者**: Claude Code with ショコたんご
**所要時間**: 8時間30分（多くの試行錯誤を含む）