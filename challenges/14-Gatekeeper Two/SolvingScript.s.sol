//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Solving} from "src/Solving.sol";
import {Script} from "forge-std/Script.sol";

contract SolvingScript is Script {
    address victim = 0xbc8ED29B20bE8b9a0207448dA5E01c71D49C1609; /* Your instance address */
    Solving solving;

    function run() public {
        vm.startBroadcast();
        solving = new Solving(victim);
        vm.stopBroadcast();
    }
}
