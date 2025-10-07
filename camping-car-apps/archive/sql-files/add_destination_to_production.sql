-- 本番環境のSupabaseにdestinationカラムを追加するSQL
-- 実行方法: Supabase ダッシュボード > SQL Editor で実行

-- 1. destinationカラムを追加
ALTER TABLE trips 
ADD COLUMN IF NOT EXISTS destination TEXT;

-- 2. カラムが追加されたことを確認
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'trips' 
AND column_name = 'destination';

-- 3. 既存のtripsテーブルの構造を確認
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'trips' 
ORDER BY ordinal_position;