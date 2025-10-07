# 📂 プロジェクトディレクトリマップ - Camping Car Apps

## 🚀 **開発作業時は必ずここを確認！**

### **🎯 作業開始時のチェック**
```bash
# 1. 正しい作業場所を確認
pwd
# 表示されるべきパス: /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps/travel-journal

# 2. この場所でない場合は移動
cd /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps/travel-journal
```

---

## 📁 **ディレクトリ構造（2025年8月21日現在）**

```
📁 camping-car-apps/ (プロジェクトルート)
├── 📂 travel-journal/                     ← **🎯 メイン開発フォルダ**
│   ├── 📂 src/                           ← **全ての開発作業はここ**
│   │   ├── 📂 components/                ← React コンポーネント
│   │   ├── 📂 utils/                     ← ユーティリティ関数
│   │   ├── 📂 contexts/                  ← React Context
│   │   ├── 📂 constants/                 ← 定数定義
│   │   └── App.jsx                       ← メインアプリ
│   ├── 📂 public/                        ← 静的ファイル
│   ├── 📂 .vercel/                       ← 🚀 本番デプロイ設定
│   ├── 📂 supabase/                      ← DB Migration
│   ├── .env                              ← 🔑 本番環境変数
│   ├── package.json                      ← 📦 依存関係
│   └── vercel.json                       ← 🚀 デプロイ設定
├── 📂 travel-journal-backup-20250809/     ← **🔒 バックアップ（触るな）**
│   └── [緊急時復旧用・参照専用]
├── 📂 docs/                              ← **📚 ドキュメント類**
│   ├── technical-specification.md
│   ├── supabase-setup-guide.md
│   └── [その他のドキュメント]
├── 📂 learning-logs/                      ← **📝 学習記録**
│   ├── 2025-08-21.md                     ← 最新のログ
│   ├── index.md                          ← 索引
│   └── [日別ログファイル]
├── 📂 supabase/                           ← **🗄️ DB Migration管理**
│   └── migrations/                       ← マイグレーションファイル
├── 📂 archive/                            ← **📦 アーカイブ**
│   ├── sql-files/                        ← 古いSQLファイル
│   └── old-docs/                         ← 古いドキュメント
├── 📄 PROJECT_DIRECTORY_MAP.md            ← **📍 このファイル（最重要）**
├── 📄 CLAUDE.md                           ← **⚙️ 開発ルール集**
├── 📄 PROJECT_MANAGEMENT_DEFINITION.md    ← **📋 管理定義書**
├── 📄 DEPLOYMENT_SECURITY_RULEBOOK.md     ← **🛡️ デプロイルール**
└── 📄 README.md                           ← プロジェクト概要
```

---

## 🎯 **フォルダ別作業ガイド**

### **🟢 開発作業OK**
| フォルダ | 用途 | 作業内容 |
|---------|------|---------|
| `travel-journal/src/` | **メイン開発** | React開発・新機能・バグ修正 |
| `travel-journal/public/` | 静的ファイル | 画像・アイコン追加 |
| `learning-logs/` | 学習記録 | 日別ログ作成・更新 |
| `docs/` | ドキュメント | 仕様書・ガイド作成 |

### **🟡 参照・確認のみ**
| フォルダ | 用途 | 注意事項 |
|---------|------|---------|
| `travel-journal-backup-20250809/` | バックアップ | **編集絶対禁止** |
| `supabase/migrations/` | DB履歴 | 直接編集しない |
| `archive/` | 古いファイル | 参照のみ |

### **🔴 触ってはいけない**
| ファイル/フォルダ | 理由 |
|-----------------|------|
| `.vercel/` | デプロイ設定（破損リスク） |
| `.env` | 環境変数（誤編集リスク） |
| `node_modules/` | 自動生成（削除・編集禁止） |

---

## 🚨 **緊急時の場所確認**

### **迷子になった時**
```bash
# 現在地確認
pwd

# プロジェクトルートに戻る
cd /Users/syokota_mac/Desktop/claude-code/learning-projects/camping-car-apps

# 開発フォルダに移動
cd travel-journal
```

### **本番サイト確認**
- **URL**: https://travel-journal-ochre-two.vercel.app
- **管理画面**: https://vercel.com/dashboard

### **問題発生時の連絡先**
- **GitHub**: https://github.com/syokota-cyber/travel-journal
- **Supabase**: https://supabase.com/dashboard/project/rwxllvnuuxabvgxpeuma

---

## 📋 **作業開始前チェックリスト**

### **毎回確認すること**
- [ ] 正しいフォルダ（`travel-journal/`）にいるか？
- [ ] 最新コード取得済みか？ (`git pull origin main`)
- [ ] バックアップフォルダを触っていないか？
- [ ] `.env` ファイルを誤編集していないか？

### **週次確認すること**
- [ ] ディレクトリ構造に変更はないか？
- [ ] 新しいファイルが正しい場所にあるか？
- [ ] アーカイブすべき古いファイルはないか？
- [ ] バックアップが最新状態か？

---

## 📅 **更新履歴**

| 日付 | 変更内容 | 担当者 |
|------|---------|-------|
| 2025-08-21 | 初版作成・ディレクトリ整理実施 | Claude |
| | SQLファイルをarchive/sql-files/に移動 | |
| | 古いドキュメントをarchive/old-docs/に移動 | |

---

## 💡 **このファイルについて**

- **目的**: プロジェクト構造の迷子防止
- **更新頻度**: ディレクトリ構造変更時
- **重要度**: ⭐⭐⭐⭐⭐ (最重要)
- **場所**: プロジェクトルート直下（見つけやすい位置）

**📍 迷ったらまずこのファイルを確認してください！**