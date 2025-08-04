# 🌍 キャンピングカー旅先リストアプリ 多言語対応ガイド

## 1. 概要

このアプリケーションは日本語と英語の多言語対応を実装しています。Next.js 14のApp Routerと`next-intl`ライブラリを使用して、完全な国際化（i18n）を提供します。

## 2. 技術スタック

### 2.1 使用ライブラリ
- **next-intl**: Next.js用の国際化ライブラリ
- **@formatjs/intl-localematcher**: 言語マッチング
- **negotiator**: ブラウザ言語検出

### 2.2 対応言語
- **日本語 (ja)**: デフォルト言語
- **英語 (en)**: セカンダリ言語

## 3. プロジェクト構造

```
src/
├── app/
│   ├── [locale]/              # 動的ルート（言語別）
│   │   ├── (auth)/
│   │   ├── (dashboard)/
│   │   ├── layout.tsx         # 言語別レイアウト
│   │   └── page.tsx           # 言語別ホームページ
│   └── i18n/
│       ├── locales/           # 翻訳ファイル
│       │   ├── ja/
│       │   │   ├── common.json
│       │   │   ├── auth.json
│       │   │   ├── trips.json
│       │   │   └── spots.json
│       │   └── en/
│       │       ├── common.json
│       │       ├── auth.json
│       │       ├── trips.json
│       │       └── spots.json
│       └── config.ts          # i18n設定
├── lib/
│   └── i18n/
│       ├── client.ts          # クライアントサイド設定
│       └── server.ts          # サーバーサイド設定
└── components/
    └── LanguageSwitcher.tsx   # 言語切り替えコンポーネント
```

## 4. 設定ファイル

### 4.1 i18n設定
```typescript
// src/app/i18n/config.ts
export const locales = ['ja', 'en'] as const;
export const defaultLocale = 'ja' as const;

export type Locale = typeof locales[number];

export const localeNames: Record<Locale, string> = {
  ja: '日本語',
  en: 'English'
};
```

### 4.2 サーバーサイド設定
```typescript
// src/lib/i18n/server.ts
import { getRequestConfig } from 'next-intl/server';
import { locales } from '@/app/i18n/config';

export default getRequestConfig(async ({ locale }) => {
  // サポートされていない言語の場合はデフォルト言語を使用
  if (!locales.includes(locale as any)) locale = 'ja';

  return {
    messages: (await import(`@/app/i18n/locales/${locale}/common.json`)).default
  };
});
```

### 4.3 クライアントサイド設定
```typescript
// src/lib/i18n/client.ts
import { createSharedPathnamesNavigation } from 'next-intl/navigation';

export const { Link, redirect, usePathname, useRouter } =
  createSharedPathnamesNavigation({ locales: ['ja', 'en'] });
```

## 5. 翻訳ファイル

### 5.1 日本語翻訳ファイル
```json
// src/app/i18n/locales/ja/common.json
{
  "navigation": {
    "home": "ホーム",
    "trips": "旅の記録",
    "spots": "スポット",
    "profile": "プロフィール",
    "logout": "ログアウト"
  },
  "common": {
    "save": "保存",
    "cancel": "キャンセル",
    "delete": "削除",
    "edit": "編集",
    "add": "追加",
    "search": "検索",
    "loading": "読み込み中...",
    "error": "エラーが発生しました",
    "success": "成功しました"
  },
  "language": {
    "ja": "日本語",
    "en": "English"
  }
}
```

```json
// src/app/i18n/locales/ja/auth.json
{
  "login": {
    "title": "ログイン",
    "email": "メールアドレス",
    "password": "パスワード",
    "submit": "ログイン",
    "forgotPassword": "パスワードを忘れた方",
    "noAccount": "アカウントをお持ちでない方",
    "signup": "新規登録"
  },
  "register": {
    "title": "新規登録",
    "username": "ユーザー名",
    "email": "メールアドレス",
    "password": "パスワード",
    "confirmPassword": "パスワード（確認）",
    "submit": "登録",
    "hasAccount": "既にアカウントをお持ちの方",
    "login": "ログイン"
  }
}
```

