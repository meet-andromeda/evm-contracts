// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.17.0;

import {Test} from "forge-std/Test.sol";
import {Login} from "src/Login.sol";
import {ILogin} from "src/interfaces/ILogin.sol";

contract LoginRemoveAdminTest is Test {
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
     * [SUCCESS] The function removeAdmin should remove the admin from the adminUsers enumerableSet
     * if caller is Owner and the admin is adminUsers.
     */
    function testRemoveAdminWithOwner() public {
        bool validAdmin = login.isAdmin(alice);
        assertEq(validAdmin, true);
        login.removeAdmin(alice);
        validAdmin = login.isAdmin(alice);
        assertEq(validAdmin, false);
    }

    /*//////////////////////////////////////////////////////////////
                              REVERT
    //////////////////////////////////////////////////////////////*/

    /**
     * [REVERT] Should call removeAdmin() and revert because caller is not owner
     */
    function testCannotRemoveAdminWithoutOwnership() public {
        vm.expectRevert("UNAUTHORIZED");
        vm.prank(vm.addr(0x01));
        login.removeAdmin(alice);
    }

    /**
     * [REVERT] Should call removeAdmin() and revert because admin is not in adminUsers enumerableSet.
     */
    function testCannotRemoveAdminNotInUserAdmins() public {
        vm.expectRevert("Admin not in adminUsers");
        login.removeAdmin(bob);
    }
}
