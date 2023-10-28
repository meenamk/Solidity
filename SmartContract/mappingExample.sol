// SPDX-License-Identifier: GPL-3.0
//declare version
pragma solidity >=0.4.0 <0.9.0;

//creating contract called 'MappingExample'
contract MappingExample {
    
    //declaring public variable called 'balances' with mapping data structure(type) 
    //Here address maps with unsigned integer
    mapping(address => uint) public balances;

    //creating a public function called 'update' 
    //it allows anyone to update their balance by providing a new balance as an argument
    //msg. sender is a built-in variable that refers to the address of the contract caller.
    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }
}

//creating contract called 'MappingUser'
contract MappingUser {

    //creating function called 'f', publicly accessible and returns an unsigned integer.
    function f() public returns (uint) {

        //new instance of the `MappingExample` contract is created 
        //assigned to the variable `m`.
        MappingExample m = new MappingExample();

        //update` function of the `MappingExample` contract is called to update the balance of the sender
        m.update(100);

        //function retrieves the balance associated with the address of the `MappingUser` contract 
        return m.balances(address(this));
    }
}