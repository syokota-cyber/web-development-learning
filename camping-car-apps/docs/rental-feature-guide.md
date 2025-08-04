# 🚐 キャンピングカーレンタル機能ガイド

## 1. 概要

キャンピングカーレンタル機能は、[Camping Car Travel Tips](https://campingcartraveltips.com/en/how-to-rent-a-campervan-in-japan-for-the-first-time/)の情報を基に、日本でのキャンピングカーレンタル体験をサポートする機能です。初回レンタル利用者から経験豊富なユーザーまで、すべてのレンタル利用者に対応します。

## 2. 主要機能

### 2.1 レンタル手続きガイド
- **必要な書類**: 免許証、国際免許証
- **事前準備**: 予約時の注意事項
- **受け取り・返却**: 手続きの流れ
- **トラブル対処**: よくある問題と解決方法

### 2.2 料金情報・計算ツール
- **基本料金**: 平日・休日・繁忙期の料金体系
- **車両タイプ**: ライトキャンパー、バンコン、キャブコン
- **料金計算**: 期間に応じた料金計算ツール
- **追加料金**: 保険、装備品の料金情報

## 3. データベース設計

### 3.1 レンタル会社テーブル
```sql
CREATE TABLE rental_companies (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  name_en TEXT,
  description TEXT,
  description_en TEXT,
  address TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  website TEXT,
  airport_access TEXT,
  airport_access_en TEXT,
  business_hours TEXT,
  holidays TEXT,
  languages TEXT[], -- 対応言語
  pet_friendly BOOLEAN DEFAULT FALSE,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 3.2 レンタル車両テーブル
```sql
CREATE TABLE rental_vehicles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  company_id UUID REFERENCES rental_companies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  name_en TEXT,
  vehicle_type TEXT NOT NULL CHECK (vehicle_type IN (
    'light_camper',    -- ライトキャンパー
    'van_con',         -- バンコン
    'cab_con'          -- キャブコン
  )),
  capacity INTEGER NOT NULL, -- 定員
  daily_rate_weekday INTEGER NOT NULL, -- 平日料金
  daily_rate_weekend INTEGER NOT NULL, -- 休日料金
  daily_rate_peak INTEGER NOT NULL, -- 繁忙期料金
  description TEXT,
  description_en TEXT,
  features TEXT[], -- 装備品
  pet_friendly BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 3.3 レンタル予約テーブル
```sql
CREATE TABLE rental_bookings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  vehicle_id UUID REFERENCES rental_vehicles(id) NOT NULL,
  pickup_date DATE NOT NULL,
  return_date DATE NOT NULL,
  pickup_time TIME NOT NULL,
  return_time TIME NOT NULL,
  total_amount INTEGER NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
  insurance_option BOOLEAN DEFAULT FALSE,
  equipment_options TEXT[], -- 追加装備品
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 4. 料金体系

### 4.1 基本料金（参考: [Camping Car Travel Tips](https://campingcartraveltips.com/en/how-to-rent-a-campervan-in-japan-for-the-first-time/)）
- **平日利用**: 約15,000-25,000円/日
- **週末・祝日**: 約20,000-35,000円/日
- **繁忙期（GW・夏休み）**: 約30,000-50,000円/日

### 4.2 追加料金
- **オプション料金**: キッチン用品・寝具レンタル 1,000-5,000円/日
- **保険料**: 任意保険 1,000-3,000円/日

## 5. 料金計算ツール

### 5.1 料金計算機能
- **車両タイプ選択**: ライトキャンパー、バンコン、キャブコン
- **期間選択**: 開始日・終了日の設定
- **料金タイプ判定**: 平日・休日・繁忙期の自動判定
- **合計金額計算**: 期間に応じた料金の自動計算

### 5.2 料金計算ロジック
```javascript
// 料金計算の例
function calculateRentalPrice(vehicleType, startDate, endDate) {
  const days = calculateDays(startDate, endDate);
  let totalAmount = 0;
  
  for (let i = 0; i < days; i++) {
    const currentDate = addDays(startDate, i);
    const rateType = determineRateType(currentDate); // weekday/weekend/peak
    const dailyRate = getDailyRate(vehicleType, rateType);
    totalAmount += dailyRate;
  }
  
  return totalAmount;
}
```

## 6. レンタル手続きの流れ

### 6.1 事前準備
1. **オンライン予約**
   - 日時、車両タイプ、オプション選択
   - 多くのレンタル業者がウェブサイトで予約受付

2. **必要な書類の準備**
   - 日本在住者: 普通免許証
   - 外国人旅行者: 国際免許証
   - クレジットカード情報の登録

### 6.2 受け取り当日
1. **オフィスでの手続き**
   - 車両の使用方法と注意事項の説明
   - 車両の状態確認
   - 書類の確認・署名

2. **事前確認事項**
   - ペット同伴の可否
   - キャンセルポリシーの確認

### 6.3 返却時
1. **車両清掃**
   - 内装の基本清掃（食品残渣、ゴミの除去）

2. **燃料補給**
   - 多くの業者が満タン返却を要求

3. **最終確認**
   - スタッフと車両の状態確認
   - 損傷がある場合は修理費が別途請求される可能性

## 7. 注意事項・トラブル対処

### 7.1 よくある問題
- **遅延返却**: 遅延料金が発生する場合があるため定刻を守る
- **忘れ物**: キッチン用品や個人用品の忘れ物が多い

### 7.2 トラブル対処法
- **車両トラブル**: レンタル会社に連絡
- **事故・故障**: 保険の適用範囲を確認
- **延長希望**: 事前に連絡して空き状況を確認

## 8. ユーザー体験の向上

### 8.1 初回利用者向け
- **手続きガイド**: ステップバイステップの説明
- **よくある質問**: FAQ形式での情報提供
- **動画ガイド**: 視覚的な説明

### 8.2 経験者向け
- **高度な検索**: 詳細な条件での絞り込み
- **比較機能**: 複数会社・車両の比較
- **レビュー機能**: 利用者の口コミ・評価

## 9. 多言語対応

### 9.1 対応言語
- **日本語**: メイン言語
- **英語**: 外国人旅行者向け

### 9.2 翻訳内容
- **会社情報**: 名前、説明、アクセス情報
- **車両情報**: 車両名、説明、装備品
- **手続きガイド**: 全手続きの説明
- **料金情報**: 料金体系の説明

## 10. 今後の拡張予定

### 10.1 Phase 2
- **レンタル会社情報**: 主要レンタル会社の情報追加
- **車両詳細情報**: 各車両の詳細仕様・装備品情報
- **レビューシステム**: 利用者評価の投稿・閲覧

### 10.2 Phase 3
- **予約システム**: 実際のレンタル予約機能
- **決済機能**: オンライン決済の実装
- **AI レコメンデーション**: ユーザーに最適な車両の提案

---

**参考資料**: [How to rent a campervan in Japan](https://campingcartraveltips.com/en/how-to-rent-a-campervan-in-japan-for-the-first-time/)

**作成日**: 2024年12月
**作成者**: 開発チーム
**バージョン**: 1.0 