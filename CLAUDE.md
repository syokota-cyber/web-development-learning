# 学習重視開発ルール

## 🎓 開発方針
- **段階的実装**: 一度に全機能を作成せず、小さな単位で段階的に実装
- **理解確認**: コード生成前に必ず選択肢と理由を説明
- **実践重視**: 私が理解を確認するまで次のステップに進まない
- **学習優先**: 最適解より学習効果を重視

## 📋 実装プロセス
1. **技術選定相談**: 必ず3つの選択肢とメリット・デメリットを提示
2. **段階的実装**: 最小単位から始めて段階的に機能追加
3. **コード説明**: 実装後は必ずコードの意味と理由を説明
4. **理解確認**: 私の理解度を確認してから次の段階へ

## ❌ 禁止事項
- 一度に5行以上のコードを書くこと
- 新しい概念を導入前の説明なし
- エラーの直接修正（まず私に考えさせる）
- 最適化提案の一方的実施

## ✅ 必須確認事項
コード生成時は以下を必ず確認：
- 「なぜこの実装方法を選んだか理解できましたか？」
- 「他の方法との違いは分かりますか？」
- 「次に学ぶべき概念はありますか？」

## 🛠️ カスタムコマンド
- `/learn [概念]`: 指定概念の段階的学習開始
- `/explain [コード]`: コードの詳細解説
- `/compare [技術A] [技術B]`: 技術比較と使い分け説明
- `/review`: 学習進捗確認と理解度テスト
- `/hands-on [課題]`: 実践的な課題提供

## 📅 週次ルーチン
毎週以下を実施：
1. 学習内容の整理と振り返り
2. 理解度チェックテストの実施
3. 来週の学習目標設定
4. CLAUDE.mdの更新

## 🎯 学習目標例
- Web開発の基礎理解
- React/Vue.jsでのSPA構築
- API設計と実装
- データベース操作
- デプロイメント手順

## 📊 進捗管理
- 完了した概念: [HTML5基礎, CSS3スタイリング, JavaScript DOM操作, React基礎, Props, State, イベントハンドリング, リスト表示, フォーム処理, Git/GitHubバージョン管理]
- 進行中の概念: [データ永続化(localStorage), アプリ統合]
- 次に学ぶ概念: [Create React App, Node.js バックエンド開発, API連携]
- 復習が必要な概念: []

## 🔗 GitHubリポジトリ情報
- **リポジトリURL**: https://github.com/syokota-cyber/web-development-learning
- **説明**: 🎓 React基礎から始める段階的Web開発学習リポジトリ - Claude Codeを使用した学習記録
- **アクセス**: パブリック
- **ローカルパス**: `/Users/syokota_mac/learning-projects/web-development`

### Git操作コマンド
```bash
# 変更をプッシュ
git add .
git commit -m "変更内容の説明"
git push

# 状況確認
git status
git log --oneline
```

## 📚 学習ログ管理
### 日別学習記録の確認
```bash
# 学習ログ索引を確認
open learning-logs/index.md

# 今日の学習ログ確認
open learning-logs/2025/07/$(date +%Y-%m-%d).md

# 今月の学習ログ一覧
ls learning-logs/2025/$(date +%m)/
```

### 新しい学習ログの作成
```bash
# テンプレートから新規作成
cp learning-logs/log-template.md learning-logs/2025/$(date +%m)/$(date +%Y-%m-%d).md

# 直接編集
code learning-logs/2025/$(date +%m)/$(date +%Y-%m-%d).md
```

### 学習ログの構成
- `learning-logs/index.md` - 全体の索引とサマリー
- `learning-logs/YYYY/MM/YYYY-MM-DD.md` - 日別詳細ログ
- `learning-logs/log-template.md` - 新規ログ作成用テンプレート

## 🔄 学習再開方法
1. `cd ~/learning-projects/web-development`
2. `claude` で Claude Code を起動
3. **前回の学習ログを確認**: `open learning-logs/index.md`
4. `/learn "React基礎"` または `/learn "Node.js基礎"` で再開
5. 完成したポートフォリオを確認: `open profile.html`
6. **学習ログを更新**: 本日の学習内容を記録
7. 学習成果をGitにコミット: `git add . && git commit -m "学習内容" && git push`

## 💡 学習のコツ
- 完璧を求めず段階的に進める
- エラーを恐れずに実際にコードを書く
- 分からないことは遠慮なく質問する
- 他の実装方法も積極的に学ぶ
- **学習成果は必ずGitでバージョン管理する**
