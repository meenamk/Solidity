// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract welcomeUser{
    string welcomeMsg="Welcome";

    function getWelcome(string memory _name) public view returns(string memory){
        return string.concat(welcomeMsg, " ", _name, "!");
    }
}