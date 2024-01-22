/*
Potencjalne zagrożenia:
  - zmienna stanu owner nie jest immutable,
  - v, które jest zależne od w jest inicjalizowane przed nim,
  - funkcja transfer nie emituje zdarzenia Transfer informujące o przelewie środków między adresami,
  - funkcja withdraw jest podatna na atak reentrancy,
  - funkcja kill pozwala na samozniszczenie kontraktu przez właściciela i przesłanie wszystkich środków do niego.
*/

// SPDX-License-Identifier: MIT
// solc version 0.8.0
pragma solidity ^0.8.0;

contract Bug {
    uint public w = 5;
    uint public immutable v = set(); // Declare as immutable
    uint public immutable x = set(); // Declare as immutable
    address payable public owner; // No changes needed
    mapping(address => uint) public balances;
    
    constructor() {
        owner = payable(msg.sender); // should be immutable
    }
    
    function set() public returns (uint) {
        // If this function is being used to initialize a state variable declared
        // before w, w will be zero. If it is declared after w, w will be set.
        if (w == 0) {
            return 77;
        }
        return 88;
    }
    
    function transfer(address to, uint amount) public {
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        // missing Transfer event
    }
    
    function withdraw() public {
        uint amount = balances[msg.sender];
        // reentrancy bug
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed.");
        balances[msg.sender] = 0;
    }
    
    function kill() public {
        require(msg.sender == owner);
        // unprotected selfdestruct
        selfdestruct(owner);
    }
}