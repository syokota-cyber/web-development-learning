# 🔧 管理ダッシュボード技術仕様書

## 1. アーキテクチャ概要

### 1.1 システム構成図
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Browser   │────▶│  React App  │────▶│  Supabase   │
│  (Admin)    │◀────│  + Chart.js │◀────│   Database  │
└─────────────┘     └─────────────┘     └─────────────┘
                           │                     │
                           ▼                     ▼
                    ┌─────────────┐     ┌─────────────┐
                    │Local Storage│     │  Realtime   │
                    │   (Cache)   │     │  (Phase 2)  │
                    └─────────────┘     └─────────────┘
```

### 1.2 技術スタック
| レイヤー | 技術 | バージョン | 用途 |
|---------|------|-----------|------|
| Frontend | React | 19.1.1 | UIフレームワーク |
| Visualization | Chart.js | 4.4.0 | グラフ描画 |
| Chart Integration | react-chartjs-2 | 5.3.0 | React統合 |
| Backend | Supabase | 2.38.4 | BaaS |
| Database | PostgreSQL | 15 | データストア |
| Styling | CSS-in-JS | - | スタイリング |
| Build Tool | Create React App | 5.0.1 | ビルド |

---

## 2. ディレクトリ構成

```
travel-journal/src/
├── components/
│   ├── AdminDashboard.jsx        # メインダッシュボード
│   ├── AdminRoute.jsx            # 管理者専用ルート
│   ├── charts/
│   │   ├── UserStatsChart.jsx   # ユーザー統計グラフ
│   │   ├── TripStatsChart.jsx   # 旅行統計グラフ
│   │   └── SystemHealthChart.jsx # システム状態グラフ
│   └── admin/
│       ├── SystemStatus.jsx      # システム状態表示
│       ├── ErrorLog.jsx          # エラーログ表示
│       └── DataTable.jsx        # データテーブル
├── hooks/
│   ├── useAdminAuth.js          # 管理者認証フック
│   ├── useDashboardData.js      # データ取得フック
│   └── useRealtimeUpdates.js    # リアルタイム更新（Phase 2）
├── utils/
│   ├── adminHelpers.js          # 管理画面ユーティリティ
│   ├── chartConfig.js           # Chart.js設定
│   └── dataAggregation.js       # データ集計処理
└── constants/
    └── adminConfig.js           # 管理画面設定定数
```

---

## 3. データベース設計

### 3.1 新規テーブル

#### admin_logs テーブル
```sql
CREATE TABLE admin_logs (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  action VARCHAR(100) NOT NULL,
  details JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- インデックス
CREATE INDEX idx_admin_logs_user_id ON admin_logs(user_id);
CREATE INDEX idx_admin_logs_created_at ON admin_logs(created_at DESC);
```

#### dashboard_cache テーブル
```sql
CREATE TABLE dashboard_cache (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  cache_key VARCHAR(100) UNIQUE NOT NULL,
  cache_value JSONB NOT NULL,
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- インデックス
CREATE INDEX idx_dashboard_cache_key ON dashboard_cache(cache_key);
CREATE INDEX idx_dashboard_cache_expires ON dashboard_cache(expires_at);
```

### 3.2 既存テーブルの利用
- `profiles`: ユーザー統計用
- `trips`: 旅行記録統計用
- `auth.users`: 認証情報

### 3.3 RLSポリシー
```sql
-- admin_logs: 管理者のみ読み取り可能
ALTER TABLE admin_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can read admin_logs" 
ON admin_logs FOR SELECT 
USING (
  auth.email() IN ('shin1yokota@gmail.com')
);

-- dashboard_cache: 管理者のみアクセス可能
ALTER TABLE dashboard_cache ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can manage cache" 
ON dashboard_cache FOR ALL 
USING (
  auth.email() IN ('shin1yokota@gmail.com')
);
```

---

## 4. API設計

### 4.1 エンドポイント一覧

| エンドポイント | メソッド | 説明 | レート制限 |
|-------------|---------|------|-----------|
| /api/admin/stats | GET | 統計データ取得 | 2回/分 |
| /api/admin/errors | GET | エラーログ取得 | 5回/分 |
| /api/admin/system | GET | システム状態取得 | 10回/分 |
| /api/admin/export | GET | データエクスポート | 1回/時 |

### 4.2 データ取得関数

```javascript
// ユーザー統計取得
async function fetchUserStats() {
  const { data, error } = await supabase
    .rpc('get_user_stats', {
      start_date: startDate,
      end_date: endDate
    });
  return data;
}

// システム状態チェック
async function checkSystemHealth() {
  const checks = await Promise.all([
    checkDatabase(),
    checkStorage(),
    checkAPILatency()
  ]);
  return aggregateHealthStatus(checks);
}
```

---

## 5. コンポーネント仕様

### 5.1 AdminDashboard コンポーネント

#### Props
```typescript
interface AdminDashboardProps {
  refreshInterval?: number;  // デフォルト: 30000ms
  enableRealtime?: boolean;  // デフォルト: false
  adminEmail?: string;       // 管理者メール
}
```

#### State管理
```javascript
const [dashboardState, setDashboardState] = useState({
  stats: {
    users: { total: 0, active: 0, new: 0 },
    trips: { total: 0, monthly: 0, average: 0 },
    system: { status: 'loading', errors: [] }
  },
  loading: true,
  error: null,
  lastUpdate: null
});
```

### 5.2 Chart.js設定

```javascript
// グラフ共通設定
const chartDefaults = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'top',
      labels: {
        font: { size: 12 },
        color: '#666'
      }
    },
    tooltip: {
      backgroundColor: 'rgba(0,0,0,0.8)',
      titleFont: { size: 14 },
      bodyFont: { size: 12 }
    }
  },
  scales: {
    y: {
      beginAtZero: true,
      grid: {
        color: 'rgba(0,0,0,0.05)'
      }
    }
  }
};
```

---

## 6. セキュリティ実装

### 6.1 認証フロー
```
1. ユーザーアクセス
   ↓