```json
// src/app/i18n/locales/ja/trips.json
{
  "title": "旅の記録",
  "create": {
    "title": "新しい旅を作成",
    "name": "旅の名前",
    "description": "説明",
    "startDate": "開始日",
    "endDate": "終了日",
    "submit": "作成"
  },
  "status": {
    "planning": "計画中",
    "active": "進行中",
    "completed": "完了"
  },
  "empty": "まだ旅の記録がありません",
  "actions": {
    "create": "新しい旅を作成",
    "edit": "旅を編集",
    "delete": "旅を削除"
  }
}
```

```json
// src/app/i18n/locales/ja/spots.json
{
  "title": "スポット",
  "categories": {
    "onsen": "温泉・銭湯",
    "road_station": "道の駅・SA・PA",
    "local_products": "特産品売り場・直売所",
    "factory": "自社・工場見学",
    "historical": "歴史的スポット・史跡",
    "viewpoint": "展望スポット・絶景ポイント",
    "food": "グルメ・レストラン",
    "campground": "キャンプ場・オートキャンプ場",
    "fuel_station": "給油所・充電スタンド",
    "shower_facility": "シャワー施設・洗濯施設",
    "rental_company": "レンタル会社",
    "airport": "空港・交通機関"
  },
  "create": {
    "title": "スポットを追加",
    "name": "スポット名",
    "category": "カテゴリ",
    "address": "住所",
    "description": "説明",
    "notes": "メモ",
    "submit": "追加"
  },
  "visit": {
    "visited": "訪問済み",
    "notVisited": "未訪問",
    "rating": "評価",
    "visitDate": "訪問日"
  }
}
```

### 5.2 英語翻訳ファイル
```json
// src/app/i18n/locales/en/common.json
{
  "navigation": {
    "home": "Home",
    "trips": "Trips",
    "spots": "Spots",
    "profile": "Profile",
    "logout": "Logout"
  },
  "common": {
    "save": "Save",
    "cancel": "Cancel",
    "delete": "Delete",
    "edit": "Edit",
    "add": "Add",
    "search": "Search",
    "loading": "Loading...",
    "error": "An error occurred",
    "success": "Success"
  },
  "language": {
    "ja": "日本語",
    "en": "English"
  }
}
```

```json
// src/app/i18n/locales/en/auth.json
{
  "login": {
    "title": "Login",
    "email": "Email",
    "password": "Password",
    "submit": "Login",
    "forgotPassword": "Forgot Password?",
    "noAccount": "Don't have an account?",
    "signup": "Sign Up"
  },
  "register": {
    "title": "Sign Up",
    "username": "Username",
    "email": "Email",
    "password": "Password",
    "confirmPassword": "Confirm Password",
    "submit": "Sign Up",
    "hasAccount": "Already have an account?",
    "login": "Login"
  }
}
```

```json
// src/app/i18n/locales/en/trips.json
{
  "title": "Trips",
  "create": {
    "title": "Create New Trip",
    "name": "Trip Name",
    "description": "Description",
    "startDate": "Start Date",
    "endDate": "End Date",
    "submit": "Create"
  },
  "status": {
    "planning": "Planning",
    "active": "Active",
    "completed": "Completed"
  },
  "empty": "No trips yet",
  "actions": {
    "create": "Create New Trip",
    "edit": "Edit Trip",
    "delete": "Delete Trip"
  }
}
```

```json
// src/app/i18n/locales/ja/rental.json
{
  "title": "レンタル",
  "guides": {
    "title": "レンタルガイド",
    "documents": "必要な書類",
    "preparation": "事前準備",
    "pickup": "受け取り手順",
    "return": "返却手順",
    "troubleshooting": "トラブル対処"
  },
  "pricing": {
    "title": "料金情報",
    "vehicleTypes": {
      "light_camper": "ライトキャンパー",
      "van_con": "バンコン",
      "cab_con": "キャブコン"
    },
    "rateTypes": {
      "weekday": "平日",
      "weekend": "休日",
      "peak": "繁忙期"
    },
    "calculator": {
      "title": "料金計算",
      "vehicleType": "車両タイプ",
      "startDate": "開始日",
      "endDate": "終了日",
      "calculate": "計算する",
      "totalAmount": "合計金額"
    }
  }
}
```

