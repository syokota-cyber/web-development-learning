# ソーシャルログイン設定ガイド

## 🔐 Supabaseでソーシャルログインを追加する方法

### Googleログインの設定手順

#### 1. Google Cloud Console設定
1. [Google Cloud Console](https://console.cloud.google.com/)にアクセス
2. 新規プロジェクト作成または既存プロジェクト選択
3. 「APIとサービス」→「認証情報」
4. 「認証情報を作成」→「OAuth 2.0 クライアント ID」
5. アプリケーションの種類：ウェブアプリケーション
6. 承認済みリダイレクトURI：
   ```
   https://[YOUR-PROJECT-REF].supabase.co/auth/v1/callback
   ```
7. Client IDとClient Secretをコピー

#### 2. Supabase設定
1. Supabaseダッシュボード → Authentication → Providers
2. Googleを有効化
3. Client IDとClient Secretを貼り付け
4. Save

#### 3. コード実装
```javascript
// Googleでログイン
const signInWithGoogle = async () => {
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: 'google',
    options: {
      redirectTo: window.location.origin
    }
  });
};

// ボタン実装
<button onClick={signInWithGoogle}>
  Googleでログイン
</button>
```

### メール認証 vs ソーシャルログイン

| 項目 | メール認証 | ソーシャルログイン |
|------|-----------|------------------|
| **実装難易度** | 中（メールサーバー必要） | 簡単 |
| **ユーザー体験** | 面倒（メール確認） | 簡単（1クリック） |
| **メールサーバー** | 必要 | 不要 |
| **コスト** | あり（Resend等） | 無料 |
| **信頼性** | 高い | 最高（Google等） |
| **プライバシー** | 良い | Googleに依存 |

### 併用がベスト

多くのサービスは両方提供：
```
━━━━━━━━━━━━━━━━━━
  🔵 Googleでログイン
  🐙 GitHubでログイン
━━━━━━━━━━━━━━━━━━
      または
  📧 メールで登録
━━━━━━━━━━━━━━━━━━
```

## コスト比較

### メール認証のみ
- Resend: 100通/月まで無料
- 超過: $20/月〜

### ソーシャルログインのみ
- Google OAuth: 完全無料
- メールサーバー: 不要

### 併用（推奨）
- 多くのユーザーはGoogle選択 → メール送信減少
- メール派も対応 → 全ユーザーカバー

## まとめ

1. **小規模（〜100人/月）**: 現状のまま（Resend無料）で十分
2. **中規模（〜1000人/月）**: ソーシャルログイン追加を推奨
3. **大規模（1000人〜）**: 併用必須、Resend有料プラン検討