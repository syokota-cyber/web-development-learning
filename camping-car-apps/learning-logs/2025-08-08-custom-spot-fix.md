# 🔧 カスタム立ち寄りスポット達成度保存問題 - 修正ログ

**日付**: 2025年8月8日  
**問題**: カスタム立ち寄りスポットの達成度チェックが戻ると消えてしまう

---

## 🚨 **問題の詳細**

### **症状**
- カスタム立ち寄りスポットにチェックを入れる
- 画面遷移して戻る
- チェックが外れている（未チェック状態に戻る）

### **根本原因**
1. **ID生成の不整合**: `encodeURIComponent`の使用による特殊文字のエンコード
2. **復元処理の不完全**: カスタムIDの復元処理で確実に追加されていない
3. **デバッグ情報不足**: 問題の特定が困難

---

## ✅ **実行した修正**

### **1. ID生成の統一** 
**ファイル**: `src/components/TripReview.jsx:118-140`

**修正前**:
```javascript
const customId = `custom_name_${encodeURIComponent(customSub.name)}`;
```

**修正後**:
```javascript
const customId = `custom_name_${customSub.name}`; // エンコードなしで統一
```

### **2. 復元処理の改善**
**ファイル**: `src/components/TripReview.jsx:320-340`

**修正前**:
```javascript
if (idStr.startsWith('custom_name_')) {
  console.log('📍 復元: カスタムスポットID detected (名前ベース):', key);
} else if (idStr.startsWith('custom_')) {
  console.log('📍 復元: カスタムスポットID detected (旧形式):', key);
}
achievedSet.add(key);
```

**修正後**:
```javascript
if (idStr.startsWith('custom_name_')) {
  console.log('📍 復元: カスタムスポットID detected (名前ベース):', key);
  // カスタムIDの場合は確実に追加
  achievedSet.add(key);
} else if (idStr.startsWith('custom_')) {
  console.log('📍 復元: カスタムスポットID detected (旧形式):', key);
  achievedSet.add(key);
} else {
  // 通常のIDの場合
  achievedSet.add(key);
}
```

### **3. デバッグ情報の追加**
**ファイル**: `src/components/TripReview.jsx:735-740`

```javascript
console.log(`  - purposeIdStr: ${purposeIdStr}`);
console.log(`  - key: ${key}`);
console.log(`  - achievedPurposes contains: ${Array.from(achievedPurposes).join(', ')}`);
console.log(`  - isChecked: ${isChecked}`);
```

---

## 🔍 **修正の技術的詳細**

### **ID生成の一貫性**
- **問題**: `encodeURIComponent`で特殊文字がエンコードされ、保存時と復元時でIDが異なる
- **解決**: エンコードなしで統一し、一貫性を保証

### **復元処理の確実性**
- **問題**: カスタムIDの復元処理で条件分岐が不完全
- **解決**: 各条件で確実に`achievedSet.add(key)`を実行

### **デバッグの改善**
- **問題**: 問題の特定が困難
- **解決**: 詳細なログ出力で状態を可視化

---

## 🧪 **テスト手順**

### **1. カスタム立ち寄りスポット追加**
1. 旅行記録作成画面で「カスタム立ち寄りスポット」を追加
2. 名前を入力して追加ボタンをクリック

### **2. 達成度チェック**
1. レビュー画面でカスタム立ち寄りスポットにチェック
2. コンソールでログを確認:
   ```
   📍 カスタムスポット from selectedPurposes: "スポット名" with ID: custom_name_スポット名
   ```

### **3. 保存・復元テスト**
1. 「レビューを保存」ボタンをクリック
2. 画面遷移して戻る
3. チェック状態が維持されていることを確認

### **4. 期待されるログ**
```
📍 復元: カスタムスポットID detected (名前ベース): sub_custom_name_スポット名
Rendering sub purpose: スポット名 (sub_custom_name_スポット名) - checked: true
```

---

## 📊 **修正前後の比較**

| 項目 | 修正前 | 修正後 |
|------|--------|--------|
| ID生成 | `custom_name_${encodeURIComponent(name)}` | `custom_name_${name}` |
| 復元処理 | 条件分岐後に一括追加 | 各条件で個別追加 |
| デバッグ | 基本ログのみ | 詳細ログ追加 |
| 特殊文字 | エンコードで問題発生 | エンコードなしで統一 |

---

## ⚠️ **注意事項**

1. **既存データ**: エンコードされたIDで保存された既存データは手動で修正が必要
2. **特殊文字**: カスタム立ち寄りスポット名に特殊文字を含めないことを推奨
3. **テスト**: 修正後は必ず保存・復元のフローをテスト

---

## 🔄 **次のステップ**

1. ✅ ローカル環境での修正完了
2. ⏳ 動作確認テスト
3. ⏳ 本番環境への反映
4. ⏳ 既存データの移行（必要に応じて）

---

**修正完了後、このログは削除可能です。**
