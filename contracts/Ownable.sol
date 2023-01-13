// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Ownable{
    address owner;
     constructor(){
        owner = msg.sender;
     }
     modifier onlyOwner{
        require(owner == msg.sender);
        _;
     }
}