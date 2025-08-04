-- 目的カテゴリテーブル
CREATE TABLE purpose_categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  display_order INT NOT NULL
);

-- メイン目的テーブル
CREATE TABLE main_purposes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  display_order INT NOT NULL
);

-- サブ目的テーブル
CREATE TABLE sub_purposes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  display_order INT NOT NULL
);

-- 旅行目的（選択された目的を保存）
CREATE TABLE trip_purposes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID REFERENCES trips(id) ON DELETE CASCADE,
  main_purpose_id UUID REFERENCES main_purposes(id),
  sub_purpose_id UUID REFERENCES sub_purposes(id),
  custom_purpose TEXT,
  purpose_type TEXT CHECK (purpose_type IN ('main', 'sub', 'custom')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- デフォルト持ち物テーブル
CREATE TABLE default_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  main_purpose_id UUID REFERENCES main_purposes(id),
  name TEXT NOT NULL,
  display_order INT NOT NULL
);

-- 旅行の持ち物チェックリスト
CREATE TABLE trip_checklists (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID REFERENCES trips(id) ON DELETE CASCADE,
  item_name TEXT NOT NULL,
  is_default BOOLEAN DEFAULT true,
  is_checked BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);