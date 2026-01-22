<<<<<<< HEAD
# Avalanche Debugger - Transitioned to Foundry

This project has been migrated from Hardhat to Foundry for smart contract development and testing.

## Setup Instructions

1. Install Foundry by following the official installation guide: https://book.getfoundry.sh/getting-started/installation
=======
# Avalanche Debugger

A comprehensive debugging and profiling tool for smart contracts on the Avalanche blockchain. This project provides developers with powerful tools to analyze, debug, and optimize their smart contracts.

## 🚀 Features

- **Smart Contract Debugging**: Analyze transaction traces and execution paths
- **Gas Profiling**: Estimate and profile gas usage for contract functions
- **Multi-Contract Analysis**: Trace complex interactions across multiple contracts
- **DeFi-Specific Tools**: Specialized debugging for DeFi protocols and AMMs
- **Real-time Monitoring**: Monitor contract state changes and events
- **Transaction Visualization**: Visual representation of transaction flows

## 🏗️ Architecture

The Avalanche Debugger consists of three main components:

### 1. Smart Contracts
- **Simple Storage**: Basic contract for getting started
- **Complex Token**: Full ERC20 implementation with advanced features
- **Staking Pool**: DeFi staking mechanism with reward calculations
- **AMM Pair**: Automated Market Maker contract for DeFi trading
- **DEX Factory**: Contract factory for creating trading pairs
- **DEX Router**: Routing contract for facilitating trades

### 2. Backend Server
- **Express.js API**: RESTful API for debugging operations
- **Transaction Analysis**: Detailed transaction trace analysis
- **Gas Estimation**: Function call gas estimation
- **Avalanche Integration**: Direct integration with Avalanche RPC endpoints

### 3. Frontend Application
- **React.js Interface**: Modern UI for interacting with the debugger
- **Transaction Input**: Simple interface for entering transaction hashes
- **Trace Visualization**: Visual representation of transaction traces
- **Real-time Updates**: Live updates of contract states

## 🛠️ Setup

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation) for smart contract development
- Node.js 16+ for backend and frontend
- Avalanche-compatible wallet with testnet funds

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd avalanche-debugger
```
>>>>>>> 28b24fb (avatrace)

2. Install Node.js dependencies:
```bash
npm install
```

3. Install Foundry dependencies:
```bash
forge install
```

4. Copy the `.env.example` file to `.env` and fill in your values:
```bash
cp .env.example .env
```

<<<<<<< HEAD
## Environment Variables
=======
5. Install backend dependencies:
```bash
cd backend
npm install
```

6. Install frontend dependencies:
```bash
cd ../frontend
npm install
```

## ⚙️ Configuration
>>>>>>> 28b24fb (avatrace)

Create a `.env` file in the root directory with the following variables:

```
PRIVATE_KEY=your_private_key_here
ETHERSCAN_API_KEY=your_etherscan_api_key
AVALANCHE_RPC_URL=https://api.avax.network/ext/bc/C/rpc
AVALANCHE_FUJI_RPC_URL=https://api.avax-test.network/ext/bc/C/rpc
```

<<<<<<< HEAD
## Available Commands

- `forge build` - Compile smart contracts
- `forge test` - Run tests
- `forge script script/Deploy.s.sol --rpc-url avalanche --broadcast` - Deploy to Avalanche mainnet
- `forge script script/Deploy.s.sol --rpc-url avalanche_fuji --broadcast` - Deploy to Fuji testnet

## Project Structure

- `contracts/` - Smart contract source files
- `script/` - Deployment scripts
- `test/` - Test files
- `src/` - Source files
- `backend/` - Backend server for debugging
- `frontend/` - Frontend application

## Backend Server

Start the backend server:
```bash
cd backend
npm install
npm run dev
```

## Frontend Application

Start the frontend application:
```bash
cd frontend
npm install
npm run dev
```
=======
## 🧪 Testing

### Local Testing
Run local tests using Foundry:
```bash
forge test
```

### Network Testing
Test with the Fuji testnet:
```bash
forge test --fork-url $AVALANCHE_FUJI_RPC_URL
```

### Complex Contract Testing
Run tests for complex contracts:
```bash
forge test --match-path test/ComplexContracts.t.sol
```

### DeFi Contract Testing
Run tests for DeFi contracts:
```bash
forge test --match-path test/DeFiTest.t.sol
```

## 📦 Deployment

### Deploy Simple Contracts
Deploy to Fuji testnet:
```bash
forge script script/Deploy.s.sol --rpc-url $AVALANCHE_FUJI_RPC_URL --broadcast --private-key $PRIVATE_KEY
```

### Deploy Complex Contracts
Deploy complex contracts to Fuji testnet:
```bash
forge script script/DeployComplex.s.sol --rpc-url $AVALANCHE_FUJI_RPC_URL --broadcast --private-key $PRIVATE_KEY
```

### Deploy DeFi Contracts
Deploy DeFi contracts to Fuji testnet:
```bash
forge script script/DeployDeFi.s.sol --rpc-url $AVALANCHE_FUJI_RPC_URL --broadcast --private-key $PRIVATE_KEY
```

## 🖥️ Running the Application

### Start Backend Server
```bash
cd backend
npm run dev
```

### Start Frontend Application
```bash
cd frontend
npm run dev
```

## 🔍 Using the Debugger

### Backend API Endpoints

#### Debug Transaction
Analyze a transaction on the Avalanche network:
```bash
curl -X POST http://localhost:5000/api/debug \
  -H "Content-Type: application/json" \
  -d '{"txHash":"0x..."}'
```

#### Profile Function
Estimate gas usage for a contract function:
```bash
curl -X POST http://localhost:5000/api/profile \
  -H "Content-Type: application/json" \
  -d '{
    "contractAddress": "0x...",
    "functionName": "get",
    "abi": [...],
    "args": []
  }'
```

### Frontend Usage
1. Navigate to the frontend application
2. Enter a transaction hash in the input field
3. Click "Debug Transaction" to analyze the transaction
4. View the detailed trace information in the output panel

## 🏷️ Supported Operations

### Simple Contracts
- Basic storage operations
- State variable access
- Simple function calls

### Complex Contracts
- Multi-token operations
- Staking mechanisms
- Reward calculations
- Complex state management

### DeFi Protocols
- Pair creation
- Liquidity provision
- Token swaps
- AMM operations
- Multi-contract interactions

## 📊 Debugging Information

The debugger provides detailed information about each transaction:

- **Transaction Hash**: Unique identifier for the transaction
- **Status**: Success or failure status
- **Gas Used**: Actual gas consumed
- **Cumulative Gas Used**: Total gas used in the block
- **Logs**: Event logs generated during execution
- **State Changes**: Changes to contract storage

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you have any questions or issues, please open an issue in the repository or contact the maintainers.
>>>>>>> 28b24fb (avatrace)
