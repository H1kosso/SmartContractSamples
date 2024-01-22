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
        // Gets the balance of the user calling the withdraw function
        uint256 bal = balances[msg.sender];

        // Checks if the user/caller has Ether in this contract
        require(bal > 0, "Insufficient balance");

        // Transfers the Ether to the user using `transfer`
        require(address(this).transfer(bal), "Failed to transfer Ether");

        // Update the caller's balance after the transfer is complete
        balances[msg.sender] -= bal;
    }



    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}