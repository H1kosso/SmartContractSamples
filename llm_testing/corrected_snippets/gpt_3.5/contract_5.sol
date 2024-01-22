 pragma solidity ^0.4.15;

/// @title Ethereum Lottery Game.

contract EtherLotto {

    // Amount of ether needed for participating in the lottery.
    uint constant TICKET_AMOUNT = 10;

    // Fixed amount fee for each lottery game.
    uint constant FEE_AMOUNT = 1;

    // Address where fee is sent.
    address public bank;

    // Public jackpot that each participant can win (minus fee).
    uint public pot;

    // Lottery constructor sets bank account from the smart-contract owner.
    function EtherLotto() {
        bank = msg.sender;
    }

    // Public function for playing lottery. Each time this function
    // is invoked, the sender has an oportunity for winning pot.
    uint256 pot;

function play() payable {
    require(msg.value == TICKET_AMOUNT, "Invalid ticket amount");

    pot += msg.value;

    // Compute some *almost random* value for selecting a winner from the current transaction.
    // <yes> <report> TIME_MANIPULATION
    uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp))) % 2;

    if (random == 0) {
        distributePrize();
    }
}

function distributePrize() private {
    // Send fee to bank account
    bank.transfer(FEE_AMOUNT);

    // Send jackpot to the winner
    uint256 jackpot = pot - FEE_AMOUNT;
    pot = 0; // Reset the pot
    payable(msg.sender).transfer(jackpot);
}

}