/*
Potencjalne zagrożenia:
  - zmiana implementacji kod bez zabezpieczeń,
  - funkcje wysyłające Ether do dowolnych miejsc,
  - delegatecall na dowolny kontrakt (potencjalnie niebezpieczny)
*/

// SPDX-License-Identifier: MIT
// solc version 0.8.0
pragma solidity ^0.8.0;

contract ManyMistakes {
    uint public n;
    address public sender;
    address payable public owner;
    address public implementation;

    constructor() {
        owner = payable(msg.sender);
    }

    // ---

    function delegatecallSetN(address _e, uint _n) public {
        (bool result,) = _e.delegatecall(abi.encodeWithSignature("setN(uint256)", _n));
        require(result);
    }

    // ---

    function setN(uint _n) public {
        n = _n;
        sender = msg.sender;
    }

    function getN() public view returns (uint) {
        return n;
    }

    // ---

    function sendEther(address payable _to, uint _amount) public {
        require(msg.sender == owner, "Only owner can send ether");
        (bool sent,) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    // ---

    function upgradeTo(address _newImplementation) public {
        implementation = _newImplementation;
    }
}