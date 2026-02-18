import React, { useState } from 'react';
import { Shield, Send, Lock, Eye, Zap, Database } from 'lucide-react';

function App() {
  const [prompt, setPrompt] = useState('');
  const [response, setResponse] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleSend = async () => {
    if (!prompt) return;
    setLoading(true);
    
    try {
      const res = await fetch('http://localhost:3000/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ prompt })
      });
      const data = await res.json();
      setResponse(data);
    } catch (error) {
      console.error("Gateway Error:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 font-sans">
      {/* Header */}
      <nav className="bg-white border-b px-8 py-4 flex items-center justify-between shadow-sm">
        <div className="flex items-center gap-2">
          <Shield className="text-indigo-600 w-8 h-8" />
          <span className="text-xl font-bold tracking-tight">SecureLLM Gateway</span>
        </div>
        <div className="flex gap-4 items-center text-sm font-medium text-slate-500">
          <span className="flex items-center gap-1"><Zap className="w-4 h-4 text-amber-500" /> Latency Optimized</span>
          <span className="flex items-center gap-1"><Database className="w-4 h-4 text-emerald-500" /> PostgreSQL Audited</span>
        </div>
      </nav>

      <main className="max-w-5xl mx-auto p-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          
          {/* Left Side: Input */}
          <div className="flex flex-col gap-4">
            <h2 className="text-lg font-semibold flex items-center gap-2">
              <Eye className="w-5 h-5 text-indigo-500" /> Input Prompt
            </h2>
            <textarea
              className="w-full h-64 p-4 border rounded-xl shadow-inner focus:ring-2 focus:ring-indigo-500 outline-none resize-none bg-white"
              placeholder="Enter text with PII (e.g., 'My email is test@gmail.com and my credit card is 4111...')"
              value={prompt}
              onChange={(e) => setPrompt(e.target.value)}
            />
            <button
              onClick={handleSend}
              disabled={loading}
              className="bg-indigo-600 text-white font-bold py-3 rounded-xl hover:bg-indigo-700 transition flex items-center justify-center gap-2 shadow-lg disabled:opacity-50"
            >
              {loading ? "Intercepting..." : <><Send className="w-5 h-5" /> Send through Gateway</>}
            </button>
          </div>

          {/* Right Side: Redaction & Response */}
          <div className="flex flex-col gap-4">
             <h2 className="text-lg font-semibold flex items-center gap-2">
              <Lock className="w-5 h-5 text-emerald-500" /> Gateway Output
            </h2>
            
            <div className="bg-white border rounded-xl p-6 min-h-[300px] shadow-sm flex flex-col gap-6">
              {response ? (
                <>
                  <div>
                    <span className="text-xs font-bold uppercase text-slate-400">Sanitized Prompt (Sent to AI)</span>
                    <p className="mt-2 text-sm font-mono bg-slate-100 p-3 rounded border border-slate-200 text-slate-700">
                      {response.sanitized_prompt}
                    </p>
                  </div>
                  
                  <div>
                    <span className="text-xs font-bold uppercase text-slate-400">LLM Response</span>
                    <p className="mt-2 text-slate-800 leading-relaxed italic">
                      "{response.response}"
                    </p>
                  </div>

                  <div className="pt-4 border-t flex justify-between text-xs text-slate-500">
                    <span>Latency: <strong>{response.metrics?.latency_ms}ms</strong></span>
                    <span>Tokens: <strong>{response.metrics?.tokens}</strong></span>
                  </div>
                </>
              ) : (
                <div className="flex flex-col items-center justify-center h-full text-slate-400 gap-2">
                  <Shield className="w-12 h-12 opacity-20" />
                  <p>Send a request to see the security layers in action.</p>
                </div>
              )}
            </div>
          </div>

        </div>
      </main>
    </div>
  );
}

export default App;