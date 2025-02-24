//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Solving {

    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 _newOwner) public {
        owner = msg.sender;
    }
}