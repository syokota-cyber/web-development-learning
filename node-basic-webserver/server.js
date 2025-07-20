const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');

// 設定ファイル管理
let config = {};

function loadConfig() {
  try {
    const configData = fs.readFileSync('config.json', 'utf8');
    config = JSON.parse(configData);
    console.log('✅ 設定ファイルを読み込みました:', config.server.name);
  } catch (error) {
    console.log('❌ 設定ファイルの読み込みに失敗:', error.message);
    // デフォルト設定を使用
    config = {
      server: { port: 8080, host: 'localhost', name: 'デフォルトサーバー' },
      weather: { defaultCity: '東京', updateInterval: 1000, simulationMode: true },
      logging: { enabled: true, logFile: 'access.log', logLevel: 'info' }
    };
  }
}

function saveConfig() {
  try {
    config.lastUpdated = new Date().toISOString();
    fs.writeFileSync('config.json', JSON.stringify(config, null, 2));
    console.log('💾 設定ファイルを保存しました');
  } catch (error) {
    console.log('❌ 設定ファイルの保存に失敗:', error.message);
  }
}

// 起動時に設定を読み込み
loadConfig();

// アクセスログ機能
function logAccess(req, res, statusCode) {
  if (!config.logging.enabled) return;
  
  const timestamp = new Date().toISOString();
  const ip = req.connection.remoteAddress || 'unknown';
  const method = req.method;
  const url = req.url;
  const userAgent = req.headers['user-agent'] || 'unknown';
  
  const logEntry = {
    timestamp,
    ip,
    method,
    url,
    statusCode,
    userAgent
  };
  
  // ログをファイルに追記（非同期）
  const logLine = `${timestamp} | ${ip} | ${method} ${url} | ${statusCode} | ${userAgent}\n`;
  
  fs.appendFile(config.logging.logFile, logLine, (err) => {
    if (err) {
      console.log('❌ ログファイル書き込みエラー:', err.message);
    }
  });
  
  // メモリ上にも保存（最新100件）
  if (!global.accessLogs) global.accessLogs = [];
  global.accessLogs.push(logEntry);
  if (global.accessLogs.length > 100) {
    global.accessLogs.shift(); // 古いログを削除
  }
  
  console.log(`📊 ${method} ${url} - ${statusCode}`);
}

// 静的ファイル配信関数（ログ対応）
function serveStaticFile(filePath, res, req) {
  const fullPath = path.join(__dirname, 'public', filePath);
  
  fs.readFile(fullPath, (err, data) => {
    if (err) {
      res.writeHead(404, {'Content-Type': 'text/html; charset=utf-8'});
      res.end('<h1>404 - ファイルが見つかりません</h1>');
      logAccess(req, res, 404);
      return;
    }
    
    // ファイル拡張子に基づいてContent-Typeを設定
    const ext = path.extname(filePath);
    let contentType = 'text/html; charset=utf-8';
    
    if (ext === '.css') contentType = 'text/css';
    if (ext === '.js') contentType = 'application/javascript';
    if (ext === '.json') contentType = 'application/json';
    
    res.writeHead(200, {'Content-Type': contentType});
    res.end(data);
    logAccess(req, res, 200);
  });
}

// 天気情報取得関数（簡単版）
function getWeatherData(callback) {
  // 実際のAPIの代わりに、ランダムな値を生成
  const weatherData = {
    city: '東京',
    temperature: Math.floor(Math.random() * 15) + 15, // 15-30度
    weather: ['晴れ', '曇り', '雨', '雪'][Math.floor(Math.random() * 4)],
    humidity: Math.floor(Math.random() * 40) + 40 // 40-80%
  };
  
  // 外部API呼び出しをシミュレート（1秒待機）
  setTimeout(() => callback(weatherData), 1000);
}

