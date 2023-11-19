/*
Potencjalne zagrożenia:
  - zmiana implementacji kod bez zabezpieczeń,
  - funkcje wysyłające Ether do dowolnych miejsc,
  - delegatecall na dowolny kontrakt (potencjalnie niebezpieczny)
*/

// SPDX-License-Identifier: MIT
// solc version 0.8.0
pragma solidity ^0.8.0;

contract Delegate {
    function delegatecallSetN(address _e, uint _n) public {
        (bool result,) = _e.delegatecall(abi.encodeWithSignature("setN(uint256)", _n));
        require(result);
    }
}

contract SetGet {
    uint public n;
    address public sender;

    function setN(uint _n) public {
        n = _n;
        sender = msg.sender;
    }

    function getN() public view returns (uint) {
        return n;
    }
}

contract EtherTransfer {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function sendEther(address payable _to, uint _amount) public {
        require(msg.sender == owner, "Only owner can send ether");
        (bool sent,) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Upgradeable {
    address public implementation;

    function upgradeTo(address _newImplementation) public {
        implementation = _newImplementation;
    }
}