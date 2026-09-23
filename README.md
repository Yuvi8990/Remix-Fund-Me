# Remix Fund Me: Decentralized Crowdfunding

## Overview
This repository contains a decentralized crowdfunding smart contract system built and deployed using Remix IDE. Representing a rigorous two-week study into EVM value transfer mechanics, external oracle integration, and contract modularity, this project demonstrates secure fund management, custom error handling, and robust withdrawal architectures. 

## Technical Stack
* **Language:** Solidity (^0.8.34)
* **Environment:** Remix IDE
* **Core Integrations:** Chainlink Data Feeds (Price Oracles)
* **Key Concepts:** Payable functions, external data consumption, custom modifiers, libraries, and gas-efficient state resets.

## Contract Architecture & Core Mechanics

### 1. `FundMe.sol`
The primary crowdfunding contract that accepts ETH based on a minimum USD threshold.
* **Funding Mechanics:** Utilizes payable functions and the `PriceConverter` library to ensure minimum contribution values are met before accepting transactions.
* **Access Control:** Implements an `onlyOwner` modifier and custom errors to restrict withdrawal capabilities exclusively to the contract deployer, optimizing gas costs compared to traditional `require` strings.
* **Withdrawal Logic:** Resets the `funders` array and securely transfers the contract balance to the owner using low-level `call` functions to prevent reentrancy-like failures.

### 2. `PriceConverter.sol`
A modular Solidity library that abstracts the Chainlink oracle integration away from the main contract.
* **Core Functionality:** Interfaces with the Chainlink `AggregatorV3Interface` to fetch real-time ETH/USD price data.
* **Math Operations:** Handles the necessary decimal conversions to match Ethereum's 18-decimal formatting, ensuring accurate minimum USD threshold calculations in the main contract.

### 3. `FallbackExample.sol`
A supplementary demonstration contract isolating low-level transaction routing.
* **Core Functionality:** Implements `receive()` and `fallback()` functions to capture direct ETH transfers that bypass the standard `fund()` function, proving an understanding of EVM calldata triggers.
