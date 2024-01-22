pragma solidity ^0.4.0;

contract Government {
    struct Creditor {
        address creditorAddress;
        uint256 creditorAmount;
        bool isPaidOut;
    }

    uint256 public lastCreditorPayedOut;
    uint256 public lastTimeOfNewCredit;
    uint256 public profitFromCrash;
    address public corruptElite;
    uint256 constant TWELVE_HOURS = 43200;
    uint8 public round;

    Creditor[] public creditors;
    mapping(address => uint256) public buddies;

    modifier onlyCorruptElite() {
        require(msg.sender == corruptElite, "You are not the corrupt elite");
        _;
    }

    constructor() {
        profitFromCrash = msg.value;
        corruptElite = msg.sender;
        lastTimeOfNewCredit = block.timestamp;
    }

    function lendGovernmentMoney(address buddy) external payable returns (bool) {
        require(msg.value > 0, "Must deposit a non-zero amount");

        uint256 amount = msg.value;

        if (lastTimeOfNewCredit + TWELVE_HOURS < block.timestamp) {
            distributeFundsOnSystemCrash();
            return false;
        } else {
            if (amount >= 10**18) {
                handleValidCreditTransaction(amount, buddy);
                return true;
            } else {
                return false;
            }
        }
    }

    function distributeFundsOnSystemCrash() internal {
        for (uint256 i = 0; i < creditors.length; i++) {
            if (!creditors[i].isPaidOut) {
                sendToCreditor(i);
            }
        }

        corruptElite.transfer(address(this).balance);
        resetContractState();
        round++;
    }

    function sendToCreditor(uint256 index) internal {
        address payable creditorAddress = payable(creditors[index].creditorAddress);
        uint256 amountToSend = creditors[index].creditorAmount;

        if (address(this).balance >= amountToSend) {
            creditorAddress.transfer(amountToSend);
            buddies[creditorAddress] -= amountToSend;
            creditors[index].isPaidOut = true;
        }
    }

    function handleValidCreditTransaction(uint256 amount, address buddy) internal {
        lastTimeOfNewCredit = block.timestamp;
        uint256 amountWithInterest = amount * 110 / 100;
        creditors.push(Creditor(msg.sender, amountWithInterest, false));

        corruptElite.transfer(amount * 5 / 100);

        if (profitFromCrash < 10000 * 10**18) {
            profitFromCrash += amount * 5 / 100;
        }

        if (buddies[buddy] >= amount) {
            payable(buddy).transfer(amount * 5 / 100);
        }

        buddies[msg.sender] += amountWithInterest;

        if (!creditors[lastCreditorPayedOut].isPaidOut) {
            sendToCreditor(lastCreditorPayedOut);
            lastCreditorPayedOut++;
        }
    }

    function resetContractState() internal {
        lastCreditorPayedOut = 0;
        lastTimeOfNewCredit = block.timestamp;
        profitFromCrash = 0;
        delete creditors;
        round++;
    }

    function totalDebt() external view returns (uint256 debt) {
        for (uint256 i = lastCreditorPayedOut; i < creditors.length; i++) {
            debt += creditors[i].creditorAmount;
        }
    }

    function totalPayedOut() external view returns (uint256 payout) {
        for (uint256 i = 0; i < lastCreditorPayedOut; i++) {
            payout += creditors[i].creditorAmount;
        }
    }

    function investInTheSystem() external payable {
        profitFromCrash += msg.value;
    }

    function inheritToNextGeneration(address nextGeneration) external onlyCorruptElite {
        corruptElite = nextGeneration;
    }

    function getCreditorAddresses() external view returns (address[] memory) {
        address[] memory addresses = new address[](creditors.length);

        for (uint256 i = 0; i < creditors.length; i++) {
            addresses[i] = creditors[i].creditorAddress;
        }

        return addresses;
    }

    function getCreditorAmounts() external view returns (uint256[] memory) {
        uint256[] memory amounts = new uint256[](creditors.length);

        for (uint256 i = 0; i < creditors.length; i++) {
            amounts[i] = creditors[i].creditorAmount;
        }

        return amounts;
    }

    receive() external payable {
        lendGovernmentMoney(address(0));
    }
}
