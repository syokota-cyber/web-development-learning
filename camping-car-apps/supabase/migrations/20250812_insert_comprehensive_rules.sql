-- travel_rulesテーブルにメイン目的別の充実したルール・マナーを挿入

-- 各メイン目的のIDを取得してルールを挿入
-- 観光用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '撮影マナーの遵守', '史跡や文化財では撮影禁止エリアを確認し、フラッシュ撮影や三脚使用のルールを守りましょう。', true, 1
FROM main_purposes WHERE name = '観光';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '静粛の保持', '神社仏閣や美術館では静かに見学し、大声での会話は控えましょう。', true, 2
FROM main_purposes WHERE name = '観光';

-- SUP・カヤック用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', 'ライフジャケット必須着用', '水上アクティビティでは必ずライフジャケットを着用してください。法令でも義務化されています。', true, 1
FROM main_purposes WHERE name = 'SUP・カヤック';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '気象・波浪情報の確認', '出発前に必ず気象情報と波浪情報を確認し、悪天候時は中止する勇気を持ちましょう。', true, 2
FROM main_purposes WHERE name = 'SUP・カヤック';

-- サイクリング用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', 'ヘルメット着用と点検', 'ヘルメットを必ず着用し、出発前にブレーキやライトの動作確認を行いましょう。', true, 1
FROM main_purposes WHERE name = 'サイクリング';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '車道走行と一列走行', 'サイクリングロード以外では車道左側を一列で走行し、並走は避けましょう。', true, 2
FROM main_purposes WHERE name = 'サイクリング';

-- スキー・スノーボード用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', 'ゲレンデルールの遵守', 'コース外滑走は厳禁です。標識やロープで区切られたエリアには絶対に立ち入らないでください。', true, 1
FROM main_purposes WHERE name = 'スキー・スノーボード';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '雪崩・気象情報の確認', '雪崩注意報や気象警報が発令されている場合は、無理な滑走を控えましょう。', true, 2
FROM main_purposes WHERE name = 'スキー・スノーボード';

-- 登山・ハイキング用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '登山計画書の提出', '登山口や警察署に登山計画書を提出し、下山時は必ず下山届を出しましょう。', true, 1
FROM main_purposes WHERE name = '登山・ハイキング';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '適切な装備と食料', '天候急変に備えた防寒具、十分な水分と非常食、ヘッドライトを必ず携帯しましょう。', true, 2
FROM main_purposes WHERE name = '登山・ハイキング';

-- フルーツ狩り用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '指定エリアでの収穫', '案内された指定エリア以外での収穫は禁止です。ルールを守って楽しくフルーツ狩りをしましょう。', true, 1
FROM main_purposes WHERE name = 'フルーツ狩り';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '食べ放題の節度', 'その場での試食は適度にとどめ、大量の持ち帰りは指定されたルールに従いましょう。', true, 2
FROM main_purposes WHERE name = 'フルーツ狩り';

-- 夜景撮影用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '私有地立入の禁止', '撮影のために私有地や立入禁止区域に無断で入ることは絶対に禁止です。', true, 1
FROM main_purposes WHERE name = '夜景撮影';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '三脚マナーと安全確保', '三脚は通行の妨げにならない場所に設置し、夜間の安全確保のため懐中電灯を携帯しましょう。', true, 2
FROM main_purposes WHERE name = '夜景撮影';

-- 天体観測用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '赤色ライトの使用', '他の観測者の観測を妨げないよう、必要時は赤色ライトのみを使用しましょう。', true, 1
FROM main_purposes WHERE name = '天体観測';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '観測地のマナー', '観測地では静かに行動し、車のライトや懐中電灯で他の人の観測を妨害しないよう注意しましょう。', true, 2
FROM main_purposes WHERE name = '天体観測';

-- 日の出・夕陽撮影用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '早朝・夕方の安全確保', '暗い時間帯の移動では、滑落や転倒に十分注意し、明るい服装で視認性を確保しましょう。', true, 1
FROM main_purposes WHERE name = '日の出・夕陽撮影';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '混雑時の配慮', '人気撮影スポットでは場所の独占を避け、他の人も撮影できるよう譲り合いましょう。', true, 2
FROM main_purposes WHERE name = '日の出・夕陽撮影';

