// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "Counter.sol";

contract CounterTest is Test {
    Counter counter;

    function beforeEach() public override {
        counter = new Counter();
    }

    function testFuzzSetNumber() public {
        uint256 randomValue = getRandomUint256();
        counter.setNumber(randomValue);
        assertEqual(counter.number(), randomValue, "SetNumber failed");
    }

    function testFuzzIncrement() public {
        uint256 initialNumber = counter.number();
        counter.increment();
        assertEqual(counter.number(), initialNumber + 1, "Increment failed");
    }

    function getRandomUint256() internal view returns (uint256) {
        // Implement your logic to generate random uint256 values
        // For simplicity, you can use a fixed value or a timestamp-based approach
        return block.timestamp;
    }
}