// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.26 and less than 0.9.0
pragma solidity ^0.8.26;

contract HelloWorld {  //contract name is HelloWorld
    string public greet = "Hello World!";  // a string variable called 'greet' with visibility of public and value "hello world" has been assigned
}

//after compiling and deploying this contract, when greet variable is called, The 'Hello World!' value is returned.