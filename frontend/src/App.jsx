import { useState } from 'react';
import axios from 'axios';

function App() {
  const [txHash, setTxHash] = useState('');
  const [trace, setTrace] = useState([]);

  const handleDebug = async () => {
    const response = await axios.post('/api/debug', { txHash });
    setTrace(response.data.trace);
  };

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold">Avalanche Smart Contract Debugger</h1>
      <input
        type="text"
        value={txHash}
        onChange={(e) => setTxHash(e.target.value)}
        placeholder="Enter Transaction Hash"
        className="border p-2 w-full mb-4"
      />
      <button onClick={handleDebug} className="bg-blue-500 text-white px-4 py-2 rounded">
        Debug Transaction
      </button>

      <pre className="mt-4 bg-gray-100 p-4 rounded">{JSON.stringify(trace, null, 2)}</pre>
    </div>
  );
}

export default App;