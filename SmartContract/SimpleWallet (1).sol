// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Wallet {
    function deposit(uint _newBalance) external  returns(string memory);
    function withdraw(uint _amount) external  returns(string memory);
    function getBalance() external  view returns(uint _balance);
    
}

contract SimpleWallet is Wallet{
    mapping (address=>uint) public owner;

    function deposit(uint _newBalance) external  returns(string memory){
        owner[msg.sender]=owner[msg.sender]+_newBalance;
        return string.concat("your amount has been deposited",string(abi.encodePacked(owner[msg.sender])));
    }

    function withdraw(uint _amount) external  returns(string memory){
        if(owner[msg.sender]>=_amount){
            owner[msg.sender]=owner[msg.sender]-_amount;
            //bytes32 x=bytes32(owner[msg.sender]);
            return string.concat("Here is your amount",string(abi.encodePacked(owner[msg.sender])));    
        }
        else{
            return "Your balance is insufficient";
        }
    }
    
    function getBalance() external view returns(uint _balance){
        return owner[msg.sender];

    }
    
}
