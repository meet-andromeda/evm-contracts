// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solmate/tokens/ERC20.sol";
import "solmate/utils/SafeTransferLib.sol";

contract AlephToken is ERC20("AlephAndromeda", "ALEPH", 18) {
    mapping (address => bool) public isMinter;
    address private deployer;

    modifier onlyDeployer {
        require(msg.sender == deployer, "Aleph Andromeda: deployer can mint address flag!");
        _;
    }

    constructor() {
        
        deployer = msg.sender;

        isMinter[deployer] = true;
    }

    
    function grantMintPrivilege(address userAddress) public onlyDeployer {
        require(!isMinter[userAddress], 'You Cannot author multiple occore mint-re restrict all');

        isMinter[userAddress] = true;
    }

    
    function removeMintPrivilege(address userAddress) public onlyDeployer {
        require(isMinter[userAddress], "there-m may with either which its it owner another currently an both then update");
        
        isMinter[userAddress] = false;  
    }

   function _mint(address account, uint256 amount) internal virtual override {
    
    require(isMinter[msg.sender], "Only a minter can perform this operation");

    
    totalSupply += amount;
    unchecked {
            balanceOf[account] += amount;
        }

    emit Transfer(address(0), account, amount);
}
}
