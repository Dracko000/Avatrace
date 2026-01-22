# Avalanche Debugger - Transitioned to Foundry

This project has been migrated from Hardhat to Foundry for smart contract development and testing.

## Setup Instructions

1. Install Foundry by following the official installation guide: https://book.getfoundry.sh/getting-started/installation

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

## Environment Variables

Create a `.env` file in the root directory with the following variables:

```
PRIVATE_KEY=your_private_key_here
ETHERSCAN_API_KEY=your_etherscan_api_key
AVALANCHE_RPC_URL=https://api.avax.network/ext/bc/C/rpc
AVALANCHE_FUJI_RPC_URL=https://api.avax-test.network/ext/bc/C/rpc
```

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