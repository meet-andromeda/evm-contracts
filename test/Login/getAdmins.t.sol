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
    address[] public admins;
    ILogin public login;

    function setUp() public {
        login = new Login();
        admins = new address[](2);
        admins[0] = alice;
        admins[1] = bob;
        login.addAdmin(alice);
        login.addAdmin(bob);
    }

    /*//////////////////////////////////////////////////////////////
                              SUCCESS
    //////////////////////////////////////////////////////////////*/

    /**
     * [SUCCESS] Should return an array of adminUsers.
     */
    function testGetAdmins() public {
        address[] memory userAdmins = login.getAdmins();
        assertEq(userAdmins, admins);
    }

    /**
     * [SUCCESS] Should return an empty adminUsers array.
     */
    function testShouldReturnEmptyWhenNoAdmins() public {
        address[] memory noAdmins = new address[](0);
        login.removeAdmin(alice);
        login.removeAdmin(bob);
        address[] memory userAdmins = login.getAdmins();
        assertEq(userAdmins, noAdmins);
    }
}
