# 🛠️ キャンピングカー旅行手帳アプリ 技術仕様書（認証・データ集積版）

## 1. システム構成

### 1.1 アーキテクチャ概要
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   (React/Next)  │◄──►│   (Supabase)    │◄──►│   (PostgreSQL)  │
│   Vercel        │    │   Auth/API      │    │   User Data     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                         │
                                                         ▼
                                                  ┌─────────────────┐
                                                  │  Analytics DB   │
                                                  │  (集計データ)    │
                                                  └─────────────────┘
```

### 1.2 技術選択の理由

アーキテクチャ変更の理由：
- **認証必要**: メールアドレスでのログイン
- **データ永続化**: 端末間でのデータ同期
- **将来の分析**: 匿名化データの集積・分析

## 2. 技術スタック

### 2.1 段階的な実装アプローチ

#### Phase 1: MVP with Auth（現在）
- **Frontend**: React + Supabase Auth
- **Backend**: Supabase (BaaS)
- **Database**: PostgreSQL (Supabase)
- **Hosting**: Vercel

#### Phase 2: 分析機能（将来）
- **Analytics**: 集計用テーブル追加
- **Feedback**: レポート生成機能

### 2.2 認証フロー
```javascript
// Supabaseの認証フロー
1. メールアドレス入力
2. マジックリンク送信
3. メール内リンククリック
4. 自動ログイン
5. マイページへリダイレクト
```

## 3. データベース設計

### 3.1 ユーザーデータ（プライベート）
```sql
-- ユーザープロファイル
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  last_login TIMESTAMP
);

-- 旅行データ
CREATE TABLE trips (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  start_date DATE,
  end_date DATE,
  status TEXT CHECK (status IN ('planning', 'ongoing', 'completed')),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 目的データ
CREATE TABLE purposes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID REFERENCES trips(id) ON DELETE CASCADE,
  type TEXT CHECK (type IN ('main', 'sub')),
  name TEXT NOT NULL,
  category TEXT,
  priority TEXT,
  achieved BOOLEAN DEFAULT FALSE,
  satisfaction INTEGER CHECK (satisfaction BETWEEN 1 AND 5),
  memo TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 持ち物データ
CREATE TABLE items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID REFERENCES trips(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  category TEXT,
  quantity INTEGER DEFAULT 1,
  packed BOOLEAN DEFAULT FALSE,
  usage TEXT CHECK (usage IN ('well', 'little', 'unused')),
  next_time BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 3.2 集計用データ（匿名化・将来実装）
```sql
-- 匿名化された集計データ
CREATE TABLE analytics_trips (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  month DATE, -- YYYY-MM-01形式
  duration_days INTEGER,
  main_purpose_count INTEGER,
  sub_purpose_count INTEGER,
  achievement_rate_main DECIMAL(5,2),
  achievement_rate_sub DECIMAL(5,2),
  item_usage_rate DECIMAL(5,2),
  created_at TIMESTAMP DEFAULT NOW()
);

-- カテゴリ別統計
CREATE TABLE analytics_categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  month DATE,
  category TEXT,
  type TEXT CHECK (type IN ('purpose', 'item')),
  usage_count INTEGER,
  achievement_rate DECIMAL(5,2),
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 3.3 Row Level Security (RLS)
```sql
-- ユーザーは自分のデータのみアクセス可能
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own trips" ON trips
  FOR ALL USING (auth.uid() = user_id);

-- 同様のポリシーを全テーブルに適用
```

## 4. 認証実装

### 4.1 メールアドレス認証（マジックリンク）
```javascript
// ログイン処理
const handleLogin = async (email) => {
  const { error } = await supabase.auth.signInWithOtp({
    email: email,
    options: {
      emailRedirectTo: window.location.origin + '/dashboard'
    }
  });
  
  if (!error) {
    setMessage('メールを確認してください');
  }
};

// セッション管理
useEffect(() => {
  const { data: authListener } = supabase.auth.onAuthStateChange(
    (event, session) => {
      if (session) {
        setUser(session.user);
      } else {
        setUser(null);
      }
    }
  );
  
  return () => {
    authListener.subscription.unsubscribe();
  };
}, []);
```

### 4.2 プライバシー設計
- パスワード不要（マジックリンク）
- 個人データは完全分離
- 他ユーザーのデータは一切見えない
- 集計データは完全匿名化

## 5. データ集積とフィードバック（将来機能）

### 5.1 匿名データ収集
```javascript
// 旅行完了時に匿名データを送信
const submitAnonymousData = async (trip) => {
  const anonymousData = {
    duration_days: calculateDays(trip),
    main_purpose_count: trip.mainPurposes.length,
    achievement_rate_main: calculateAchievementRate(trip.mainPurposes),
    // 個人を特定できる情報は含まない
  };
  
  await supabase
    .from('analytics_trips')
    .insert(anonymousData);
};
```

### 5.2 フィードバック機能
```javascript
// 月次レポート例
const MonthlyReport = () => {
  return (
    <div>
      <h2>今月の傾向</h2>
      <p>あなたの達成率: {userRate}%</p>
      <p>全体平均: {averageRate}%</p>
      
      <h3>人気の目的地TOP5</h3>
      <ol>
        {popularDestinations.map(dest => (
          <li>{dest.name} ({dest.count}人)</li>
        ))}
      </ol>
      
      <h3>よく使われた持ち物</h3>
      {/* 匿名化された統計情報 */}
    </div>
  );
};
```

## 6. 実装フェーズ

### Phase 1: 認証付きMVP（2-3週間）
1. Supabase設定
2. メール認証実装
3. 基本的なCRUD機能
4. プライベートデータ管理

### Phase 2: UI/UX改善（1-2週間）
1. グラフ表示機能
2. レスポンシブ対応
3. PWA化

### Phase 3: 分析機能（将来）
1. 匿名データ収集
2. 統計ダッシュボード
3. パーソナライズドフィードバック

## 7. セキュリティとプライバシー

### 7.1 データ保護
- すべての通信はHTTPS
- Supabase RLSで完全分離
- 定期的なバックアップ

### 7.2 プライバシーポリシー必須項目
- 収集するデータの明示
- 匿名化の説明
- データ削除の権利
- 第三者提供なし

## 8. 開発環境セットアップ

```bash
# 1. Supabaseプロジェクト作成
# 2. 環境変数設定
REACT_APP_SUPABASE_URL=your-project-url
REACT_APP_SUPABASE_ANON_KEY=your-anon-key

# 3. 開発開始
npm create react-app travel-journal
cd travel-journal
npm install @supabase/supabase-js
npm start
```

---

**更新日**: 2024年12月
**バージョン**: 3.0（認証・データ集積版）