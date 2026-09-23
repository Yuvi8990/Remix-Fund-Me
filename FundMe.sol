//SPDX-License-Identifier: MIT

pragma solidity ^0.8.34;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5 * 1e18;

    address[] public funders;
    
    mapping(address Funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable owner;

    constructor() {
      owner = msg.sender;
    }

    function fund() public payable {
    require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH");
       funders.push(msg.sender);
       addressToAmountFunded[msg.sender] += msg.value;
   }

    function withdraw() public onlyOwner{
       for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;
       }
   
    funders = new address[](0);
    
    (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
      if(msg.sender != owner) { revert NotOwner();} 
      _;
    }

    receive() external payable {
      fund();
    }

    fallback() external payable {
      fund();
    }
}
   
