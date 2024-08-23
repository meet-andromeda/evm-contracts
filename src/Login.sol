// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.13;

import {Owned} from "solmate/auth/Owned.sol";
import {ReentrancyGuard} from "solmate/utils/ReentrancyGuard.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {ILogin} from "./interfaces/ILogin.sol";

contract Login is ILogin, Owned, ReentrancyGuard {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private _adminUsers;

    constructor() Owned(msg.sender) {}

    /**
     * Returns an array with the addresses of all the admins
     *
     * @return an array of addresses of the admins
     */
    function getAdmins() external view returns (address[] memory) {
        return _adminUsers.values();
    }

    /**
     * Checks if the address is in the admins list
     *
     * @param _admin The address of an admin
     *
     * @return bool True/False if the address is in the admins list or not
     */
    function isAdmin(address _admin) public view returns (bool) {
        return _adminUsers.contains(_admin);
    }

    /**
     * Allows the owner to add an admin to the admins list
     *
     * @param _admin The address of the admin to add
     */
    function addAdmin(address _admin) external onlyOwner nonReentrant {
        require(_admin != address(0), "Must be a valid address");
        require(!isAdmin(address(_admin)), "Address is already admin");

        require(_adminUsers.add(_admin), "Cannot add admin");

        emit AdminAdded(_admin);
    }

    /**
     * Allows a the owner to remove an admin from the admins list
     *
     * @param _admin The address of the admin to remove
     */
    function removeAdmin(address _admin) external onlyOwner nonReentrant {
        require(isAdmin(_admin), "Admin not in adminUsers");

        require(_adminUsers.remove(_admin), "Cannot remove admin");

        emit AdminRemoved(_admin);
    }
}
