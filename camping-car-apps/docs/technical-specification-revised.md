# 🛠️ キャンピングカー旅行手帳アプリ 技術仕様書（改訂版）

## 1. システム構成

### 1.1 アーキテクチャ概要
```
┌─────────────────┐
│   Frontend      │
│   (React)       │
│   localStorage  │
└─────────────────┘
```

**特徴**: 
- 完全オフライン対応
- 個人データは端末内のみ
- 外部サーバー不要

### 1.2 技術スタック

#### Frontend
- **Framework**: React 18
- **Language**: JavaScript (段階的にTypeScript導入可)
- **Styling**: CSS Modules + 基本的なCSS
- **State Management**: React Context API + useReducer
- **Data Storage**: localStorage
- **Charts**: Chart.js (React Chart.js 2)
- **Icons**: シンプルなSVGアイコン
- **Build Tool**: Create React App (学習済み)

#### Development Tools
- **Package Manager**: npm
- **Version Control**: Git

## 2. データ設計

### 2.1 データ構造
```javascript
// localStorage に保存するデータ構造
const dataStructure = {
  trips: [
    {
      id: "unique-id",
      title: "2024年夏 富士山旅行",
      startDate: "2024-07-15",
      endDate: "2024-07-17",
      status: "planning" | "ongoing" | "completed",
      createdAt: "2024-07-01T10:00:00Z",
      
      // メイン目的
      mainPurposes: [
        {
          id: "main-1",
          name: "富士山5合目観光",
          category: "sightseeing",
          priority: "high" | "medium" | "low",
          achieved: false,
          satisfaction: null, // 1-5 or null
          memo: ""
        }
      ],
      
      // サブ目的
      subPurposes: [
        {
          id: "sub-1",
          name: "道の駅なるさわ",
          category: "roadstation",
          achieved: false,
          satisfaction: null,
          memo: ""
        }
      ],
      
      // 持ち物
      items: [
        {
          id: "item-1",
          name: "寝袋",
          category: "bedding",
          quantity: 2,
          packed: false,
          usage: null, // "well" | "little" | "unused" | null
          nextTime: true
        }
      ],
      
      // レビュー
      review: {
        overallMemo: "",
        improvements: "",
        bestMoment: "",
        completedAt: null
      }
    }
  ],
  
  // アプリ設定
  settings: {
    theme: "light" | "dark",
    defaultItemTemplates: [],
    lastBackup: "2024-07-01T10:00:00Z"
  }
};
```

### 2.2 カテゴリ定義
```javascript
const categories = {
  mainPurposes: {
    nature: "自然体験",
    activity: "アクティビティ", 
    sightseeing: "観光",
    event: "イベント",
    custom: "その他"
  },
  
  subPurposes: {
    roadstation: "道の駅",
    onsen: "温泉",
    food: "グルメ",
    shopping: "買い物",
    facility: "施設"
  },
  
  items: {
    bedding: "寝具",
    cooking: "調理器具",
    outdoor: "アウトドア用品",
    hygiene: "衛生用品",
    safety: "安全用品",
    activity: "アクティビティ用品",
    seasonal: "季節用品"
  }
};
```

## 3. コンポーネント設計

### 3.1 ディレクトリ構造
```
src/
├── components/
│   ├── common/
│   │   ├── Button.js
│   │   ├── Checkbox.js
│   │   ├── ProgressBar.js
│   │   └── Rating.js
│   ├── trip/
│   │   ├── TripList.js
│   │   ├── TripCard.js
│   │   └── TripForm.js
│   ├── purpose/
│   │   ├── PurposeList.js
│   │   ├── PurposeItem.js
│   │   └── PurposeForm.js
│   ├── item/
│   │   ├── ItemList.js
│   │   ├── ItemCategory.js
│   │   └── ItemForm.js
│   ├── review/
│   │   ├── ReviewDashboard.js
│   │   ├── AchievementChart.js
│   │   └── UsageChart.js
│   └── layout/
│       ├── Header.js
│       ├── Navigation.js
│       └── TabView.js
├── contexts/
│   └── AppContext.js
├── hooks/
│   ├── useLocalStorage.js
│   └── useTrip.js
├── utils/
│   ├── storage.js
│   ├── export.js
│   └── chartConfig.js
├── App.js
├── App.css
└── index.js
```

### 3.2 主要コンポーネント

#### TripList（旅行一覧）
```javascript
// 表示内容
- 旅行タイトル
- 期間
- ステータス（計画中/進行中/完了）
- 達成度プログレスバー
```

