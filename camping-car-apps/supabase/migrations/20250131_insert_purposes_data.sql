-- メイン目的データ挿入
INSERT INTO main_purposes (name, display_order) VALUES
  ('観光', 1),
  ('SUP・カヤック', 2),
  ('サイクリング', 3),
  ('スキー・スノーボード', 4),
  ('登山・ハイキング', 5);

-- 続きのメイン目的
INSERT INTO main_purposes (name, display_order) VALUES
  ('フルーツ狩り', 6),
  ('夜景撮影', 7),
  ('天体観測', 8),
  ('日の出・夕陽撮影', 9),
  ('海水浴・シュノーケリング', 10);

-- さらに続きのメイン目的
INSERT INTO main_purposes (name, display_order) VALUES
  ('潮干狩り', 11),
  ('花見', 12),
  ('紅葉狩り', 13),
  ('野鳥観察', 14),
  ('釣り', 15),
  ('鉄道撮影', 16);

-- サブ目的データ挿入
INSERT INTO sub_purposes (name, display_order) VALUES
  ('温泉', 1),
  ('道の駅', 2),
  ('バーベキュー', 3),
  ('キャンプ場', 4),
  ('RVパーク', 5);

-- 続きのサブ目的
INSERT INTO sub_purposes (name, display_order) VALUES
  ('地元グルメ', 6),
  ('地元特産品店', 7),
  ('展望台', 8),
  ('文化財・史跡訪問', 9),
  ('国立公園', 10),
  ('景勝地', 11);