# ローカル開発環境でのメール設定ガイド

## 🎯 目的
本番環境のメール送信制限を回避し、安全にメール機能をテストする

## 📧 推奨設定

### 1. Supabase CLI + Mailpit（推奨）
Supabase CLIには標準でMailpitが組み込まれています。

#### セットアップ手順
```bash
# Supabase CLIのインストール
brew install supabase/tap/supabase

# プロジェクトの初期化
supabase init

# ローカル環境の起動
supabase start
```

#### Mailpitへのアクセス
- URL: http://localhost:54324
- すべてのメールがここにキャプチャされます
- 実際のメール送信は発生しません

### 2. 環境変数による制御
`.env.local`ファイルで開発環境を明示：

```env
# 開発環境フラグ
REACT_APP_ENV=development

# テスト用メールアドレス（実在するもの）
REACT_APP_TEST_EMAIL=shin1yokota@gmail.com

# Mailpit使用フラグ
REACT_APP_USE_MAILPIT=true
```

### 3. コード側の実装
```javascript
// lib/supabase.js
const isDevelopment = process.env.REACT_APP_ENV === 'development';
const useMailpit = process.env.REACT_APP_USE_MAILPIT === 'true';

if (isDevelopment && useMailpit) {
  console.log('📧 開発環境: メールはMailpit (localhost:54324) でキャプチャされます');
}

// 開発環境でのメール送信スキップオプション
export const authOptions = {
  auth: {
    autoConfirmEmail: isDevelopment, // 開発環境では自動確認
    enableEmailConfirmation: !isDevelopment // 本番のみメール確認
  }
};
```

## ⚠️ 注意事項

### 絶対に避けるべきこと
- ❌ 架空のドメインを使用（@test.com、@example.com等）
- ❌ 存在しないメールアドレスでのテスト
- ❌ 本番環境での頻繁なテストメール送信
- ❌ メール確認なしでの大量アカウント作成

### 推奨プラクティス
- ✅ ローカルではMailpitを使用
- ✅ ステージング環境では専用のSMTPサービス
- ✅ 本番環境移行前にカスタムSMTP設定
- ✅ レート制限の監視とアラート設定

## 🔧 トラブルシューティング

### Mailpitが起動しない場合
```bash
# ポートの確認
lsof -i :54324

# Supabaseの再起動
supabase stop
supabase start
```

### メールが届かない場合
1. Mailpit UI (localhost:54324) を確認
2. ブラウザのコンソールでエラーを確認
3. Supabaseダッシュボードでログを確認

## 📚 参考リンク
- [Supabase Local Development](https://supabase.com/docs/guides/cli/local-development)
- [Testing Auth Emails](https://supabase.com/docs/guides/cli/testing-emails)
- [Custom SMTP Configuration](https://supabase.com/docs/guides/auth/auth-smtp)