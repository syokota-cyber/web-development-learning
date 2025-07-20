// 外部JavaScriptファイル：script.js

console.log('🚀 外部JavaScriptファイルが読み込まれました！');

// リアルタイム時計機能
function updateTime() {
  const now = new Date();
  const timeElement = document.getElementById('current-time');
  
  if (timeElement) {
    timeElement.innerHTML = '現在時刻: ' + now.toLocaleString('ja-JP');
    
    // 更新時に視覚的フィードバック
    timeElement.classList.add('updated');
    setTimeout(() => {
      timeElement.classList.remove('updated');
    }, 1000);
  }
}

// ページ読み込み完了時の処理
document.addEventListener('DOMContentLoaded', function() {
  console.log('📄 DOMが読み込まれました');
  
  // 初回時刻表示
  updateTime();
  
  // 1秒ごとに時刻を更新
  setInterval(updateTime, 1000);
  
  // ボタンにクリックイベントを追加
  const buttons = document.querySelectorAll('.btn');
  buttons.forEach(button => {
    button.addEventListener('click', function(e) {
      console.log('🔗 リンククリック:', this.href);
      
      // クリック時のアニメーション
      this.style.transform = 'scale(0.95)';
      setTimeout(() => {
        this.style.transform = '';
      }, 150);
    });
  });
  
  // ページ情報をコンソールに表示
  console.log('📁 ファイル構成:');
  console.log('  - HTML: index.html');
  console.log('  - CSS: style.css'); 
  console.log('  - JS: script.js');
  console.log('  - Server: server.js');
});

// ウィンドウサイズ変更時の処理
window.addEventListener('resize', function() {
  console.log('📱 ウィンドウサイズが変更されました');
});

// タブの表示/非表示切り替え時の処理
document.addEventListener('visibilitychange', function() {
  if (document.hidden) {
    console.log('👀 タブが非表示になりました');
  } else {
    console.log('👁️ タブが表示されました');
    updateTime(); // タブが戻った時に時刻を即座に更新
  }
});