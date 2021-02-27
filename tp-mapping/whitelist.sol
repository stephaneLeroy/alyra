// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.11;

/**
 * @title Whitelist
 * @dev Store & retrieve an addresses whitelist in a variable
 */
contract Whitelist {
    mapping(address => bool) whitelist;
    event Authorized(address user);

    function authorize(address _address) public {
        whitelist[_address] = true;

        emit Authorized(_address);
    }
}