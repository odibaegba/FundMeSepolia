
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts@1.2.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    
    function getPrice() internal view returns(uint){
        //this function is going to help get the price of Eth in. terms of USD
        //In order to get the price, we need the Address and the ABI
        //Address : 0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI : our interface
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();

        return uint256(price) * 1e10;
    }

    function getConversionRate(uint ethAmount) internal view returns(uint256){
        //it will get the value based of of the price of eth
        //with math in solidity, you always want to multiply before you divide
        uint256 ethPrice = getPrice();
        uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;

    }

    function getVersion() internal  view returns(uint256){
         return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}