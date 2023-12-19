pragma solidity ^0.8.0;

contract EtherStore {
    mapping(address => uint256) public balances;

    // Event to emit when Ether is deposited
    event EtherDeposited(address indexed _from, uint256 _amount);

    // Event to emit when Ether is withdrawn
    event EtherWithdrawn(address indexed _to, uint256 _amount);

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }

    function withdraw() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "Insufficient balance");

        balances[msg.sender] = 0;
        emit EtherWithdrawn(msg.sender, balance);

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}