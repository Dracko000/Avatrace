// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts/SimpleStorage.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey); 
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();
        
        console.log("SimpleStorage deployed to:", address(simpleStorage));
    }
}