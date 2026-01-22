// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts/SimpleStorage.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
<<<<<<< HEAD
        
        vm.startBroadcast(deployerPrivateKey); 
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();
        
=======

        vm.startBroadcast(deployerPrivateKey);
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();

>>>>>>> 28b24fb (avatrace)
        console.log("SimpleStorage deployed to:", address(simpleStorage));
    }
}