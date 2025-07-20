#!/bin/bash

command="$1"

echo "🔍 コマンド実行前チェック: $command"

# 学習モードでは危険なコマンドを制限
case "$command" in
    *"npm run dev"*|*"npm start"*|*"yarn dev"*|*"yarn start"*)
        echo "⚠️  開発サーバーの起動は学習目的では推奨しません"
        echo ""
        echo "📚 学習により効果的な方法："
        echo "  • 小さなテストファイルで動作確認"
        echo "  • 個別の機能をNode.jsで直接実行"
        echo "  • 静的ファイルでの動作確認"
        echo ""
        echo "💡 それでも実行したい場合は、手動で実行してください："
        echo "   $command"
        exit 1
        ;;
    *"rm -rf"*|*"git push"*|*"sudo"*)
        echo "🚫 危険なコマンドは学習段階では実行しません"
        echo ""
        echo "⚠️  このコマンドは以下のリスクがあります："
        case "$command" in
            *"rm -rf"*)
                echo "  • ファイルの完全削除（復旧不可能）"
                ;;
            *"git push"*)
                echo "  • リモートリポジトリへの変更反映"
                echo "  • 他の開発者への影響"
                ;;
            *"sudo"*)
                echo "  • システムレベルの権限昇格"
                echo "  • システム設定の変更"
                ;;
        esac
        echo ""
        echo "📚 学習目的であれば、より安全な代替方法を検討しましょう"
        exit 1
        ;;
    *"npm install"*|*"yarn add"*)
        echo "📦 パッケージのインストールを実行します"
        echo "💡 インストール後は package.json の変更を確認してみましょう"
        ;;
    *"git commit"*)
        echo "📝 コミットを実行します"
        echo "💡 コミット後は git log で履歴を確認してみましょう"
        ;;
    *"npm test"*|*"yarn test"*)
        echo "🧪 テストを実行します"
        echo "💡 テスト結果を読んで理解を深めましょう"
        ;;
esac

echo "✅ コマンド実行を許可します: $command"
