// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.17.0;

import "forge-std/Script.sol";
import {AlephToken} from "src/AlephToken.sol";

contract LoginDeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);


        new AlephToken();


        vm.stopBroadcast();
    }
}
