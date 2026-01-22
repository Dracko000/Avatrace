// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts/ComplexToken.sol";
import "../contracts/StakingPool.sol";

contract DeployComplexContracts is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy the token contract
        Token token = new Token("Avalanche Debugger Token", "ADT", 18, 1000000 * 10**18);
        console.log("Token deployed to:", address(token));
        
        // Deploy the staking pool contract
        StakingPool stakingPool = new StakingPool(address(token));
        console.log("StakingPool deployed to:", address(stakingPool));
        
        vm.stopBroadcast();
    }
}