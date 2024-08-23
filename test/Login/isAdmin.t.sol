// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.17.0;

import {Test} from "forge-std/Test.sol";
import {Login} from "src/Login.sol";
import {ILogin} from "src/interfaces/ILogin.sol";

contract LoginIsAdminTest is Test {
    /*//////////////////////////////////////////////////////////////
                              SET UP
    //////////////////////////////////////////////////////////////*/
    address public alice = vm.addr(0x123);
    address public bob = vm.addr(0x456);
    ILogin public login;

    function setUp() public {
        login = new Login();
        login.addAdmin(alice);
    }

    /*//////////////////////////////////////////////////////////////
                              SUCCESS
    //////////////////////////////////////////////////////////////*/

    /**
     * [SUCCESS] Should return true if the admin is in the adminUsers enumerableSet.
     */
    function testIsAdminInAdminUsers() public {
        bool isAdmin = login.isAdmin(alice);
        assertEq(isAdmin, true);
    }

    /**
     * [SUCCESS] Should return false if the admin is not in the adminUsers enumerableSet.
     */
    function testIsNotAdminInAdminUsers() public {
        bool isAdmin = login.isAdmin(bob);
        assertEq(isAdmin, false);
    }
}
