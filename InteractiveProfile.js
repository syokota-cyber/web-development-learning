// InteractiveProfile.js - Stateを使った動的プロフィール
// 
// 🎯 学習目標：
// 1. useStateフックの使い方
// 2. イベントハンドラーの作成
// 3. 動的なUI更新の体験

import { useState } from 'react';

function InteractiveProfile() {
    // State（状態）の定義
    const [name, setName] = useState("ショコたんご");
    const [goal, setGoal] = useState("React基礎をマスターする");
    const [progress, setProgress] = useState("State学習中");
    const [isEditing, setIsEditing] = useState(false);
    
    // イベントハンドラー関数
    const handleEditClick = () => {
        setIsEditing(!isEditing); // true ↔ false を切り替え
    };
    
    const handleNameChange = (event) => {
        setName(event.target.value); // 入力値でnameを更新
    };
    
    const handleGoalChange = (event) => {
        setGoal(event.target.value); // 入力値でgoalを更新
    };
    
    const updateProgress = () => {
        setProgress("useState完全マスター! 🎉");
    };

    return (
        <div className="interactive-profile">
            <h2>動的プロフィールカード</h2>
            
            {/* 編集モードの切り替え */}
            {isEditing ? (
                // 編集モード（入力フィールド表示）
                <div className="edit-mode">
                    <p>名前: 
                        <input 
                            type="text" 
                            value={name} 
                            onChange={handleNameChange}
                        />
                    </p>
                    <p>目標: 
                        <input 
                            type="text" 
                            value={goal} 
                            onChange={handleGoalChange}
                        />
                    </p>
                    <p>進捗: {progress}</p>
                </div>
            ) : (
                // 表示モード（通常の表示）
                <div className="display-mode">
                    <p>名前: {name}</p>
                    <p>目標: {goal}</p>
                    <p>進捗: {progress}</p>
                </div>
            )}
            
            {/* ボタン群 */}
            <div className="buttons">
                <button onClick={handleEditClick}>
                    {isEditing ? "保存" : "編集"}
                </button>
                <button onClick={updateProgress}>
                    進捗を更新
                </button>
            </div>
            
            {/* デバッグ情報 */}
            <div className="debug-info">
                <small>編集モード: {isEditing ? "ON" : "OFF"}</small>
            </div>
        </div>
    );
}

export default InteractiveProfile;

// 🔧 練習課題：
// 1. 新しいState（趣味など）を追加してみる
// 2. 新しいボタンを追加してStateを変更
// 3. 条件分岐（isEditing）の動作を確認
//
// 💡 重要ポイント：
// - useState(初期値)で[値, 更新関数]を取得
// - 更新関数を呼ぶと自動で画面が更新される
// - イベントハンドラーでユーザーの操作に反応
// - 条件分岐で表示内容を動的に変更