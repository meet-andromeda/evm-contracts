// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.17.0;

import {Test} from "forge-std/Test.sol";
import {AlephLogger} from "src/AlephLogger.sol";


contract AlephLoggerTest is Test {
    /*//////////////////////////////////////////////////////////////
                              SET UP
    //////////////////////////////////////////////////////////////*/
    address public alice = vm.addr(0x123);
    address public bob = vm.addr(0x456);
    AlephLogger public alephLogger;


    function setUp() public {
        alephLogger = new AlephLogger(15393413491323156052291887947505193180550009759100508221703500646414847850240);
    }

    /*//////////////////////////////////////////////////////////////
                              SUCCESS
    //////////////////////////////////////////////////////////////*/

    /**
     * [SUCCESS] Should return true if the admin is in the adminUsers mapping .
     */
    function testGreet() public {
        vm.prank(alice);
        alephLogger.greet("solanaAddress");
    }

    /**
     * [SUCCESS] Should return and emit the event twice when flag not true.
     */
    function testGreetTwice() public {
        vm.prank(alice);
        alephLogger.greet("solanaAddress");
        vm.prank(alice);
        alephLogger.greet("solanaAddress");
    }

    /**
     * [FAIL] Should fail if tries to greet 2 times when flag true.
     */
    function testGreetTwiceFail() public {
        vm.prank(address(this));
        alephLogger.setDebuggingFlag(true);
        vm.prank(alice);
        alephLogger.greet("solanaAddress");
        vm.expectRevert("Address already logged");
        vm.prank(alice);
        alephLogger.greet("solanaAddress");
    }
}
