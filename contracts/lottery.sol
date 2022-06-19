/*
Task

Implement a contract that mints a NFT as ticket id for people that purchase a lottery ticket. 
The winner of the lottery gets to take home the entire loot size. 

Architecture
global variables
owner - person that deploys the contract
players -addresses / list of players []

functions
enter lottery - mints nft as ticket id
pick winner

optional
function to get a player and their nft
mappings (address => uint256) player nft 

ideas
us struct player info - address , ticket id nft - more gas efficient

*/

//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is ERC721{


address public owner;
address public player;
address payable[] public players;
uint256 public ticketId;
mapping(address =>uint256)) playerNft;


constructor() payable ERC721("LotteryNfts", "LN"){
owner = msg.sender;
ticketId = 0;
}

modifier onlyOwner() {
    require(msg.sender == owner);
    _;
}

 
function createNft(string memory tokenURI) public onlyOwner returns (uint256) {
    _safeMint(msg.sender, ticketId);
   setTokenURI(ticketId, tokenURI);
   ticketId = ticketId + 1;
    return ticketId; 
}

function setTokenURI (uint256 newItemId, string memory tokenURI) public  {
     setTokenURI(newItemId, tokenURI);
}

function enterLottery() public payable {
    require(msg.value > 1 ether);
    // playerNft[msg.sender][true];
     players.push(payable(msg.sender));
       uint256 newItemId = ticketId;
      _safeMint(msg.sender, newItemId);

}

function getRandomNumber() public view returns(uint) {
    return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
}

function pickWinner() public onlyOwner{
    uint index = getRandomNumber() % players.length;
    players[index].transfer(address(this).balance);

//reset the contract for another round
players = new address payable[](0);
}

////////////VIEW FUNCTIONS//////////////////
///@dev to find out what is the loot
function getBalance() public view returns(uint){
    return address(this).balance;
}

function playerBal(address player) public view returns(){
    return balance = playerNft[msg.sender];
}

}