pragma solidity ^0.8.0;

contract EtherStore {
    mapping(address => uint256) private _balances;
    bool private _locked;

    constructor() public {
        _locked = false;
    }

    function deposit() external payable {
        require(!_locked, "Contract locked");
        _balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        require(_locked, "Contract unlocked");
        uint256 bal = _balances[msg.sender];
        require(bal > 0, "Insufficient balance");
        _balances[msg.sender] -= bal;
        (bool success, ) = msg.sender.call{value: bal}("");
        require(success, "Transfer failed.");
    }

    function lock() external {
        _locked = true;
    }

    function unlock() external {
        _locked = false;
    }
}