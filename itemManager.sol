//SPDX-License-Identifier: MIT

pragma solidity  0.8.10;

import "./owned.sol";
import "./item.sol";
contract ItemManager is owned {
    enum supplychainstate{Created, Paid, Delivered}
    struct itemdetails{
        item _item;
        supplychainstate _state;
        uint _price;
        string _identifier;
    }
    mapping(uint => itemdetails) public items;
    uint index;
    event supplychainstep(uint _itemindex, uint _step, address _addr);
    function createItem(string memory _identifier, uint _itemprice) public ownedbyme{
        item Item = new item(this, _itemprice, index);
        items[index]._item = Item;
        items[index]._price = _itemprice;
        items[index]._identifier = _identifier;
        items[index]._state = supplychainstate.Created;
        emit supplychainstep(index, uint(items[index]._state), address(items[index]._item));
        index++;
    }
    function triggerpayment(uint _index) public payable{
        require(items[_index]._price == msg.value, "Not valid amount");
        require(items[_index]._state == supplychainstate.Created, "You cannot move further in the cart");
        items[_index]._state = supplychainstate.Paid;
        emit supplychainstep(_index, uint(items[_index]._state), address(items[_index]._item));
    }
    function triggerdelivery(uint _index) public ownedbyme{
       require(items[_index]._state == supplychainstate.Paid, "You have not paid yet");   
       items[_index]._state = supplychainstate.Delivered;
       emit supplychainstep(_index, uint(items[_index]._state), address(items[_index]._item));
    }
}