// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.17.0;

interface ILogin {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event AdminAdded(address indexed _admin);

    event AdminRemoved(address indexed _admin);

    /*//////////////////////////////////////////////////////////////
                            LOGIN LOGIC
    //////////////////////////////////////////////////////////////*/

    function getAdmins() external view returns (address[] memory);

    function isAdmin(address _admin) external view returns (bool);

    function addAdmin(address _admin) external;

    function removeAdmin(address _admin) external;
}
