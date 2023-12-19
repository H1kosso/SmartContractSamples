pragma solidity ^0.8.0;

contract EtherStore {
    // Mapping Data structure to keep track of balances of users
    mapping(address => uint256) private balances;

    // As the name suggests, you can use this function to deposit Ether to the contract
    function deposit() public payable {
        require(msg.value > 0, "Invalid deposit amount");
        balances[msg.sender] += msg.value;
    }

    // For withdrawing the Ether stored by users
    function withdraw(uint256 amount) public {
        uint256 bal = balances[msg.sender];

        require(bal >= amount, "Insufficient balance");
        require(msg.sender == tx.origin, "Caller should be tx.origin");

        // Transfers the Ether to the user using `transfer`
        require(payable(address(this)).transfer(amount), "Failed to transfer Ether");

        balances[msg.sender] -= amount;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}