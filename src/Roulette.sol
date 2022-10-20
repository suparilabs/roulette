// SPDX-License-Identifier: GPLv3
pragma solidity ^0.8.4;

import { ERC20 } from "solmate/tokens/ERC20.sol";
import { Owned } from "solmate/auth/Owned.sol";

contract Roulette is Owned {
    error Invalid__BetAmount();

    uint256 public round;
    uint256 public BetAmount;
    mapping(uint256 => mapping(uint256 => uint256)) public roundToBetsToCount;
    mapping(uint256 => mapping(address => uint256)) public roundToUserToGuess;
    mapping(uint256 => mapping(uint256 => address[])) public roundToBetToUsers;
    mapping(uint256 => uint256) public totalFunds;

    ERC20 public immutable token;

    constructor(ERC20 _token, uint256 _betAmount) Owned(msg.sender) {
        token = _token;
        BetAmount = _betAmount;
    }

    function setBetAmount(uint256 _betAmount) external onlyOwner {
        BetAmount = _betAmount;
    }

    function placeBet(uint256 _betAmount, uint256 _guessNumber) external {
        uint256 _balanceBefore = ERC20(token).balanceOf(address(this));
        ERC20(token).transferFrom(msg.sender, address(this), _betAmount);
        uint256 _balanceAfter = ERC20(token).balanceOf(address(this));
        uint256 _actualBetAmount = _balanceAfter = _balanceBefore;
        if (_actualBetAmount != uint256(1)) {
            revert Invalid__BetAmount();
        }
        roundToBetsToCount[round][_actualBetAmount] += 1;
        roundToUserToGuess[round][msg.sender] = _guessNumber;
        roundToBetToUsers[round][_guessNumber].push(msg.sender);
        totalFunds[round] += _actualBetAmount;
    }
}
