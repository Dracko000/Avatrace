require('dotenv').config();
const express = require('express');
const { ethers } = require('ethers');
const app = express();
const port = 5000;

app.use(express.json());

<<<<<<< HEAD
// Initialize provider for Avalanche
const provider = new ethers.JsonRpcProvider(
  process.env.AVALANCHE_RPC_URL || 'https://api.avax.network/ext/bc/C/rpc'
=======
// Initialize provider for Avalanche Fuji (testnet)
const provider = new ethers.JsonRpcProvider(
  process.env.AVALANCHE_FUJI_RPC_URL || 'https://api.avax-test.network/ext/bc/C/rpc'
>>>>>>> 28b24fb (avatrace)
);

// Endpoint untuk debugging
app.post('/api/debug', async (req, res) => {
  const { txHash } = req.body;

  try {
    // Get transaction receipt to analyze the transaction
    const receipt = await provider.getTransactionReceipt(txHash);

    if (!receipt) {
      return res.status(404).json({ status: 'error', message: 'Transaction not found' });
    }

    // Extract trace information from the receipt
    const trace = {
      transactionHash: receipt.hash,
      status: receipt.status === 1 ? 'success' : 'failed',
      gasUsed: receipt.gasUsed.toString(),
      cumulativeGasUsed: receipt.cumulativeGasUsed.toString(),
      logs: receipt.logs.map(log => ({
        address: log.address,
        topics: log.topics,
        data: log.data
      }))
    };

    res.json({ status: 'success', trace });
  } catch (error) {
    console.error('Debug error:', error);
    res.status(500).json({ status: 'error', message: error.message });
  }
});

// Endpoint untuk profiling gas
app.post('/api/profile', async (req, res) => {
  const { contractAddress, functionName, abi, args = [] } = req.body;

  try {
    // Create a contract instance
    const contract = new ethers.Contract(contractAddress, abi, provider);

    // Estimate gas for the function call
    const gasEstimate = await contract[functionName].estimateGas(...args);

    res.json({ gasUsed: gasEstimate.toString() });
  } catch (error) {
    console.error('Profile error:', error);
    res.status(500).json({ status: 'error', message: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});