import { ethers } from 'ethers';
import dotenv from 'dotenv';
import { readFileSync } from 'fs';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';

// Load environment variables
dotenv.config();

// Get the directory name of the current module
const __dirname = dirname(fileURLToPath(import.meta.url));

async function deployContract(network = 'fuji') {
  console.log(`Starting deployment to ${network} network...\n`);

  // Select the appropriate RPC URL based on network
  const rpcUrl = network === 'fuji' 
    ? process.env.AVALANCHE_FUJI_RPC_URL 
    : process.env.AVALANCHE_RPC_URL;
    
  if (!rpcUrl) {
    throw new Error(`${network} RPC URL not configured in environment variables`);
  }

  // Initialize provider for Avalanche
  const provider = new ethers.JsonRpcProvider(rpcUrl);

  // Initialize wallet with the private key
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  console.log('Connected to', network, 'network');
  console.log('Wallet address:', wallet.address);

  // Get wallet balance
  const balance = await provider.getBalance(wallet.address);
  console.log('Wallet balance:', ethers.formatEther(balance), 'AVAX\n');

  // Define the contract ABI and bytecode for SimpleStorage
  const simpleStorageABI = [
    "function set(uint256 x) public",
    "function get() public view returns (uint256)",
    "function storedData() public view returns (uint256)"
  ];
  
  // Placeholder bytecode - in a real scenario, this would come from compilation
  const simpleStorageBytecode = "0x608060405234801561001057600080fd5b50610150806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c806360fe47b11461003b5780636d4ce63c14610057575b600080fd5b6100556004803603810190610050919061009d565b610075565b005b61005f61007f565b60405161006c91906100d9565b60405180910390f35b8060008190555050565b60008054905090565b60008135905061009781610103565b92915050565b6000602082840312156100b1576100b06100fe565b5b60006100bf84828501610088565b91505092915050565b6100d3816100f4565b82525050565b60006020820190506100ec60008301846100ca565b92915050565b6000819050919050565b600080fd5b61010c816100f4565b811461011757600080fd5b5056fea26469706673582212202a178d853e83ddb5db3640eb86223b35d9e4e85004c4b7625de43f844941e43d64736f6c63430008130033";

  // Get the contract factory
  const contractFactory = new ethers.ContractFactory(
    simpleStorageABI,
    simpleStorageBytecode,
    wallet
  );

  // Deploy the contract
  console.log('Deploying SimpleStorage contract...');
  const simpleStorage = await contractFactory.deploy();
  await simpleStorage.waitForDeployment();
  
  const contractAddress = await simpleStorage.getAddress();
  console.log('SimpleStorage deployed to:', contractAddress);

  // Verify deployment by calling a function
  const initialValue = await simpleStorage.get();
  console.log('Initial value in contract:', initialValue);

  console.log('\nDeployment completed successfully!');
  console.log('Contract address:', contractAddress);
  
  return contractAddress;
}

// Parse command line arguments
const args = process.argv.slice(2);
let network = 'fuji'; // default to fuji

for (let i = 0; i < args.length; i++) {
  if (args[i] === '--network' && args[i + 1]) {
    network = args[i + 1];
    break;
  }
}

deployContract(network).catch(console.error);