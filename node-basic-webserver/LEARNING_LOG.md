# Node.js基礎学習ログ - 2025年7月20日

## 🎯 本日の学習目標
段階的にNode.jsの基礎を学習し、実用的なWebサーバーを構築する

## 📚 学習した概念

### 1. Node.js基礎
- **HTTPサーバー作成**: `http.createServer()`
- **ルーティング**: URL別の処理分岐
- **レスポンス制御**: HTML, JSON, CSS, JSの配信
- **エラーハンドリング**: 404ページの実装

### 2. ファイル操作
- **同期読み込み**: `fs.readFileSync()`
- **非同期読み込み**: `fs.readFile()`
- **ファイル追記**: `fs.appendFile()`
- **JSON操作**: `JSON.parse()` / `JSON.stringify()`

### 3. アーキテクチャ理解
- **インライン方式**: server.js内にHTMLを埋め込み
- **外部ファイル方式**: HTML/CSS/JSを分離
- **静的ファイル配信**: Content-Type設定の重要性

## 🛠️ 実装した機能

### ✅ 基本Webサーバー
```javascript
// 最小構成から開始
const server = http.createServer((req, res) => {
  res.end('Hello, Node.js World!');
});
```

### ✅ URLルーティング
- `/` - ホームページ
- `/api` - JSON API
- `/weather` - 動的天気情報
- `/config` - 設定管理
- `/logs` - アクセスログ

### ✅ 設定ファイル管理
- `config.json` 読み書き
- 動的設定変更（ポート番号など）
- エラーハンドリング付き

### ✅ アクセスログ機能
- 全リクエストの記録
- ファイル出力（`access.log`）
- リアルタイム統計表示
- メモリキャッシュ（最新100件）

## 🔧 技術的な学び

### ファイル間連携の仕組み
```
ブラウザ → server.js（配達員）
            ↓
        public/index.html（設計図）
            ↓
        public/style.css（装飾）
            ↓
        public/script.js（動力）
```

### ログ記録の仕組み
```javascript
function logAccess(req, res, statusCode) {
  // 1. データ収集
  const logEntry = { timestamp, ip, method, url, statusCode };
  
  // 2. ファイル保存
  fs.appendFile('access.log', logLine);
  
  // 3. メモリ保存
  global.accessLogs.push(logEntry);
}
```

## 📊 作成したファイル構成

```
node-basic-webserver/
├── server.js           # メインサーバーファイル
├── config.json         # 設定ファイル
├── access.log          # アクセスログ
├── public/
│   ├── index.html      # ホームページ
│   ├── style.css       # スタイルシート
│   └── script.js       # クライアントサイドJS
└── LEARNING_LOG.md     # 本ファイル
```

## 🎉 理解できた重要概念

### 1. require()の役割
```javascript
const http = require('http');  // 道具箱から工具を取り出す
```

### 2. 非同期処理
```javascript
getWeatherData((data) => {     // コールバック関数
  res.end(generateHTML(data)); // データ受信後に実行
});
```

### 3. Content-Type の重要性
```javascript
// HTML配信
res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});

// JSON配信  
res.writeHead(200, {'Content-Type': 'application/json'});
```

## 🔄 次回への継続

### 学習予定
1. **ユーザーデータ保存機能**
   - フォーム作成
   - データCRUD操作
   - 簡易データベース

2. **セキュリティ強化**
   - 入力検証
   - 基本認証
   - 権限管理

3. **パフォーマンス向上**
   - キャッシュ機能
   - ログローテーション
   - 負荷対策

### 現在の理解度
- Node.js基礎: ⭐⭐⭐⭐⭐ (5/5)
- ファイル操作: ⭐⭐⭐⭐⭐ (5/5)
- ルーティング: ⭐⭐⭐⭐⭐ (5/5)
- 非同期処理: ⭐⭐⭐⭐☆ (4/5)
- セキュリティ: ⭐⭐☆☆☆ (2/5)

## 💡 学習のコツ（気づき）
1. **段階的実装**: 一度に全機能を作らず、動くものから拡張
2. **エラー体験**: わざと間違えて、修正過程で理解を深める
3. **仕組み理解**: 「何が」「なぜ」「どのように」を意識
4. **実用重視**: 実際に使える機能を作ることでモチベーション維持

---

# React + Node.js 連携学習ログ - 2025年7月21日

## 🎯 今日の学習目標
React + Node.js連携を既存プロジェクトを活用して段階的に学習する

## 📚 学習内容と成果

### ✅ 習得した技術概念

#### 1. **同一サーバー内でのReact配信方式**
- Node.jsサーバーからReactアプリを配信する仕組み
- テンプレート方式の理解
- CORS問題の回避方法

#### 2. **段階的実装手法**
- ステップ1: 静的HTML → ステップ3: React基本 → ステップ4: 入力処理 → ステップ5: API連携
- 一度に5行以内のコード追加
- エラー原因の特定と解決

#### 3. **React基礎**
- CDN方式でのReact導入
- `React.createElement`の使用
- `useState`による状態管理
- イベントハンドリング（`onClick`, `onChange`）

#### 4. **API連携**
- `fetch`を使った非同期通信
- 複数APIエンドポイントの活用（`/api`, `/logs/api`）
- JSONデータの表示

### 🛠️ 実装したファイル

#### 新規作成ファイル
- `public/react-step1.html` - 静的HTML + React CDN + 基本コンポーネント
- `public/react-step4.html` - 入力とリアルタイム更新
- `public/react-step5.html` - API切り替えアプリ

#### 修正ファイル
- `server.js` - 新しいルート追加（/react-step1, /react-step4, /react-step5）

### 🚀 次回学習予定
- テンプレート方式の活用
- より実用的なReactアプリ
- Vercel Functions（サーバーレス）

## 🎉 今日の最大の成果
**React + Node.js API連携アプリ完成**: 2つのボタンで異なるAPIを呼び出し、結果をリアルタイム表示