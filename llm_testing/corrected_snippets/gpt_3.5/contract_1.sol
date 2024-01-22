// Reentrancy bug
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherStore {
        // Mapping Data structure to keep track of balances of users 
    mapping(address => uint256) public balances;

        // As the name suggests, you can use this function to deposit Ether to the contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0, "Insufficient balance");

        // Set the user's balance to zero before transferring funds
        balances[msg.sender] = 0;

        // Use transfer to send Ether to the user
        payable(msg.sender).transfer(bal);
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}