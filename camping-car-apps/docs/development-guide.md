# 🚀 キャンピングカー旅先リストアプリ 開発ガイド

## 1. 開発環境セットアップ

### 1.1 必要なツール
- **Node.js**: v18.17.0以上
- **npm**: v9.0.0以上
- **Git**: v2.30.0以上
- **VS Code**: 推奨エディタ

### 1.2 推奨VS Code拡張機能
```json
{
  "recommendations": [
    "bradlc.vscode-tailwindcss",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-vscode.vscode-typescript-next",
    "supabase.supabase"
  ]
}
```

### 1.3 プロジェクト初期化
```bash
# プロジェクトのクローン
git clone <repository-url>
cd camping-car-apps

# 依存関係のインストール
npm install

# 開発サーバーの起動
npm run dev
```

## 2. 環境変数設定

### 2.1 .env.local ファイル作成
```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Google Maps
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_google_maps_api_key

# Internationalization
NEXT_PUBLIC_DEFAULT_LOCALE=ja
NEXT_PUBLIC_SUPPORTED_LOCALES=ja,en

# Vercel
VERCEL_URL=your_vercel_url
VERCEL_ENV=development
```

### 2.2 Supabaseプロジェクト設定
1. [Supabase](https://supabase.com)でプロジェクトを作成
2. プロジェクトURLとAPIキーを取得
3. データベーススキーマを適用（`docs/database-schema.sql`）

### 2.3 多言語対応設定
1. `next-intl` パッケージのインストール
```bash
npm install next-intl
```

2. 翻訳ファイルの作成
```bash
mkdir -p src/app/i18n/locales/{ja,en}
```

3. 言語設定ファイルの作成
```typescript
// src/app/i18n/config.ts
export const locales = ['ja', 'en'] as const;
export const defaultLocale = 'ja' as const;
```

## 3. プロジェクト構造

```
camping-car-apps/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── [locale]/          # 多言語対応ルート
│   │   │   ├── (auth)/        # 認証関連ページ
│   │   │   ├── (dashboard)/   # ダッシュボード
│   │   │   ├── api/           # API Routes
│   │   │   ├── globals.css    # グローバルスタイル
│   │   │   ├── layout.tsx     # ルートレイアウト
│   │   │   └── page.tsx       # ホームページ
│   │   └── i18n/              # 国際化設定
│   │       ├── locales/       # 翻訳ファイル
│   │       │   ├── ja/        # 日本語
│   │       │   └── en/        # 英語
│   │       └── config.ts      # i18n設定
│   ├── components/            # React コンポーネント
│   │   ├── ui/               # 基本UIコンポーネント
│   │   ├── forms/            # フォームコンポーネント
│   │   ├── maps/             # 地図関連コンポーネント
│   │   └── layout/           # レイアウトコンポーネント
│   ├── lib/                  # ユーティリティ
│   │   ├── supabase/         # Supabase設定
│   │   ├── utils/            # 汎用ユーティリティ
│   │   ├── validations/      # バリデーション
│   │   └── i18n/             # 国際化ユーティリティ
│   ├── hooks/                # カスタムフック
│   ├── stores/               # Zustandストア
│   └── types/                # TypeScript型定義
├── docs/                     # ドキュメント
├── public/                   # 静的ファイル
├── tests/                    # テストファイル
├── .env.local               # 環境変数
├── .eslintrc.js             # ESLint設定
├── .prettierrc              # Prettier設定
├── next.config.js           # Next.js設定
├── tailwind.config.js       # Tailwind CSS設定
├── tsconfig.json            # TypeScript設定
└── package.json             # 依存関係
```

## 4. 開発フロー

### 4.1 ブランチ戦略
```
main                    # 本番環境
├── develop            # 開発環境
├── feature/auth       # 認証機能
├── feature/trips      # 旅の管理機能
├── feature/spots      # スポット管理機能
└── feature/maps       # 地図機能
```

### 4.2 コミットメッセージ規約
```
feat: 新機能の追加
fix: バグ修正
docs: ドキュメント更新
style: コードスタイル修正
refactor: リファクタリング
test: テスト追加
chore: その他の変更
```

### 4.3 プルリクエスト
1. 機能ブランチを作成
2. 開発・テスト
3. プルリクエスト作成
4. コードレビュー
5. マージ

## 5. コーディング規約

### 5.1 TypeScript
```typescript
// 型定義
interface Trip {
  id: string;
  title: string;
  description?: string;
  startDate?: Date;
  endDate?: Date;
  status: 'planning' | 'active' | 'completed';
  createdAt: Date;
  updatedAt: Date;
}

// 関数定義
const createTrip = async (tripData: CreateTripData): Promise<Trip> => {
  // 実装
};
```

### 5.2 React コンポーネント
```typescript
// コンポーネント定義
interface TripCardProps {
  trip: Trip;
  onEdit?: (trip: Trip) => void;
  onDelete?: (id: string) => void;
}

export const TripCard: React.FC<TripCardProps> = ({
  trip,
  onEdit,
  onDelete
}) => {
  return (
    <div className="bg-white rounded-lg shadow-md p-4">
      {/* コンポーネント内容 */}
    </div>
  );
};
```

### 5.3 Tailwind CSS
```typescript
// クラス名の順序
// 1. レイアウト (display, position, top, right, bottom, left)
// 2. ボックスモデル (width, height, margin, padding)
// 3. タイポグラフィ (font, text)
// 4. 背景 (background, border)
// 5. その他 (transform, transition, etc.)

<div className="flex items-center justify-between p-4 bg-white border rounded-lg">
  <h2 className="text-lg font-semibold text-gray-900">タイトル</h2>
  <button className="px-3 py-1 text-sm text-white bg-blue-600 rounded hover:bg-blue-700">
    ボタン
  </button>
</div>
```

### 5.4 多言語対応
```typescript
// 翻訳キーの命名規則
// 機能.画面.要素
// 例: auth.login.title, trips.create.button

// 翻訳ファイルの構造
// src/app/i18n/locales/ja/common.json
{
  "auth": {
    "login": {
      "title": "ログイン",
      "email": "メールアドレス",
      "password": "パスワード"
    }
  }
}

// コンポーネントでの使用
import { useTranslations } from 'next-intl';

export const LoginForm = () => {
  const t = useTranslations('auth.login');
  
  return (
    <form>
      <h1>{t('title')}</h1>
      <input placeholder={t('email')} />
      <input placeholder={t('password')} />
    </form>
  );
};
```

## 6. テスト戦略

### 6.1 ユニットテスト
```typescript
// __tests__/components/TripCard.test.tsx
import { render, screen } from '@testing-library/react';
import { TripCard } from '@/components/TripCard';

describe('TripCard', () => {
  it('should render trip title', () => {
    const mockTrip = {
      id: '1',
      title: '北海道旅行',
      status: 'planning' as const,
      createdAt: new Date(),
      updatedAt: new Date()
    };

    render(<TripCard trip={mockTrip} />);
    expect(screen.getByText('北海道旅行')).toBeInTheDocument();
  });
});
```

### 6.2 統合テスト
```typescript
// __tests__/api/trips.test.ts
import { createClient } from '@supabase/supabase-js';

describe('Trips API', () => {
  it('should create a new trip', async () => {
    // API テストの実装
  });
});
```

### 6.3 E2Eテスト
```typescript
// tests/trips.spec.ts
import { test, expect } from '@playwright/test';

test('user can create a new trip', async ({ page }) => {
  await page.goto('/trips');
  await page.click('[data-testid="create-trip-button"]');
  await page.fill('[data-testid="trip-title"]', '北海道旅行');
  await page.click('[data-testid="save-trip-button"]');
  
  await expect(page.locator('text=北海道旅行')).toBeVisible();
});
```

## 7. パフォーマンス最適化

### 7.1 画像最適化
```typescript
import Image from 'next/image';

<Image
  src="/spot-image.jpg"
  alt="スポット画像"
  width={400}
  height={300}
  placeholder="blur"
  blurDataURL="data:image/jpeg;base64,..."
/>
```

### 7.2 コード分割
```typescript
// 動的インポート
const MapComponent = dynamic(() => import('@/components/Map'), {
  loading: () => <div>読み込み中...</div>,
  ssr: false
});
```

### 7.3 キャッシュ戦略
```typescript
// React Query キャッシュ設定
const { data: trips } = useQuery({
  queryKey: ['trips'],
  queryFn: fetchTrips,
  staleTime: 5 * 60 * 1000, // 5分
  cacheTime: 10 * 60 * 1000, // 10分
});
```

## 8. セキュリティ対策

### 8.1 入力値検証
```typescript
import { z } from 'zod';

const tripSchema = z.object({
  title: z.string().min(1, 'タイトルは必須です').max(100, 'タイトルは100文字以内で入力してください'),
  description: z.string().max(500, '説明は500文字以内で入力してください').optional(),
  startDate: z.date().optional(),
  endDate: z.date().optional(),
});

type TripFormData = z.infer<typeof tripSchema>;
```

### 8.2 XSS対策
```typescript
// 危険なHTMLのサニタイズ
import DOMPurify from 'dompurify';

const sanitizedHtml = DOMPurify.sanitize(userInput);
```

### 8.3 CSRF対策
```typescript
// Next.js の CSRF 保護
export async function POST(request: Request) {
  const csrfToken = request.headers.get('x-csrf-token');
  // CSRF トークンの検証
}
```

## 9. デプロイメント

### 9.1 Vercel デプロイ
```bash
# Vercel CLI インストール
npm i -g vercel

# デプロイ
vercel

# 本番環境デプロイ
vercel --prod
```

### 9.2 環境変数設定
```bash
# Vercel 環境変数設定
vercel env add NEXT_PUBLIC_SUPABASE_URL
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY
vercel env add SUPABASE_SERVICE_ROLE_KEY
```

### 9.3 データベースマイグレーション
```bash
# Supabase CLI インストール
npm install -g supabase

# ローカル開発環境
supabase start

# マイグレーション実行
supabase db push
```

## 10. トラブルシューティング

### 10.1 よくある問題

#### Supabase接続エラー
```bash
# 環境変数の確認
echo $NEXT_PUBLIC_SUPABASE_URL
echo $NEXT_PUBLIC_SUPABASE_ANON_KEY

# Supabase プロジェクトの確認
supabase status
```

#### TypeScript エラー
```bash
# 型チェック
npm run type-check

# 型定義の更新
npm run build
```

#### Tailwind CSS スタイルが適用されない
```bash
# Tailwind CSS の再ビルド
npm run build:css

# キャッシュのクリア
rm -rf .next
npm run dev
```

### 10.2 デバッグツール
- **React Developer Tools**: コンポーネントの状態確認
- **Redux DevTools**: Zustand ストアの状態確認
- **Network Tab**: API リクエストの確認
- **Console**: エラーログの確認

## 11. 参考資料

### 11.1 公式ドキュメント
- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)

### 11.2 参考記事
- [Next.js App Router Best Practices](https://nextjs.org/docs/app/building-your-application)
- [Supabase Security Best Practices](https://supabase.com/docs/guides/security)
- [React Performance Optimization](https://react.dev/learn/render-and-commit)

---

**作成日**: 2024年12月
**作成者**: 開発チーム
**バージョン**: 1.0 