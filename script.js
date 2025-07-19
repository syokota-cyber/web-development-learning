// プロジェクト詳細の表示/非表示機能

document.addEventListener('DOMContentLoaded', function() {
    // 全ての詳細切り替えボタンを取得
    const toggleButtons = document.querySelectorAll('.toggle-details');
    
    // 初期状態で詳細を非表示にする
    const projectDetails = document.querySelectorAll('.project-details');
    projectDetails.forEach(detail => {
        detail.style.display = 'none';
    });
    
    // 各ボタンにクリックイベントを追加
    toggleButtons.forEach(button => {
        button.addEventListener('click', function() {
            // data-target属性から対象のIDを取得
            const targetId = this.getAttribute('data-target');
            const targetElement = document.getElementById(targetId);
            
            // 現在の表示状態を確認
            const isVisible = targetElement.style.display !== 'none';
            
            if (isVisible) {
                // 非表示にする
                targetElement.style.display = 'none';
                this.textContent = '詳細 ▼';
                this.classList.remove('expanded');
            } else {
                // 表示する
                targetElement.style.display = 'block';
                this.textContent = '詳細 ▲';
                this.classList.add('expanded');
            }
        });
    });
});