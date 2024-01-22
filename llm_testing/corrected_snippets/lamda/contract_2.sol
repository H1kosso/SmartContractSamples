
// Arithmetic overflows / underflows
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "Lock time not expired");

        // Use a non-reentrancy guard to prevent reentrancy attacks
        require(!isWithdrawInProgress(), "Withdrawal in progress");
        setWithdrawInProgress(true);

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        // Transfer the Ether to the user using `transfer`
        require(address(this).transfer(amount), "Failed to transfer Ether");

        // Clear the withdrawal in progress flag
        setWithdrawInProgress(false);
    }

}