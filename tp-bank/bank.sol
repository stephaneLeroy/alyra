// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/math/SafeMath.sol";

contract Bank {
    using SafeMath for uint;
    mapping(address => uint) _balances;

    function deposit(uint _amount) public {
        require(msg.sender != address(0), "You cannot deposit for the address zero");
        _balances[msg.sender] = _balances[msg.sender].add(_amount);
    }

    function transfer(address _recipient,  uint _amount) public {
        require(msg.sender != address(0), "You cannot transfer from the address zero");
        require(_recipient != address(0), "You cannot transfer to the address zero");
        require(_balances[msg.sender] >= _amount, "Insufficient fund");

        _balances[msg.sender] = _balances[msg.sender].sub(_amount);
        _balances[_recipient] = _balances[_recipient].add(_amount);
    }

    function balanceOf(address _address) public view returns(uint) {
        return _balances[_address];
    }

}