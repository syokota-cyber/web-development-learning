# 📋 プロジェクト管理定義書 - Camping Car Apps

## 📅 作成日: 2025年8月21日
## 🎯 目的: 開発プロセスの混乱防止と効率的な運用確立

---

## 📁 **1. フォルダ役割分担**

### **1.1 メインフォルダ構成**
```
📁 camping-car-apps/ (プロジェクトルート)
├── 📁 travel-journal/                 ← **本番用フォルダ (PRIMARY)**
│   ├── .vercel/                       ← 本番デプロイ設定
│   ├── src/                          ← **開発作業はここで実施**
│   ├── .env                          ← 本番環境変数
│   └── [完全なReactアプリ構成]
├── 📁 travel-journal-backup-20250809/ ← **バックアップフォルダ (BACKUP)**
│   └── [緊急時復旧用のスナップショット]
└── [プロジェクト共通ファイル]
```

### **1.2 各フォルダの明確な役割**

#### **🎯 travel-journal/ (本番用)**
- **用途**: 日常的な開発作業・本番デプロイ
- **Vercel接続**: あり (プロジェクトID: prj_RZLr9s8OdmXSPJWD8z54emUpDrQA)
- **Git管理**: 独立リポジトリ (https://github.com/syokota-cyber/travel-journal.git)
- **編集権限**: 全面的な開発作業OK
- **デプロイ**: 自動 (main ブランチへのpush時)

#### **🔒 travel-journal-backup-20250809/ (バックアップ用)**
- **用途**: 緊急時復旧・参照のみ
- **Vercel接続**: あり (同一プロジェクトID) ← **危険な重複設定**
- **Git管理**: 独立 (但し古いバージョン)
- **編集権限**: **参照のみ・編集禁止**
- **デプロイ**: **絶対禁止** (重複デプロイリスク)

---

## 🔧 **2. 作業ルール定義**

### **2.1 日常開発作業**

#### **✅ 正しい作業フロー**
```bash
# Step 1: 作業場所の確認
cd /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps/travel-journal

# Step 2: 最新状態の確認
git status
git pull origin main

# Step 3: 機能開発
# src/ 内でコード編集
# ローカルテスト実行

# Step 4: 本番反映
git add .
git commit -m "具体的な変更内容"
git push origin main  # 自動でVercelデプロイ
```

#### **❌ 禁止事項**
- **travel-journal-backup-20250809/** での開発作業
- **複数フォルダでの同時編集**
- **親フォルダ (camping-car-apps) での直接的なReact開発**

### **2.2 フォルダ選択基準**

| 作業内容 | 使用フォルダ | 理由 |
|---------|-------------|------|
| 新機能開発 | `travel-journal/` | 本番デプロイ直結 |
| バグ修正 | `travel-journal/` | 即座に本番反映必要 |
| 実験・テスト | `travel-journal/` + feature branch | 安全な開発プロセス |
| 緊急復旧 | `travel-journal-backup-20250809/` → コピー | バックアップから復元 |
| 参照・確認 | どちらでも | 読み取り専用 |

---

## 🔄 **3. 変更反映手順**

### **3.1 通常の変更反映 (推奨)**
```bash
# === travel-journal/ で直接開発 ===
cd travel-journal/
# 開発作業
git add .
git commit -m "変更内容"
git push origin main
# → 自動でVercelデプロイ ✅
```

### **3.2 親フォルダで作業した場合の同期手順**
```bash
# === 例外的に親フォルダで作業してしまった場合 ===

# Step 1: 変更ファイルの特定
cd /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps
git status  # 変更されたファイルを確認

# Step 2: 手動同期
rsync -av --exclude='.git' --exclude='node_modules' \
  ./src/ ./travel-journal/src/
rsync -av --exclude='.git' --exclude='node_modules' \
  ./public/ ./travel-journal/public/

# Step 3: travel-journalで本番反映
cd travel-journal/
git add .
git commit -m "🔄 親フォルダから同期: [変更内容]"
git push origin main

# Step 4: 親フォルダの変更を記録
cd ..
git add .
git commit -m "📝 変更記録: travel-journalに同期済み"
```

### **3.3 同期チェックリスト**
```
□ 変更したファイルが全て travel-journal/ にコピーされたか？
□ .env ファイルの環境変数が正しいか？
□ package.json の依存関係が同期されているか？
□ ローカルでビルドが成功するか？ (npm run build)
□ コミットメッセージに同期元を明記したか？
```

---

## ⚠️ **4. バックアップフォルダ管理**

### **4.1 バックアップポリシー**

#### **現在のバックアップ状況**
- **travel-journal-backup-20250809/**: 2025年8月9日時点のスナップショット
- **目的**: 重大障害時の緊急復旧用
- **更新頻度**: 月次または重大変更前

#### **バックアップ作成手順**
```bash
# 新しいバックアップ作成 (月初実施)
cd /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps
cp -r travel-journal/ travel-journal-backup-$(date +%Y%m%d)/

# 古いバックアップの整理 (3ヶ月以上は削除)
rm -rf travel-journal-backup-20250509/  # 例
```

### **4.2 バックアップ使用ルール**

#### **✅ 許可される用途**
- 過去のコード参照
- 緊急時の復旧素材として
- 変更前後の比較

#### **❌ 禁止される用途**
- バックアップフォルダでの直接開発
- バックアップからの直接デプロイ
- バックアップフォルダの .vercel/ を使用

---

## 🚨 **5. 緊急時対応手順**

### **5.1 本番環境障害時**

#### **Level 1: 軽微な問題 (UI崩れ等)**
```bash
# 最新のコミットをロールバック
cd travel-journal/
git log --oneline -5  # 最近のコミット確認
git revert [コミットハッシュ]
git push origin main  # 自動でロールバックデプロイ
```

#### **Level 2: 重大な障害 (アプリ起動不可等)**
```bash
# バックアップから緊急復旧
cd /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps

# Step 1: 現在の状態をバックアップ
mv travel-journal/ travel-journal-emergency-$(date +%Y%m%d-%H%M%S)/

# Step 2: バックアップから復元
cp -r travel-journal-backup-20250809/ travel-journal/

# Step 3: 緊急デプロイ
cd travel-journal/
git add .
git commit -m "🚨 緊急復旧: バックアップから復元"
git push origin main
```

### **5.2 Vercel設定問題時**
```bash
# Vercelプロジェクト再接続
cd travel-journal/
vercel --force  # 強制的に新しいプロジェクト作成
# または
vercel link  # 既存プロジェクトに再接続
```

### **5.3 Git リポジトリ問題時**
```bash
# 新しいリポジトリへの移行
cd travel-journal/
git remote remove origin
git remote add origin [新しいリポジトリURL]
git push -u origin main
```

---

## 📊 **6. 運用監視・チェック項目**

### **6.1 日次チェック**
- [ ] 本番サイトが正常に動作しているか？
- [ ] 最新のコミットが正しくデプロイされているか？
- [ ] エラーログに異常はないか？

### **6.2 週次チェック**
- [ ] 開発フォルダと本番フォルダの同期状態確認
- [ ] バックアップフォルダの整合性チェック
- [ ] 不要なファイル・フォルダの整理

### **6.3 月次チェック**
- [ ] 新しいバックアップの作成
- [ ] 古いバックアップの削除
- [ ] プロジェクト管理定義書の見直し

---

## 🔄 **7. この定義書の更新**

### **更新タイミング**
- プロジェクト構造に重大な変更があった時
- 運用上の問題が発見された時
- 新しいツール・手順を導入した時
- 月次レビュー時

### **更新手順**
1. 変更内容を明確に記録
2. 実際の運用で検証
3. チーム（ユーザー）承認
4. 定義書更新・配布

---

## 📝 **8. よくある質問・トラブルシューティング**

### **Q1: どのフォルダで作業すればいい？**
**A1**: 基本的に `travel-journal/` で作業してください。迷ったらこのフォルダです。

### **Q2: 親フォルダで作業してしまった場合は？**
**A2**: セクション3.2の同期手順に従って、手動で `travel-journal/` に反映してください。

### **Q3: バックアップフォルダを誤って編集してしまった場合は？**
**A3**: 編集内容を破棄し、必要に応じて新しいバックアップを作成してください。

### **Q4: 本番サイトが表示されない場合は？**
**A4**: セクション5の緊急時対応手順に従って対処してください。

---

**📅 最終更新**: 2025年8月21日  
**📝 次回見直し**: 2025年9月21日  
**🎯 管理責任者**: プロジェクト管理者（ユーザー）