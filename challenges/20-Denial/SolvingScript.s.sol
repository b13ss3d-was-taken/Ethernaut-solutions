// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Solving} from "src/Solving.sol";

contract SolvingScript is Script {

    Solving solving;
    address victim = ; // Your instance address

    function run() external {
        vm.startBroadcast();
        solving = new Solving();
        solving.solve(victim);
        vm.stopBroadcast();
    }
}