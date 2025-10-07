# 🚨 緊急修正指示 - Invalid API Key問題

**日付**: 2025年8月8日  
**ステータス**: 要手動対応

---

## 📋 **問題サマリー**

昨日（8月7日）から継続しているSupabase認証エラーを調査した結果：

### **根本原因**
- 使用中の全てのAPIキーが無効
- Legacy JWT Secret: 期限切れまたはローテーション済み
- Publishable Key: 形式がサポートされていない

### **影響範囲**
- ローカル開発環境: 認証不可
- 本番環境（Vercel）: 認証不可
- 全ユーザー機能: 利用不可

---

## ⚡ **即座に実行すべき対応**

### **1. Supabaseダッシュボードでの確認** ⏰ **最優先**

```
1. https://supabase.com にアクセス
2. プロジェクト "camping-car-journal" (ID: rwxllvnuuxabvgxpeuma) を選択
3. Settings → API を開く
4. 以下をメモ:
   - Project URL: https://rwxllvnuuxabvgxpeuma.supabase.co ✅
   - anon public key: eyJ...で始まるJWT （これが必要！）
```

### **2. ローカル環境の修正**

`.env.local` ファイルを作成:
```bash
REACT_APP_SUPABASE_URL=https://rwxllvnuuxabvgxpeuma.supabase.co
REACT_APP_SUPABASE_ANON_KEY=[ダッシュボードから取得したanon key]
```

開発サーバー再起動:
```bash
npm start
```

### **3. Vercel環境変数の更新**

```
1. https://vercel.com → travel-journal プロジェクト
2. Settings → Environment Variables
3. REACT_APP_SUPABASE_ANON_KEY を新しい値で更新
4. Deploy → Redeploy 実行
```

---

## 🔍 **実行済み調査結果**

### **テスト済みキー（全て無効）**
- ❌ Legacy JWT: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
- ❌ Publishable: `sb_publishable_iocv0OdvU4tJ1ENbCGskug_hOaJccJr`

### **Supabaseプロジェクト状態**
- ✅ プロジェクト: 正常動作
- ✅ データベース: 接続可能
- ✅ JWKS エンドポイント: 応答正常

---

## 📁 **修正済みファイル**

1. ✅ `src/lib/supabase.js` - デバッグ情報追加、エラーメッセージ改善
2. ✅ `API_KEY_FIX_GUIDE.md` - 詳細修正手順
3. ✅ 各種ログファイル確認完了

---

## ⚠️ **重要な注意事項**

### **キーの種類を理解する**
- **anon key**: クライアント側で使用（通常 `eyJ...` で始まる）
- **service_role key**: サーバーサイドのみ（絶対にクライアントで使用禁止）
- **publishable key**: 新形式だが現在サポート外

### **セキュリティ**
- anon keyはRLS有効時にクライアント側で安全
- 環境変数更新後は必ず再起動
- service_role keyは絶対に公開しない

---

## ✅ **動作確認方法**

修正後、以下で確認:

```javascript
// ブラウザコンソールで確認すべき出力
🔍 Supabase設定デバッグ情報 (2025-08-08):
URL: https://rwxllvnuuxabvgxpeuma.supabase.co
Key exists: true
Key prefix: eyJ...

// エラーが出ないこと
❌ Missing Supabase environment variables
❌ Invalid API key
```

---

**⏰ 修正完了までの推定時間: 10-15分**  
**🔧 必要な作業: ダッシュボードからキー取得 → 環境変数更新 → 再起動**

この指示書は修正完了後削除してください。