```json
// src/app/i18n/locales/en/rental.json
{
  "title": "Rental",
  "guides": {
    "title": "Rental Guide",
    "documents": "Required Documents",
    "preparation": "Preparation",
    "pickup": "Pickup Process",
    "return": "Return Process",
    "troubleshooting": "Troubleshooting"
  },
  "pricing": {
    "title": "Pricing Information",
    "vehicleTypes": {
      "light_camper": "Light Camper",
      "van_con": "Van Con",
      "cab_con": "Cab Con"
    },
    "rateTypes": {
      "weekday": "Weekday",
      "weekend": "Weekend",
      "peak": "Peak Season"
    },
    "calculator": {
      "title": "Price Calculator",
      "vehicleType": "Vehicle Type",
      "startDate": "Start Date",
      "endDate": "End Date",
      "calculate": "Calculate",
      "totalAmount": "Total Amount"
    }
  }
}
```

```json
// src/app/i18n/locales/en/spots.json
{
  "title": "Spots",
  "categories": {
    "onsen": "Onsen/Hot Springs",
    "road_station": "Road Stations/Service Areas",
    "local_products": "Local Products/Direct Sales",
    "factory": "Factory Tours",
    "historical": "Historical Sites",
    "viewpoint": "Viewpoints/Scenic Spots",
    "food": "Food/Restaurants",
    "campground": "Campgrounds",
    "fuel_station": "Fuel Stations/Charging",
    "shower_facility": "Shower/Laundry Facilities",
    "rental_company": "Rental Companies",
    "airport": "Airports/Transportation"
  },
  "create": {
    "title": "Add Spot",
    "name": "Spot Name",
    "category": "Category",
    "address": "Address",
    "description": "Description",
    "notes": "Notes",
    "submit": "Add"
  },
  "visit": {
    "visited": "Visited",
    "notVisited": "Not Visited",
    "rating": "Rating",
    "visitDate": "Visit Date"
  }
}
```

## 6. コンポーネント実装

### 6.1 言語切り替えコンポーネント
```typescript
// src/components/LanguageSwitcher.tsx
'use client';

import { useLocale, useTranslations } from 'next-intl';
import { useRouter, usePathname } from '@/lib/i18n/client';
import { locales, localeNames } from '@/app/i18n/config';

export const LanguageSwitcher = () => {
  const locale = useLocale();
  const router = useRouter();
  const pathname = usePathname();
  const t = useTranslations('common');

  const handleLanguageChange = (newLocale: string) => {
    router.replace(pathname, { locale: newLocale });
  };

  return (
    <div className="relative">
      <select
        value={locale}
        onChange={(e) => handleLanguageChange(e.target.value)}
        className="appearance-none bg-white border border-gray-300 rounded px-3 py-2 pr-8 focus:outline-none focus:ring-2 focus:ring-blue-500"
      >
        {locales.map((loc) => (
          <option key={loc} value={loc}>
            {localeNames[loc]}
          </option>
        ))}
      </select>
    </div>
  );
};
```

### 6.2 多言語対応レイアウト
```typescript
// src/app/[locale]/layout.tsx
import { NextIntlClientProvider } from 'next-intl';
import { getMessages } from 'next-intl/server';
import { locales } from '@/app/i18n/config';

export async function generateStaticParams() {
  return locales.map((locale) => ({ locale }));
}

export default async function LocaleLayout({
  children,
  params: { locale }
}: {
  children: React.ReactNode;
  params: { locale: string };
}) {
  const messages = await getMessages();

  return (
    <NextIntlClientProvider messages={messages}>
      <html lang={locale}>
        <body>
          <header>
            <LanguageSwitcher />
          </header>
          <main>{children}</main>
        </body>
      </html>
    </NextIntlClientProvider>
  );
}
```

