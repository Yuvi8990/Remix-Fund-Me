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
      if(msg.sender != owner) { revert NotOwner();} //this means if sender is not the owner, then revert with notOwner error.
      _;
    }

    receive() external payable {
      fund();
    }

    fallback() external payable {
      fund();
    }

}
   
    


// fund function --
  //is public so that anyone will be able to donate funds for our project.
  //we wants to give it functionality to send money and have a minimum limit required for donation
//ques => how do we have that when a user calls this func, his ETH gets sent to this contract.
//answ => first thing to do is make the func payable using the keyword 'payable'.
 // => msg.sender signifies the address of the user from which fund was sent to our account.
 // => and then we push msg.sender to our funders array to make a list of donating users.
   // => and the mapping makes it easier to lookup how much money each user has sent.

// We can access the 'value' [amount of a transaction,the native crypto currency being sent/received]using one of the 'globals' of the solidity known as -- msg.value.
//If we wanted users to spend atleast 1 ETH(for-ex) when using fund, we can use 'required' to do so with msg.value
                      //i.e => required(msg.value > 1e18); here, 1e18 = 1ETH = 1000000000000000000 Wei = 1*10**18[1times10^18]
    //also a revert message can be added => it means if the 1st section(req....1e18) goes false, revert the transaction with second section(didnt....ETH)
// In actual we will keep minimal amount around 5 usd.

//Revert -- a revert undo's any actions done previously, and sends the gas associated with transaction back[whats left of it]

// line 8 attaches functions from our library to all uint256's here

// a for-loop is a way to loop through a list of something or to do something in a repeated amount of time.

// first we used new keyword to deploy a contract, now we used it to reset an array to blank.

// 3 different ways to withdraw funds are -- transfer, send and call

// = means 'set' and == means 'must be equal to'

//actually withdrawing the funds
    //transfer, it is capped at 2200 gas and above than that throws an error and reverts automatically. so not very liked to be used
      // => payable(msg.sender).transfer(address(this).balance);
    //send, also capped at 2200 gas, but it doesnt return an error, but a boolean -- telling us whether it was successful or not and we have to set a revert command for the not case in the 2nd line
    // =>  bool sendSuccess = payable(msg.sender).send(address(this).balance);
      // => require(sendSuccess,"Send failed");

// first way to make contracts efficient was using 'constant' and immutable.
// # another way to make the contracts gas efficient are errors.At first we are storing the revert statements such as 'not enough eth' or 'sender is not the owner' as strings which are high on gas.      // So we can updates the require and make them custom errors and use if and our revert statements.
// this ends up saving gas since we called the error 'code' instead of calling the entire thing associated with error.
// so just create a error outside the contract and then use a if statement instead of require in the contract.
// as we did with the require in line 52-53 by specifying a error outside the contract and using if, same can be done with all the requires by making specific custom errors.

//You know sometimes people can interact with a contract that takes native currency , using its address and can donate or fund directly with using the 'fund' function.
//but what if we want to keep a record of those persons and their funds, lets say to reward them later.
// so if a person funds us without using fund, and we still need some piece of code to trigger to notify us of the fund and its details---
//--- we can use two special functions of solidity to known as 'receive' or 'fallback'; to understand and use this, we are gonna create a new file.
//understand them both from examples and then we can implement them here, and when they detect something, they can simply call fund.

//also (); -- means execute or call