pragma solidity ^0.4.0;
 
contract Government {
 
    // Global Variables
    uint32 public lastCreditorPayedOut;
    uint public lastTimeOfNewCredit;
    uint public profitFromCrash;
    address[] public creditorAddresses;
    uint[] public creditorAmounts;
    address public corruptElite;
    mapping (address => uint) buddies;
    uint constant TWELVE_HOURS = 43200;
    uint8 public round;
 
    // Constructor
    function Government() public payable {
        require(msg.value > 0);
        profitFromCrash = msg.value;
        corruptElite = msg.sender;
        lastTimeOfNewCredit = block.timestamp;
    }
 
    function lendGovernmentMoney(address buddy) public payable returns (bool) {
        uint amount = msg.value;
        require(amount > 0);
 
        if (lastTimeOfNewCredit + TWELVE_HOURS < block.timestamp) {
            bool success = msg.sender.send(amount);
            require(success);
 
            success = creditorAddresses[creditorAddresses.length - 1].send(profitFromCrash);
            require(success);
 
            success = corruptElite.send(address(this).balance);
            require(success);
 
            lastCreditorPayedOut = 0;
            lastTimeOfNewCredit = block.timestamp;
            profitFromCrash = 0;
            delete creditorAddresses;
            delete creditorAmounts;
            round += 1;
 
            return false;
        }
        else {
            if (amount >= 10 ** 18) {
                lastTimeOfNewCredit = block.timestamp;
 
                creditorAddresses.push(msg.sender);
                creditorAmounts.push(amount * 110 / 100);
 
                success = corruptElite.send(amount * 5/100);
                require(success);
 
                if (profitFromCrash < 10000 * 10**18) {
                    profitFromCrash += amount * 5/100;
                }
 
                if(buddies[buddy] >= amount) {
                    success = buddy.send(amount * 5/100);
                    require(success);
                }
 
                buddies[msg.sender] += amount * 110 / 100;
 
                if (creditorAmounts[lastCreditorPayedOut] <= address(this).balance - profitFromCrash) {
                    success = creditorAddresses[lastCreditorPayedOut].send(creditorAmounts[lastCreditorPayedOut]);
                    require(success);
 
                    buddies[creditorAddresses[lastCreditorPayedOut]] -= creditorAmounts[lastCreditorPayedOut];
                    lastCreditorPayedOut += 1;
                }
 
                return true;
            }
            else {
                success = msg.sender.send(amount);
                require(success);
 
                return false;
            }
        }
    }
 
    // Fallback function
    function() external {
        lendGovernmentMoney(0);
    }
 
    function totalDebt() public view returns (uint debt) {
        for(uint i = lastCreditorPayedOut; i < creditorAmounts.length; i++) {
            debt += creditorAmounts[i];
        }
    }
 
    function totalPayedOut() public view returns (uint payout) {
        for(uint i = 0; i < lastCreditorPayedOut; i++) {
            payout += creditorAmounts[i];
        }
    }
 
    function investInTheSystem() public payable {
        require(msg.value > 0);
        profitFromCrash += msg.value;
    }
 
    function inheritToNextGeneration(address nextGeneration) public {
        require(msg.sender == corruptElite && nextGeneration != address(0));
        corruptElite = nextGeneration;
    }
 
    function getCreditorAddresses() public view returns (address[]) {
        return creditorAddresses;
    }
 
    function getCreditorAmounts() public view returns (uint[]) {
        return creditorAmounts;
    }
}