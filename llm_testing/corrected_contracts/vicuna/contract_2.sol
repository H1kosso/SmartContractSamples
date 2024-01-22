// Arithmetic overflows / underflows
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7; // Update to the latest version (0.8.7 as of now) for security patches
 
contract TimeLock {
mapping(address => uint) public balance; // Conforms to solidity naming conventions
mapping(address => uint) public lockTime;
 
    function deposit() external payable {
        require(block.timestamp < lockTime[msg.sender], "You have a pending lock time");
        balance[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }
    
    function increaseLockTime(uint _secondsToIncrease) public {
        require(lockTime[msg.sender] > block.timestamp, "Lock time already expired");
        lockTime[msg.sender] += _secondsToIncrease;
    }
    
    function withdraw() public {
        require(balance[msg.sender] > 0, "Insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "Lock time not expired");
    
        balance[msg.sender] = 0; // Clearing the balance instead of assigning it to a variable
    }
}