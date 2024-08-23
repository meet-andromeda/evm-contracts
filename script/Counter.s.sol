// Copyright 2022 Smash Works Inc.
// SPDX-License-Identifier: Apache License 2.0
pragma solidity ^0.8.17.0;

import "forge-std/Script.sol";
import {Login} from "src/Login.sol";

contract LoginDeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        address safeAddress = vm.envAddress("MULTISIG_ADDRESS");

        Login login = new Login();

        login.transferOwnership(safeAddress);

        vm.stopBroadcast();
    }
}
