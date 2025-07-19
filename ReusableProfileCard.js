// ReusableProfileCard.js - Props対応版プロフィールカード
// 
// 🎯 学習目標：
// 1. Propsを受け取る方法
// 2. JSXで変数を表示する方法（{}の使い方）
// 3. 同じコンポーネントで違う内容を表示

function ReusableProfileCard(props) {
    return (
        <div className="profile-card">
            <h2>{props.title}</h2>
            <p>名前: {props.name}</p>
            <p>目標: {props.goal}</p>
            <p>進捗: {props.progress}</p>
            <p>趣味: {props.hobby}</p>
            <button>{props.buttonText}</button>
        </div>
    );
}

// 使用例を作成する親コンポーネント
function ProfileGallery() {
    return (
        <div>
            <h1>学習者ギャラリー</h1>
            
            {/* 1人目のプロフィール */}
            <ReusableProfileCard 
                title="学習者プロフィール"
                name="ショコたんご"
                goal="React基礎をマスターする"
                progress="Props学習中 🚀"
                hobby="Web開発とプログラミング学習"
                buttonText="プロフィール編集"
            />
            
            {/* 2人目のプロフィール（練習用）*/}
            <ReusableProfileCard 
                title="開発者プロフィール"
                name="田中太郎"
                goal="フルスタック開発者になる"
                progress="バックエンド学習中 ⚡"
                hobby="ゲーム制作とアニメ"
                buttonText="詳細を見る"
            />
        </div>
    );
}

export default ReusableProfileCard;
export { ProfileGallery };

// 🔧 練習課題：
// 1. 3人目のプロフィールを追加してみる
// 2. 新しいプロパティ（年齢、住所など）を追加
// 3. props.○○の部分でどんな値が表示されるか確認
//
// 💡 重要ポイント：
// - {}内にJavaScriptの変数や式を書ける
// - propsは関数の第1引数として受け取る
// - 同じコンポーネントを何度でも再利用可能