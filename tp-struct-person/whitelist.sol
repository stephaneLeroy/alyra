// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;

contract Whitelist {
    struct Person { // Structure de données
        string name;
        uint age;
    }

    Person[] public people;

    function add(string memory _name, uint _age) public {
        people.push(Person(_name, _age));
    }

    function remove() public {
        people.pop();
    }

}
