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