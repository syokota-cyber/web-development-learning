# 🎓 Web開発学習プロジェクト

Claude Codeを使った段階的Web開発学習の記録

## 📂 プロジェクト一覧

### 1. web-development (React基礎)
**期間**: 2025年7月19日  
**ステータス**: ✅ 完了  
**技術**: HTML, CSS, JavaScript, React基礎  
**成果**:
- プロフィールカード作成
- インタラクティブコンポーネント
- React基本概念の理解
- Todo アプリ（リスト、フォーム、フィルタリング）
- データ永続化の仕組み解説

### 2. node-basic-webserver (Node.js基礎)
**期間**: 2025年7月20日  
**ステータス**: ✅ 基礎完了  
**技術**: Node.js, HTTP, ファイル操作, JSON  
**成果**:
- ✅ HTTPサーバー作成
- ✅ URLルーティング実装
- ✅ 外部ファイル方式の理解
- ✅ 設定ファイル管理機能
- ✅ アクセスログ機能
- 🔄 ユーザーデータ保存機能（次回）

## 📈 学習進捗

### 完了した概念
- [x] HTML/CSS基礎
- [x] JavaScript基礎
- [x] React基本概念（コンポーネント、Props、State）
- [x] Node.js HTTP server
- [x] URLルーティング
- [x] ファイル読み書き
- [x] JSON操作
- [x] 非同期処理

### 現在学習中
- [x] Node.js ファイル操作
- [ ] データベース基礎
- [ ] ユーザー認証
- [ ] React + Node.js連携

### 次に学ぶ予定
- [ ] データベース連携 (SQLite)
- [ ] 認証システム
- [ ] リアルタイム通信 (WebSocket)
- [ ] デプロイメント

## 🎯 学習方針

CLAUDE.mdに基づく段階的学習を実践：
1. **最小単位から開始** - 一度に5行以内のコード
2. **理解確認重視** - 各段階で概念を確認
3. **実践重視** - 実際に動くものを作成
4. **選択肢提示** - 複数のアプローチを比較検討

## 📝 学習メモ

### React基礎で学んだ重要概念
- コンポーネント思考 - UIを再利用可能な部品として捉える
- Props vs State - 外部データと内部状態の使い分け
- イベント駆動 - ユーザー操作に応じた動的UI更新
- データフロー - 親から子への一方向データ流れ

### Node.js基礎で学んだ重要概念
- `require()` - モジュール読み込み
- `fs` - ファイルシステム操作
- `http.createServer()` - HTTPサーバー作成
- 非同期処理 - コールバック関数
- JSON操作 - `JSON.parse()` / `JSON.stringify()`

### 実装したアーキテクチャ
```
クライアント（ブラウザ）
      ↓ HTTP Request
サーバー（Node.js）
      ↓ ファイル操作
ファイルシステム（設定、ログ）
```

## 🔄 次回の学習予定

1. **ユーザーデータ保存機能**
   - フォーム作成
   - データの CRUD 操作
   - JSON ファイルベース簡易DB

2. **データベース連携**
   - SQLite導入
   - SQL基礎
   - データ永続化

3. **React + Node.js 連携**
   - API作成
   - フロントエンド・バックエンド分離
   - SPA（Single Page Application）構築

## 🛠️ 技術スタック

- **Frontend**: React 18 (CDN版), HTML5, CSS3, JavaScript ES6+
- **Backend**: Node.js, HTTP module
- **Data**: JSON files, ファイルシステム
- **Development**: Claude Code + ローカルブラウザ

## 🤝 学習パートナー

このプロジェクトは[Claude Code](https://claude.ai/code)を使用して段階的に学習を進めています。

---

**最終更新**: 2025年7月20日  
**学習者**: ショコたんご  
**進捗**: React基礎完了、Node.js基礎完了、データベース学習準備中
