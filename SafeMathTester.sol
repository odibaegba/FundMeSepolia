// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SafeMathTester{
    uint8 public bigNumber = 255;

    function addNum() public {
        bigNumber = bigNumber +1;
    }
}
