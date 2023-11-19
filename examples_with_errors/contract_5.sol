// Try-catch error

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    function getMessage() public pure returns (string memory) {
        return "Hello, World!";
    }
}

contract HelloWorldFactory {
    mapping(address => HelloWorld) public contracts;
    uint public errorCount;

    function createHelloWorld() public {
        try new HelloWorld() returns (HelloWorld instance) {
            contracts[msg.sender] = instance;
        } catch {
            errorCount++;
        }
    }
}