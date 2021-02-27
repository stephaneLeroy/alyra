// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/access/Ownable.sol";

contract Admin is Ownable {
    mapping(address => bool) _whitelist;
    mapping(address => bool) _blacklist;

    event Whitelisted(address user);
    event Blacklisted(address user);

    function whitelist(address _address) public onlyOwner {
        _whitelist[_address] = true;
        emit Whitelisted(_address);
    }

    function isWhitelisted(address _user) public view returns(bool) {
        return _whitelist[_user];
    }

    function blacklist(address _address) public onlyOwner {
        _blacklist[_address] = true;
        emit Blacklisted(_address);
    }

    function isBlacklisted(address _user) public view returns(bool) {
        return _blacklist[_user];
    }
}