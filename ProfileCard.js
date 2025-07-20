// ProfileCard.js - あなたの最初のReactコンポーネント
// 
// 🎯 学習目標：
// 1. 関数コンポーネントの書き方
// 2. JSXの基本構文
// 3. HTMLのようでHTMLではない部分の理解

function ProfileCard() {
    return (
        <div className="profile-card">
            <h2>学習者プロフィール</h2>
            <p>名前: ショコたんご</p>
            <p>目標: React基礎をマスターする</p>
            <p>進捗: コンポーネント作成 ✅</p>
            <p>趣味: Web開発とプログラミング学習</p>
            <button>プロフィール編集</button>
        </div>
    );
}

// 他のファイルから使えるようにエクスポート
export default ProfileCard;

// 🔧 練習課題：
// 1. 「あなたの名前をここに書いてください」を実際の名前に変更
// 2. 新しい項目（趣味、学習時間など）を追加
// 3. ボタンの文字を変更してみる
//
// 💡 注意点：
// - className（classではない）
// - 必ず1つの親要素で囲む
// - JSXでは必ずタグを閉じる