### 6.3 翻訳を使用したコンポーネント例
```typescript
// src/components/TripCard.tsx
import { useTranslations } from 'next-intl';
import { Trip } from '@/types';

interface TripCardProps {
  trip: Trip;
  onEdit?: (trip: Trip) => void;
  onDelete?: (id: string) => void;
}

export const TripCard = ({ trip, onEdit, onDelete }: TripCardProps) => {
  const t = useTranslations('trips');
  const common = useTranslations('common');

  return (
    <div className="bg-white rounded-lg shadow-md p-4">
      <h3 className="text-lg font-semibold">{trip.title}</h3>
      <p className="text-gray-600">{trip.description}</p>
      <div className="mt-2">
        <span className={`px-2 py-1 rounded text-sm ${
          trip.status === 'completed' ? 'bg-green-100 text-green-800' :
          trip.status === 'active' ? 'bg-blue-100 text-blue-800' :
          'bg-yellow-100 text-yellow-800'
        }`}>
          {t(`status.${trip.status}`)}
        </span>
      </div>
      <div className="mt-4 flex gap-2">
        {onEdit && (
          <button
            onClick={() => onEdit(trip)}
            className="px-3 py-1 text-sm bg-blue-600 text-white rounded hover:bg-blue-700"
          >
            {common('edit')}
          </button>
        )}
        {onDelete && (
          <button
            onClick={() => onDelete(trip.id)}
            className="px-3 py-1 text-sm bg-red-600 text-white rounded hover:bg-red-700"
          >
            {common('delete')}
          </button>
        )}
      </div>
    </div>
  );
};
```

## 7. データベース多言語対応

### 7.1 ユーザー言語設定
```typescript
// ユーザープロフィールの言語設定を更新
const updateUserLanguage = async (userId: string, language: 'ja' | 'en') => {
  const { error } = await supabase
    .from('profiles')
    .update({ language })
    .eq('id', userId);
  
  return { error };
};
```

### 7.2 カテゴリ翻訳の取得
```typescript
// カテゴリの翻訳を取得
const getCategoryTranslations = async (locale: string) => {
  const { data, error } = await supabase
    .from('category_translations')
    .select('category_key, display_name')
    .eq('locale', locale);
  
  if (error) throw error;
  
  return data.reduce((acc, item) => {
    acc[item.category_key] = item.display_name;
    return acc;
  }, {} as Record<string, string>);
};
```

## 8. テスト

### 8.1 翻訳テスト
```typescript
// __tests__/i18n.test.ts
import { render, screen } from '@testing-library/react';
import { NextIntlClientProvider } from 'next-intl';
import { TripCard } from '@/components/TripCard';

const messages = {
  trips: {
    status: {
      planning: 'Planning',
      active: 'Active',
      completed: 'Completed'
    }
  },
  common: {
    edit: 'Edit',
    delete: 'Delete'
  }
};

describe('TripCard with i18n', () => {
  it('should display translated status', () => {
    const mockTrip = {
      id: '1',
      title: 'Test Trip',
      status: 'planning' as const,
      createdAt: new Date(),
      updatedAt: new Date()
    };

    render(
      <NextIntlClientProvider messages={messages}>
        <TripCard trip={mockTrip} />
      </NextIntlClientProvider>
    );

    expect(screen.getByText('Planning')).toBeInTheDocument();
  });
});
```

## 9. デプロイメント

### 9.1 Vercel設定
```json
// vercel.json
{
  "i18n": {
    "locales": ["ja", "en"],
    "defaultLocale": "ja"
  }
}
```

### 9.2 環境変数
```env
# 多言語対応設定
NEXT_PUBLIC_DEFAULT_LOCALE=ja
NEXT_PUBLIC_SUPPORTED_LOCALES=ja,en
```

## 10. ベストプラクティス

### 10.1 翻訳キーの命名
- **階層構造**: `feature.screen.element`
- **一意性**: 重複を避ける
- **意味の明確性**: 何を表すかが分かりやすい

### 10.2 翻訳ファイルの管理
- **機能別分割**: 大きなファイルを避ける
- **一貫性**: 同じ要素は同じキーを使用
- **コメント**: 複雑な翻訳にはコメントを追加

### 10.3 パフォーマンス
- **遅延読み込み**: 必要な翻訳のみ読み込み
- **キャッシュ**: 翻訳のキャッシュを活用
- **バンドル分割**: 言語別にバンドルを分割

---

**作成日**: 2024年12月
**作成者**: 開発チーム
**バージョン**: 1.0 