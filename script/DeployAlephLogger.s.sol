// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.17.0;

import "forge-std/Script.sol";
import {AlephLogger} from "src/AlephLogger.sol";

contract LoginDeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);


        new AlephLogger(15393413491323156052291887947505193180550009759100508221703500646414847850240);


        vm.stopBroadcast();
    }
}