-- 海水浴・シュノーケリング用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '遊泳可能エリアの確認', 'ライフガードがいる指定された遊泳エリア以外では泳がず、危険フラッグに注意しましょう。', true, 1
FROM main_purposes WHERE name = '海水浴・シュノーケリング';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '海洋生物の保護', 'サンゴや海洋生物には触れず、日焼け止めは海洋環境に配慮したものを使用しましょう。', true, 2
FROM main_purposes WHERE name = '海水浴・シュノーケリング';

-- 潮干狩り用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '採取ルールの遵守', '指定されたサイズ以下の貝は採取せず、採取量の制限を守りましょう。資源保護のため重要です。', true, 1
FROM main_purposes WHERE name = '潮干狩り';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '干潟の環境保護', '干潟を必要以上に掘り返さず、採取後は元通りに整地して海洋環境を保護しましょう。', true, 2
FROM main_purposes WHERE name = '潮干狩り';

-- 花見用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '桜の保護', '桜の枝を折ったり、木に登ったりせず、根元を踏み荒らさないよう注意しましょう。', true, 1
FROM main_purposes WHERE name = '花見';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '場所取りマナー', '場所取りは最小限にとどめ、長時間の占有は避けて他の来園者との共有を心がけましょう。', true, 2
FROM main_purposes WHERE name = '花見';

-- 紅葉狩り用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '自然保護と採取禁止', '紅葉した葉や枝の採取は禁止です。写真撮影で自然の美しさを記録に残しましょう。', true, 1
FROM main_purposes WHERE name = '紅葉狩り';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '混雑時期の配慮', '紅葉シーズンは混雑するため、早朝や平日の利用、公共交通機関の活用を推奨します。', true, 2
FROM main_purposes WHERE name = '紅葉狩り';

-- 野鳥観察用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '静かな観察', '野鳥を驚かせないよう静かに行動し、巣に近づいたり餌を与えたりしないでください。', true, 1
FROM main_purposes WHERE name = '野鳥観察';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '適切な距離の維持', '望遠レンズやフラッシュ撮影は野鳥にストレスを与えるため、適切な距離を保ちましょう。', true, 2
FROM main_purposes WHERE name = '野鳥観察';

-- 釣り用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '遊漁券の購入', '内水面での釣りでは遊漁券が必要です。現地の釣具店や漁協で事前に購入しましょう。', true, 1
FROM main_purposes WHERE name = '釣り';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '禁漁期間と漁法制限', '魚種ごとの禁漁期間や使用できる漁具の制限を確認し、資源保護に協力しましょう。', true, 2
FROM main_purposes WHERE name = '釣り';

-- 鉄道撮影用ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '安全な撮影位置', '線路内や駅構内での撮影は危険です。必ず安全な公道や指定された場所から撮影しましょう。', true, 1
FROM main_purposes WHERE name = '鉄道撮影';

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'specific', '農地・私有地の尊重', '撮影のために無断で農地や私有地に立ち入ることは絶対に禁止です。許可を得てから撮影しましょう。', true, 2
FROM main_purposes WHERE name = '鉄道撮影';

-- 全目的共通の基本ルール
INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'general', 'ゴミの完全持ち帰り', '自分が出したゴミは必ず持ち帰り、来た時よりも美しい状態で帰りましょう。', true, 10
FROM main_purposes;

INSERT INTO travel_rules (main_purpose_id, rule_category, rule_title, rule_description, is_required, display_order)
SELECT id, 'general', '地元住民への配慮', '騒音や路上駐車で地元住民に迷惑をかけないよう、マナーある行動を心がけましょう。', true, 11
FROM main_purposes;

-- 挿入結果の確認
SELECT 
    '✅ ルール挿入完了' as status,
    COUNT(*) as total_rules,
    COUNT(DISTINCT main_purpose_id) as purposes_covered,
    COUNT(CASE WHEN rule_category = 'specific' THEN 1 END) as specific_rules,
    COUNT(CASE WHEN rule_category = 'general' THEN 1 END) as general_rules
FROM travel_rules;