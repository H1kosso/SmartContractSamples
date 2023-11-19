/*
Potencjalne zagrożenia:
 - wartość zwracana przez zewnętrzny transfer nie jest sprawdzana.
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
    {
        //...
    }
}
contract MyBank{  
    mapping(address => uint) balances;
    Token token;
    function deposit(uint amount) public{
        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }
}