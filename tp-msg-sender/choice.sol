// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

contract Choice {
    mapping(address => uint) choices;

    function add(address _address, uint _myuint) public {
        choices[_address] = _myuint;
    }

}
