//I want this contract to be able to get funds from users
//withdraw funds 
//set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.18;

// import {AggregatorV3Interface} from "@chainlink/contracts@1.2.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
//gas for deployment 	791,887 	771,777
import{PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe{

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18; //represents 5$ in. 18 decimal places
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable  {
        //what i want this function to do is:
        //Allow Users to send $,
        //Have a minimum $ sent
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough Eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        
        //withdawl function will set our funds to zero whever we completely withdraw what we have in our fund contract.
        //we will make use of a forloop 
        //for(/*startingIndex; endingIndex; stepAmount*/)
        for(uint256 fundersIndex = 0; fundersIndex < funders.length; fundersIndex++){
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }
        //resetting the array to zero
        funders = new address[](0);

        //withdraw

        //there are 3 different ways by which we can withdraw eth from this contract and they are:
        //transfer
        // payable (msg.sender).transfer(address(this).balance);

        //send
        // bool sendSuccess = payable (msg.sender).send(address(this).balance);
        // require(sendSuccess, "send failed");

        //call
        (bool callSuccess, /*bytes memory dataReturned*/) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");

    }

    modifier onlyOwner(){
        //require(msg.sender == i_owner, "access denied!!!");
        if(msg.sender != i_owner){
            revert NotOwner();
        }
        _;
    }

    //What happens when someone sends money to this contract without calling the fundMe function?
    //receive function
    receive() external payable { 
        fund();
    }

    //fallback function
    fallback() external payable { 
        fund();
    }

    // function getPrice() public view returns(uint){
    //     //this function is going to help get the price of Eth in. terms of USD
    //     //In order to get the price, we need the Address and the ABI
    //     //Address : 0x694AA1769357215DE4FAC081bf1f309aDC325306
    //     //ABI : our interface
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    //     (,int256 price,,,) = priceFeed.latestRoundData();

    //     return uint256(price) * 1e10;
    // }

    // function getConversionRate(uint ethAmount) public view returns(uint256){
    //     //it will get the value based of of the price of eth
    //     //with math in solidity, you always want to multiply before you divide
    //     uint256 ethPrice = getPrice();
    //     uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
    //     return ethAmountInUsd;

    // }

    // function getVersion() public view returns(uint256){
    //      return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    // }
       
    
}