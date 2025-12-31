import { useState } from 'react'
import './App.css'

function App() {
    const [fortune, setFortune] = useState(null);
    const [loading, setLoading] = useState(false);

    const drawOmikuji = async () => {
        setLoading(true);
        setFortune(null);

        // 1. 鐘を鳴らす (public/bell.mp3)
        const audio = new Audio('/bell.mp3');
        audio.play();

        try {
            // 2. Rails APIを叩く (時間はかかる想定)
            // 演出として「最低3秒」は待たせるために Promise.all を使用
            const [response] = await Promise.all([
                fetch('http://localhost:3000/fortunes/draw'),
                new Promise(resolve => setTimeout(resolve, 3000)) // 最低3秒待機
            ]);

            const data = await response.json();
            setFortune(data);
        } catch (error) {
            alert("通信に失敗しました。Railsは起動していますか？");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="container">
            <h1>🔔 除夜の鐘おみくじ</h1>

            <div className={`bell-section ${loading ? 'shaking' : ''}`} onClick={!loading ? drawOmikuji : null}>
                <div className="bell">🔔</div>
                {!loading && !fortune && <p className="hint">クリックして鐘を突く</p>}
            </div>

            {loading && <p className="status">祈祷中...（AIが運勢を生成中）</p>}

            {fortune && (
                <div className="result-card">
                    <h2 className="rank">{fortune.rank}</h2>
                    <p className="message">{fortune.ai_message}</p>
                    <button onClick={() => setFortune(null)}>もう一度</button>
                </div>
            )}
        </div>
    )
}

export default App