const server = http.createServer((req, res) => {
  const url = req.url;
  
  if (url === '/' || url === '/home') {
    // 外部HTMLファイルを配信
    serveStaticFile('index.html', res, req);
  } else if (url === '/inline') {
    // インライン版も残しておく（比較用）
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.end(`
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Node.js ホームページ</title>
          <style>
            body {
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
              margin: 0;
              padding: 0;
              background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
              min-height: 100vh;
              display: flex;
              justify-content: center;
              align-items: center;
            }
            .container {
              background: white;
              padding: 2rem;
              border-radius: 20px;
              box-shadow: 0 20px 40px rgba(0,0,0,0.1);
              text-align: center;
              max-width: 500px;
              width: 90%;
            }
            h1 {
              color: #333;
              margin-bottom: 1rem;
              font-size: 2.5rem;
            }
            .time {
              color: #666;
              font-size: 1.2rem;
              margin: 1.5rem 0;
              padding: 1rem;
              background: #f8f9fa;
              border-radius: 10px;
            }
            .nav-buttons {
              display: flex;
              gap: 1rem;
              justify-content: center;
              margin-top: 2rem;
            }
            .btn {
              padding: 12px 24px;
              background: #667eea;
              color: white;
              text-decoration: none;
              border-radius: 25px;
              transition: all 0.3s ease;
              font-weight: bold;
            }
            .btn:hover {
              background: #5a6fd8;
              transform: translateY(-2px);
              box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }
            .weather-btn {
              background: #ff6b6b;
            }
            .weather-btn:hover {
              background: #ff5252;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <h1>🏠 ようこそ！</h1>
            <div class="time" id="current-time">
              現在時刻: ${new Date().toLocaleString('ja-JP')}
            </div>
            <div class="nav-buttons">
              <a href="/api" class="btn">📊 API情報</a>
              <a href="/weather" class="btn weather-btn">🌤️ 天気情報</a>
            </div>
          </div>
          
          <script>
            // リアルタイム時計
            function updateTime() {
              const now = new Date();
              document.getElementById('current-time').innerHTML = 
                '現在時刻: ' + now.toLocaleString('ja-JP');
            }
            
            // 1秒ごとに時刻を更新
            setInterval(updateTime, 1000);
            
            // ページ読み込み時のアニメーション
            window.addEventListener('load', function() {
              const container = document.querySelector('.container');
              container.style.opacity = '0';
              container.style.transform = 'translateY(20px)';
              
              setTimeout(function() {
                container.style.transition = 'all 0.5s ease';
                container.style.opacity = '1';
                container.style.transform = 'translateY(0)';
              }, 100);
            });
          </script>
        </body>
      </html>
    `);
  } else if (url === '/api') {
    // JSON API（設定情報も含む）
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify({
      message: 'Hello API!', 
      status: 'success', 
      time: new Date(),
      server: 'Node.js',
      config: {
        serverName: config.server.name,
        weatherCity: config.weather.defaultCity,
        loggingEnabled: config.logging.enabled
      }
    }));
    logAccess(req, res, 200);
  } else if (url === '/config') {
    // 設定ファイル閲覧・編集ページ
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.end(`
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <title>設定管理</title>
          <style>
            body { font-family: Arial, sans-serif; margin: 2rem; background: #f5f5f5; }
            .config-container { background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            .config-section { margin: 1rem 0; padding: 1rem; background: #f8f9fa; border-radius: 5px; }
            .btn { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; margin: 5px; }
            .btn:hover { background: #0056b3; }
            .btn-success { background: #28a745; }
            .btn-warning { background: #ffc107; color: #212529; }
            pre { background: #f8f9fa; padding: 1rem; border-radius: 5px; overflow-x: auto; }
          </style>
        </head>
        <body>
          <div class="config-container">
            <h1>⚙️ 設定管理</h1>
            
            <div class="config-section">
              <h3>現在の設定</h3>
              <pre>${JSON.stringify(config, null, 2)}</pre>
            </div>
            
            <div class="config-section">
              <h3>設定操作</h3>
              <button class="btn" onclick="reloadConfig()">🔄 設定を再読み込み</button>
              <button class="btn btn-warning" onclick="updatePort()">🔧 ポート番号変更</button>
              <button class="btn btn-success" onclick="saveSettings()">💾 設定を保存</button>
            </div>
            
            <div class="config-section">
              <h3>ファイル操作のしくみ</h3>
              <p>📖 <strong>読み込み:</strong> fs.readFileSync('config.json') でファイルを読み取り</p>
              <p>💾 <strong>保存:</strong> fs.writeFileSync('config.json') でファイルに書き込み</p>
              <p>🔄 <strong>更新:</strong> メモリ上の設定を変更後、ファイルに保存</p>
            </div>
            
            <a href="/" class="btn">🏠 ホームに戻る</a>
          </div>
          
          <script>
            function reloadConfig() {
              fetch('/config/reload', {method: 'POST'})
                .then(() => location.reload());
            }
            
            function updatePort() {
              const newPort = prompt('新しいポート番号を入力してください:', '8080');
              if (newPort) {
                fetch('/config/update-port', {
                  method: 'POST',
                  headers: {'Content-Type': 'application/json'},
                  body: JSON.stringify({port: parseInt(newPort)})
                }).then(() => location.reload());
              }
            }
            
            function saveSettings() {
              fetch('/config/save', {method: 'POST'})
                .then(() => {
                  alert('設定を保存しました！');
                  location.reload();
                });
            }
          </script>
        </body>
      </html>
    `);
    logAccess(req, res, 200);
  } else if (url === '/weather') {
    // 天気情報ページ（外部API使用）
    getWeatherData((data) => {
      res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
      res.end(`
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>天気情報</title>
            <style>
              body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
              }
              .weather-card {
                background: white;
                padding: 2rem;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                text-align: center;
                max-width: 400px;
                width: 90%;
                position: relative;
                overflow: hidden;
              }
              .weather-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 5px;
                background: linear-gradient(90deg, #74b9ff, #0984e3, #74b9ff);
              }
              h1 {
                color: #2d3436;
                margin-bottom: 1rem;
                font-size: 2rem;
              }
              .city {
                font-size: 1.5rem;
                color: #636e72;
                margin-bottom: 1.5rem;
              }
              .weather-info {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1rem;
                margin: 1.5rem 0;
              }
              .info-item {
                background: #f1f2f6;
                padding: 1rem;
                border-radius: 10px;
                transition: transform 0.3s ease;
              }
              .info-item:hover {
                transform: scale(1.05);
              }
              .info-label {
                font-size: 0.9rem;
                color: #636e72;
                margin-bottom: 0.5rem;
              }
              .info-value {
                font-size: 1.4rem;
                font-weight: bold;
                color: #2d3436;
              }
              .temperature {
                grid-column: 1 / -1;
                background: linear-gradient(135deg, #fd79a8 0%, #e84393 100%);
                color: white;
              }
              .temperature .info-value {
                color: white;
                font-size: 2.5rem;
              }
              .update-time {
                color: #636e72;
                font-size: 0.9rem;
                margin: 1rem 0;
                font-style: italic;
              }
              .nav-buttons {
                display: flex;
                gap: 1rem;
                justify-content: center;
                margin-top: 1.5rem;
              }
              .btn {
                padding: 10px 20px;
                border-radius: 20px;
                text-decoration: none;
                font-weight: bold;
                transition: all 0.3s ease;
              }
              .btn-home {
                background: #00b894;
                color: white;
              }
              .btn-refresh {
                background: #fdcb6e;
                color: #2d3436;
              }
              .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
              }
            </style>
          </head>
          <body>
            <div class="weather-card">
              <h1>🌤️ 今日の天気</h1>
              <div class="city">${data.city}</div>
              
              <div class="weather-info">
                <div class="info-item temperature">
                  <div class="info-label">気温</div>
                  <div class="info-value">${data.temperature}°C</div>
                </div>
                <div class="info-item">
                  <div class="info-label">天気</div>
                  <div class="info-value">${data.weather}</div>
                </div>
                <div class="info-item">
                  <div class="info-label">湿度</div>
                  <div class="info-value">${data.humidity}%</div>
                </div>
              </div>
              
              <div class="update-time">
                更新時刻: ${new Date().toLocaleString('ja-JP')}
              </div>
              
              <div class="nav-buttons">
                <a href="/" class="btn btn-home">🏠 ホーム</a>
                <a href="/weather" class="btn btn-refresh">🔄 更新</a>
              </div>
            </div>
            
            <script>
              // ページ読み込みアニメーション
              window.addEventListener('load', function() {
                const card = document.querySelector('.weather-card');
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px) scale(0.9)';
                
                setTimeout(function() {
                  card.style.transition = 'all 0.6s ease';
                  card.style.opacity = '1';
                  card.style.transform = 'translateY(0) scale(1)';
                }, 100);
              });
            </script>
          </body>
        </html>
      `);
    });
  } else if (url === '/logs') {
    // ログ表示ページ
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    const logs = global.accessLogs || [];
    const logCount = logs.length;
    const recentLogs = logs.slice(-20).reverse(); // 最新20件を表示
    
    res.end(`
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <title>アクセスログ</title>
          <style>
            body { font-family: Arial, sans-serif; margin: 2rem; background: #f5f5f5; }
            .log-container { background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
            .log-stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 2rem; }
            .stat-card { background: #f8f9fa; padding: 1rem; border-radius: 8px; text-align: center; }
            .stat-number { font-size: 2rem; font-weight: bold; color: #007bff; }
            .log-table { width: 100%; border-collapse: collapse; margin: 1rem 0; }
            .log-table th, .log-table td { padding: 8px; border: 1px solid #ddd; text-align: left; }
            .log-table th { background: #f8f9fa; font-weight: bold; }
            .log-table tr:nth-child(even) { background: #f9f9f9; }
            .status-200 { color: #28a745; font-weight: bold; }
            .status-404 { color: #dc3545; font-weight: bold; }
            .btn { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; margin: 5px; text-decoration: none; display: inline-block; }
            .btn:hover { background: #0056b3; }
            .auto-refresh { color: #28a745; font-weight: bold; }
          </style>
        </head>
        <body>
          <div class="log-container">
            <h1>📊 アクセスログ</h1>
            
            <div class="log-stats">
              <div class="stat-card">
                <div class="stat-number">${logCount}</div>
                <div>総アクセス数</div>
              </div>
              <div class="stat-card">
                <div class="stat-number">${logs.filter(l => l.statusCode === 200).length}</div>
                <div>成功 (200)</div>
              </div>
              <div class="stat-card">
                <div class="stat-number">${logs.filter(l => l.statusCode === 404).length}</div>
                <div>エラー (404)</div>
              </div>
              <div class="stat-card">
                <div class="stat-number">${new Date().toLocaleString('ja-JP')}</div>
                <div>現在時刻</div>
              </div>
            </div>
            
            <h3>最新のアクセス（20件）<span class="auto-refresh" id="refresh-indicator"></span></h3>
            <table class="log-table">
              <thead>
                <tr>
                  <th>時刻</th>
                  <th>IPアドレス</th>
                  <th>メソッド</th>
                  <th>URL</th>
                  <th>ステータス</th>
                </tr>
              </thead>
              <tbody>
                ${recentLogs.map(log => `
                  <tr>
                    <td>${new Date(log.timestamp).toLocaleString('ja-JP')}</td>
                    <td>${log.ip}</td>
                    <td>${log.method}</td>
                    <td>${log.url}</td>
                    <td class="status-${log.statusCode}">${log.statusCode}</td>
                  </tr>
                `).join('')}
              </tbody>
            </table>
            
            <div style="margin-top: 2rem;">
              <button class="btn" onclick="location.reload()">🔄 更新</button>
              <a href="/logs/api" class="btn">📊 JSON API</a>
              <a href="/" class="btn">🏠 ホーム</a>
            </div>
          </div>
          
          <script>
            // 5秒ごとに自動更新
            let refreshCount = 0;
            setInterval(() => {
              refreshCount++;
              document.getElementById('refresh-indicator').textContent = 
                \` (自動更新: \${refreshCount}回)\`;
              
              if (refreshCount % 6 === 0) { // 30秒ごとにページ更新
                location.reload();
              }
            }, 5000);
          </script>
        </body>
      </html>
    `);
    logAccess(req, res, 200);
  } else if (url === '/logs/api') {
    // ログAPIエンドポイント
    res.writeHead(200, {'Content-Type': 'application/json'});
    const logs = global.accessLogs || [];
    res.end(JSON.stringify({
      total: logs.length,
      recent: logs.slice(-10),
      stats: {
        success: logs.filter(l => l.statusCode === 200).length,
        notFound: logs.filter(l => l.statusCode === 404).length,
        lastAccess: logs.length > 0 ? logs[logs.length - 1].timestamp : null
      }
    }));
    logAccess(req, res, 200);
  } else if (url === '/config/reload' && req.method === 'POST') {
    // 設定再読み込み
    loadConfig();
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify({status: 'success', message: '設定を再読み込みしました'}));
  } else if (url === '/config/save' && req.method === 'POST') {
    // 設定保存
    saveConfig();
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify({status: 'success', message: '設定を保存しました'}));
  } else if (url === '/config/update-port' && req.method === 'POST') {
    // ポート番号更新
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try {
        const data = JSON.parse(body);
        config.server.port = data.port;
        saveConfig();
        res.writeHead(200, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({status: 'success', message: `ポートを${data.port}に変更しました`}));
      } catch (error) {
        res.writeHead(400, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({status: 'error', message: 'データの解析に失敗しました'}));
      }
    });
  } else if (url.startsWith('/style.css') || url.startsWith('/script.js')) {
    // 静的ファイル（CSS, JS）を配信
    const fileName = url.substring(1); // 先頭の'/'を除去
    serveStaticFile(fileName, res, req);
  } else {
    // 404エラー
    res.writeHead(404, {'Content-Type': 'text/html; charset=utf-8'});
    res.end(`
      <html>
        <head>
          <meta charset="utf-8">
          <title>404エラー</title>
        </head>
        <body>
          <h1>404 - ページが見つかりません</h1>
          <p><a href="/">ホームに戻る</a></p>
        </body>
      </html>
    `);
    logAccess(req, res, 404);
  }
});

server.listen(8080, () => console.log('Server running on http://localhost:8080'));