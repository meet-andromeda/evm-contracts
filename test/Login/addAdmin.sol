// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.17.0;

import {Test} from "forge-std/Test.sol";
import {Login} from "src/Login.sol";
import {ILogin} from "src/interfaces/ILogin.sol";

contract LoginAddAdminTest is Test {
    /*//////////////////////////////////////////////////////////////
                              SET UP
    //////////////////////////////////////////////////////////////*/
    address public alice = vm.addr(0x123);
    ILogin public login;

    function setUp() public {
        login = new Login();
    }

    /*//////////////////////////////////////////////////////////////
                              SUCCESS
    //////////////////////////////////////////////////////////////*/

    /**
     * [SUCCESS] The function addWAdmin should add the admin to the adminUsers enumerableSet
     * if caller is Owner and the admin is not in adminUsers.
     */
    function testAddAdminWithOwner() public {
        login.addAdmin(alice);
        address[] memory userAdmins = login.getAdmins();
        assertEq(userAdmins[0], vm.addr(0x123));
    }

    /*//////////////////////////////////////////////////////////////
                              REVERT
    //////////////////////////////////////////////////////////////*/

    /**
     * [REVERT] Should call addAdmin() and revert because caller is not owner
     */
    function testCannotAddAdminWithoutOwnership() public {
        vm.expectRevert("UNAUTHORIZED");
        vm.prank(vm.addr(0x01));
        login.addAdmin(alice);
    }

    /**
     * [REVERT] Should call addAdmin() and revert because admin is already in adminUsers enumerableSet.
     */
    function testCannotAddAdminAlreadyInUserAdmin() public {
        login.addAdmin(alice);
        vm.expectRevert("Address is already admin");
        login.addAdmin(alice);
    }
}
