// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    struct Supplier {
        uint256 id;
        address walletAddress;
        string companyName;
        uint256 productCount;
        bool isApproved;
    }

    Supplier[] public suppliers;

    // Function to add a new supplier to the supply chain
    function addSupplier(address _walletAddress,string memory _companyName,uint256 _productCount,bool _isApproved
    ) public {
        suppliers.push(Supplier({
        id: suppliers.length,walletAddress: _walletAddress,companyName: _companyName,
        productCount: _productCount,isApproved: _isApproved
        }));
    }

    // Function to get the number of suppliers
    function getSupplierCount() public view returns (uint256) {
        return suppliers.length;
    }

    // Function to retrieve supplier details by index
    function getSupplier(uint256 index) public view returns (uint256 id,address walletAddress,
    string memory companyName,uint256 productCount,bool isApproved) {
        require(index < suppliers.length, "Invalid index");
        Supplier memory supplier = suppliers[index];
        return (supplier.id,supplier.walletAddress,supplier.companyName,supplier.productCount,supplier.isApproved);
    }
}