2. メールアドレス確認
   ↓
3. ホワイトリスト照合
   ├─ OK → ダッシュボード表示
   └─ NG → アクセス拒否
```

### 6.2 管理者判定
```javascript
const ADMIN_EMAILS = [
  'shin1yokota@gmail.com'
];

function isAdmin(email) {
  return ADMIN_EMAILS.includes(email);
}

// カスタムフック
function useAdminAuth() {
  const { user } = useAuth();
  const isAdmin = user && ADMIN_EMAILS.includes(user.email);
  
  useEffect(() => {
    if (!isAdmin) {
      navigate('/');
    }
  }, [isAdmin]);
  
  return { isAdmin, user };
}
```

---

## 7. パフォーマンス最適化

### 7.1 キャッシュ戦略
```javascript
// ローカルストレージキャッシュ
const CACHE_KEY = 'dashboard_data';
const CACHE_DURATION = 5 * 60 * 1000; // 5分

function getCachedData() {
  const cached = localStorage.getItem(CACHE_KEY);
  if (!cached) return null;
  
  const { data, timestamp } = JSON.parse(cached);
  if (Date.now() - timestamp > CACHE_DURATION) {
    localStorage.removeItem(CACHE_KEY);
    return null;
  }
  
  return data;
}
```

### 7.2 遅延読み込み
```javascript
// コンポーネントの遅延読み込み
const AdminDashboard = lazy(() => 
  import('./components/AdminDashboard')
);

// データの段階的読み込み
async function loadDashboardData() {
  // 優先度高: システム状態
  const system = await fetchSystemStatus();
  updateUI({ system });
  
  // 優先度中: ユーザー統計
  const users = await fetchUserStats();
  updateUI({ users });
  
  // 優先度低: 詳細データ
  const details = await fetchDetailedStats();
  updateUI({ details });
}
```

---

## 8. エラーハンドリング

### 8.1 エラー種別と対応
| エラー種別 | 対応方法 | ユーザー表示 |
|----------|---------|------------|
| ネットワークエラー | リトライ（3回） | "接続を確認中..." |
| 認証エラー | 再ログイン促す | "再度ログインしてください" |
| データ取得エラー | キャッシュ表示 | "最新データ取得失敗" |
| 権限エラー | トップページへ | "アクセス権限がありません" |

### 8.2 エラーログ収集
```javascript
class ErrorLogger {
  static log(error, context) {
    console.error(`[Admin Dashboard] ${context}:`, error);
    
    // Supabaseに記録
    supabase.from('admin_logs').insert({
      action: 'error',
      details: {
        message: error.message,
        stack: error.stack,
        context: context
      }
    });
  }
}
```

---

## 9. テスト仕様

### 9.1 ユニットテスト
```javascript
// データ集計関数のテスト
describe('Data Aggregation', () => {
  test('calculateActiveUsers', () => {
    const users = [/* テストデータ */];
    const result = calculateActiveUsers(users, 7);
    expect(result).toBe(5);
  });
});
```

### 9.2 統合テスト
- 管理者認証フロー
- データ取得と表示
- エラー処理
- キャッシュ動作

---

## 10. デプロイメント

### 10.1 環境変数
```bash
# .env.local（開発環境）
REACT_APP_ADMIN_EMAILS=shin1yokota@gmail.com
REACT_APP_DASHBOARD_REFRESH_INTERVAL=30000
REACT_APP_ENABLE_ADMIN_LOGS=true

# .env.production（本番環境）
REACT_APP_ADMIN_EMAILS=shin1yokota@gmail.com
REACT_APP_DASHBOARD_REFRESH_INTERVAL=60000
REACT_APP_ENABLE_ADMIN_LOGS=true
```

### 10.2 ビルド設定
```json
// package.json
{
  "scripts": {
    "build:admin": "REACT_APP_ENABLE_ADMIN=true npm run build",
    "test:admin": "jest --testPathPattern=admin",
    "analyze:bundle": "source-map-explorer build/static/js/*.js"
  }
}
```

---

## 11. 監視とアラート

### 11.1 監視項目
- API応答時間（閾値: 3秒）
- エラー率（閾値: 5%）
- データ更新遅延（閾値: 5分）

### 11.2 アラート条件
```javascript
const ALERT_THRESHOLDS = {
  apiLatency: 3000,      // 3秒
  errorRate: 0.05,       // 5%
  userDropRate: 0.2,     // 20%減
  systemDowntime: 300000 // 5分
};
```

---

## 12. 将来の拡張計画

### Phase 2 実装項目
1. **Supabase Realtime統合**
   - WebSocket接続管理
   - 自動再接続処理
   - オプティミスティックUI

2. **高度な可視化**
   - ヒートマップ
   - 地理的分布
   - 時系列予測

3. **自動化**
   - 定期レポート生成
   - 異常検知アラート
   - 自動スケーリング

---

**文書バージョン**: 1.0.0  
**作成日**: 2025年8月29日  
**最終更新**: 2025年8月29日  
**レビュー予定**: 2025年9月5日