// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/release-v3.0.0/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    int public rate = 200;

    constructor(uint256 initialSupply) public ERC20("ALYRA", "ALY") {
        _mint(msg.sender, initialSupply);
    }
}