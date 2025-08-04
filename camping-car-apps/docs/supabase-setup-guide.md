# 🚀 Supabaseプロジェクト作成ガイド

## 📋 事前準備
- Supabaseアカウント（既にお持ちとのこと）
- プロジェクト名: `travel-journal` または `camping-car-journal`

## 🔧 Step 1: ブラウザでプロジェクト作成

### 1.1 Supabaseダッシュボードにアクセス
```
https://supabase.com/dashboard
```

### 1.2 新規プロジェクト作成
1. **「New project」** ボタンをクリック
2. 以下の情報を入力：
   - **Project name**: `travel-journal`
   - **Database Password**: 強力なパスワードを生成（保存しておく）
   - **Region**: `Northeast Asia (Tokyo)` を選択
   - **Pricing Plan**: Free tier でOK

3. **「Create new project」** をクリック
4. プロジェクトの初期化を待つ（1-2分）

## 🔗 Step 2: CLIとプロジェクトを連携

### 2.1 プロジェクト情報の取得
ダッシュボードから以下を確認：
- **Project URL**: `https://xxxxx.supabase.co`
- **Anon Key**: `eyJhbGci...` （長い文字列）
- **Project Ref**: `xxxxx` （URLの一部）

### 2.2 CLIでログイン
```bash
# ターミナルで実行
cd /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps

# Supabaseにログイン（ブラウザが開く）
supabase login
```

### 2.3 プロジェクトとリンク
```bash
# プロジェクトIDを使ってリンク
supabase link --project-ref your-project-ref

# 例：
# supabase link --project-ref abcdefghijklmnop
```

## 📝 Step 3: 環境変数の設定

### 3.1 .env.localファイルを作成
```bash
# プロジェクトルートに作成
touch .env.local
```

### 3.2 環境変数を記入
```env
# Supabaseの設定（ダッシュボードから取得）
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGci...（長い文字列）

# 開発用（オプション）
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...（サービスロールキー）
```

## 🗄️ Step 4: データベースのセットアップ

### 4.1 マイグレーションを実行
```bash
# ローカルで開発する場合
supabase start

# 本番環境に反映する場合
supabase db push
```

### 4.2 マイグレーション確認
```bash
# 実行されたマイグレーションを確認
supabase migration list
```

## ✅ Step 5: 動作確認

### 5.1 Supabase Studioで確認
1. ダッシュボードの「Table Editor」を開く
2. 作成されたテーブルを確認：
   - profiles
   - trips
   - purposes
   - items
   - reviews

### 5.2 認証設定の確認
1. 「Authentication」→「Providers」
2. 「Email」が有効になっていることを確認
3. 「Email Auth」の設定：
   - **Enable Email Confirmations**: OFF（開発時）
   - **Enable Email One-Time Password (Magic Link)**: ON

## 🎯 Step 6: マジックリンクの設定

### 6.1 メールテンプレートの確認
1. 「Authentication」→「Email Templates」
2. 「Magic Link」テンプレートを確認
3. 必要に応じて日本語化

### 6.2 リダイレクトURLの設定
1. 「Authentication」→「URL Configuration」
2. 「Site URL」: `http://localhost:3000`（開発時）
3. 「Redirect URLs」に追加：
   - `http://localhost:3000/*`
   - `https://your-domain.com/*`（本番用）

## 🚨 トラブルシューティング

### プロジェクトが作成できない場合
- 無料枠の制限（2プロジェクトまで）を確認
- 不要なプロジェクトを削除

### CLIでリンクできない場合
```bash
# プロジェクト一覧を確認
supabase projects list

# 手動でproject-refを確認
# ダッシュボードのSettings → General → Reference ID
```

### マイグレーションエラーの場合
```bash
# ローカルDBをリセット
supabase db reset

# マイグレーションを再実行
supabase db push
```

## 📱 次のステップ

1. **Reactアプリの作成**
   ```bash
   npx create-react-app travel-journal
   cd travel-journal
   npm install @supabase/supabase-js
   ```

2. **Supabaseクライアントの初期化**
   ```javascript
   // src/lib/supabase.js
   import { createClient } from '@supabase/supabase-js'
   
   const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
   const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
   
   export const supabase = createClient(supabaseUrl, supabaseAnonKey)
   ```

---

準備ができたら、実際の実装を開始できます！