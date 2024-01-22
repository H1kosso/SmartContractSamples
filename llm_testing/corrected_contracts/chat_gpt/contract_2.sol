// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLock {
    struct Deposit {
        uint256 amount;
        uint256 releaseTime;
    }

    mapping(address => Deposit) public deposits;

    function deposit() external payable {
        require(msg.value > 0, "Must deposit a non-zero amount");

        deposits[msg.sender].amount += msg.value;
        deposits[msg.sender].releaseTime = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint256 _secondsToIncrease) external {
        deposits[msg.sender].releaseTime += _secondsToIncrease;
    }

    function withdraw() public {
        Deposit storage userDeposit = deposits[msg.sender];
        require(userDeposit.amount > 0, "Insufficient funds");
        require(block.timestamp > userDeposit.releaseTime, "Lock time not expired");

        uint256 amount = userDeposit.amount;
        userDeposit.amount = 0;

        payable(msg.sender).transfer(amount);
    }
}