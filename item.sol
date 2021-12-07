//SPDX-License-Identifier: MIT

pragma solidity  0.8.10;

import "./itemManager.sol";
contract item {
    uint public priceInWei;
    uint public index;
    uint public pricepaid;
    ItemManager parentContract;
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index){
        priceInWei = _priceInWei;
        index = _index;
        parentContract =_parentContract;
    }
    receive() external payable {
        require(pricepaid == 0, "Already paid");
        require(priceInWei == msg.value, "Only full payments accepted");
        pricepaid += msg.value;
        (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerpayment(uint256)", index));
        require(success, "Your transaction is not successful");
    }
    fallback() external payable {}
}