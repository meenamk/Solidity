// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter; // A third party who can arbitrate in case of disputes
    uint256 public amount;
    bool public isFunded;
    bool public isSellerApproved;
    bool public isArbiterApproved;

    constructor(address _seller, address _arbiter) {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can call this function");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can call this function");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Only the arbiter can call this function");
        _;
    }

    modifier escrowNotFunded() {
        require(!isFunded, "Escrow is already funded");
        _;
    }

    modifier escrowFunded() {
        require(isFunded, "Escrow is not funded");
        _;
    }

    function fundEscrow() public payable onlyBuyer escrowNotFunded {
        require(msg.value > 0, "Funding amount must be greater than 0");
        amount = msg.value;
        isFunded = true;
    }

    function approveSeller() public onlySeller escrowFunded {
        isSellerApproved = true;
    }

    function approveArbiter() public onlyArbiter escrowFunded {
        isArbiterApproved = true;
    }

    function releaseFundsToSeller() public onlySeller escrowFunded {
        require(isSellerApproved && isArbiterApproved, "Both seller and arbiter must approve");
        payable(seller).transfer(amount);
        isFunded = false;
    }

    function refundBuyer() public onlyBuyer escrowFunded {
        require(!isSellerApproved && isArbiterApproved, "Only the buyer can refund");
        payable(buyer).transfer(amount);
        isFunded = false;
    }
}
