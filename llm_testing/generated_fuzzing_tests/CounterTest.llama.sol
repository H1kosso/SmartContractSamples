pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Counter} from "Counter.sol";

contract CounterFuzzer is Test {
    Counter counter;

    function setUp() public {
        counter = new Counter();
    }

    function testSetNumber() public {
        uint256[] numbers = [1, 2, 3, 4, 5];
        for (uint256 i = 0; i < numbers.length; i++) {
            uint256 expected = numbers[i];
            uint256 actual = counter.number();
            Assert.equal(actual, expected, "The number should be equal to the expected value after setting it.");
        }
    }

    function testIncrement() public {
        uint256 initial = counter.number();
        counter.increment();
        uint256 expected = initial + 1;
        uint256 actual = counter.number();
        Assert.equal(actual, expected, "The number should increase by 1 after incrementing it.");
    }
}
