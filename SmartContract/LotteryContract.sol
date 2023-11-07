// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleLottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum contribution is 0.01 ether");
        players.push(msg.sender);
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(blockhash(block.number-1), block.timestamp, players)));
    }

    function pickWinner() public restricted {
        require(msg.sender == manager, "Only the manager can pick a winner");
        require(players.length > 0, "No players in the lottery");

        uint index = random() % players.length;
        address winner = players[index];

        // Transfer the entire contract balance to the winner
        payable(winner).transfer(address(this).balance);

        // Reset the player list for the next round
        players = new address[](0);
    }   

    modifier restricted() {
        require(msg.sender == manager, "Only the manager can call this function");
        _;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}
