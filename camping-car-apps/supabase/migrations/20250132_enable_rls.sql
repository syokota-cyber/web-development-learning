-- Row Level Security (RLS) を有効化
ALTER TABLE purpose_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE main_purposes ENABLE ROW LEVEL SECURITY;
ALTER TABLE sub_purposes ENABLE ROW LEVEL SECURITY;
ALTER TABLE trip_purposes ENABLE ROW LEVEL SECURITY;
ALTER TABLE default_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE trip_checklists ENABLE ROW LEVEL SECURITY;

-- 既存のポリシーを安全に削除してから再作成
-- purpose_categories
DROP POLICY IF EXISTS "Allow public read access" ON purpose_categories;
CREATE POLICY "Allow public read access" ON purpose_categories
  FOR SELECT USING (true);

-- main_purposes  
DROP POLICY IF EXISTS "Allow public read access" ON main_purposes;
CREATE POLICY "Allow public read access" ON main_purposes
  FOR SELECT USING (true);

-- sub_purposes
DROP POLICY IF EXISTS "Allow public read access" ON sub_purposes;
CREATE POLICY "Allow public read access" ON sub_purposes
  FOR SELECT USING (true);

-- default_items
DROP POLICY IF EXISTS "Allow public read access" ON default_items;
CREATE POLICY "Allow public read access" ON default_items
  FOR SELECT USING (true);

-- trip_purposes: 自分の旅行の目的のみアクセス可能（セキュリティ重要）
DROP POLICY IF EXISTS "Users can view own trip purposes" ON trip_purposes;
CREATE POLICY "Users can view own trip purposes" ON trip_purposes
  FOR SELECT USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can insert own trip purposes" ON trip_purposes;
CREATE POLICY "Users can insert own trip purposes" ON trip_purposes
  FOR INSERT WITH CHECK (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can update own trip purposes" ON trip_purposes;
CREATE POLICY "Users can update own trip purposes" ON trip_purposes
  FOR UPDATE USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can delete own trip purposes" ON trip_purposes;
CREATE POLICY "Users can delete own trip purposes" ON trip_purposes
  FOR DELETE USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

-- trip_checklists: 自分の旅行のチェックリストのみアクセス可能（セキュリティ重要）
DROP POLICY IF EXISTS "Users can view own checklists" ON trip_checklists;
CREATE POLICY "Users can view own checklists" ON trip_checklists
  FOR SELECT USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can insert own checklists" ON trip_checklists;
CREATE POLICY "Users can insert own checklists" ON trip_checklists
  FOR INSERT WITH CHECK (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can update own checklists" ON trip_checklists;
CREATE POLICY "Users can update own checklists" ON trip_checklists
  FOR UPDATE USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Users can delete own checklists" ON trip_checklists;
CREATE POLICY "Users can delete own checklists" ON trip_checklists
  FOR DELETE USING (
    trip_id IN (
      SELECT id FROM trips WHERE user_id = auth.uid()
    )
  );