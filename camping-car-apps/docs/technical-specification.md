# 🛠️ キャンピングカー旅先リストアプリ 技術仕様書

## 1. システム構成

### 1.1 アーキテクチャ概要
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   (Next.js)     │◄──►│   (Supabase)    │◄──►│   (PostgreSQL)  │
│   Vercel        │    │   Auth          │    │   Storage       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 1.2 技術スタック

#### Frontend
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **State Management**: Zustand
- **Form Management**: React Hook Form + Zod
- **Data Fetching**: TanStack Query (React Query)
- **Icons**: Lucide React
- **Maps**: Google Maps JavaScript API
- **Internationalization**: next-intl
- **Deployment**: Vercel

#### Backend
- **Platform**: Supabase
- **Database**: PostgreSQL
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage
- **Edge Functions**: Supabase Edge Functions
- **Real-time**: Supabase Realtime

#### Development Tools
- **Package Manager**: npm
- **Linting**: ESLint
- **Formatting**: Prettier
- **Type Checking**: TypeScript
- **Testing**: Jest + React Testing Library

## 2. データベース設計

### 2.1 ER図
```
users (auth.users)
├── profiles
├── trips
│   └── spots
│       └── spot_images
└── user_settings
```

### 2.2 テーブル定義

#### profiles テーブル
```sql
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  username TEXT UNIQUE,
  avatar_url TEXT,
  language TEXT DEFAULT 'ja' CHECK (language IN ('ja', 'en')),
  timezone TEXT DEFAULT 'Asia/Tokyo',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### trips テーブル
```sql
CREATE TABLE trips (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  start_date DATE,
  end_date DATE,
  status TEXT DEFAULT 'planning' CHECK (status IN ('planning', 'active', 'completed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### spots テーブル
```sql
CREATE TABLE spots (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID REFERENCES trips(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  name TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN (
    'onsen', 'road_station', 'local_products', 'factory', 
    'historical', 'viewpoint', 'food', 'campground', 
    'fuel_station', 'shower_facility'
  )),
  address TEXT,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  description TEXT,
  notes TEXT,
  is_visited BOOLEAN DEFAULT FALSE,
  visited_at TIMESTAMP WITH TIME ZONE,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### spot_images テーブル
```sql
CREATE TABLE spot_images (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  spot_id UUID REFERENCES spots(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  mime_type TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2.3 インデックス
```sql
-- パフォーマンス向上のためのインデックス
CREATE INDEX idx_trips_user_id ON trips(user_id);
CREATE INDEX idx_trips_status ON trips(status);
CREATE INDEX idx_spots_trip_id ON spots(trip_id);
CREATE INDEX idx_spots_user_id ON spots(user_id);
CREATE INDEX idx_spots_category ON spots(category);
CREATE INDEX idx_spots_is_visited ON spots(is_visited);
CREATE INDEX idx_spot_images_spot_id ON spot_images(spot_id);
```

## 3. セキュリティ設計

### 3.1 Row Level Security (RLS)
```sql
-- profiles テーブルのRLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- trips テーブルのRLS
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own trips" ON trips
  FOR ALL USING (auth.uid() = user_id);

-- spots テーブルのRLS
ALTER TABLE spots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own spots" ON spots
  FOR ALL USING (auth.uid() = user_id);

-- spot_images テーブルのRLS
ALTER TABLE spot_images ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own spot images" ON spot_images
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM spots 
      WHERE spots.id = spot_images.spot_id 
      AND spots.user_id = auth.uid()
    )
  );
```

### 3.2 認証・認可
- **JWT認証**: Supabase Authを使用
- **セッション管理**: 自動的なセッション更新
- **パスワードポリシー**: 最小8文字、大文字・小文字・数字を含む
- **レート制限**: API呼び出しの制限

### 3.3 データ保護
- **暗号化**: 転送時（TLS）、保存時（AES-256）
- **バックアップ**: 自動日次バックアップ
- **監査ログ**: データベース操作のログ記録

## 4. API設計

### 4.1 RESTful API エンドポイント

#### 認証関連
```
POST   /api/auth/signup
POST   /api/auth/signin
POST   /api/auth/signout
POST   /api/auth/reset-password
GET    /api/auth/user
```

#### 旅の管理
```
GET    /api/trips
POST   /api/trips
GET    /api/trips/:id
PUT    /api/trips/:id
DELETE /api/trips/:id
```

#### スポット管理
```
GET    /api/trips/:tripId/spots
POST   /api/trips/:tripId/spots
GET    /api/spots/:id
PUT    /api/spots/:id
DELETE /api/spots/:id
```

#### 画像管理
```
POST   /api/spots/:spotId/images
DELETE /api/spots/:spotId/images/:imageId
```

### 4.2 レスポンス形式
```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}
```

## 5. フロントエンド設計

### 5.1 ディレクトリ構造
```
src/
├── app/
│   ├── [locale]/
│   │   ├── (auth)/
│   │   │   ├── login/
│   │   │   └── register/
│   │   ├── (dashboard)/
│   │   │   ├── trips/
│   │   │   ├── spots/
│   │   │   └── profile/
│   │   ├── api/
│   │   ├── globals.css
│   │   ├── layout.tsx
│   │   └── page.tsx
│   └── i18n/
│       ├── locales/
│       │   ├── ja/
│       │   └── en/
│       └── config.ts
├── components/
│   ├── ui/
│   ├── forms/
│   ├── maps/
│   └── layout/
├── lib/
│   ├── supabase/
│   ├── utils/
│   ├── validations/
│   └── i18n/
├── hooks/
├── stores/
└── types/
```

### 5.2 状態管理
```typescript
// Zustand store
interface AppState {
  user: User | null;
  currentTrip: Trip | null;
  trips: Trip[];
  spots: Spot[];
  isLoading: boolean;
  
  // Actions
  setUser: (user: User | null) => void;
  setCurrentTrip: (trip: Trip | null) => void;
  fetchTrips: () => Promise<void>;
  fetchSpots: (tripId: string) => Promise<void>;
}
```

### 5.3 コンポーネント設計
- **Atomic Design** パターンの採用
- **Props Interface** の厳密な定義
- **Error Boundary** の実装
- **Loading States** の統一

## 6. パフォーマンス最適化

### 6.1 フロントエンド
- **Code Splitting**: 動的インポート
- **Image Optimization**: Next.js Image コンポーネント
- **Caching**: React Query によるキャッシュ
- **Bundle Analysis**: webpack-bundle-analyzer

### 6.2 バックエンド
- **Database Indexing**: 適切なインデックス設定
- **Query Optimization**: N+1問題の回避
- **Connection Pooling**: データベース接続の最適化

### 6.3 CDN・キャッシュ
- **Vercel Edge Network**: グローバルCDN
- **Browser Caching**: 静的アセットのキャッシュ
- **API Caching**: レスポンスキャッシュ

## 7. 監視・ログ

### 7.1 エラー監視
- **Sentry**: フロントエンドエラー監視
- **Supabase Logs**: バックエンドログ監視
- **Vercel Analytics**: パフォーマンス監視

### 7.2 メトリクス
- **Core Web Vitals**: LCP, FID, CLS
- **API Response Time**: 平均応答時間
- **Error Rate**: エラー発生率
- **User Engagement**: ユーザーエンゲージメント

## 8. デプロイメント

### 8.1 環境設定
```bash
# 開発環境
npm run dev

# 本番環境
npm run build
npm run start
```

### 8.2 CI/CD
- **GitHub Actions**: 自動テスト・デプロイ
- **Vercel**: 自動デプロイ
- **Supabase**: データベースマイグレーション

### 8.3 環境変数
```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Google Maps
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=

# Internationalization
NEXT_PUBLIC_DEFAULT_LOCALE=ja
NEXT_PUBLIC_SUPPORTED_LOCALES=ja,en

# Vercel
VERCEL_URL=
VERCEL_ENV=
```

## 9. テスト戦略

### 9.1 テストピラミッド
- **Unit Tests**: 70% (Jest + React Testing Library)
- **Integration Tests**: 20% (API テスト)
- **E2E Tests**: 10% (Playwright)

### 9.2 テストカバレッジ
- **目標**: 80%以上
- **重要機能**: 100%カバレッジ
- **UI コンポーネント**: 主要なユーザーフロー

## 10. セキュリティチェックリスト

- [ ] SQLインジェクション対策
- [ ] XSS対策
- [ ] CSRF対策
- [ ] 認証・認可の実装
- [ ] 入力値検証
- [ ] ファイルアップロード制限
- [ ] 環境変数の管理
- [ ] ログ出力の制御
- [ ] エラーハンドリング
- [ ] セキュリティヘッダー設定

---

**作成日**: 2024年12月
**作成者**: 開発チーム
**バージョン**: 1.0 