# 🎓 Web開発学習プロジェクト

React基礎から始める段階的Web開発学習リポジトリ

## 📋 プロジェクト概要

このリポジトリは、Claude Codeを使用したReactとWeb開発の学習記録です。基礎概念から実践的なアプリケーション作成まで、段階的に学習を進めています。

## 🎯 学習目標

- [x] HTML/CSS/JavaScriptの基礎理解
- [x] Reactの基本概念（コンポーネント、JSX）
- [x] Props（プロパティ）の使い方
- [x] State（状態管理）とuseState
- [x] イベントハンドリング
- [x] リスト表示とmap関数
- [x] フォーム処理とバリデーション
- [ ] データ永続化（localStorage）
- [ ] 本格的なReactプロジェクト構築

## 📁 ファイル構成

### 🎨 基礎学習ファイル
- `index.html` - 初期のHTML/CSS学習
- `profile.html` - プロフィールページ作成
- `styles.css` - CSS スタイリング
- `script.js` - JavaScript基礎

### ⚛️ React学習ファイル
- `ProfileCard.js` - 最初のReactコンポーネント
- `ReusableProfileCard.js` - Props対応版コンポーネント  
- `InteractiveProfile.js` - State対応版コンポーネント

### 🖥️ デモアプリケーション
- `react-demo.html` - React基礎デモ（コンポーネント、Props、State）
- `advanced-react-demo.html` - 高機能Todoアプリ（リスト、フォーム、フィルタリング）
- `data-explanation-demo.html` - データ保存の仕組み解説

### 🛠️ 設定ファイル
- `CLAUDE.md` - 学習重視開発ルール
- `.gitignore` - Git除外設定

## 🚀 実行方法

### 基本デモの確認
```bash
# React基礎デモを開く
open react-demo.html

# 高機能Todoアプリを開く  
open advanced-react-demo.html

# データ保存の仕組み解説を開く
open data-explanation-demo.html
```

### 開発者ツールでの確認
ブラウザの開発者ツール（F12）で以下を確認できます：
- Consoleでエラーやログ
- ApplicationタブでlocalStorageの内容
- Elementsタブで動的DOM変更

## 📚 学習進捗

### Phase 1: 基礎概念 ✅
- HTML構造とCSS スタイリング
- JavaScript DOM操作
- React コンポーネントの概念

### Phase 2: React基礎 ✅  
- JSX記法の理解
- Props による外部データ受け渡し
- State による内部状態管理
- イベントハンドラーの実装

### Phase 3: 実践的機能 ✅
- 配列データのリスト表示（map関数）
- フォーム入力とバリデーション
- データフィルタリング機能
- 統計情報の動的計算

### Phase 4: データ管理 🔄
- [ ] localStorage による永続化
- [ ] アプリ間のデータ連携
- [ ] より複雑な状態管理

### Phase 5: 発展 📅
- [ ] Create React App環境構築
- [ ] コンポーネント設計パターン
- [ ] パフォーマンス最適化

## 🎓 学習のポイント

### 段階的アプローチ
- 一度に多くを実装せず、小さな単位で進行
- 各概念を確実に理解してから次のステップへ
- エラーを恐れず実際にコードを書いて学習

### 重要な概念
1. **コンポーネント思考** - UIを再利用可能な部品として捉える
2. **Props vs State** - 外部データと内部状態の使い分け
3. **イベント駆動** - ユーザー操作に応じた動的UI更新
4. **データフロー** - 親から子への一方向データ流れ

## 🛠️ 技術スタック

- **Frontend**: React 18 (CDN版)
- **Build Tool**: Babel Standalone（学習目的）
- **Styling**: Vanilla CSS
- **Development**: Claude Code + ローカルブラウザ

## 📝 メモ

### 学習方法
- 概念説明 → コード例 → 実践 → 理解確認の循環
- 段階的に機能を追加して複雑性を管理
- 実際に動作するものを作って体感的に学習

### 次の学習計画
1. 既存アプリにlocalStorage永続化を追加
2. プロフィールカードと学習管理アプリの統合
3. Create React Appでの本格的な開発環境構築

## 🤝 学習パートナー

このプロジェクトは[Claude Code](https://claude.ai/code)を使用して段階的に学習を進めています。

---

**最終更新**: 2025年1月  
**学習者**: ショコたんご  
**進捗**: React基礎完了、実践的機能実装中