#### TripDetail（旅行詳細）
```javascript
// タブ構成
- 基本情報タブ
- 目的タブ（メイン/サブ切り替え）
- 持ち物タブ
- レビュータブ
```

#### ReviewDashboard（レビュー画面）
```javascript
// 表示内容
- 達成度グラフ（棒グラフ）
- カテゴリ別分析（レーダーチャート）
- 持ち物活用率（円グラフ）
- 振り返りメモ
```

## 4. 状態管理

### 4.1 Context設計
```javascript
const AppContext = React.createContext({
  trips: [],
  currentTrip: null,
  settings: {},
  
  // Actions
  addTrip: (trip) => {},
  updateTrip: (id, updates) => {},
  deleteTrip: (id) => {},
  setCurrentTrip: (trip) => {},
  updateSettings: (settings) => {}
});
```

### 4.2 localStorage連携
```javascript
// 自動保存
useEffect(() => {
  localStorage.setItem('trips', JSON.stringify(trips));
}, [trips]);

// 自動読み込み
useEffect(() => {
  const savedTrips = localStorage.getItem('trips');
  if (savedTrips) {
    setTrips(JSON.parse(savedTrips));
  }
}, []);
```

## 5. 機能実装の詳細

### 5.1 チェック機能
```javascript
// シンプルなチェックボックス操作
const toggleAchieved = (purposeId) => {
  setPurposes(prev => prev.map(p => 
    p.id === purposeId ? {...p, achieved: !p.achieved} : p
  ));
};
```

### 5.2 グラフ表示
```javascript
// Chart.js設定例
const achievementData = {
  labels: trips.map(t => t.title),
  datasets: [
    {
      label: 'メイン目的',
      data: trips.map(t => calculateAchievement(t.mainPurposes)),
      backgroundColor: 'rgba(75, 192, 192, 0.6)'
    },
    {
      label: 'サブ目的',
      data: trips.map(t => calculateAchievement(t.subPurposes)),
      backgroundColor: 'rgba(255, 206, 86, 0.6)'
    }
  ]
};
```

### 5.3 データエクスポート
```javascript
// JSON形式でダウンロード
const exportData = () => {
  const data = JSON.stringify(trips, null, 2);
  const blob = new Blob([data], {type: 'application/json'});
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `travel-journal-${Date.now()}.json`;
  a.click();
};
```

## 6. UI/UXガイドライン

### 6.1 デザイン原則
- **シンプル**: 必要最小限の要素
- **直感的**: タップ/クリックで即座に反応
- **視覚的**: グラフで一目で分かる

### 6.2 レスポンシブ対応
```css
/* モバイルファースト */
.container {
  padding: 16px;
  max-width: 100%;
}

/* タブレット以上 */
@media (min-width: 768px) {
  .container {
    max-width: 768px;
    margin: 0 auto;
  }
}
```

## 7. パフォーマンス最適化

### 7.1 データ管理
- localStorage上限（5-10MB）を考慮
- 古いデータの自動アーカイブ機能
- 画像は保存せず、メモのみ

### 7.2 レンダリング最適化
- React.memoで不要な再レンダリング防止
- useMemoでグラフデータをキャッシュ
- 仮想スクロール（大量データ時）

## 8. 段階的な実装計画

### Phase 1: MVP（1-2週間）
1. 基本的なCRUD機能
2. チェックリスト機能
3. localStorage保存

### Phase 2: グラフ機能（1週間）
1. Chart.js導入
2. 達成度グラフ
3. 基本的な統計表示

### Phase 3: 改善（1週間）
1. データエクスポート/インポート
2. テンプレート機能
3. UI/UXブラッシュアップ

## 9. テスト方針

### 9.1 手動テスト
- 各機能の動作確認
- エッジケースの確認
- モバイル/デスクトップでの表示確認

### 9.2 データ検証
```javascript
// データ整合性チェック
const validateTrip = (trip) => {
  return {
    isValid: trip.title && trip.startDate && trip.endDate,
    errors: []
  };
};
```

## 10. 今後の拡張可能性

### 将来的な機能追加
- PWA化（オフラインでも完全動作）
- IndexedDB移行（大容量対応）
- 写真メモ機能
- 共有機能（要望があれば）

### 技術的な成長パス
1. TypeScript導入
2. テスト自動化（Jest）
3. Next.js移行
4. バックエンド連携

---

**作成日**: 2024年12月
**バージョン**: 2.0（手帳アプリ版）