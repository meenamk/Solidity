// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

contract sayHello{
    string strMsg = "Hello World!";

    function getMsg() public view returns(string memory){
        return strMsg;
    }
}