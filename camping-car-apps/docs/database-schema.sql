-- キャンピングカー旅先リストアプリ データベーススキーマ
-- Supabase PostgreSQL

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enable RLS
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- ========================================
-- プロフィールテーブル
-- ========================================
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  username TEXT UNIQUE,
  avatar_url TEXT,
  language TEXT DEFAULT 'ja' CHECK (language IN ('ja', 'en')),
  timezone TEXT DEFAULT 'Asia/Tokyo',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- 旅の記録テーブル
-- ========================================
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

-- ========================================
-- スポット情報テーブル
-- ========================================
CREATE TABLE spots (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID REFERENCES trips(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  name TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN (
    'onsen',           -- 温泉・銭湯
    'road_station',    -- 道の駅・SA・PA
    'local_products',  -- 特産品売り場・直売所
    'factory',         -- 自社・工場見学
    'historical',      -- 歴史的スポット・史跡
    'viewpoint',       -- 展望スポット・絶景ポイント
    'food',            -- グルメ・レストラン
    'campground',      -- キャンプ場・オートキャンプ場
    'fuel_station',    -- 給油所・充電スタンド
    'shower_facility', -- シャワー施設・洗濯施設
    'rental_company',  -- レンタル会社
    'airport'          -- 空港・交通機関
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

-- ========================================
-- スポット画像テーブル
-- ========================================
CREATE TABLE spot_images (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  spot_id UUID REFERENCES spots(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  mime_type TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- インデックス作成
-- ========================================
-- パフォーマンス向上のためのインデックス
CREATE INDEX idx_trips_user_id ON trips(user_id);
CREATE INDEX idx_trips_status ON trips(status);
CREATE INDEX idx_trips_dates ON trips(start_date, end_date);
CREATE INDEX idx_spots_trip_id ON spots(trip_id);
CREATE INDEX idx_spots_user_id ON spots(user_id);
CREATE INDEX idx_spots_category ON spots(category);
CREATE INDEX idx_spots_is_visited ON spots(is_visited);
CREATE INDEX idx_spots_location ON spots(latitude, longitude);
CREATE INDEX idx_spot_images_spot_id ON spot_images(spot_id);

-- ========================================
-- Row Level Security (RLS) 設定
-- ========================================

-- profiles テーブルのRLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

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

-- category_translations テーブルのRLS
ALTER TABLE category_translations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read category translations" ON category_translations
  FOR SELECT USING (true);

-- ========================================
-- トリガー関数
-- ========================================

-- updated_at を自動更新する関数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- トリガーの作成
CREATE TRIGGER update_profiles_updated_at 
  BEFORE UPDATE ON profiles 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_trips_updated_at 
  BEFORE UPDATE ON trips 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_spots_updated_at 
  BEFORE UPDATE ON spots 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- ビュー作成
-- ========================================

-- 旅の統計情報ビュー
CREATE VIEW trip_stats AS
SELECT 
  t.id as trip_id,
  t.title,
  t.status,
  COUNT(s.id) as total_spots,
  COUNT(CASE WHEN s.is_visited = true THEN 1 END) as visited_spots,
  AVG(s.rating) as average_rating
FROM trips t
LEFT JOIN spots s ON t.id = s.trip_id
GROUP BY t.id, t.title, t.status;

-- カテゴリ別統計ビュー
CREATE VIEW category_stats AS
SELECT 
  category,
  COUNT(*) as total_spots,
  COUNT(CASE WHEN is_visited = true THEN 1 END) as visited_spots,
  AVG(rating) as average_rating
FROM spots
GROUP BY category;

-- 多言語対応用のカテゴリ翻訳テーブル
CREATE TABLE category_translations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category_key TEXT NOT NULL,
  locale TEXT NOT NULL CHECK (locale IN ('ja', 'en')),
  display_name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(category_key, locale)
);

-- カテゴリ翻訳データの挿入
INSERT INTO category_translations (category_key, locale, display_name, description) VALUES
  ('onsen', 'ja', '温泉・銭湯', '温泉や銭湯施設'),
  ('onsen', 'en', 'Onsen/Hot Springs', 'Hot spring and bath facilities'),
  ('road_station', 'ja', '道の駅・SA・PA', '道の駅やサービスエリア'),
  ('road_station', 'en', 'Road Stations/Service Areas', 'Road stations and service areas'),
  ('local_products', 'ja', '特産品売り場・直売所', '地元の特産品を販売'),
  ('local_products', 'en', 'Local Products/Direct Sales', 'Local specialty products'),
  ('factory', 'ja', '自社・工場見学', '工場見学や企業見学'),
  ('factory', 'en', 'Factory Tours', 'Factory and company tours'),
  ('historical', 'ja', '歴史的スポット・史跡', '歴史的な場所や史跡'),
  ('historical', 'en', 'Historical Sites', 'Historical places and monuments'),
  ('viewpoint', 'ja', '展望スポット・絶景ポイント', '美しい景色を楽しめる場所'),
  ('viewpoint', 'en', 'Viewpoints/Scenic Spots', 'Places with beautiful views'),
  ('food', 'ja', 'グルメ・レストラン', '食事やグルメスポット'),
  ('food', 'en', 'Food/Restaurants', 'Dining and gourmet spots'),
  ('campground', 'ja', 'キャンプ場・オートキャンプ場', 'キャンプや車中泊施設'),
  ('campground', 'en', 'Campgrounds', 'Camping and RV facilities'),
  ('fuel_station', 'ja', '給油所・充電スタンド', '燃料補給や充電施設'),
  ('fuel_station', 'en', 'Fuel Stations/Charging', 'Fuel and charging facilities'),
  ('shower_facility', 'ja', 'シャワー施設・洗濯施設', 'シャワーや洗濯設備'),
  ('shower_facility', 'en', 'Shower/Laundry Facilities', 'Shower and laundry facilities'),
  ('rental_company', 'ja', 'レンタル会社', 'キャンピングカーレンタル会社'),
  ('rental_company', 'en', 'Rental Companies', 'Campervan rental companies'),
  ('airport', 'ja', '空港・交通機関', '空港や交通アクセス'),
  ('airport', 'en', 'Airports/Transportation', 'Airports and transportation access');

-- ========================================
-- レンタル機能テーブル
-- ========================================

-- レンタル手続きガイドテーブル
CREATE TABLE rental_guides (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  title_en TEXT,
  content TEXT NOT NULL,
  content_en TEXT,
  category TEXT NOT NULL CHECK (category IN (
    'documents',       -- 必要な書類
    'preparation',     -- 事前準備
    'pickup',          -- 受け取り手順
    'return',          -- 返却手順
    'troubleshooting'  -- トラブル対処
  )),
  priority INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- レンタル料金情報テーブル
CREATE TABLE rental_pricing (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  vehicle_type TEXT NOT NULL CHECK (vehicle_type IN (
    'light_camper',    -- ライトキャンパー
    'van_con',         -- バンコン
    'cab_con'          -- キャブコン
  )),
  rate_type TEXT NOT NULL CHECK (rate_type IN ('weekday', 'weekend', 'peak')),
  daily_rate INTEGER NOT NULL,
  description TEXT,
  description_en TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- レンタル機能インデックス
-- ========================================
CREATE INDEX idx_rental_guides_category ON rental_guides(category);
CREATE INDEX idx_rental_pricing_type ON rental_pricing(vehicle_type, rate_type);

-- ========================================
-- レンタル機能RLS設定
-- ========================================

-- rental_guides テーブルのRLS
ALTER TABLE rental_guides ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read rental guides" ON rental_guides
  FOR SELECT USING (true);

-- rental_pricing テーブルのRLS
ALTER TABLE rental_pricing ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read rental pricing" ON rental_pricing
  FOR SELECT USING (true);

-- ========================================
-- レンタル機能トリガー
-- ========================================
CREATE TRIGGER update_rental_guides_updated_at 
  BEFORE UPDATE ON rental_guides 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_rental_pricing_updated_at 
  BEFORE UPDATE ON rental_pricing 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- レンタル機能サンプルデータ
-- ========================================

-- レンタル手続きガイドサンプルデータ
INSERT INTO rental_guides (title, title_en, content, content_en, category, priority) VALUES
  ('必要な書類', 'Required Documents', '日本在住者は普通免許証、外国人旅行者は国際免許証が必要です。', 'Ordinary driver''s licence for residents of Japan. Foreign travellers must have an international driving licence.', 'documents', 1),
  ('事前準備', 'Preparation', '予約時に車両タイプとオプション（キッチン用品、寝具など）を選択してください。', 'Select the date, time, vehicle type and options (e.g. bedding, kitchenware, etc.) when booking.', 'preparation', 2),
  ('受け取り手順', 'Pickup Process', '予約日にオフィスで車両の使用方法と注意事項を聞き、車両の状態を確認します。', 'On the day of the appointment, you will hear about the use and precautions of the vehicle at the office and check its condition.', 'pickup', 3),
  ('返却手順', 'Return Process', '車両の内装は基本的に清掃が必要です。燃料も満タンで返却してください。', 'The interior of the vehicle basically needs to be cleaned. Many operators require the return of a full tank.', 'return', 4),
  ('トラブル対処', 'Troubleshooting', '遅延返却は遅延料金が発生する場合があります。定刻を守ってください。', 'Be punctual as late fees are often incurred.', 'troubleshooting', 5);

-- レンタル料金サンプルデータ（参考: [Camping Car Travel Tips](https://campingcartraveltips.com/en/how-to-rent-a-campervan-in-japan-for-the-first-time/)）
INSERT INTO rental_pricing (vehicle_type, rate_type, daily_rate, description, description_en) VALUES
  ('light_camper', 'weekday', 15000, 'ライトキャンパー平日料金', 'Light camper weekday rate'),
  ('light_camper', 'weekend', 20000, 'ライトキャンパー休日料金', 'Light camper weekend rate'),
  ('light_camper', 'peak', 30000, 'ライトキャンパー繁忙期料金', 'Light camper peak season rate'),
  ('van_con', 'weekday', 25000, 'バンコン平日料金', 'Van con weekday rate'),
  ('van_con', 'weekend', 35000, 'バンコン休日料金', 'Van con weekend rate'),
  ('van_con', 'peak', 50000, 'バンコン繁忙期料金', 'Van con peak season rate'),
  ('cab_con', 'weekday', 30000, 'キャブコン平日料金', 'Cab con weekday rate'),
  ('cab_con', 'weekend', 40000, 'キャブコン休日料金', 'Cab con weekend rate'),
  ('cab_con', 'peak', 60000, 'キャブコン繁忙期料金', 'Cab con peak season rate');

-- ========================================
-- サンプルデータ（開発用）
-- ========================================

-- 注意: 本番環境では削除してください
-- INSERT INTO profiles (id, username) VALUES 
--   ('00000000-0000-0000-0000-000000000001', 'testuser');

-- INSERT INTO trips (user_id, title, description, start_date, end_date, status) VALUES
--   ('00000000-0000-0000-0000-000000000001', '北海道一周の旅', '北海道を一周するキャンピングカー旅行', '2024-07-01', '2024-07-15', 'planning');

-- INSERT INTO spots (trip_id, user_id, name, category, address, description) VALUES
--   ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', '登別温泉', 'onsen', '北海道登別市登別温泉町', '有名な温泉地'),
--   ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000001', '道の駅 とうや湖', 'road_station', '北海道虻田郡ニセコ町', '美しい湖の道の駅');

-- ========================================
-- 権限設定
-- ========================================

-- 認証済みユーザーに権限を付与
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO authenticated;

-- 匿名ユーザーには最小限の権限
GRANT USAGE ON SCHEMA public TO anon;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon; 