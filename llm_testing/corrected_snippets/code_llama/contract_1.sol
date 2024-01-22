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

    event Transfer(address indexed from, address indexed to, uint256 value);
    function withdraw(uint256 amount) public returns (bool) {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        emit Transfer(msg.sender, address(this), amount);
        return true;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}