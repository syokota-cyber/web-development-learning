# Supabase セキュリティ修正手順

## 📅 実施日: 2025年8月13日

## 🔴 修正が必要な問題

### 1. RLS（Row Level Security）エラー - 6件
以下のテーブルでRLSが無効になっています：
- `purpose_categories`
- `trip_purposes`
- `main_purposes`
- `sub_purposes`
- `default_items`
- `trip_checklists`

### 2. Auth関連の警告 - 2件
- **OTP Long Expiry**: OTPの有効期限が長すぎる
- **Leaked Password Protection**: パスワード漏洩保護が無効

### 3. Function Search Path Mutable - 2件
- `handle_new_user`
- `update_travel_rules_updated_at`

## 🛠️ 修正方法

### ステップ1: Migrationファイルの適用

作成した3つのmigrationファイルを適用：

1. **RLSの有効化**
   - ファイル: `20250813_enable_rls_security.sql`
   - 内容: 6つのテーブルにRLSを有効化し、適切なポリシーを設定

2. **関数のsearch_path修正**
   - ファイル: `20250813_fix_function_search_path.sql`
   - 内容: 関数に明示的なsearch_pathを設定

### ステップ2: Supabase Dashboardでの設定

1. **Supabase Dashboard**にログイン
2. プロジェクト `camping-car-journal` を選択

#### SQLエディタでMigration実行：
1. SQL Editor → New Query
2. 各migrationファイルの内容をコピー＆ペースト
3. 順番に実行：
   - `20250813_enable_rls_security.sql`
   - `20250813_fix_function_search_path.sql`

#### Auth設定の修正（Dashboard上で）：
1. **Authentication → Providers → Email**
   - OTP Expiry: `3600`秒（1時間）に設定

2. **Authentication → Auth Settings**
   - Password Leak Protection: 有効にする

### ステップ3: 確認

1. **Security Advisor**を再度確認
2. エラーと警告が解消されていることを確認

## 📝 注意事項

- RLSポリシーは現在、読み取りは全員許可、書き込みは認証ユーザーのみに設定
- `trip_checklists`テーブルは、ユーザー固有のデータなので、自分のデータのみアクセス可能
- Auth設定はDashboard上でのみ変更可能（SQLでは変更できない）

## 🔒 セキュリティベストプラクティス

1. **最小権限の原則**: 必要最小限のアクセス権限のみ付与
2. **RLS必須**: publicスキーマのすべてのテーブルでRLSを有効化
3. **関数のsearch_path**: セキュリティ定義関数には明示的なsearch_pathを設定
4. **定期的な監査**: Security Advisorを定期的にチェック