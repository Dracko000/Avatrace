// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts/WETH9.sol";
import "../contracts/ComplexToken.sol";
import "../contracts/DEXFactory.sol";
import "../contracts/DEXRouter.sol";

contract DeployDeFiContracts is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy WETH
        WETH9 weth = new WETH9();
        console.log("WETH9 deployed to:", address(weth));
        
        // Deploy sample tokens
        Token tokenA = new Token("Token A", "TKNA", 18, 1000000 * 10**18);
        console.log("Token A deployed to:", address(tokenA));
        
        Token tokenB = new Token("Token B", "TKNB", 18, 1000000 * 10**18);
        console.log("Token B deployed to:", address(tokenB));
        
        // Deploy factory
        DEXFactory factory = new DEXFactory(msg.sender);
        console.log("DEX Factory deployed to:", address(factory));
        
        // Deploy router
        DEXRouter router = new DEXRouter(address(factory), address(weth));
        console.log("DEX Router deployed to:", address(router));
        
        vm.stopBroadcast();
    }
}