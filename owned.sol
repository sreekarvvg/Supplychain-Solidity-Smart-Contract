//SPDX-License-Identifier: MIT

pragma solidity  0.8.10;

contract owned {
    address payable public owner;
    constructor () {
        owner = payable(msg.sender);
    }
    modifier ownedbyme() {
       require(isOwner(), "Not owner");
        _;
    } 
    function isOwner() public view returns(bool){
        return owner == msg.sender;
    }  
}