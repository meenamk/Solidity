// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Counter {
    uint256 public count;// Count variable with uint256 data type and public visibility

    // Function to get the current count
    function get() public view returns (uint256) {// function called get() with public visibility and view state mutability
        return count;
    }

    //view-> read the stored data from blockchain

    // Function to increment count by 1
    function inc() public {//inc() function increments 1 to the count value
        count += 1;
    }

    // Function to decrement count by 1
    function dec() public {//dec() function increments 1 to the count value
        // This function will fail if count = 0
        count -= 1;
    }
}
