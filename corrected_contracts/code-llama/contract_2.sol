pragma solidity ^0.8.0;

contract Timelock {
    struct Lock {
        uint256 startTimestamp;
        uint256 endTimestamp;
    }

    mapping(address => Lock[]) public locks;

    function createLock(uint256 _startTimestamp, uint256 _endTimestamp) public {
        locks[msg.sender].push(Lock({
            startTimestamp: _startTimestamp,
            endTimestamp: _endTimestamp
        }));
    }

    function releaseLock(uint256 index) public {
        require(index < locks[msg.sender].length, "Index out of range");
        require(block.timestamp >= locks[msg.sender][index].endTimestamp, "Lock still active");

        delete locks[msg.sender][index];
    }
}