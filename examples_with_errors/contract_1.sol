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

        // For withdrawing the Ether stored by users
    function withdraw() public {

                // Gets the balance of the user calling the withdraw function
        uint256 bal = balances[msg.sender];

                // Checks if the user/caller has Ether in this contract
        require(bal > 0);

                // Transfers the Ether to the user 
                // Vulnerability point
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        balances[msg.sender] = 0;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}