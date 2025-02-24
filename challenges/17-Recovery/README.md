# Recovery   
In this challenge, our goal is to recover (or remove) the 0.001 ether from a lost contract. The difficulty lies in the fact that we don’t know the address of that contract. To solve this, we need to calculate the address of the lost contract.

I found [this post](https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed) extremely helpful in understanding how Ethereum contract addresses are computed. Essentially, the address of a contract is determined by hashing together the deployer’s address and the `nonce` (the number of transactions the deployer has sent). The formula is as follows:   
```solidity
address nonce1= address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _origin, bytes1(0x01))))));
```
Here, `_origin` is the address of the deployer, and `nonce1` is the computed address of the lost contract.
To solve this challenge, I created a script that automates the process of calculating the lost contract address and recovering the funds:
```solidity
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

contract SolvingScript is Script {
    address _origin = ; /* Your instance address */
    address nonce1 = payable(
        address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _origin, bytes1(0x01))))))
    ); // Computed lost address

    function run() public {
        vm.startBroadcast();
        nonce1.call(abi.encodeWithSignature("destroy(address)", msg.sender));
        vm.stopBroadcast();
    }
}
```