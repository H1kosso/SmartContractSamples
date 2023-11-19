// Cross-function race conditions 
//  Two or more Solidity functions are trying to access the same state variable for their individual computation before either has the chance to make the update.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTransfer{
    mapping(address => uint256) public userBalances;

    /* uses userBalance to transfer funds */
    function transfer(address to, uint256 amount) public {
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] += amount;
            userBalances[msg.sender] -= amount;
        }
    }

    /* uses userBalances to withdraw funds */
    function withdrawalBalance() public {
        uint256 amountToWithdraw = userBalances[msg.sender];
            // makes external call to the address receiving the ether
        (bool sent, ) = msg.sender.call{value: amountToWithdraw}("");
        require(sent, "Failed to send Ether");
        userBalances[msg.sender] = 0;
    }
}

