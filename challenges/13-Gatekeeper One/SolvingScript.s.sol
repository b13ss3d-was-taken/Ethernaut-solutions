// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Solving} from "src/Solving.sol";

contract SolvingScript is Script {
    address victim = ; /* Your instance address */
    Solving solving;

    function run() public {
        vm.startBroadcast();
        solving = new Solving();
        solve();
        vm.stopBroadcast();
    }

    function solve() public {
        /* for (uint256 i = 0; i < 500; i++) { // Use this loop to find the correct gas value
            try solving.attack(victim, i) {
                console2.log("Solved", i);
                return;
            } catch { }
    }*/
        solving.attack(victim, 256); // In my case this was the correct value
    }
}
