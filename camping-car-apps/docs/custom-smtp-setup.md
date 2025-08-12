# カスタムSMTP設定ガイド

## 🚨 なぜカスタムSMTPが必要か

### Supabaseデフォルトメールの制限
1. **送信先制限**: チームメンバーのメールアドレスのみ
2. **レート制限**: 1時間あたり2通まで
3. **SLA保証なし**: 本番環境での使用は非推奨

### 現在の問題
- デフォルトSMTPでは実質的にメール機能が使えない
- 新規ユーザー登録、パスワードリセットが機能しない

## 📧 推奨：Resendでの設定手順

### 1. Resendアカウント作成
1. [Resend](https://resend.com)にアクセス
2. 無料アカウント作成（100通/日まで無料）
3. メールアドレス認証を完了

### 2. APIキー取得
```bash
# Resendダッシュボードから
1. API Keys セクションへ移動
2. Create API Key をクリック
3. キーをコピー（re_xxxxx形式）
```

### 3. SMTP認証情報取得
```
SMTPホスト: smtp.resend.com
SMTPポート: 465（SSL）または 587（STARTTLS）
ユーザー名: resend
パスワード: [APIキー]
```

### 4. Supabaseでの設定

#### A. Supabaseダッシュボードで設定
1. プロジェクトダッシュボードにアクセス
2. Settings → Authentication → SMTP Settings
3. Enable Custom SMTP をオン
4. 以下を入力：
```
Sender email: no-reply@yourdomain.com
Sender name: Your App Name
Host: smtp.resend.com
Port: 587
Username: resend
Password: [ResendのAPIキー]
```
5. Save をクリック

#### B. 環境変数での管理（推奨）
`.env.local`:
```env
# カスタムSMTP設定
SMTP_HOST=smtp.resend.com
SMTP_PORT=587
SMTP_USER=resend
SMTP_PASS=re_xxxxxxxxxxxxx
SMTP_FROM=no-reply@yourdomain.com
SMTP_FROM_NAME=Your App Name
```

## 🔧 その他のSMTPプロバイダー

### SendGrid
```
Host: smtp.sendgrid.net
Port: 587
Username: apikey
Password: [SendGrid APIキー]
```

### AWS SES（東京リージョン）
```
Host: email-smtp.ap-northeast-1.amazonaws.com
Port: 587
Username: [IAMユーザーのSMTP認証情報]
Password: [IAMユーザーのSMTPパスワード]
```

### Postmark
```
Host: smtp.postmarkapp.com
Port: 587
Username: [Server API Token]
Password: [Server API Token]
```

## ✅ 設定後の確認

### 1. テストメール送信
```javascript
// Supabaseコンソールから
await supabase.auth.resetPasswordForEmail('your-email@example.com')
```

### 2. ログ確認
- Supabaseダッシュボード → Logs → Auth
- SMTPプロバイダーのダッシュボード

### 3. 配信率モニタリング
- バウンス率
- スパム判定率
- 配信成功率

## ⚠️ 注意事項

### やってはいけないこと
- ❌ 本番環境でデフォルトSMTPを使用
- ❌ APIキーをコードに直接記載
- ❌ テスト環境と本番環境で同じSMTP設定を使用

### ベストプラクティス
- ✅ 環境ごとに異なるSMTP設定
- ✅ APIキーは環境変数で管理
- ✅ SPF、DKIM、DMARCの設定
- ✅ 送信元ドメインの認証

## 📊 コスト比較

| プロバイダー | 無料枠 | 追加料金 |
|------------|--------|----------|
| Resend | 100通/日 | $20/月で10,000通 |
| SendGrid | 100通/日 | $19.95/月で40,000通 |
| AWS SES | 62,000通/月 | $0.10/1,000通 |
| Postmark | 100通/月 | $15/月で10,000通 |
| Brevo | 300通/日 | €19/月で20,000通 |

## 🚀 次のステップ

1. **開発環境**: Resend無料プランで開始
2. **ステージング**: 同じResendアカウントの別APIキー
3. **本番環境**: 必要に応じて有料プラン検討

## 📚 参考リンク
- [Supabase Custom SMTP](https://supabase.com/docs/guides/auth/auth-smtp)
- [Resend Documentation](https://resend.com/docs)
- [Email Deliverability Best Practices](https://resend.com/docs/deliverability)